// ignore_for_file: must_be_immutable, unused_field

import 'package:flutter/material.dart';
import 'package:magician_app/provider/data_manager.dart';
import 'package:magician_app/utils/cards_icons.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    context.read<DataManager>().onInitOffset(widget.viewport!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Offset _offset = context.watch<DataManager>().offset;
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        onScaleStart: (ScaleStartDetails details) => context.read<DataManager>().onScaleStart(details),
        onScaleUpdate: (ScaleUpdateDetails details) => context.read<DataManager>().onScaleUpdate(details, widget.width!, widget.height!, widget.viewport!),
        child: widget.ghost,
      ),
    );
  }
}
