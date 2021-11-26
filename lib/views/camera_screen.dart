import 'dart:io';
import 'dart:ui';

import 'package:add_to_gallery/add_to_gallery.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:magician_app/provider/data_manager.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/utils/magician_icons_icons.dart';
import 'package:provider/provider.dart';
import 'package:blur/blur.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  //To control the camera
  int selectedCamera = 0;
  bool isFlashOn = true;

  @override
  void initState() {
    context.read<DataManager>().initializeCamera(0, context); //Initially selectedCamera = 0

    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    context.read<DataManager>().disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _controller = context.watch<DataManager>().controller;
    var scale = context.watch<DataManager>().scale;
    return Center(
      child: !_controller.value.isInitialized
          ? const CircularProgressIndicator(color: primaryColor)
          : Transform.scale(
              scale: scale,
              child: CameraPreview(
                _controller,
                child: Align(
                  heightFactor: scale,
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Blur(
                          blur: 2.5,
                          blurColor: const Color(0xff181B30).withOpacity(.5),
                          child: Container(
                            height: MediaQuery.of(context).size.height * .08,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          margin: const EdgeInsets.symmetric(vertical: 20),
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
                                child: const CircleAvatar(
                                  backgroundColor: mainGrayColor,
                                  radius: 35,
                                  child: Center(
                                    child: Icon(
                                      MagicianIcons.camera,
                                      color: Colors.black,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 25),
                              IconButton(
                                onPressed: () {
                                  if (context.read<DataManager>().cameras.length > 1) {
                                    setState(() {
                                      selectedCamera = selectedCamera == 0 ? 1 : 0;
                                      context.read<DataManager>().initializeCamera(selectedCamera, context);
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
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

/*Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .1,
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                          child: const CircleAvatar(
                            backgroundColor: mainGrayColor,
                            radius: 40,
                            child: Center(
                              child: Icon(
                                MagicianIcons.camera,
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          onPressed: () {
                            if (context.read<DataManager>().cameras.length > 1) {
                              setState(() {
                                selectedCamera = selectedCamera == 0 ? 1 : 0;
                                context.read<DataManager>().initializeCamera(selectedCamera, context);
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
                ),*/
