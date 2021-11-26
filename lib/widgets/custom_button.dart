import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Function() onTap;
  final Color backgroundColor;
  final Icon icon;
  const CustomIconButton({Key? key, required this.onTap, required this.icon, this.backgroundColor = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(35),
        ),
        child: icon,
      ),
    );
  }
}
