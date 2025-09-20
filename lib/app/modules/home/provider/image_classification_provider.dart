import 'package:eco_coin/app/helper/shared/logger.dart';
import 'package:eco_coin/app/services/image_classification_services.dart';
import 'package:flutter/widgets.dart';

class ImageClassificationProvider extends ChangeNotifier {
  final ImageClassificationServices _service;

  ImageClassificationProvider(this._service) {
    _service.initHelper();
  }

  Map<String, num> _classifications = {};

  Map<String, num> get classifications => _classifications;

  Future<void> runClassificationFromFile(String imagePath) async {
    try {
      _classifications = await _service.inferenceImage(imagePath);
      printInfo('Classifications: $_classifications');
      notifyListeners();
    } catch (e) {
      printX('❌ Error in file classification: $e');
      _classifications = {};
      notifyListeners();
    }
  }

  Future<void> close() async {
    await _service.close();
  }
}
