import 'package:flutter/material.dart';
import 'package:magician_app/utils/cards_icons_icons.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/widgets/card.dart';
import 'package:magician_app/widgets/color_dropdown.dart';
import 'package:magician_app/widgets/custom_drop_down.dart';

class DeckCustomizer extends StatelessWidget {
  const DeckCustomizer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Your Deck'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  MagicCard(
                    cardName: "H-A",
                  ),
                  MagicCard(
                    cardName: "C-7",
                  ),
                  MagicCard(
                    cardName: "D-9",
                  ),
                  MagicCard(
                    cardName: "S-5",
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 18),
              child: Text(
                "Symbols",
                style: TextStyle(color: primaryColor, fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
            //symbols
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: CustomDropDown(
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          CardsIcons.coeur,
                          color: Colors.white,
                          size: 35,
                        ),
                        Icon(
                          CardsIcons.carreau,
                          color: Colors.white,
                          size: 35,
                        ),
                        Icon(
                          CardsIcons.trefle,
                          color: Colors.white,
                          size: 35,
                        ),
                        Icon(
                          CardsIcons.pique,
                          color: Colors.white,
                          size: 35,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //colors
            const Padding(
              padding: EdgeInsets.only(bottom: 18),
              child: Text(
                "Colors",
                style: TextStyle(color: secondaryColor, fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Background",
                  style: TextStyle(color: Color(0xff8390C1), fontSize: 18, fontWeight: FontWeight.normal),
                ),
                ColorDropDown(
                  initialColor: Colors.white,
                  items: const [
                    Colors.white,
                    Colors.red,
                    Colors.black,
                    Colors.blue,
                    Colors.green
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(
                        CardsIcons.coeur,
                        color: Color(0xff8390C1),
                        size: 30,
                      ),
                      Icon(
                        CardsIcons.carreau,
                        color: Color(0xff8390C1),
                        size: 30,
                      )
                    ],
                  ),
                ),
                ColorDropDown(
                  initialColor: Colors.red,
                  items: const [
                    Colors.white,
                    Colors.red,
                    Colors.black,
                    Colors.blue,
                    Colors.green
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(
                        CardsIcons.trefle,
                        color: Color(0xff8390C1),
                        size: 30,
                      ),
                      Icon(
                        CardsIcons.pique,
                        color: Color(0xff8390C1),
                        size: 30,
                      )
                    ],
                  ),
                ),
                ColorDropDown(
                  initialColor: Colors.black,
                  items: const [
                    Colors.white,
                    Colors.red,
                    Colors.black,
                    Colors.blue,
                    Colors.green
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(
                        CardsIcons.coeur,
                        color: Colors.white,
                        size: 35,
                      ),
                      Icon(
                        CardsIcons.carreau,
                        color: Colors.white,
                        size: 35,
                      ),
                      Icon(
                        CardsIcons.trefle,
                        color: Colors.white,
                        size: 35,
                      ),
                      Icon(
                        CardsIcons.pique,
                        color: Colors.white,
                        size: 35,
                      ),
                    ],
                  )*/