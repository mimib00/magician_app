import 'dart:io';

import 'package:add_to_gallery/add_to_gallery.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:magician_app/provider/data_manager.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/utils/magician_icons_icons.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller; //To control the camera
  int selectedCamera = 0;
  bool isFlashOn = true;

  double scale = 0;

  setScale(context) {
    var camera = _controller.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;
  }

  initializeCamera(int cameraIndex) async {
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      context.read<DataManager>().cameras![cameraIndex],
      // Define the resolution to use.
      ResolutionPreset.max,
    );

    // Next, initialize the controller. This returns a Future.
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    initializeCamera(selectedCamera); //Initially selectedCamera = 0
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setScale(context);
    return Center(
      child: !_controller.value.isInitialized
          ? const CircularProgressIndicator()
          : Transform.scale(
              scale: scale,
              child: CameraPreview(
                _controller,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    margin: const EdgeInsets.only(bottom: 10),
                    color: const Color(0xff181B30).withOpacity(.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (isFlashOn) {
                              _controller.setFlashMode(FlashMode.off);
                              setState(() {
                                isFlashOn = false;
                              });
                            } else {
                              _controller.setFlashMode(FlashMode.always);
                              setState(() {
                                isFlashOn = true;
                              });
                            }
                          },
                          icon: Icon(
                            isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                            color: Colors.grey[200],
                            size: 35,
                          ),
                        ),
                        const SizedBox(width: 25),
                        GestureDetector(
                          onTap: () async {
                            final image = await _controller.takePicture();

                            final path = image.path;

                            await AddToGallery.addToGallery(
                              originalFile: File(path),
                              albumName: 'Camera Demo',
                              deleteOriginalFile: true,
                            );
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: mainGrayColor,
                            ),
                            child: const Center(
                              child: Icon(
                                MagicianIcons.camera,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          onPressed: () {
                            if (context.read<DataManager>().cameras!.length > 1) {
                              setState(() {
                                selectedCamera = selectedCamera == 0 ? 1 : 0;
                                initializeCamera(selectedCamera);
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('No secondary camera found'),
                                duration: Duration(seconds: 2),
                              ));
                            }
                          },
                          icon: Icon(
                            MagicianIcons.rotatecamera,
                            color: Colors.grey[200],
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
