import 'dart:io';

import 'package:camera/camera.dart';
import 'package:eco_coin/app/helper/shared/logger.dart';
import 'package:eco_coin/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Body();
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with WidgetsBindingObserver {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const CameraView());
  }
}

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  bool _isCameraInitialized = false;

  List<CameraDescription> _cameras = [];

  CameraController? controller;

  bool _isProcessing = false;

  XFile? image;

  int flash = 0;

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    final cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.yuv420
          : ImageFormatGroup.bgra8888,
    );

    await previousCameraController?.dispose();

    try {
      await cameraController.initialize();
      if (mounted) {
        setState(() {
          controller = cameraController;
          controller!.startImageStream(_processCameraImage);
          _isCameraInitialized = controller!.value.isInitialized;
        });
      }
    } catch (e) {
      printX('❌ Error initializing camera: $e');
      if (mounted) {
        _showErrorDialog('Failed to initialize camera: $e');
      }
    }
  }

  void initCamera() async {
    try {
      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
      }

      if (_cameras.isEmpty) {
        printX('❌ No cameras available');
        if (mounted) {
          _showErrorDialog('No cameras found on this device');
        }
        return;
      }

      CameraDescription selectedCamera;
      try {
        selectedCamera = _cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
        );
      } catch (e) {
        selectedCamera = _cameras.first;
      }

      await onNewCameraSelected(selectedCamera);
      if (mounted && controller != null) {
        await controller!.setFlashMode(FlashMode.off);
        printY('✅ Camera initialized successfully');
      }
    } catch (e) {
      printX('❌ Error initializing camera: $e');
      if (mounted) {
        _showErrorDialog('Failed to initialize camera: $e');
      }
    }
  }

  void _processCameraImage(CameraImage image) {
    if (_isProcessing) return;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    initCamera();

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    controller?.stopImageStream().catchError((e) {
      printX('Error stopping image stream: $e');
    });
    controller?.dispose().catchError((e) {
      printX('Error disposing controller: $e');
    });

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.inactive:
        cameraController.dispose();
        break;
      case AppLifecycleState.resumed:
        onNewCameraSelected(cameraController.description);
        break;
      default:
    }
  }

  Future<void> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      printX('❌ Camera not ready for capture');
      return;
    }

    try {
      HapticFeedback.lightImpact();

      final XFile capturedImage = await cameraController.takePicture();
      printY('✅ Image captured: ${capturedImage.path}');

      if (mounted) {
        Navigator.pushNamed(
          context,
          Routes.resultDetection,
          arguments: {'imagePath': capturedImage.path},
        );
      }
    } catch (e) {
      printX('❌ Capture failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Capture failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  flashMode() {
    flash = flash == 0
        ? 1
        : flash == 1
        ? 2
        : flash == 2
        ? 3
        : 0;
    controller?.setFlashMode(
      flash == 0
          ? FlashMode.off
          : flash == 1
          ? FlashMode.always
          : flash == 2
          ? FlashMode.auto
          : FlashMode.torch,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _isCameraInitialized
        ? Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller!.value.previewSize!.height,
                    height: controller!.value.previewSize!.width,
                    child: CameraPreview(controller!),
                  ),
                ),
              ),

              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),

                      GestureDetector(
                        onTap: flashMode,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: flash == 0
                                ? Colors.black.withOpacity(0.3)
                                : Colors.amber.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: flash == 0
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.amber.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            flash == 0
                                ? Icons.flash_off
                                : flash == 1
                                ? Icons.flash_on
                                : flash == 2
                                ? Icons.flash_auto
                                : Icons.highlight,
                            color: flash == 0 ? Colors.white : Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -2,
                        left: -2,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.green, width: 4),
                              left: BorderSide(color: Colors.green, width: 4),
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.green, width: 4),
                              right: BorderSide(color: Colors.green, width: 4),
                            ),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -2,
                        left: -2,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.green, width: 4),
                              left: BorderSide(color: Colors.green, width: 4),
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.green, width: 4),
                              right: BorderSide(color: Colors.green, width: 4),
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Container Placeholder (For spacings)
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(color: Colors.transparent),
                      ),

                      GestureDetector(
                        onTap: takePicture,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.green, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.green,
                            size: 36,
                          ),
                        ),
                      ),

                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.cameraswitch,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    '📸 Arahkan kamera ke sampah untuk mengidentifikasi jenis',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container(
            decoration: BoxDecoration(color: Colors.white),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Menyiapkan kamera...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
