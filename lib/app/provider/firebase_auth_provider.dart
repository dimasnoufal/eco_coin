import 'dart:io';

import 'package:eco_coin/app/helper/firebase_auth_status.dart';
import 'package:eco_coin/app/model/user_model.dart';
import 'package:eco_coin/app/services/firebase_auth_service.dart';
import 'package:eco_coin/app/services/local_storage_services.dart';
import 'package:eco_coin/app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService;
  final UserService _userService;
  final LocalStorageService _localStorageService;

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

  // Getters
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

  // Create account
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

  Future<void> sendPasswordReset(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      _message = "Email reset password telah dikirim";
    } catch (e) {
      _message = e.toString();
    }
    notifyListeners();
  }

  Future<void> signOutUser() async {
    try {
      _authStatus = FirebaseAuthStatus.signingOut;
      notifyListeners();

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

  Future<bool> uploadProfileImage(File imageFile) async {
    if (_user == null) return false;

    try {
      if (_userModel?.profileImageUrl != null &&
          _userModel!.profileImageUrl!.startsWith('/')) {
        await _localStorageService.deleteImage(_userModel!.profileImageUrl!);
      }

      final localImagePath = await _localStorageService.saveProfileImage(
        _user!.uid,
        imageFile,
      );

      await _userService.updateProfileImage(_user!.uid, localImagePath);

      if (_userModel != null) {
        _userModel = _userModel!.copyWith(profileImageUrl: localImagePath);
        notifyListeners();
      }

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

  Future<bool> deleteAccount() async {
    if (_user == null) return false;

    try {
      final uid = _user!.uid;

      await _localStorageService.clearUserData(uid);

      await _userService.deleteUser(uid);

      await _user!.delete();

      _userModel = null;
      _authStatus = FirebaseAuthStatus.unauthenticated;
      _message = "Akun berhasil dihapus";

      notifyListeners();
      return true;
    } catch (e) {
      _message = e.toString();
      return false;
    }
  }

  void clearMessage() {
    _message = null;
    notifyListeners();
  }
}
