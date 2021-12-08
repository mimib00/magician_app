// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:add_to_gallery/add_to_gallery.dart';
import 'package:flutter/material.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/utils/magician_icons_icons.dart';
import 'package:magician_app/widgets/custom_button.dart';
import 'package:path/path.dart' as path;

class SaveScreen extends StatelessWidget {
  final File file;
  SaveScreen({Key? key, required this.file}) : super(key: key);

  final TextEditingController _name = TextEditingController();

  void saveImageToGallery() async {
    if (_name.text.isNotEmpty) {
      /// Moves the image to the app gallery album and delete the image from the temp folder.
      /// to avoid duplication of images and save space.
      var newFile = await AddToGallery.addToGallery(
        originalFile: file,
        albumName: 'Magician App',
        deleteOriginalFile: true,
      );

      String dir = path.dirname(newFile.path);
      String newPath = path.join(dir, '${_name.text.trim()}.jpg');
      newFile.renameSync(newPath);
    } else {
      await AddToGallery.addToGallery(
        originalFile: file,
        albumName: 'Magician App',
        deleteOriginalFile: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.file(file),
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
                      onTap: () {},
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
                        file.deleteSync();
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
        ),
      ),
    );
  }
}
