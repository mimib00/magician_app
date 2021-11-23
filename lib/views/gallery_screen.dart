import 'package:flutter/material.dart';
import 'package:magician_app/provider/data_manager.dart';
import 'package:magician_app/widgets/asset_thumbnail.dart';
import 'package:provider/provider.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<DataManager>().getImages();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        // A grid view with 3 items per row
        crossAxisCount: 3,
      ),
      itemCount: context.read<DataManager>().images.length,
      itemBuilder: (_, index) {
        return AssetThumbnail(asset: context.read<DataManager>().images[index]);
      },
    );
  }
}
