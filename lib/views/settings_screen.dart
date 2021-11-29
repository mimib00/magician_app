import 'package:flutter/material.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/views/deck_customizer.dart';
import 'package:magician_app/widgets/custom_setting_tile.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          CustomSettingTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DeckCustomizer()));
            },
            title: "Deck Selection",
            subTitle: "Customize your deck",
          ),
          const Divider(
            thickness: 3,
            color: primaryColor,
          ),
        ],
      ),
    );
  }
}
