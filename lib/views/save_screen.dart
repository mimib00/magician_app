// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:add_to_gallery/add_to_gallery.dart';
import 'package:flutter/material.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/utils/magician_icons_icons.dart';
import 'package:magician_app/widgets/custom_button.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

class SaveScreen extends StatefulWidget {
  final File file;
  const SaveScreen({Key? key, required this.file}) : super(key: key);

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  final TextEditingController _name = TextEditingController();

  bool isLoading = false;

  void saveImageToGallery() async {
    setState(() {
      isLoading = true;
    });
    if (_name.text.isNotEmpty) {
      /// Moves the image to the app gallery album and delete the image from the temp folder.
      /// to avoid duplication of images and save space.
      var newFile = await AddToGallery.addToGallery(
        originalFile: widget.file,
        albumName: 'Magician App',
        deleteOriginalFile: true,
      );

      String dir = path.dirname(newFile.path);
      String newPath = path.join(dir, '${_name.text.trim()}.jpg');
      newFile.renameSync(newPath);
    } else {
      await AddToGallery.addToGallery(
        originalFile: widget.file,
        albumName: 'Magician App',
        deleteOriginalFile: true,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Image.file(widget.file),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: _name,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          label: Text('Add Title'),
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomIconButton(
                          onTap: () async {
                            Share.shareFiles(
                              [
                                widget.file.path
                              ],
                            );
                          },
                          icon: const Icon(
                            MagicianIcons.share,
                            color: Colors.black,
                          ),
                        ),
                        CustomIconButton(
                          onTap: () {
                            saveImageToGallery();
                          },
                          backgroundColor: primaryColor,
                          icon: const Icon(
                            MagicianIcons.save,
                            color: Colors.black,
                          ),
                        ),
                        CustomIconButton(
                          onTap: () {
                            widget.file.deleteSync();
                            Navigator.pop(context);
                          },
                          backgroundColor: Colors.red[400]!,
                          icon: const Icon(
                            MagicianIcons.delete,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              isLoading
                  ? Align(
                      alignment: Alignment.center,
                      child: AlertDialog(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Loading.."),
                            CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
