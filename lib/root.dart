import 'package:flutter/material.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/utils/magician_icons_icons.dart';
import 'package:magician_app/views/camera_screen.dart';
import 'package:magician_app/views/gallery_screen.dart';
import 'package:magician_app/views/settings_screen.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int selectedScreen = 1;
  List<Widget> screens = const [
    GalleryScreen(),
    CameraScreen(),
    SettingScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: screens[selectedScreen],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            selectedScreen = index;
          });
        },
        currentIndex: selectedScreen,
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        backgroundColor: backgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(MagicianIcons.gallery), label: ''),
          BottomNavigationBarItem(icon: Icon(MagicianIcons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(MagicianIcons.settings), label: ''),
        ],
      ),
    );
  }
}
