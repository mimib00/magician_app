import 'package:flutter/material.dart';
import 'package:magician_app/widgets/asset_thumbnail.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  bool hasPermission = false;
  List<AssetEntity> images = [];

  @override
  void initState() {
    _getImages();
    super.initState();
  }

  void _getImages() async {
    int _currentPage = 0;
    int _pageSize = 100;

    final result = await PhotoManager.requestPermissionExtend();

    if (result.isAuth) {
      final albums = await PhotoManager.getAssetPathList(type: RequestType.image, onlyAll: true);
      final recentAlbum = albums.first;

      final recentAssets = await recentAlbum.getAssetListPaged(_currentPage, _pageSize);

      setState(() {
        images = recentAssets;
      });
    }
  }

  @override
  void dispose() {
    images.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        // A grid view with 3 items per row
        crossAxisCount: 3,
      ),
      itemCount: images.length,
      itemBuilder: (_, index) {
        return AssetThumbnail(
          asset: images[index],
        );
      },
    );
  }
}
