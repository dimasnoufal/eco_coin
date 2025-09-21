import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  Future<Directory> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  Future<Directory> _createUserDirectory(String uid) async {
    final localPath = await _localPath;
    final userDir = Directory('${localPath.path}/users/$uid');

    if (!await userDir.exists()) {
      await userDir.create(recursive: true);
    }
    return userDir;
  }

  Future<String> saveUserImage(
    String uid,
    File imageFile,
    String folder,
  ) async {
    try {
      final userDir = await _createUserDirectory(uid);
      final targetDir = Directory('${userDir.path}/$folder');

      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final localImagePath = '${targetDir.path}/$fileName';

      await imageFile.copy(localImagePath);

      return localImagePath;
    } catch (e) {
      throw Exception('Gagal menyimpan gambar: $e');
    }
  }

  File? getImageFile(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;

    final file = File(imagePath);
    return file.existsSync() ? file : null;
  }

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
