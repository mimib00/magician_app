import 'package:flutter/material.dart';
import 'package:magician_app/widgets/playing_card.dart';

class PhotoEditor extends StatefulWidget {
  const PhotoEditor(
    this.source,
    this.cards, {
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
  final Widget source;
  final List<String> cards;

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
  Size? viewport;

  List<PlayingCard> attachedList = [];

  final GlobalKey key = GlobalKey();

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
        onTapRemove: (card) {
          onTapRemoveSticker(card);
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    return widget.source;
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
                .toList()),
      ],
    );
  }

  void onTapRemoveSticker(PlayingCard sticker) {
    setState(() {
      attachedList.removeWhere((s) => s.key == sticker.key);
    });
  }
}
