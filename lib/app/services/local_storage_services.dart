import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class LocalStorageService {
  // Get application documents directory
  Future<Directory> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  // Create user directory if it doesn't exist
  Future<Directory> _createUserDirectory(String uid) async {
    final localPath = await _localPath;
    final userDir = Directory('${localPath.path}/users/$uid');

    if (!await userDir.exists()) {
      await userDir.create(recursive: true);
    }
    return userDir;
  }

  // Save profile image to local storage
  Future<String> saveProfileImage(String uid, File imageFile) async {
    try {
      final userDir = await _createUserDirectory(uid);
      final profileDir = Directory('${userDir.path}/profile');

      if (!await profileDir.exists()) {
        await profileDir.create(recursive: true);
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final localImagePath = '${profileDir.path}/$fileName';

      // Copy the image to local directory
      await imageFile.copy(localImagePath);

      return localImagePath;
    } catch (e) {
      throw Exception('Gagal menyimpan gambar: $e');
    }
  }

  // Save general user image to local storage
  Future<String> saveUserImage(String uid, File imageFile, String folder) async {
    try {
      final userDir = await _createUserDirectory(uid);
      final targetDir = Directory('${userDir.path}/$folder');

      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final localImagePath = '${targetDir.path}/$fileName';

      // Copy the image to local directory
      await imageFile.copy(localImagePath);

      return localImagePath;
    } catch (e) {
      throw Exception('Gagal menyimpan gambar: $e');
    }
  }

  // Delete image from local storage
  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Gagal hapus gambar: $e');
    }
  }

  // Get image file from path
  File? getImageFile(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;

    final file = File(imagePath);
    return file.existsSync() ? file : null;
  }

  // Clear all user data (for logout/account deletion)
  Future<void> clearUserData(String uid) async {
    try {
      final localPath = await _localPath;
      final userDir = Directory('${localPath.path}/users/$uid');

      if (await userDir.exists()) {
        await userDir.delete(recursive: true);
      }
    } catch (e) {
      throw Exception('Gagal menghapus data user: $e');
    }
  }
}