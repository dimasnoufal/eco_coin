import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_coin/app/model/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  // Create user document
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection(_collection).doc(user.uid).set(user.toJson());
    } catch (e) {
      throw Exception('Gagal membuat user: $e');
    }
  }

  // Get user by UID
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(_collection).doc(uid).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil data user: $e');
    }
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(user.uid)
          .update(user.copyWith(updatedAt: DateTime.now()).toJson());
    } catch (e) {
      throw Exception('Gagal update user: $e');
    }
  }

  // Delete user document
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection(_collection).doc(uid).delete();
    } catch (e) {
      throw Exception('Gagal hapus user: $e');
    }
  }

  // Update profile image URL
  Future<void> updateProfileImage(String uid, String imageUrl) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'profileImageUrl': imageUrl,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Gagal update profile image: $e');
    }
  }
}
