import 'package:blur/blur.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:magician_app/provider/data_manager.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/utils/magician_icons_icons.dart';
import 'package:magician_app/views/photo_editor.dart';
import 'package:magician_app/widgets/playing_card.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String selectedCard = 'H-A';
  Widget ghostImage = Container();

  //To control the camera
  int selectedCamera = 0;
  bool isFlashOn = true;

  @override
  void initState() {
    context.read<DataManager>().initializeCamera(0); //Initially selectedCamera = 0

    super.initState();
  }

  void takePicture(CameraController controller) async {
    final image = await controller.takePicture();

    final path = image.path;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhotoEditor(
          source: path,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _controller = context.watch<DataManager>().controller;
    ghostImage = GhostSticker(
      Stack(
        children: [
          SvgPicture.asset("assets/images/Ghost.svg"),
          Positioned(
            child: HandCard(
              selectedCard,
            ),
          ),
        ],
      ),
      key: Key("sticker_$selectedCard"),
      viewport: Size(kWidth(context), kHeight(context)),
    );
    Widget child;
    if (_controller.value.isInitialized) {
      child = RepaintBoundary(
        child: Stack(
          fit: StackFit.expand,
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return CameraPreview(
                  _controller,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 10,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xff181B30).withOpacity(.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(
                              Icons.select_all_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Blur(
                          blur: 2.5,
                          blurColor: const Color(0xff181B30).withOpacity(.5),
                          child: Container(
                            height: MediaQuery.of(context).size.height * .06,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
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
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () => takePicture(_controller),
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
                              const SizedBox(width: 20),
                              IconButton(
                                onPressed: () {
                                  if (context.read<DataManager>().cameras.length > 1) {
                                    setState(() {
                                      selectedCamera = selectedCamera == 0 ? 1 : 0;
                                      context.read<DataManager>().initializeCamera(selectedCamera);
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
                );
              },
            ),
            ghostImage,
          ],
        ),
      );
    } else {
      child = const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }
    setState(() {});
    return child;
  }
}
// import 'dart:ui';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:magician_app/provider/data_manager.dart';
// import 'package:magician_app/utils/constants.dart';
// import 'package:magician_app/utils/magician_icons_icons.dart';
// import 'package:magician_app/views/photo_editor.dart';
// import 'package:magician_app/widgets/playing_card.dart';
// import 'package:provider/provider.dart';
// import 'package:blur/blur.dart';

// class CameraScreen extends StatefulWidget {
//   const CameraScreen({Key? key}) : super(key: key);

//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   Size? viewport;

//   //To control the camera
//   int selectedCamera = 0;
//   bool isFlashOn = true;

//   String selectedCard = 'H-A';

//   Widget ghostImage = Container();

//   final GlobalKey key = GlobalKey();

//   @override
//   void initState() {
//     context.read<DataManager>().initializeCamera(0, context); //Initially selectedCamera = 0

//     super.initState();
//   }

//   void takePicture(CameraController controller) async {
//     final image = await controller.takePicture();

//     final path = image.path;
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) => PhotoEditor(
//           source: path,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var _controller = context.watch<DataManager>().controller;
//     var scale = context.watch<DataManager>().scale;
//     return Center(
//       child: !_controller.value.isInitialized
//           ? const CircularProgressIndicator(color: primaryColor)
//           : Transform.scale(
//               scale: scale,
//               child: CameraPreview(
//                 _controller,
//                 child: RepaintBoundary(
//                   key: key,
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       Positioned(
//                         top: 40,
//                         left: 40,
//                         child: IconButton(
//                           padding: EdgeInsets.zero,
//                           onPressed: () {},
//                           icon: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                             decoration: BoxDecoration(
//                               color: const Color(0xff181B30).withOpacity(.5),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: const Icon(
//                               Icons.select_all_rounded,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Blur(
//                           blur: 2.5,
//                           blurColor: const Color(0xff181B30).withOpacity(.5),
//                           child: Container(
//                             height: MediaQuery.of(context).size.height * .09,
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             margin: const EdgeInsets.symmetric(vertical: 20),
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 20),
//                           margin: const EdgeInsets.symmetric(vertical: 20),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               IconButton(
//                                 onPressed: () {
//                                   if (isFlashOn) {
//                                     _controller.setFlashMode(FlashMode.off);
//                                     setState(() {
//                                       isFlashOn = false;
//                                     });
//                                   } else {
//                                     _controller.setFlashMode(FlashMode.always);
//                                     setState(() {
//                                       isFlashOn = true;
//                                     });
//                                   }
//                                 },
//                                 icon: Icon(
//                                   isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
//                                   color: Colors.grey[200],
//                                   size: 35,
//                                 ),
//                               ),
//                               const SizedBox(width: 20),
//                               GestureDetector(
//                                 onTap: () => takePicture(_controller),
//                                 child: const CircleAvatar(
//                                   backgroundColor: mainGrayColor,
//                                   radius: 35,
//                                   child: Center(
//                                     child: Icon(
//                                       MagicianIcons.camera,
//                                       color: Colors.black,
//                                       size: 25,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 20),
//                               IconButton(
//                                 onPressed: () {
//                                   if (context.read<DataManager>().cameras.length > 1) {
//                                     setState(() {
//                                       selectedCamera = selectedCamera == 0 ? 1 : 0;
//                                       context.read<DataManager>().initializeCamera(selectedCamera, context);
//                                     });
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                                       content: Text('No secondary camera found'),
//                                       duration: Duration(seconds: 2),
//                                     ));
//                                   }
//                                 },
//                                 icon: Icon(
//                                   MagicianIcons.rotatecamera,
//                                   color: Colors.grey[200],
//                                   size: 30,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: LayoutBuilder(
//                           builder: (BuildContext context, BoxConstraints constraints) {
//                             viewport = viewport ?? Size(constraints.maxWidth, constraints.maxHeight);

//                             ghostImage = GhostSticker(
//                               Stack(
//                                 children: [
//                                   SvgPicture.asset("assets/images/Ghost.svg"),
//                                   Positioned(
//                                     child: HandCard(
//                                       selectedCard,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               key: Key("sticker_$selectedCard"),
//                               viewport: viewport,
//                             );

//                             return Container();
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }

// /*Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * .1,
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     margin: const EdgeInsets.only(bottom: 10),
//                     color: const Color(0xff181B30).withOpacity(.5),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             if (isFlashOn) {
//                               _controller.setFlashMode(FlashMode.off);
//                               setState(() {
//                                 isFlashOn = false;
//                               });
//                             } else {
//                               _controller.setFlashMode(FlashMode.always);
//                               setState(() {
//                                 isFlashOn = true;
//                               });
//                             }
//                           },
//                           icon: Icon(
//                             isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
//                             color: Colors.grey[200],
//                             size: 35,
//                           ),
//                         ),
//                         const SizedBox(width: 25),
//                         GestureDetector(
//                           onTap: () async {
//                             final image = await _controller.takePicture();

//                             final path = image.path;

//                             await AddToGallery.addToGallery(
//                               originalFile: File(path),
//                               albumName: 'Camera Demo',
//                               deleteOriginalFile: true,
//                             );
//                           },
//                           child: const CircleAvatar(
//                             backgroundColor: mainGrayColor,
//                             radius: 40,
//                             child: Center(
//                               child: Icon(
//                                 MagicianIcons.camera,
//                                 color: Colors.black,
//                                 size: 25,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 25),
//                         IconButton(
//                           onPressed: () {
//                             if (context.read<DataManager>().cameras.length > 1) {
//                               setState(() {
//                                 selectedCamera = selectedCamera == 0 ? 1 : 0;
//                                 context.read<DataManager>().initializeCamera(selectedCamera, context);
//                               });
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                                 content: Text('No secondary camera found'),
//                                 duration: Duration(seconds: 2),
//                               ));
//                             }
//                           },
//                           icon: Icon(
//                             MagicianIcons.rotatecamera,
//                             color: Colors.grey[200],
//                             size: 30,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),*/
