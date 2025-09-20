import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:eco_coin/app/helper/shared/logger.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'isolate_inference.dart';

class ImageClassificationServices {
  final modelPath = 'assets/models/model.tflite';
  final labelsPath = 'assets/models/labels.txt';

  Interpreter? interpreter;
  List<String>? labels;
  Tensor? inputTensor;
  Tensor? outputTensor;
  IsolateInference? isolateInference;

  bool _isInitialized = false;
  bool _isInitializing = false;

  Future<void> _loadModel() async {
    try {
      printInfo('🔄 Loading TensorFlow Lite model...');

      final options = InterpreterOptions()
        ..useNnApiForAndroid = true
        ..useMetalDelegateForIOS = true;

      interpreter = await Interpreter.fromAsset(modelPath, options: options);
      inputTensor = interpreter!.getInputTensors().first;
      outputTensor = interpreter!.getOutputTensors().first;

      printY('✅ Interpreter loaded successfully');
    } catch (e) {
      printX('❌ Failed to load model: $e');
      rethrow;
    }
  }

  Future<void> _loadLabels() async {
    try {
      printInfo('🔄 Loading labels...');
      final labelTxt = await rootBundle.loadString(labelsPath);
      labels = labelTxt
          .split('\n')
          .where((label) => label.trim().isNotEmpty)
          .toList();
      printY('✅ Labels loaded: ${labels!.length} categories');
    } catch (e) {
      printX('❌ Failed to load labels: $e');
      rethrow;
    }
  }

  Future<void> _initializeInterpreter() async {
    try {
      await _loadLabels();
      await _loadModel();
    } catch (e) {
      printX('❌ Failed to initialize interpreter: $e');
      rethrow;
    }
  }

  Future<void> _initializeIsolateInference() async {
    try {
      isolateInference = IsolateInference();
      await isolateInference!.start();
    } catch (e) {
      printX('❌ Failed to initialize isolate inference: $e');
      rethrow;
    }
  }

  Future<void> initHelper() async {
    if (_isInitialized) {
      printInfo('✅ Service already initialized');
      return;
    }

    if (_isInitializing) {
      printInfo('⏳ Initialization already in progress, waiting...');
      while (_isInitializing && !_isInitialized) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      return;
    }

    _isInitializing = true;

    try {
      printInfo('🚀 Initializing ImageClassificationServices...');

      await _initializeInterpreter();
      await _initializeIsolateInference();

      _isInitialized = true;
      printY('✅ ImageClassificationServices initialized successfully');
    } catch (e) {
      printX('❌ Failed to initialize services: $e');
      _isInitialized = false;
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  bool get isInitialized =>
      _isInitialized &&
      interpreter != null &&
      labels != null &&
      isolateInference != null;

  Future<Map<String, double>> inferenceCameraFrame(
    CameraImage cameraImage,
  ) async {
    try {
      if (!isInitialized) {
        printInfo('⏳ Service not initialized, waiting for initialization...');
        await initHelper();
      }

      if (!isInitialized) {
        throw Exception('Failed to initialize ImageClassificationServices');
      }

      var isolateModel = InferenceModel(
        cameraImage,
        interpreter!.address,
        labels!,
        inputTensor!.shape,
        outputTensor!.shape,
      );

      ReceivePort responsePort = ReceivePort();
      isolateInference!.sendPort.send(
        isolateModel..responsePort = responsePort.sendPort,
      );
      var results = await responsePort.first;

      if (results is Map<String, double>) {
        return results;
      } else {
        return {};
      }
    } catch (e) {
      printX('❌ Camera inference error: $e');
      return {};
    }
  }

  Future<Map<String, double>> inferenceImage(String imagePath) async {
    try {
      printInfo('🔄 Processing image: $imagePath');

      if (!isInitialized) {
        printInfo('⏳ Service not initialized, waiting for initialization...');
        await initHelper();
      }

      if (!isInitialized) {
        throw Exception('Failed to initialize ImageClassificationServices');
      }

      var isolateModel = InferenceModel.fromFile(
        imagePath,
        interpreter!.address,
        labels!,
        inputTensor!.shape,
        outputTensor!.shape,
      );

      ReceivePort responsePort = ReceivePort();
      isolateInference!.sendPort.send(
        isolateModel..responsePort = responsePort.sendPort,
      );

      var results = await responsePort.first;

      if (results is Map<String, double>) {
        printY('✅ File inference completed successfully');
        var entries = results.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value));
        var sortedResults = Map<String, double>.fromEntries(entries.reversed);
        return sortedResults;
      } else {
        printX('❌ Invalid response format');
        return {};
      }
    } catch (e) {
      printX('❌ Error in file classification: $e');
      return {};
    }
  }

  Future<void> close() async {
    try {
      printInfo('🔄 Closing ImageClassificationServices...');

      if (isolateInference != null) {
        await isolateInference!.close();
      }

      interpreter?.close();

      _isInitialized = false;
      _isInitializing = false;
      printY('✅ Services closed successfully');
    } catch (e) {
      printX('❌ Error closing services: $e');
    }
  }
}
