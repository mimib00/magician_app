// ignore_for_file: prefer_final_fields

import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';

class DataManager extends ChangeNotifier {
  bool hasPermission = false;
  List<CameraDescription>? _cameras; // store the available cameras for later use

  List<AssetEntity> images = [];
  List<Uint8List?> thumbs = [];
  List<File?> files = [];

  int _currentPage = 0;
  int _pageSize = 20;

  List<CameraDescription>? get cameras => _cameras;

  set setCurrentPage(int page) => _currentPage = page;
  set setPageSize(int size) => _pageSize = size;

  void init() async {
    var result = await PhotoManager.requestPermissionExtend();
    hasPermission = result.isAuth;
    // if (hasPermission)
  }

  setAvailableCameras(List<CameraDescription> cameras) => _cameras = cameras;

  void getImages() async {
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image, onlyAll: true);
    final recentAlbum = albums.first;

    final recentAssets = await recentAlbum.getAssetListPaged(_currentPage, _pageSize);
    images = recentAssets;
    notifyListeners();
  }

  void getThumbs() async {
    thumbs.clear();
    for (var image in images) {
      var temp = await image.thumbData;
      thumbs.add(temp);
    }
    notifyListeners();
  }
}
