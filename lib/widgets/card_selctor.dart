import 'dart:math';
import 'dart:developer' as dev;

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

  Widget? _dragedCard;

  setDragedCard(Widget card) => _dragedCard = card;

  restDragedCard() => _dragedCard = null;

  getRandomCard() {
    cards.clear();
    for (var i = 0; i < 5; i++) {
      var cardnumber = random.nextInt(52);
      cards.add(
        Draggable<MagicCard>(
          key: Key(i.toString()),
          feedback: MagicCard(
            cardName: cardsList[cardnumber],
          ),
          onDragStarted: () {
            var card = cards.where((element) => element.key == Key(i.toString())).first;
            setDragedCard(card);
            setState(() {
              cards.removeWhere((element) => element.key == Key(i.toString()));
            });
          },
          onDraggableCanceled: (velocity, offset) {
            setState(() {
              cards.insert(i, _dragedCard!);
            });
            restDragedCard();
          },
          child: MagicCard(
            cardName: cardsList[cardnumber],
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
