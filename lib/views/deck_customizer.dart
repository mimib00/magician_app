import 'package:flutter/material.dart';
import 'package:magician_app/provider/data_manager.dart';
import 'package:magician_app/utils/cards_icons.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/widgets/color_dropdown.dart';
import 'package:magician_app/widgets/custom_drop_down.dart';
import 'package:magician_app/widgets/playing_card.dart';

import 'package:provider/provider.dart';

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
                children: [
                  StaticPlayingCard(
                    "H-A",
                  ),
                  StaticPlayingCard(
                    "C-7",
                  ),
                  StaticPlayingCard(
                    "D-9",
                  ),
                  StaticPlayingCard(
                    "S-5",
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
                  id: 'card_background',
                  initialColor: context.watch<DataManager>().backgroundColor!.value,
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
                  id: "coeur_carreau",
                  initialColor: context.watch<DataManager>().coeurCarreau!.value,
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
                  id: "trefle_pique",
                  initialColor: context.watch<DataManager>().treflePique!.value,
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
