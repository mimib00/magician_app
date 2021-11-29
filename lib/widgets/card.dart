// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:magician_app/utils/cards_icons_icons.dart';

class MagicCard extends StatefulWidget {
  final String cardName;
  const MagicCard({Key? key, required this.cardName}) : super(key: key);

  @override
  State<MagicCard> createState() => _MagicCardState();
}

class _MagicCardState extends State<MagicCard> {
  Icon? _cardTypeIcon;
  String name = "";
  Color? cardColor;

  initCardInfo() {
    final type = widget.cardName.split('-');
    name = type[1];

    switch (type[0]) {
      case "D":
        _cardTypeIcon = const Icon(
          CardsIcons.carreau,
          color: Colors.red,
        );
        cardColor = Colors.red;
        break;
      case "H":
        _cardTypeIcon = const Icon(
          CardsIcons.coeur,
          color: Colors.red,
        );
        cardColor = Colors.red;
        break;
      case "C":
        _cardTypeIcon = const Icon(
          CardsIcons.trefle,
          color: Colors.black,
        );
        cardColor = Colors.black;
        break;
      case "S":
        _cardTypeIcon = const Icon(
          CardsIcons.pique,
          color: Colors.black,
        );
        cardColor = Colors.black;
        break;
      default:
    }
  }

  @override
  void initState() {
    initCardInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 70,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
  }
}
