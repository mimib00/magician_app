import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magician_app/models/card_types.dart';
import 'package:magician_app/utils/constants.dart';

import 'card.dart';

class CardSelector extends StatefulWidget {
  const CardSelector({Key? key}) : super(key: key);

  @override
  State<CardSelector> createState() => _CardSelectorState();
}

class _CardSelectorState extends State<CardSelector> {
  List<MagicCard> cards = [];
  Random random = Random();
  Random randomType = Random();

  getRandomCard() {
    cards.clear();
    for (var i = 0; i < 5; i++) {
      print(cardsList.length);
      var cardnumber = random.nextInt(52);
      cards.add(
        MagicCard(
          card: PlayingCard(cardsList[cardnumber]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    getRandomCard();
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: cards);
  }
}
