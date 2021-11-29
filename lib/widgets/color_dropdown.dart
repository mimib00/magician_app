import 'package:flutter/material.dart';
import 'package:magician_app/provider/data_manager.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:provider/provider.dart';

class ColorDropDown extends StatefulWidget {
  final Color? initialColor;
  final String id;
  final List<Color> items;
  const ColorDropDown({Key? key, required this.items, required this.initialColor, required this.id}) : super(key: key);

  @override
  State<ColorDropDown> createState() => _ColorDropDownState();
}

class _ColorDropDownState extends State<ColorDropDown> {
  Color? selectedColor;
  @override
  Widget build(BuildContext context) {
    switch (widget.id) {
      case "card_background":
        selectedColor = context.watch<DataManager>().backgroundColor!;
        break;
      case "coeur_carreau":
        selectedColor = context.watch<DataManager>().coeurCarreau!;
        break;
      case "trefle_pique":
        selectedColor = context.watch<DataManager>().treflePique!;
        break;
      default:
    }

    return Container(
      width: MediaQuery.of(context).size.width * .4,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xff8390C1),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Color>(
          selectedItemBuilder: (context) {
            return widget.items.map((Color color) {
              return DropdownMenuItem<Color?>(
                value: color,
                child: Container(
                  width: 120,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              );
            }).toList();
          },
          value: selectedColor,
          onChanged: (Color? value) {
            context.read<DataManager>().setCardProps(widget.id, value!);
          },
          items: widget.items.map((Color color) {
            return DropdownMenuItem<Color>(
              value: color,
              child: Container(
                width: (MediaQuery.of(context).size.width * .4),
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            );
          }).toList(),
          iconEnabledColor: secondaryColor,
          dropdownColor: backgroundColor.withRed(50),
          iconSize: 40,
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
          ),
        ),
      ),
    );
  }
}
