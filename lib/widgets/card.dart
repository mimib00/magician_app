// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:magician_app/provider/data_manager.dart';
import 'package:magician_app/utils/cards_icons_icons.dart';
import 'package:provider/provider.dart';

class MagicCard extends StatelessWidget {
  final String cardName;
  MagicCard({Key? key, required this.cardName}) : super(key: key);

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
    return Container(
      height: 100,
      width: 70,
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
  }
}
