// ignore_for_file: must_be_immutable, unused_field

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magician_app/provider/data_manager.dart';
import 'package:magician_app/utils/cards_icons.dart';
import 'package:provider/provider.dart';

import 'package:vector_math/vector_math_64.dart' as vector;

typedef CardRemoveCallback = void Function(Widget card);

class PlayingCard extends StatefulWidget {
  const PlayingCard(
    this.name, {
    Key? key,
    this.width = 70,
    this.height = 100,
    this.viewport,
    this.minScale = 1.0,
    this.maxScale = 2.0,
    this.onTapRemove,
  }) : super(key: key);

  final String name;
  final double? width;
  final double? height;
  final Size? viewport;

  final double minScale;
  final double maxScale;

  final CardRemoveCallback? onTapRemove;

  @override
  _PlayingCardState createState() => _PlayingCardState();
}

class _PlayingCardState extends State<PlayingCard> {
  Icon? _cardTypeIcon;
  Color? cardColor;

  double _scale = 1.0;
  double _previousScale = 1.0;

  Offset _previousOffset = Offset.zero;
  Offset _startingFocalPoint = Offset.zero;

  double _rotation = 0.0;
  double _previousRotation = 0.0;
  Offset _offset = Offset.zero;

  bool _isSelected = false;
  var symbol = '';

  @override
  void dispose() {
    super.dispose();
    _offset = Offset.zero;
    _scale = 1.0;
  }

  _getCardInfo() {
    final type = widget.name.split('-');
    symbol = type[1];

    switch (type[0]) {
      case "D":
        _cardTypeIcon = Icon(
          CardsIcons.carreau,
          color: context.watch<DataManager>().coeurCarreau,
        );
        cardColor = context.watch<DataManager>().coeurCarreau;
        break;
      case "H":
        _cardTypeIcon = Icon(
          CardsIcons.coeur,
          color: context.watch<DataManager>().coeurCarreau,
        );
        cardColor = context.watch<DataManager>().coeurCarreau;
        break;
      case "C":
        _cardTypeIcon = Icon(
          CardsIcons.trefle,
          color: context.watch<DataManager>().treflePique,
        );
        cardColor = context.watch<DataManager>().treflePique;
        break;
      case "S":
        _cardTypeIcon = Icon(
          CardsIcons.pique,
          color: context.watch<DataManager>().treflePique,
        );
        cardColor = context.watch<DataManager>().treflePique;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    _getCardInfo();
    // var pos = Offset(kWidth(context) / 2, kHeight(context) / 2);
    // print("H:${widget.height}, W:${widget.width}");
    return Positioned.fromRect(
      rect: Rect.fromPoints(Offset(_offset.dx, _offset.dy), Offset(_offset.dx + widget.width!, _offset.dy + widget.height!)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform(
            transform: Matrix4.diagonal3(vector.Vector3(_scale, _scale, _scale)),
            alignment: FractionalOffset.center,
            child: GestureDetector(
              onScaleStart: (ScaleStartDetails details) {
                _startingFocalPoint = details.focalPoint;
                _previousOffset = _offset;
                _previousRotation = _rotation;
                _previousScale = _scale;

                // print("begin - focal : ${details.focalPoint}, local : ${details.localFocalPoint}");
              },
              onScaleUpdate: (ScaleUpdateDetails details) {
                _scale = min(max(_previousScale * details.scale, widget.minScale), widget.maxScale);

                _rotation = details.rotation;

                final Offset normalizedOffset = (_startingFocalPoint - _previousOffset) / _previousScale;

                Offset __offset = details.focalPoint - (normalizedOffset * _scale);

                __offset = Offset(max(__offset.dx, -widget.width!), max(__offset.dy, -widget.height!));

                __offset = Offset(min(__offset.dx, widget.viewport!.width), min(__offset.dy, widget.viewport!.height));

                setState(() {
                  _offset = __offset;
                  // print("move - $_offset, scale : $_scale");
                });
              },
              onTap: () {
                setState(() {
                  _isSelected = !_isSelected;
                });
              },
              onTapCancel: () {
                setState(() {
                  _isSelected = false;
                });
              },
              onDoubleTap: () {
                setState(() {
                  _scale = 1.0;
                });
              },
              child: Container(
                width: widget.width,
                height: widget.height,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: context.watch<DataManager>().backgroundColor, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        symbol,
                        style: TextStyle(fontSize: 20, color: cardColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _cardTypeIcon!,
                  ],
                ),
              ),
            ),
          ),
          _isSelected
              ? Container(
                  alignment: Alignment.center,
                  child: IconButton(
                    iconSize: 24,
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.delete_forever_rounded),
                    color: Colors.red,
                    onPressed: () {
                      if (widget.onTapRemove != null) {
                        widget.onTapRemove!((widget));
                      }
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class StaticPlayingCard extends StatelessWidget {
  final String cardName;
  final double height;
  final double width;
  StaticPlayingCard(this.cardName, {Key? key, this.height = 100, this.width = 70}) : super(key: key);

  Icon? _cardTypeIcon;

  String name = "";

  Color? cardColor;

  @override
  Widget build(BuildContext context) {
    final type = cardName.split('-');
    name = type[1];

    switch (type[0]) {
      case "D":
        _cardTypeIcon = Icon(
          CardsIcons.carreau,
          color: context.watch<DataManager>().coeurCarreau,
        );
        cardColor = context.watch<DataManager>().coeurCarreau;
        break;
      case "H":
        _cardTypeIcon = Icon(
          CardsIcons.coeur,
          color: context.watch<DataManager>().coeurCarreau,
        );
        cardColor = context.watch<DataManager>().coeurCarreau;
        break;
      case "C":
        _cardTypeIcon = Icon(
          CardsIcons.trefle,
          color: context.watch<DataManager>().treflePique,
        );
        cardColor = context.watch<DataManager>().treflePique;
        break;
      case "S":
        _cardTypeIcon = Icon(
          CardsIcons.pique,
          color: context.watch<DataManager>().treflePique,
        );
        cardColor = context.watch<DataManager>().treflePique;
        break;
      default:
    }

    var child = Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: context.watch<DataManager>().backgroundColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textBaseline: TextBaseline.ideographic,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              name,
              style: TextStyle(fontSize: 20, color: cardColor, fontWeight: FontWeight.bold),
            ),
          ),
          _cardTypeIcon!,
        ],
      ),
    );
    return child;
  }
}

class HandCard extends StatelessWidget {
  final String cardName;

