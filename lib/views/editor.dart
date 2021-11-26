import 'dart:io';
import 'dart:typed_data';

import 'package:add_to_gallery/add_to_gallery.dart';
import 'package:flutter/material.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/utils/magician_icons_icons.dart';
import 'package:magician_app/widgets/custom_button.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class EditorScreen extends StatefulWidget {
  final AssetEntity image;
  const EditorScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  /// Fetches the Temporary Directory of the phone.
  Future<String> getFilePath() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = "$tempPath/tempImage.jpg";

    return filePath;
  }

  /// Makes a copy of the image from the Temporary Directory of the phone.
  /// and save it to [Magician App] in the gallery and deletes the original image
  /// from the Temporary Directory
  void saveImageToGallery() {
    screenshotController.capture().then((Uint8List? image) async {
      var filePath = await getFilePath();

      File file = File(filePath);
      file.writeAsBytesSync(image!); // Saves the image in the temp folder

      /// Moves the image to the app gallery album and delete the image from the temp folder.
      /// to avoid duplication of images and save space.
      await AddToGallery.addToGallery(
        originalFile: File(filePath),
        albumName: 'Magician App',
        deleteOriginalFile: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: FutureBuilder<File?>(
          future: widget.image.file,
          builder: (_, snapshot) {
            final file = snapshot.data;
            // If we have no data, display a spinner
            if (file == null) return const Center(child: CircularProgressIndicator(color: primaryColor));
            // If there's data, display it as an image
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Screenshot(
                  controller: screenshotController,
                  child: Stack(
                    children: [
                      Container(
                        height: height * .7,
                        width: width,
                        margin: const EdgeInsets.all(5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(file, fit: BoxFit.fitWidth),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(
                      onTap: () {
                        print("Share");
                      },
                      icon: const Icon(
                        MagicianIcons.share,
                        color: Colors.black,
                      ),
                    ),
                    CustomIconButton(
                      onTap: () {
                        print("Save");
                      },
                      backgroundColor: primaryColor,
                      icon: const Icon(
                        MagicianIcons.save,
                        color: Colors.black,
                      ),
                    ),
                    CustomIconButton(
                      onTap: () {
                        print("Close");
                      },
                      backgroundColor: Colors.red[400]!,
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
