import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:magician_app/provider/data_manager.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/views/editor.dart';
import 'package:magician_app/widgets/photo_editor.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null) return const Center(child: CircularProgressIndicator(color: primaryColor));
        // If there's data, display it as an image

        return GestureDetector(
          onTap: () {
            context.read<DataManager>().setWorkingImage(asset);
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => PhotoEditor(asset)));
          },
          child: Container(
            margin: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(bytes, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}
