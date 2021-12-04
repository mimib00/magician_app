import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magician_app/provider/data_manager.dart';
import 'package:magician_app/utils/constants.dart';
import 'card.dart';
import 'package:provider/provider.dart';

class CardSelector extends StatefulWidget {
  const CardSelector({Key? key}) : super(key: key);

  @override
  State<CardSelector> createState() => _CardSelectorState();
}

class _CardSelectorState extends State<CardSelector> {
  List<Widget> cards = [];
  Random random = Random();
  Random randomType = Random();

  getRandomCard() {
    cards.clear();
    for (var i = 0; i < 5; i++) {
      var cardnumber = random.nextInt(52);
      cards.add(
        GestureDetector(
          // onTap: () => context.read<DataManager>().addCards(cardsList[cardnumber]),
          child: PlayingCard(
            cardsList[cardnumber],
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    getRandomCard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: cards,
    );
  }
}
