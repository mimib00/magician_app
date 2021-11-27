import 'package:flutter/material.dart';

class PlayingCard {
  final String name;

  PlayingCard(this.name);

  Color backgroundColor = Colors.white;
  Color textColor = Colors.red;

  setColor(Color? text, {Color? background}) {
    if (background == null) {
      textColor = text!;
    } else {
      backgroundColor = background;
      textColor = text!;
    }
  }
}
