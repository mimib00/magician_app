import 'dart:io';
import 'dart:typed_data';

import 'package:add_to_gallery/add_to_gallery.dart';
import 'package:flutter/material.dart';
import 'package:magician_app/utils/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<File?>(
        future: widget.image.file,
        builder: (_, snapshot) {
          final file = snapshot.data;
          // If we have no data, display a spinner
          if (file == null) return const Center(child: CircularProgressIndicator(color: primaryColor));
          // If there's data, display it as an image
          return Screenshot(
            controller: screenshotController,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(file, fit: BoxFit.cover),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    color: Colors.amber,
                    height: 50,
                    width: 50,
                  ),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          screenshotController.capture().then((Uint8List? image) async {
            Directory tempDir = await getTemporaryDirectory();
            String tempPath = tempDir.path;
            var filePath = "$tempPath/tempImage.jpg";

            File file = File(filePath);
            file.writeAsBytesSync(image!);
            await AddToGallery.addToGallery(
              originalFile: File(filePath),
              albumName: 'Camera Demo',
              deleteOriginalFile: true,
            );
          });
        },
      ),
    );
  }
}
