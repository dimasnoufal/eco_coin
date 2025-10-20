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
  bool _isSwitching = false;
  bool _isTakingPicture = false;

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

    if (previousCameraController != null &&
        previousCameraController.value.isInitialized &&
        previousCameraController.value.isStreamingImages) {
      try {
        await previousCameraController.stopImageStream();
      } catch (e) {
        printX('Error stopping image stream: $e');
      }
    }

    if (previousCameraController != null) {
      try {
        await previousCameraController.dispose();
      } catch (e) {
        printX('Error disposing previous controller: $e');
      }
    }

    try {
      await cameraController.initialize();

      if (!mounted) {
        await cameraController.dispose();
        return;
      }

      controller = cameraController;
      _isCameraInitialized = cameraController.value.isInitialized;

      setState(() {});

      if (controller != null && controller!.value.isInitialized && mounted) {
        try {
          await controller!.startImageStream(_processCameraImage);
        } catch (e) {
          printX('Error starting image stream: $e');
        }
      }
    } catch (e) {
      printX('❌ Error initializing camera: $e');
      try {
        await cameraController.dispose();
      } catch (disposeError) {
        printX('Error disposing failed controller: $disposeError');
      }

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

    _disposeCameraController();

    super.dispose();
  }

  Future<void> _disposeCameraController() async {
    final currentController = controller;
    if (currentController != null) {
      try {
        if (currentController.value.isInitialized &&
            currentController.value.isStreamingImages) {
          await currentController.stopImageStream();
        }
      } catch (e) {
        printX('Error stopping image stream during dispose: $e');
      }

      try {
        await currentController.dispose();
      } catch (e) {
        printX('Error disposing controller: $e');
      }
    }
    controller = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        if (cameraController.value.isStreamingImages) {
          cameraController.stopImageStream().catchError((e) {
            printX('Error stopping image stream on app pause: $e');
          });
        }
        cameraController.dispose().catchError((e) {
          printX('Error disposing controller on app pause: $e');
        });
        if (mounted) {
          setState(() {
            controller = null;
            _isCameraInitialized = false;
          });
        }
        break;
      case AppLifecycleState.resumed:
        if (_cameras.isNotEmpty && controller == null) {
          final lastUsedCamera = _cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
            orElse: () => _cameras.first,
          );
          onNewCameraSelected(lastUsedCamera);
        }
        break;
      default:
        break;
    }
  }

  Future<void> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      printX('❌ Camera not ready for capture');
      return;
    }

    if (_isTakingPicture) {
      printX('📸 Picture capture already in progress');
      return;
    }

    _isTakingPicture = true;
    setState(() {});

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
    } finally {
      _isTakingPicture = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2) {
      printX('❌ Only one camera available');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hanya ada satu kamera tersedia'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    if (_isSwitching) {
      printX('⚠️ Camera switch already in progress');
      return;
    }

    _isSwitching = true;
    setState(() {});

    try {
      HapticFeedback.lightImpact();

      final currentController = controller;
      if (currentController == null || !currentController.value.isInitialized) {
        printX('❌ Camera controller not ready for switching');
        return;
      }

      final currentCamera = currentController.description;

      CameraDescription newCamera;
      if (currentCamera.lensDirection == CameraLensDirection.back) {
        newCamera = _cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras.first,
        );
      } else {
        newCamera = _cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras.first,
        );
      }

      if (currentController.value.isStreamingImages) {
        await currentController.stopImageStream().catchError((e) {
          printX('Error stopping image stream during switch: $e');
        });
      }

      if (mounted) {
        setState(() {
          controller = null;
          _isCameraInitialized = false;
        });
      }

      await Future.delayed(const Duration(milliseconds: 100));

      await onNewCameraSelected(newCamera);

      final newController = controller;
      if (newController != null && newController.value.isInitialized) {
        await newController
            .setFlashMode(
              flash == 0
                  ? FlashMode.off
                  : flash == 1
                  ? FlashMode.always
                  : flash == 2
                  ? FlashMode.auto
                  : FlashMode.torch,
            )
            .catchError((e) {
              printX('Error setting flash mode: $e');
            });
      }

      printY(
        '✅ Camera switched to ${newCamera.lensDirection == CameraLensDirection.front ? 'front' : 'back'}',
      );
    } catch (e) {
      printX('❌ Error switching camera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengganti kamera: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _isSwitching = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  flashMode() {
    final currentController = controller;
    if (currentController == null || !currentController.value.isInitialized) {
      printX('❌ Camera not ready for flash mode change');
      return;
    }

    flash = flash == 0
        ? 1
        : flash == 1
        ? 2
        : flash == 2
        ? 3
        : 0;

    currentController
        .setFlashMode(
          flash == 0
              ? FlashMode.off
              : flash == 1
              ? FlashMode.always
              : flash == 2
              ? FlashMode.auto
              : FlashMode.torch,
        )
        .catchError((e) {
          printX('Error setting flash mode: $e');
        });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (_isCameraInitialized &&
            controller != null &&
            controller!.value.isInitialized &&
            !_isSwitching)
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
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(color: Colors.transparent),
                      ),

                      GestureDetector(
                        onTap: () async {
                          if (_isTakingPicture) return;
                          await takePicture();
                        },
                        onTapDown: (_) {
                          HapticFeedback.lightImpact();
                        },
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
                          child: _isTakingPicture
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt,
                                  color: Colors.green,
                                  size: 36,
                                ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          if (_isSwitching) return;
                          await switchCamera();
                        },
                        onTapDown: (_) {
                          HapticFeedback.lightImpact();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _isSwitching
                                ? Colors.green.withOpacity(0.3)
                                : Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: _isSwitching
                                  ? Colors.green.withOpacity(0.5)
                                  : Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: _isSwitching
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.cameraswitch,
                                  color: Colors.white,
                                  size: 28,
                                ),
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
            decoration: BoxDecoration(color: Colors.black),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 20),
                  Text(
                    _isSwitching
                        ? 'Mengganti kamera...'
                        : 'Menyiapkan kamera...',
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
