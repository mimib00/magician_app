import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/utils/magician_icons_icons.dart';
import 'package:magician_app/views/save_screen.dart';
import 'package:magician_app/widgets/custom_button.dart';
import 'package:magician_app/widgets/playing_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:screenshot/screenshot.dart';

import 'package:share_plus/share_plus.dart';

class PhotoEditor extends StatefulWidget {
  const PhotoEditor({
    this.source,
    Key? key,
    this.stickerWidth = 100.0,
    this.stickerHeight = 130.0,
    this.stickerMaxScale = 2.0,
    this.stickerMinScale = 0.5,
    this.panelHeight = 200.0,
    this.panelBackgroundColor = const Color(0xff000000),
    this.panelStickerBackgroundColor = const Color(0xffffffff),
    this.panelStickercrossAxisCount = 4,
    this.panelStickerAspectRatio = 1.0,
    this.devicePixelRatio = 3.0,
  }) : super(key: key);
  final dynamic source;

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
  Size viewport = Size.zero;
  Random random = Random();

  String selectedCard = 'H-A';

  List<String> cards = [];

  Widget ghostImage = Container();

  final GlobalKey key = GlobalKey();

  bool isLoading = false;

  @override
  void initState() {
    getRandomCards();

    super.initState();
  }

  void addGhost(String name) {
    setState(() {
      selectedCard = name;
      removeCrads(name);
    });
  }

  removeCrads(String name) {
    setState(() {
      cards.removeWhere((element) => element == name);
    });
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
    var filePath = "$tempPath/${DateTime.now().millisecondsSinceEpoch}.jpg";

    return filePath;
  }

  Future<File> saveImageTemp() async {
    setState(() {
      isLoading = true;
    });

    Uint8List? image = await _screenshotController.capture();
    var filePath = await getFilePath();

    File file = File(filePath);
    file.writeAsBytesSync(image!); // Saves the image in the temp folder
    setState(() {
      isLoading = false;
    });
    return file;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.source.runtimeType == AssetEntity) {
      child = FutureBuilder<File?>(
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
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: RepaintBoundary(
                        key: key,
                        child: Screenshot(
                          controller: _screenshotController,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) {
                                  viewport = Size(constraints.maxWidth, constraints.maxHeight);

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
                                    width: widget.stickerWidth,
                                    height: widget.stickerHeight,
                                    viewport: viewport,
                                  );

                                  return Image.file(
                                    file,
                                    fit: BoxFit.fitWidth,
                                  );
                                },
                              ),
                              ghostImage,
                            ],
                          ),
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
                              addGhost(e);
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
                        onTap: () async {
                          final file = await saveImageTemp();
                          Share.shareFiles(
                            [
                              file.path
                            ],
                          );
                        },
                        icon: const Icon(
                          MagicianIcons.share,
                          color: Colors.black,
                        ),
                      ),
                      CustomIconButton(
                        onTap: () async {
                          final file = await saveImageTemp();
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => SaveScreen(file: file)));
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
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
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
                                            width: widget.stickerWidth,
                                            height: widget.stickerHeight,
                                            viewport: viewport,
                                          );
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/Ghost.svg',
                                        width: kWidth(context) * .15,
                                        height: kHeight(context) * .1,
                                      ),
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
              isLoading
                  ? AlertDialog(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Loading.."),
                          CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          );
        },
      );
    } else {
      child = Stack(
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
                            viewport = Size(constraints.maxWidth, constraints.maxHeight);

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
                              width: widget.stickerWidth,
                              height: widget.stickerHeight,
                              viewport: viewport,
                            );

                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.file(
                                File(widget.source),
                                fit: BoxFit.fitWidth,
                              ),
                            );
                          },
                        ),
                        ghostImage,
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
                          addGhost(e);
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
                    onTap: () async {
                      final file = await saveImageTemp();
                      Share.shareFiles(
                        [
                          file.path
                        ],
                      );
                    },
                    icon: const Icon(
                      MagicianIcons.share,
                      color: Colors.black,
                    ),
                  ),
                  CustomIconButton(
                    onTap: () async {
                      final file = await saveImageTemp();
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => SaveScreen(file: file)));
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
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
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
                                        width: widget.stickerWidth,
                                        height: widget.stickerHeight,
                                        viewport: viewport,
                                      );
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'assets/images/Ghost.svg',
                                    width: kWidth(context) * .15,
                                    height: kHeight(context) * .1,
                                  ),
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
          isLoading
              ? AlertDialog(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Loading.."),
                      CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ],
      );
    }
    return SafeArea(
      child: Scaffold(
        body: child,
      ),
    );
  }

  // void onTapRemoveCard(Widget card) {
  //   setState(() {
  //     ghostImage.removeWhere((s) => s.key == card.key);
  //   });
  // }
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
                Stack(children: ghostImage, fit: StackFit.expand),
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
