import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;

  FirebaseAuthService(FirebaseAuth? auth)
    : _auth = auth ?? FirebaseAuth.instance;

  // Register account
  Future<UserCredential> createUser(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      final errorMessage = switch (e.code) {
        "email-already-in-use" => "Email sudah terdaftar",
        "invalid-email" => "Format email tidak valid",
        "operation-not-allowed" => "Server error, coba lagi nanti",
        "weak-password" => "Password terlalu lemah",
        _ => "Registrasi gagal. Silakan coba lagi",
      };
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Login user
  Future<UserCredential> signInUser(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      final errorMessage = switch (e.code) {
        "invalid-email" => "Format email tidak valid",
        "user-disabled" => "Akun telah dinonaktifkan",
        "user-not-found" => "Email tidak terdaftar",
        "wrong-password" => "Email/password salah",
        _ => "Login gagal. Silakan coba lagi",
      };
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      final errorMessage = switch (e.code) {
        "invalid-email" => "Format email tidak valid",
        "user-not-found" => "Email tidak terdaftar",
        _ => "Gagal mengirim email reset password",
      };
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Logout gagal. Silakan coba lagi");
    }
  }

  // Check user login status
  Future<User?> userChanges() => _auth.userChanges().first;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
