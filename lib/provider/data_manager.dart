import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class DataManager extends ChangeNotifier {
  List<CameraDescription>? _cameras;

  List<CameraDescription>? get cameras => _cameras;

  setAvailableCameras(List<CameraDescription> cameras) => _cameras = cameras;
}
