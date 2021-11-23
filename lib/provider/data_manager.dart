import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';

class DataManager extends ChangeNotifier {
  bool hasPermission = false;
  List<CameraDescription>? _cameras; // store the available cameras for later use

  List<AssetPathEntity> albums = [];
  AssetPathEntity? recentAlbum;
  List<AssetEntity> images = [];

  List<CameraDescription>? get cameras => _cameras;

  void init() async {
    var result = await PhotoManager.requestPermissionExtend();
    hasPermission = result.isAuth;
  }

  setAvailableCameras(List<CameraDescription> cameras) => _cameras = cameras;

  void getAlbums() async {
    albums = await PhotoManager.getAssetPathList(type: RequestType.image, onlyAll: true);
    recentAlbum = albums.first;
  }

  void getImages() async {
    getAlbums();
    final recentAssets = await recentAlbum!.getAssetListRange(start: 0, end: 100);
    images = recentAssets;
    notifyListeners();
  }
}
