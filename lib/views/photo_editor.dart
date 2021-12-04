import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:add_to_gallery/add_to_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/utils/magician_icons_icons.dart';
import 'package:magician_app/widgets/custom_button.dart';
import 'package:magician_app/widgets/playing_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:screenshot/screenshot.dart';

class PhotoEditor extends StatefulWidget {
  const PhotoEditor(
    this.source, {
    Key? key,
    this.stickerWidth = 70.0,
    this.stickerHeight = 100.0,
    this.stickerMaxScale = 2.0,
    this.stickerMinScale = 0.5,
    this.panelHeight = 200.0,
    this.panelBackgroundColor = const Color(0xff000000),
    this.panelStickerBackgroundColor = const Color(0xffffffff),
    this.panelStickercrossAxisCount = 4,
    this.panelStickerAspectRatio = 1.0,
    this.devicePixelRatio = 3.0,
  }) : super(key: key);
  final AssetEntity source;

  final double stickerWidth;
  final double stickerHeight;
  final double stickerMaxScale;
  final double stickerMinScale;

  final double panelHeight;
  final Color panelBackgroundColor;
  final Color panelStickerBackgroundColor;
  final int panelStickercrossAxisCount;
  final double panelStickerAspectRatio;
  final double devicePixelRatio;

  @override
  _PhotoEditorState createState() => _PhotoEditorState();
}

class _PhotoEditorState extends State<PhotoEditor> {
  final ScreenshotController _screenshotController = ScreenshotController();
  Size? viewport;
  Random random = Random();

  List<String> cards = [];

  List<PlayingCard> attachedList = [];

  final GlobalKey key = GlobalKey();

  @override
  void initState() {
    getRandomCard();
    super.initState();
  }

  void attachSticker(String name) {
    setState(() {
      attachedList.add(PlayingCard(
        name,
        key: Key("sticker_${attachedList.length}"),
        width: widget.stickerWidth,
        height: widget.stickerHeight,
        viewport: viewport,
        maxScale: widget.stickerMaxScale,
        minScale: widget.stickerMinScale,
        onTapRemove: onTapRemoveCard,
      ));
    });
  }

  getRandomCard() {
    cards.clear();
    for (var i = 0; i < 5; i++) {
      var cardnumber = random.nextInt(52);
      cards.add(
        cardsList[cardnumber],
      );
    }
  }

  /// Fetches the Temporary Directory of the phone.
  Future<String> getFilePath() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = "$tempPath/tempImage.jpg";

    return filePath;
  }

  void saveImageToGallery() {
    _screenshotController.capture().then((Uint8List? image) async {
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
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<File?>(
          future: widget.source.file,
          builder: (_, snapshot) {
            final file = snapshot.data;

            // If we have no data, display a spinner
            if (file == null) return const Center(child: CircularProgressIndicator(color: primaryColor));
            // If there's data, display it as an image

            return Column(
              children: [
                Expanded(
                  child: RepaintBoundary(
                    key: key,
                    child: Screenshot(
                      controller: _screenshotController,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
                              viewport = viewport ?? Size(constraints.maxWidth, constraints.maxHeight);
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.file(
                                  file,
                                  fit: BoxFit.fitWidth,
                                ),
                              );
                            },
                          ),
                          Stack(children: attachedList, fit: StackFit.expand),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: cards
                      .map(
                        (e) => GestureDetector(
                          onTap: () {
                            attachSticker(e);
                          },
                          child: StaticPlayingCard(e),
                        ),
                      )
                      .toList(),
                ),
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
                        Navigator.pop(context);
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

  void onTapRemoveCard(PlayingCard card) {
    setState(() {
      attachedList.removeWhere((s) => s.key == card.key);
    });
  }
}

/*Column(
      children: [
        Expanded(
          child: RepaintBoundary(
            key: key,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    viewport = viewport ?? Size(constraints.maxWidth, constraints.maxHeight);
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Screenshot(
                        controller: _screenshotController,
                        child: widget.source,
                      ),
                    );
                  },
                ),
                Stack(children: attachedList, fit: StackFit.expand),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.cards
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    attachSticker(e);
                  },
                  child: StaticPlayingCard(e),
                ),
              )
              .toList(),
        ),
      ],
    );*/
