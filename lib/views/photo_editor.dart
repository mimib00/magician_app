import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:add_to_gallery/add_to_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:magician_app/utils/cards_icons_icons.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/utils/magician_icons_icons.dart';
import 'package:magician_app/widgets/custom_button.dart';
import 'package:magician_app/widgets/playing_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class PhotoEditor extends StatefulWidget {
  const PhotoEditor(
    this.source, {
    Key? key,
    this.stickerWidth = 80.0,
    this.stickerHeight = 110.0,
    this.stickerMaxScale = 2.0,
    this.stickerMinScale = 0.5,
    this.panelHeight = 200.0,
    this.panelBackgroundColor = const Color(0xff000000),
    this.panelStickerBackgroundColor = const Color(0xffffffff),
    this.panelStickercrossAxisCount = 4,
    this.panelStickerAspectRatio = 1.0,
    this.devicePixelRatio = 3.0,
  }) : super(key: key);
  final source;

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
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getRandomCards();
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
      removeCrads(name);
    });
  }

  removeCrads(String name) {
    setState(() {
      cards.removeWhere((element) => element == name);
    });
    // if (cards.isEmpty) getRandomCards();
  }

  getRandomCards() {
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
        key: scaffoldState,
        body: FutureBuilder<File?>(
          future: widget.source.file,
          builder: (_, snapshot) {
            final file = snapshot.data;

            // If we have no data, display a spinner
            if (file == null) return const Center(child: CircularProgressIndicator(color: primaryColor));
            // If there's data, display it as an image

            return Stack(
              children: [
                Column(
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
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isDismissible: true,
                        builder: (context) => Container(
                          padding: const EdgeInsets.all(5),
                          height: kHeight(context) * .25,
                          decoration: const BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Select Items",
                                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            getRandomCards();
                                          });

                                          Navigator.pop(context);
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/CardSelector.svg',
                                          width: kWidth(context) * .15,
                                          height: kHeight(context) * .1,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        "Get Random Cards",
                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/Ghost.svg',
                                        width: kWidth(context) * .15,
                                        height: kHeight(context) * .1,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        "Ghost",
                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/images/CardSelector.svg',
                      width: kWidth(context) * .06,
                      height: kHeight(context) * .04,
                      color: Colors.white,
                    ),
                  ),
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
