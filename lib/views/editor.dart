// // ignore_for_file: prefer_const_literals_to_create_immutables

// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:magician_app/provider/data_manager.dart';
// import 'package:magician_app/utils/constants.dart';
// import 'package:magician_app/utils/magician_icons_icons.dart';
// import 'package:magician_app/widgets/custom_button.dart';
// import 'package:magician_app/widgets/photo_editor.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:provider/provider.dart';

// class EditorScreen extends StatefulWidget {
//   final AssetEntity asset;
//   const EditorScreen(this.asset, {Key? key}) : super(key: key);

//   @override
//   _EditorScreenState createState() => _EditorScreenState();
// }

// class _EditorScreenState extends State<EditorScreen> {
//   late final DataManager dataManager;

//   Random random = Random();

//   List<String> cards = [];

//   @override
//   void initState() {
//     getRandomCard();
//     super.initState();
//     dataManager = context.read<DataManager>();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: FutureBuilder<File?>(
//           future: widget.asset.file,
//           builder: (_, snapshot) {
//             final file = snapshot.data;

//             // If we have no data, display a spinner
//             if (file == null) return const Center(child: CircularProgressIndicator(color: primaryColor));
//             // If there's data, display it as an image
//             PhotoEditor child = PhotoEditor(
//               Image.file(
//                 file,
//                 fit: BoxFit.fitWidth,
//               ),
//               cards,
//             );

//             return Column(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Expanded(
//                   child: child,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     CustomIconButton(
//                       onTap: () {
//                         print("Share");
//                       },
//                       icon: const Icon(
//                         MagicianIcons.share,
//                         color: Colors.black,
//                       ),
//                     ),
//                     CustomIconButton(
//                       onTap: () {
//                         // saveImageToGallery();
//                       },
//                       backgroundColor: primaryColor,
//                       icon: const Icon(
//                         MagicianIcons.save,
//                         color: Colors.black,
//                       ),
//                     ),
//                     CustomIconButton(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       backgroundColor: Colors.red[400]!,
//                       icon: const Icon(
//                         Icons.close,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// /*Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Expanded(
//               child: PhotoEditor(
//                 Image.file(widget.asset.file),
//                 cards,
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 CustomIconButton(
//                   onTap: () {
//                     print("Share");
//                   },
//                   icon: const Icon(
//                     MagicianIcons.share,
//                     color: Colors.black,
//                   ),
//                 ),
//                 CustomIconButton(
//                   onTap: () {
//                     // saveImageToGallery();
//                   },
//                   backgroundColor: primaryColor,
//                   icon: const Icon(
//                     MagicianIcons.save,
//                     color: Colors.black,
//                   ),
//                 ),
//                 CustomIconButton(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   backgroundColor: Colors.red[400]!,
//                   icon: const Icon(
//                     Icons.close,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),*/



// // // ignore_for_file: avoid_print

// // import 'dart:io';
// // import 'dart:math';
// // import 'dart:typed_data';

// // import 'package:add_to_gallery/add_to_gallery.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/rendering.dart';
// // import 'package:magician_app/provider/data_manager.dart';
// // import 'package:magician_app/utils/constants.dart';
// // import 'package:magician_app/utils/magician_icons_icons.dart';
// // import 'package:magician_app/widgets/card.dart';
// // import 'package:magician_app/widgets/card_selctor.dart';
// // import 'package:magician_app/widgets/custom_button.dart';
// // import 'package:photo_manager/photo_manager.dart';
// // import 'package:screenshot/screenshot.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:provider/provider.dart';

// // class EditorScreen extends StatefulWidget {
// //   final AssetEntity image;
// //   final Size size;

// //   const EditorScreen({Key? key, required this.image, required this.size}) : super(key: key);

// //   @override
// //   State<EditorScreen> createState() => _EditorScreenState();
// // }

// // class _EditorScreenState extends State<EditorScreen> {
// //   ScreenshotController screenshotController = ScreenshotController();

// //   List<Widget> cards = [];
// //   Random random = Random();
// //   Random randomType = Random();

// //   List<Widget> _items = [];
// //   List<Offset> offsets = [];

// //   /// Fetches the Temporary Directory of the phone.
// //   Future<String> getFilePath() async {
// //     Directory tempDir = await getTemporaryDirectory();
// //     String tempPath = tempDir.path;
// //     var filePath = "$tempPath/tempImage.jpg";

// //     return filePath;
// //   }

// //   /// Makes a copy of the image from the Temporary Directory of the phone.
// //   /// and save it to [Magician App] in the gallery and deletes the original image
// //   /// from the Temporary Directory
// //   void saveImageToGallery() {
// //     screenshotController.capture().then((Uint8List? image) async {
// //       var filePath = await getFilePath();

// //       File file = File(filePath);
// //       file.writeAsBytesSync(image!); // Saves the image in the temp folder

// //       /// Moves the image to the app gallery album and delete the image from the temp folder.
// //       /// to avoid duplication of images and save space.
// //       await AddToGallery.addToGallery(
// //         originalFile: File(filePath),
// //         albumName: 'Magician App',
// //         deleteOriginalFile: true,
// //       );
// //     });
// //   }

// //   void addCards(String name) {
// //     setState(() {
// //       _items.add(MagicCard(cardName: name));
// //     });
// //   }

// //   @override
// //   void initState() {
// //     getRandomCard();
// //     super.initState();
// //   }

// //   @override
// //   void dispose() {
// //     _items.clear();
// //     super.dispose();
// //   }

// //   getRandomCard() {
// //     cards.clear();
// //     for (var i = 0; i < 5; i++) {
// //       var cardnumber = random.nextInt(52);
// //       cards.add(
// //         GestureDetector(
// //           onTap: () => addCards(cardsList[cardnumber]),
// //           child: MagicCard(
// //             cardName: cardsList[cardnumber],
// //           ),
// //         ),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold(
// //         body: FutureBuilder<File?>(
// //           future: widget.image.file,
// //           builder: (_, snapshot) {
// //             final file = snapshot.data;

// //             // If we have no data, display a spinner
// //             if (file == null) return const Center(child: CircularProgressIndicator(color: primaryColor));
// //             // If there's data, display it as an image
// //             return Column(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 const SizedBox(height: 20),
// //                 Flexible(
// //                   flex: 5,
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 10),
// //                     child: ClipRRect(
// //                       borderRadius: BorderRadius.circular(16),
// //                       child: Screenshot(
// //                         controller: screenshotController,
// //                         child: Stack(
// //                           fit: StackFit.passthrough,
// //                           children: [
// //                             Image.file(
// //                               file,
// //                               fit: BoxFit.fitWidth,
// //                               width: kWidth(context),
// //                             ),
// //                             ..._items
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: cards,
// //                 ),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: [
// //                     CustomIconButton(
// //                       onTap: () {
// //                         print("Share");
// //                       },
// //                       icon: const Icon(
// //                         MagicianIcons.share,
// //                         color: Colors.black,
// //                       ),
// //                     ),
// //                     CustomIconButton(
// //                       onTap: () {
// //                         saveImageToGallery();
// //                       },
// //                       backgroundColor: primaryColor,
// //                       icon: const Icon(
// //                         MagicianIcons.save,
// //                         color: Colors.black,
// //                       ),
// //                     ),
// //                     CustomIconButton(
// //                       onTap: () {
// //                         Navigator.pop(context);
// //                       },
// //                       backgroundColor: Colors.red[400]!,
// //                       icon: const Icon(
// //                         Icons.close,
// //                         color: Colors.black,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