  HandCard(
    this.cardName, {
    Key? key,
  }) : super(key: key);

  Icon? _cardTypeIcon;

  String name = "";

  Color? cardColor;

  double cardSymbolSize = 12;

  @override
  Widget build(BuildContext context) {
    final type = cardName.split('-');
    name = type[1];

    switch (type[0]) {
      case "D":
        _cardTypeIcon = Icon(
          CardsIcons.carreau,
          color: context.watch<DataManager>().coeurCarreau,
          size: cardSymbolSize,
        );
        cardColor = context.watch<DataManager>().coeurCarreau;
        break;
      case "H":
        _cardTypeIcon = Icon(
          CardsIcons.coeur,
          color: context.watch<DataManager>().coeurCarreau,
          size: cardSymbolSize,
        );
        cardColor = context.watch<DataManager>().coeurCarreau;
        break;
      case "C":
        _cardTypeIcon = Icon(
          CardsIcons.trefle,
          color: context.watch<DataManager>().treflePique,
          size: cardSymbolSize,
        );
        cardColor = context.watch<DataManager>().treflePique;
        break;
      case "S":
        _cardTypeIcon = Icon(
          CardsIcons.pique,
          color: context.watch<DataManager>().treflePique,
          size: cardSymbolSize,
        );
        cardColor = context.watch<DataManager>().treflePique;
        break;
      default:
    }
    var child = Container(
      height: 40,
      width: 25,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: context.watch<DataManager>().backgroundColor, borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // textBaseline: TextBaseline.ideographic,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 10, color: cardColor, fontWeight: FontWeight.bold),
          ),
          _cardTypeIcon!,
        ],
      ),
    );
    return child;
  }
}

class GhostSticker extends StatefulWidget {
  const GhostSticker(
    this.ghost, {
    Key? key,
    this.width = 100,
    this.height = 130,
    this.viewport,
  }) : super(key: key);

  final Widget ghost;
  final double? width;
  final double? height;
  final Size? viewport;

  @override
  _GhostStickerState createState() => _GhostStickerState();
}

class _GhostStickerState extends State<GhostSticker> {
  Offset _previousOffset = Offset.zero;
  Offset _startingFocalPoint = Offset.zero;

  Offset _offset = Offset.zero;

  @override
  void dispose() {
    super.dispose();
    _offset = Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // rect: Rect.fromPoints(Offset(_offset.dx, _offset.dy), Offset(_offset.dx + widget.width!, _offset.dy + widget.height!)),
      left: _offset.dx,
      top: _offset.dy,
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        onScaleStart: (ScaleStartDetails details) {
          _startingFocalPoint = details.focalPoint;
          _previousOffset = _offset;

          // print("begin - focal : ${details.focalPoint}, local : ${details.localFocalPoint}");
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          final Offset normalizedOffset = (_startingFocalPoint - _previousOffset);

          Offset __offset = details.focalPoint - normalizedOffset;

          __offset = Offset(max(__offset.dx, -widget.width!), max(__offset.dy, -widget.height!));

          __offset = Offset(min(__offset.dx, widget.viewport!.width), min(__offset.dy, widget.viewport!.height));

          setState(() {
            _offset = __offset;
            // print("move - $_offset, scale : $_scale");
          });
        },
        child: widget.ghost,
      ),
    );
  }
}
