import 'package:flutter/material.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/widgets/playing_card.dart';

class PhotoEditor extends StatefulWidget {
  const PhotoEditor(
    this.source,
    this.cards, {
    Key? key,
    this.stickerSize = 100.0,
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

  final double stickerSize;
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
        width: widget.stickerSize,
        height: widget.stickerSize,
        viewport: viewport,
        maxScale: widget.stickerMaxScale,
        minScale: widget.stickerMinScale,
        onTapRemove: (sticker) {
          // this.onTapRemoveSticker(sticker);
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
        // GridView.builder(
        //   padding: EdgeInsets.zero,
        //   scrollDirection: Axis.vertical,
        //   itemCount: widget.cardsList.length,
        //   itemBuilder: (BuildContext context, int i) {
        //     return Container(
        //       color: backgroundColor,
        //       child: TextButton(
        //           onPressed: () {
        //             attachSticker(widget.cardsList[i]);
        //           },
        //           child: StaticPlayingCard(widget.cardsList[i])),
        //     );
        //   },
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: this.widget.panelStickercrossAxisCount, childAspectRatio: this.widget.panelStickerAspectRatio),
        // ),
        // DragTarget(
        //   builder: (BuildContext context, List<String?> candidateData, List<dynamic> rejectedData) {
        //     return Container(
        //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        //       color: backgroundColor,
        //       child: GridView.builder(
        //         padding: EdgeInsets.zero,
        //         scrollDirection: Axis.vertical,
        //         itemCount: widget.cardsList.length,
        //         itemBuilder: (BuildContext context, int i) {
        //           return Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Container(
        //               color: backgroundColor,
        //               child: TextButton(
        //                   onPressed: () {
        //                     attachSticker(widget.cardsList[i]);
        //                   },
        //                   child: StaticPlayingCard(widget.cardsList[i])),
        //             ),
        //           );
        //         },
        //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: this.widget.panelStickercrossAxisCount, childAspectRatio: this.widget.panelStickerAspectRatio),
        //       ),
        //       height: widget.panelHeight,
        //     );
        //   },
        // )
        // Scrollbar(child: child)
      ],
    );
  }
}
