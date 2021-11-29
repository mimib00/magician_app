import 'package:flutter/material.dart';
import 'package:magician_app/utils/constants.dart';

class CustomDropDown extends StatefulWidget {
  final List<DropdownMenuItem<int>> items;
  const CustomDropDown({Key? key, required this.items}) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xff8390C1),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: widget.items[selectedItem].value,
          onChanged: (value) {
            setState(() {
              selectedItem = value!;
            });
          },
          isExpanded: true,
          iconSize: 80,
          iconEnabledColor: primaryColor,
          dropdownColor: backgroundColor.withRed(50),
          elevation: 1,
          borderRadius: BorderRadius.circular(11),
          items: widget.items,
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
          ),
        ),
      ),
    );
  }
}


/* @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xff8390C1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: finalItems(),
      ),
    );
  }*/
