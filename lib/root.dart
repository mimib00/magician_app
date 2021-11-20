import 'package:flutter/material.dart';
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
      body: screens[selectedScreen],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            selectedScreen = index;
          });
        },
        currentIndex: selectedScreen,
        type: BottomNavigationBarType.fixed,
        iconSize: 35,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.image), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
    );
  }
}
