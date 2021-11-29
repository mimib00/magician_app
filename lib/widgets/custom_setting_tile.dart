import 'package:flutter/material.dart';
import 'package:magician_app/utils/constants.dart';

class CustomSettingTile extends StatelessWidget {
  final Function() onTap;
  final String title;
  final String? subTitle;
  const CustomSettingTile({Key? key, required this.onTap, required this.title, this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 65,
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: const Color(0xff8390C1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subTitle == null
                    ? Container()
                    : Text(
                        subTitle!,
                        style: const TextStyle(color: Color(0xff8390C1), fontSize: 14, fontWeight: FontWeight.normal),
                      ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
