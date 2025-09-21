import 'dart:io';

import 'package:eco_coin/app/helper/firebase_auth_status.dart';
import 'package:eco_coin/app/model/user_model.dart';
import 'package:eco_coin/app/services/firebase_auth_service.dart';
import 'package:eco_coin/app/services/local_storage_services.dart';
import 'package:eco_coin/app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService;
  final UserService _userService;
  final LocalStorageService _localStorageService;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  FirebaseAuthProvider(
    this._authService,
    this._userService,
    this._localStorageService,
  ) {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData();
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  String? _message;
  User? _user;
  UserModel? _userModel;
  FirebaseAuthStatus _authStatus = FirebaseAuthStatus.unauthenticated;

  String? get message => _message;

  User? get user => _user;

  UserModel? get userModel => _userModel;

  FirebaseAuthStatus get authStatus => _authStatus;

  bool get isAuthenticated => _user != null;

  Future<void> _loadUserData() async {
    if (_user == null) return;

    try {
      _userModel = await _userService.getUser(_user!.uid);
    } catch (e) {
      _message = e.toString();
    }
    notifyListeners();
  }

  Future<void> createAccount(
    String email,
    String password,
    String namaLengkap,
    String namaPanggilan,
  ) async {
    try {
      _authStatus = FirebaseAuthStatus.creatingAccount;
      notifyListeners();

      final credential = await _authService.createUser(email, password);

      final user = UserModel(
        uid: credential.user!.uid,
        email: email,
        namaLengkap: namaLengkap,
        namaPanggilan: namaPanggilan,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _userService.createUser(user);
      _userModel = user;

      _authStatus = FirebaseAuthStatus.accountCreated;
      _message = "Registrasi berhasil";
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatus.error;
    }
    notifyListeners();
  }

  Future<void> signInUser(String email, String password) async {
    try {
      _authStatus = FirebaseAuthStatus.authenticating;
      notifyListeners();

      await _authService.signInUser(email, password);

      _authStatus = FirebaseAuthStatus.authenticated;
      _message = "Login berhasil";
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatus.error;
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      _authStatus = FirebaseAuthStatus.authenticating;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _authStatus = FirebaseAuthStatus.unauthenticated;
        _message = "Sign in dibatalkan";
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (userCredential.user == null) {
        _authStatus = FirebaseAuthStatus.error;
        _message = "Gagal masuk dengan Google";
        notifyListeners();
        return;
      }

      final firebaseUser = userCredential.user!;
      final email = firebaseUser.email;

      if (email == null) {
        _authStatus = FirebaseAuthStatus.error;
        _message = "Email tidak ditemukan dari akun Google";
        notifyListeners();
        return;
      }

      final exists = await _userService.userExistsByEmail(email);

      if (exists) {
        final existingUser = await _userService.getUserByEmail(email);
        if (existingUser != null) {
          _userModel = existingUser;
          _message = "Selamat datang kembali, ${existingUser.namaPanggilan}!";
        } else {
          _authStatus = FirebaseAuthStatus.error;
          _message = "Terjadi kesalahan saat mengambil data user";
          notifyListeners();
          return;
        }
      } else {
        final displayName = firebaseUser.displayName ?? 'User';
        final nameParts = displayName.split(' ');
        final now = DateTime.now();

        final newUser = UserModel(
          uid: firebaseUser.uid,
          email: email,
          namaLengkap: displayName,
          namaPanggilan: nameParts.isNotEmpty ? nameParts.first : 'User',
          phoneNumber: firebaseUser.phoneNumber,
          address: null,
          bio: null,
          createdAt: now,
          updatedAt: now,
        );

        await _userService.createUser(newUser);
        _userModel = newUser;
        _message = "Selamat datang di EcoCoin, ${newUser.namaPanggilan}!";
      }

      _authStatus = FirebaseAuthStatus.authenticated;
    } on FirebaseAuthException catch (e) {
      _authStatus = FirebaseAuthStatus.error;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          _message =
              "Email sudah terdaftar dengan metode sign-in lain. Coba login dengan email/password";
          break;
        case 'invalid-credential':
          _message = "Credential Google tidak valid";
          break;
        case 'operation-not-allowed':
          _message = "Google Sign-In tidak diaktifkan";
          break;
        case 'user-disabled':
          _message = "Akun pengguna telah dinonaktifkan";
          break;
        default:
          _message = "Terjadi kesalahan: ${e.message}";
      }
    } catch (e) {
      _authStatus = FirebaseAuthStatus.error;
      _message = "Terjadi kesalahan: $e";
    }
    notifyListeners();
  }

  Future<void> signOutUser() async {
    try {
      _authStatus = FirebaseAuthStatus.signingOut;
      notifyListeners();

      await _googleSignIn.signOut();

      await _authService.signOut();
      _userModel = null;

      _authStatus = FirebaseAuthStatus.unauthenticated;
      _message = "Logout berhasil";
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatus.error;
    }
    notifyListeners();
  }

  Future<void> updateProfile() async {
    final user = await _authService.userChanges();
    if (user != null) {
      _userModel = await _userService.getUser(user.uid);
    }
    notifyListeners();
  }

  Future<bool> updateUserProfile(UserModel updatedUser) async {
    try {
      await _userService.updateUser(updatedUser);
      _userModel = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      _message = e.toString();
      return false;
    }
  }

  Future<String?> uploadUserImage(File imageFile, String folder) async {
    if (_user == null) return null;

    try {
      final imagePath = await _localStorageService.saveUserImage(
        _user!.uid,
        imageFile,
        folder,
      );
      return imagePath;
    } catch (e) {
      _message = e.toString();
      return null;
    }
  }

  File? getImageFile(String? imagePath) {
    return _localStorageService.getImageFile(imagePath);
  }

  void clearMessage() {
    _message = null;
    notifyListeners();
  }
}
