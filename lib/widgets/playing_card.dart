// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magician_app/provider/data_manager.dart';
import 'package:magician_app/utils/cards_icons_icons.dart';
import 'package:provider/provider.dart';

import 'package:vector_math/vector_math_64.dart';

typedef StickeImageRemoveCallback = void Function(PlayingCard sticker);

class PlayingCard extends StatefulWidget {
  const PlayingCard(
    this.name, {
    Key? key,
    this.width,
    this.height,
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

  final StickeImageRemoveCallback? onTapRemove;

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
  Offset _offset = Offset.zero;

  double _rotation = 0.0;
  double _previousRotation = 0.0;

  bool _isSelected = false;

  @override
  void dispose() {
    super.dispose();
    _offset = Offset.zero;
    _scale = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.name.split('-');
    var symbol = type[1];

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

    return Positioned.fromRect(
      rect: Rect.fromPoints(Offset(_offset.dx, _offset.dy), Offset(_offset.dx + widget.width!, _offset.dy + widget.height!)),
      child: Stack(
        children: [
          Center(
            child: Transform(
              transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
              alignment: FractionalOffset.center,
              child: GestureDetector(
                onScaleStart: (ScaleStartDetails details) {
                  _startingFocalPoint = details.focalPoint;
                  _previousOffset = _offset;
                  _previousRotation = _rotation;
                  _previousScale = _scale;

                  print("begin - focal : ${details.focalPoint}, local : ${details.localFocalPoint}");
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
                    print("move - $_offset, scale : $_scale");
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
          ),
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
