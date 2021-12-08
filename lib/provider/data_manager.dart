// ignore_for_file: prefer_final_fields

import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magician_app/models/working_modes.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This class manage the state of difrent elements of the app
class DataManager extends ChangeNotifier {
  //Color data for the cards
  Color? backgroundColor;
  Color? coeurCarreau;
  Color? treflePique;

  bool hasPermission = false;

  WorkingMode workingMode = WorkingMode.none;

  List<Widget> _items = [];

  List<CameraDescription> _cameras = []; // store the available cameras for later use
  late CameraController _controller;

  AssetEntity? image;

  List<AssetEntity> images = [];
  List<Uint8List?> thumbs = [];
  List<File?> files = [];

  AssetEntity? workingImage;

  double _scale = 0;

  List<Widget> get items => _items;
  List<CameraDescription> get cameras => _cameras;
  CameraController get controller => _controller;

  double get scale => _scale;

  setWorkingImage(AssetEntity image) {
    workingImage = image;
    notifyListeners();
  }

  initializeCamera(int cameraIndex, context) async {
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      _cameras[cameraIndex],
      // Define the resolution to use.
      ResolutionPreset.max,
    );

    // Next, initialize the controller. This returns a Future.
    await _controller.initialize();
    setScale(context);
    notifyListeners();
  }

  disposeController() => _controller.dispose();

  /// in the args list you must pass [context , _controller]
  setScale(context) {
    var camera = _controller.value;

    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    _scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (_scale < 1) _scale = 1 / _scale;
  }

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
}
