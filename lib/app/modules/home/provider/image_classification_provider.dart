import 'package:eco_coin/app/helper/shared/logger.dart';
import 'package:eco_coin/app/helper/shared/static_state.dart';
import 'package:eco_coin/app/services/image_classification_services.dart';
import 'package:flutter/widgets.dart';

class ImageClassificationProvider extends ChangeNotifier {
  final ImageClassificationServices _service;

  ImageClassificationProvider(this._service) {
    _service.initHelper();
  }

  StaticResultState<Map<String, num>> _resultState = StaticResultNone();

  StaticResultState<Map<String, num>> get resultState => _resultState;

  Future<void> runClassificationFromFile(String imagePath) async {
    _resultState = StaticResultLoading();
    notifyListeners();

    try {
      final resultClasification = await _service.inferenceImage(imagePath);
      printInfo('resultClasification: $resultClasification');

      if (resultClasification.isEmpty) {
        _resultState = StaticResultError('No classification found');
        printX('❌ No classification found');
        notifyListeners();
        return;
      } else {
        _resultState = StaticResultLoaded(resultClasification);
        printY('Classifications: $_resultState');
        notifyListeners();
      }
    } catch (e) {
      printX('❌ Error in file classification: $e');
      _resultState = StaticResultError('Error: $e');
      notifyListeners();
    }
  }

  Future<void> close() async {
    await _service.close();
  }
}
