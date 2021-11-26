// ignore_for_file: prefer_final_fields

import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';

/// This class manage the state of difrent elements of the app
class DataManager extends ChangeNotifier {
  bool hasPermission = false;

  List<CameraDescription> _cameras = []; // store the available cameras for later use
  late CameraController _controller;

  List<AssetEntity> images = [];
  List<Uint8List?> thumbs = [];
  List<File?> files = [];

  double _scale = 0;

  int _currentPage = 0;
  int _pageSize = 100;

  List<CameraDescription> get cameras => _cameras;
  CameraController get controller => _controller;

  double get scale => _scale;

  set setCurrentPage(int page) => _currentPage = page;
  set setPageSize(int size) => _pageSize = size;

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

  void _init() async {
    var result = await PhotoManager.requestPermissionExtend();
    hasPermission = result.isAuth;
  }

  setAvailableCameras(List<CameraDescription> cameras) => _cameras = cameras;

  void getImages() async {
    _init();
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image, onlyAll: true);
    final recentAlbum = albums.first;

    final recentAssets = await recentAlbum.getAssetListPaged(_currentPage, _pageSize);
    images = recentAssets;
    notifyListeners();
  }
}
