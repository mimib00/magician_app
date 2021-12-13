// ignore_for_file: prefer_final_fields

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This class manage the state of difrent elements of the app
class DataManager extends ChangeNotifier {
  //Color data for the cards
  Color? backgroundColor;
  Color? coeurCarreau;
  Color? treflePique;

  bool hasPermission = false;

  List<CameraDescription> _cameras = []; // store the available cameras for later use
  late CameraController _controller;

  Offset _offset = Offset.zero;
  Offset _previousOffset = Offset.zero;
  Offset _startingFocalPoint = Offset.zero;

  String _selectedCard = 'H-A';

  AssetEntity? image;

  List<AssetEntity> images = [];
  List<Uint8List?> thumbs = [];
  List<File?> files = [];

  List<CameraDescription> get cameras => _cameras;
  CameraController get controller => _controller;
  Offset get offset => _offset;
  String get selectedCard => _selectedCard;

  initializeCamera(int cameraIndex) async {
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      _cameras[cameraIndex],
      // Define the resolution to use.
      ResolutionPreset.max,
    );

    // Next, initialize the controller. This returns a Future.
    await _controller.initialize();
    notifyListeners();
  }

  disposeController() => _controller.dispose();

  setAvailableCameras(List<CameraDescription> cameras) => _cameras = cameras;

  /// Initilize card props if they are null.
  void initCardProps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> keys = [
      "card_background",
      "coeur_carreau",
      "trefle_pique",
    ];

    for (var key in keys) {
      switch (key) {
        case "card_background":
          prefs.setInt(key, Colors.white.value);
          backgroundColor = Colors.white;
          break;
        case "coeur_carreau":
          prefs.setInt(key, Colors.red.value);
          coeurCarreau = Colors.red;
          break;
        case "trefle_pique":
          prefs.setInt(key, Colors.black.value);
          treflePique = Colors.black;
          break;
        default:
      }
    }
    notifyListeners();
  }

  /// Set the value to the it's key.
  void setCardProps(String key, int color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, color);
    getCardProps();
    notifyListeners();
  }

  /// Fetches card props from phone.
  void getCardProps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var keys = prefs.getKeys().toList();
    if (keys.length < 3) {
      initCardProps();
      return;
    }

    for (var key in keys) {
      switch (key) {
        case "card_background":
          var value = prefs.getInt("card_background");
          var colorCode = int.parse(value.toString());
          backgroundColor = Color(colorCode);
          break;
        case "coeur_carreau":
          var value = prefs.getInt("coeur_carreau");
          var colorCode = int.parse(value.toString());
          coeurCarreau = Color(colorCode);
          break;
        case "trefle_pique":
          var value = prefs.getInt("trefle_pique");
          var colorCode = int.parse(value.toString());
          treflePique = Color(colorCode);
          break;
        default:
      }
    }
  }

  selectCard(String name) {
    _selectedCard = name;
    notifyListeners();
  }

  void onInitOffset(Size viewport) {
    if (_offset == Offset.zero) {
      _offset = Offset(viewport.width / 3, viewport.height / 3);
    } else {
      return;
    }
  }

  void onScaleStart(ScaleStartDetails details) {
    _startingFocalPoint = details.focalPoint;
    _previousOffset = _offset;

    // print("begin - focal : ${details.focalPoint}, local : ${details.localFocalPoint}");
  }

  void onScaleUpdate(ScaleUpdateDetails details, double width, double height, Size viewport) {
    final Offset normalizedOffset = (_startingFocalPoint - _previousOffset);

    Offset __offset = details.focalPoint - normalizedOffset;

    __offset = Offset(max(__offset.dx, -width), max(__offset.dy, -height));

    __offset = Offset(min(__offset.dx, viewport.width), min(__offset.dy, viewport.height));

    _offset = __offset;
    // print("move - $_offset, scale : $_scale");
    notifyListeners();
  }
}
