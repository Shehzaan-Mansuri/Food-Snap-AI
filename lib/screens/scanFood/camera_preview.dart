// ignore_for_file: use_build_context_synchronously

import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:food_snap/screens/scanFood/result_screen.dart';
import 'package:food_snap/utils/responsive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class FoodSnapCameraView extends StatefulWidget {
  const FoodSnapCameraView({super.key});

  @override
  State<FoodSnapCameraView> createState() => FoodSnapCameraViewState();
}

class FoodSnapCameraViewState extends State<FoodSnapCameraView> {
  late List<CameraDescription> cameras;
  late CameraController _cameraController;

  bool isLoaded = false, isFlash = false, tapped = false, imageCaptured = false;

  @override
  void initState() {
    // This function is for getting the camera controller
    _getCameraController();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    imageCaptured = false;
    isLoaded = false;
    isFlash = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !isLoaded
        ? const Scaffold(
            body: Center(
            child: CircularProgressIndicator(),
          ))
        : Stack(
            children: [
              Positioned.fill(
                child: AspectRatio(
                  aspectRatio: _cameraController.value.aspectRatio,
                  child: CameraPreview(_cameraController),
                ),
              ),

              // For Lottie animation loading
              Align(
                alignment: Alignment.center,
                child: Lottie.asset('assets/animations/image-capture.json',
                    width: context.width * .6),
              ),

              // Close button
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade400.withOpacity(.8),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.close, color: Colors.black),
                    ),
                  ),
                ),
              ),

              // Camera controls
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: context.width * .15),
                  height: context.height * .3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(1),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Flash button
                      GestureDetector(
                        onTap: () => setState(() {
                          isFlash = !isFlash;
                          isFlash
                              ? _cameraController.setFlashMode(FlashMode.torch)
                              : _cameraController.setFlashMode(FlashMode.off);
                        }),
                        child: Icon(
                          isFlash ? Icons.flash_on : Icons.flash_off,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      // Capture button
                      GestureDetector(
                        onTapDown: (_) => setState(() => tapped = true),
                        onTapUp: (_) => setState(() => tapped = false),
                        onTapCancel: () => setState(() => tapped = false),
                        onTap: () => _captureImage(context),
                        child: Container(
                          width: context.width * .2,
                          height: context.width * .2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: tapped ? 10 : 3,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _pickImage(context),
                        child: const Icon(
                          Icons.image,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
  }

  // Get Camera controller
  Future<void> _getCameraController() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    try {
      _cameraController.initialize().then((_) {
        if (!mounted) {
          isLoaded = false;
          return false;
        }
        setState(() {
          isLoaded = true;
          isFlash ? _cameraController.setFlashMode(FlashMode.torch) : null;
        });
      });
    } catch (e) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: AlertDialog(
              title: const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 40,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Camera access permission was denied",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    AppSettings.openAppSettings();
                  },
                  style: ElevatedButton.styleFrom(
                    // foregroundColor: Colors.white,
                    // backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                            color: Colors.green)), // Set minimum button size
                  ),
                  child: const Text(
                    'Settings',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    // foregroundColor: Colors.white,
                    // backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                            color: Colors.green)), // Set minimum button size
                  ),
                  child: const Text('Close',
                      style: TextStyle(color: Colors.green)),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ), // Set border radius of AlertDialog
            ),
          );
        },
      );
    }
  }

  // Gallery picker
  Future<void> _pickImage(BuildContext context) async {
    if (imageCaptured) {
      debugPrint('Image already captured');
      return;
    }
    try {
      isFlash
          ? _cameraController.setFlashMode(FlashMode.torch)
          : _cameraController.setFlashMode(FlashMode.off);
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageCaptured = true;
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ResultScreen(file: pickedFile)))
            .then((value) => imageCaptured = false);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  // Capture image
  Future<void> _captureImage(BuildContext context) async {
    if (imageCaptured) {
      debugPrint('Image already captured');
      return;
    }
    try {
      isFlash
          ? _cameraController.setFlashMode(FlashMode.torch)
          : _cameraController.setFlashMode(FlashMode.off);
      final image = await _cameraController.takePicture();
      imageCaptured = true;
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResultScreen(file: image)))
          .then((value) => imageCaptured = false);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
