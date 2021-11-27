// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:magician_app/models/card_types.dart';

class MagicCard extends StatefulWidget {
  final PlayingCard card;
  MagicCard({Key? key, required this.card}) : super(key: key);

  @override
  State<MagicCard> createState() => _MagicCardState();
}

class _MagicCardState extends State<MagicCard> {
  Icon? _cardTypeIcon;
  String name = "";

  initCardInfo() {
    var type = widget.card.name.split('-');

    name = type[1];

    if (type[0] == "D") {
      _cardTypeIcon = const Icon(
        Icons.crop_square,
        color: Colors.red,
      );
      widget.card.setColor(Colors.red);
    } else if (type[0] == "H") {
      _cardTypeIcon = const Icon(
        Icons.favorite,
        color: Colors.red,
      );
      widget.card.setColor(Colors.red);
    } else if (type[0] == "C") {
      _cardTypeIcon = const Icon(
        Icons.arrow_upward_rounded,
        color: Colors.black,
      );
      widget.card.setColor(Colors.black);
    } else if (type[0] == "S") {
      _cardTypeIcon = const Icon(
        Icons.favorite,
        color: Colors.black,
      );
      widget.card.setColor(Colors.black);
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
              style: TextStyle(fontSize: 20, color: widget.card.textColor, fontWeight: FontWeight.bold),
            ),
          ),
          _cardTypeIcon!,
        ],
      ),
    );
  }
}
