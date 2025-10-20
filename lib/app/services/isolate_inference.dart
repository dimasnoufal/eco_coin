import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:eco_coin/app/helper/shared/logger.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';

class IsolateInference {
  static const String _debugName = 'TFLITE_INFERENCE';
  final ReceivePort _receivePort = ReceivePort();
  late Isolate _isolate;
  late SendPort _sendPort;
  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: _debugName,
    );

    _sendPort = await _receivePort.first;
  }

  Future<void> close() async {
    _isolate.kill();
    _receivePort.close();
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final InferenceModel isolateModel in port) {
      final fileImage = isolateModel.imagePath!;
      final inputShape = isolateModel.inputShape;
      final imageMatrix = _imageFilePreProcessing(fileImage, inputShape);

      final input = [imageMatrix];
      final output = [List<double>.filled(isolateModel.outputShape[1], 0.0)];
      final address = isolateModel.interpreterAddress;

      final result = _runInference(input, output, address);

      double maxScore = result.reduce((a, b) => a > b ? a : b);
      final keys = isolateModel.labels;
      final values = result
          .map((e) => e.toDouble() / maxScore.toDouble())
          .toList();

      var classification = Map.fromIterables(keys, values);
      classification.removeWhere((key, value) => value == 0);

      isolateModel.responsePort.send(classification);
    }
  }

  static List<List<List<num>>> _imageFilePreProcessing(
    String imagePath,
    List<int> inputShape,
  ) {
    try {
      final imageFile = File(imagePath);
      final bytes = imageFile.readAsBytesSync();

      image_lib.Image? originalImage = image_lib.decodeImage(bytes);
      if (originalImage == null) {
        throw Exception('Failed to decode image from path: $imagePath');
      }

      image_lib.Image imageInput = image_lib.copyResize(
        originalImage,
        width: inputShape[1],
        height: inputShape[2],
      );

      final imageMatrix = List.generate(
        imageInput.height,
        (y) => List.generate(imageInput.width, (x) {
          final pixel = imageInput.getPixel(x, y);
          return [
            pixel.r.toInt().clamp(0, 255),
            pixel.g.toInt().clamp(0, 255),
            pixel.b.toInt().clamp(0, 255),
          ];
        }),
      );

      return imageMatrix;
    } catch (e) {
      printX('❌ Error processing image file: $e');
      return List.generate(
        inputShape[2],
        (y) => List.generate(inputShape[1], (x) => [0, 0, 0]),
      );
    }
  }

  static List<double> _runInference(
    List<List<List<List<num>>>> input,
    List<List<double>> output,
    int interpreterAddress,
  ) {
    try {
      Interpreter interpreter = Interpreter.fromAddress(interpreterAddress);

      final inputTensor = interpreter.getInputTensor(0);
      final outputTensor = interpreter.getOutputTensor(0);

      printInfo('🔍 Input tensor type: ${inputTensor.type}');
      printInfo('🔍 Output tensor type: ${outputTensor.type}');
      printInfo('🔍 Input tensor shape: ${inputTensor.shape}');
      printInfo('🔍 Output tensor shape: ${outputTensor.shape}');

      var processedInput = input;
      if (inputTensor.type == TensorType.uint8) {
        processedInput = input;
      } else if (inputTensor.type == TensorType.float32) {
        processedInput = input
            .map(
              (batch) => batch
                  .map(
                    (row) => row
                        .map(
                          (pixel) => pixel.map((channel) => channel).toList(),
                        )
                        .toList(),
                  )
                  .toList(),
            )
            .toList();
      }

      interpreter.run(processedInput, output);
      return output.first;
    } catch (e) {
      printX('🚨 Inference error: $e');
      rethrow;
    }
  }
}

class InferenceModel {
  CameraImage? cameraImage;
  String? imagePath;
  int interpreterAddress;
  List<String> labels;
  List<int> inputShape;
  List<int> outputShape;
  late SendPort responsePort;

  InferenceModel(
    this.cameraImage,
    this.interpreterAddress,
    this.labels,
    this.inputShape,
    this.outputShape,
  ) : imagePath = null;

  InferenceModel.fromFile(
    this.imagePath,
    this.interpreterAddress,
    this.labels,
    this.inputShape,
    this.outputShape,
  ) : cameraImage = null;
}
