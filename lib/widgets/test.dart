import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magician_app/widgets/card.dart';

import 'package:vector_math/vector_math_64.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/rendering.dart';

// import './flutter_simple_sticker_image.dart';

typedef StickeImageRemoveCallback = void Function(PlayingCard sticker);

// Cards
class FlutterSimpleStickerImage extends StatefulWidget {
  FlutterSimpleStickerImage(
    this.image, {
    Key? key,
    this.width,
    this.height,
    this.viewport,
    this.minScale = 1.0,
    this.maxScale = 2.0,
    this.onTapRemove,
  }) : super(key: key);

  final Image image;
  final double? width;
  final double? height;
  final Size? viewport;

  final double minScale;
  final double maxScale;

  final StickeImageRemoveCallback? onTapRemove;

  final _FlutterSimpleStickerImageState _flutterSimpleStickerImageState = _FlutterSimpleStickerImageState();

  void prepareExport() {
    _flutterSimpleStickerImageState.hideRemoveButton();
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return "FlutterSimpleStickerImage-$key-${_flutterSimpleStickerImageState._offset}";
  }

  @override
  _FlutterSimpleStickerImageState createState() => _flutterSimpleStickerImageState;
}

class _FlutterSimpleStickerImageState extends State<FlutterSimpleStickerImage> {
  _FlutterSimpleStickerImageState();

  double _scale = 1.0;
  double _previousScale = 1.0;

  Offset _previousOffset = Offset(0, 0);
  Offset _startingFocalPoint = Offset(0, 0);
  Offset _offset = Offset(0, 0);

  double _rotation = 0.0;
  double _previousRotation = 0.0;

  bool _isSelected = false;

  @override
  void dispose() {
    super.dispose();
    _offset = Offset(0, 0);
    _scale = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: Rect.fromPoints(Offset(_offset.dx, _offset.dy), Offset(_offset.dx + widget.width!, _offset.dy + widget.height!)),
      child: Container(
        child: Stack(
          children: <Widget>[
            Center(
              child: Transform(
                transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
                // ..setRotationZ(_rotation),
                alignment: FractionalOffset.center,
                child: GestureDetector(
                  onScaleStart: (ScaleStartDetails details) {
                    _startingFocalPoint = details.focalPoint;
                    _previousOffset = _offset;
                    _previousRotation = _rotation;
                    _previousScale = _scale;

                    // print(
                    //     "begin - focal : ${details.focalPoint}, local : ${details.localFocalPoint}");
                  },
                  onScaleUpdate: (ScaleUpdateDetails details) {
                    _scale = min(max(_previousScale * details.scale, widget.minScale), widget.maxScale);

                    _rotation = details.rotation;

                    final Offset normalizedOffset = (_startingFocalPoint - _previousOffset) / _previousScale;

                    Offset __offset = details.focalPoint - (normalizedOffset * _scale);

                    __offset = Offset(max(__offset.dx, -widget.width!), max(__offset.dy, -widget.height!));

                    __offset = Offset(min(__offset.dx, widget.viewport!.width), min(__offset.dy, widget.viewport!.height));

                    setState(() {
                      _offset = __offset;
                      // print("move - $_offset, scale : $_scale");
                    });
                  },
                  onTap: () {
                    setState(() {
                      _isSelected = !_isSelected;
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      _isSelected = false;
                    });
                  },
                  onDoubleTap: () {
                    setState(() {
                      _scale = 1.0;
                    });
                  },
                  child: Container(child: widget.image),
                ),
              ),
            ),
            _isSelected
                ? Positioned(
                    top: 12,
                    right: 12,
                    width: 24,
                    height: 24,
                    child: Container(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.remove_circle),
                        color: Color.fromRGBO(255, 0, 0, 1.0),
                        onPressed: () {
                          print('tapped remove sticker');
                          if (widget.onTapRemove != null) {
                            // widget.onTapRemove!((widget));
                          }
                        },
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void hideRemoveButton() {
    setState(() {
      _isSelected = false;
    });
  }
}

// selector/editor
class FlutterSimpleStickerView extends StatefulWidget {
  FlutterSimpleStickerView(
    this.source,
    this.stickerList, {
    Key? key,
    this.stickerSize = 100.0,
    this.stickerMaxScale = 2.0,
    this.stickerMinScale = 0.5,
    this.panelHeight = 200.0,
    this.panelBackgroundColor = const Color(0xff000000),
    this.panelStickerBackgroundColor = const Color(0xffffffff),
    this.panelStickercrossAxisCount = 4,
    this.panelStickerAspectRatio = 1.0,
    this.devicePixelRatio = 3.0,
  }) : super(key: key);

  final Widget source;
  final List<String> stickerList;

  final double stickerSize;
  final double stickerMaxScale;
  final double stickerMinScale;

  final double panelHeight;
  final Color panelBackgroundColor;
  final Color panelStickerBackgroundColor;
  final int panelStickercrossAxisCount;
  final double panelStickerAspectRatio;
  final double devicePixelRatio;

  @override
  _FlutterSimpleStickerViewState createState() => _FlutterSimpleStickerViewState();
}

class _FlutterSimpleStickerViewState extends State<FlutterSimpleStickerView> {
  _FlutterSimpleStickerViewState();

  Size? viewport;

  List<PlayingCard> attachedList = [];

  final GlobalKey key = GlobalKey();

  void attachSticker(String name) {
    setState(() {
      attachedList.add(PlayingCard(
        name,
        key: Key("sticker_${attachedList.length}"),
        width: this.widget.stickerSize,
        height: this.widget.stickerSize,
        viewport: viewport,
        maxScale: this.widget.stickerMaxScale,
        minScale: this.widget.stickerMinScale,
        onTapRemove: (sticker) {
          this.onTapRemoveSticker(sticker);
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: RepaintBoundary(
            key: key,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    viewport = viewport ?? Size(constraints.maxWidth, constraints.maxHeight);
                    return widget.source;
                  },
                ),
                Stack(children: attachedList, fit: StackFit.expand)
              ],
            ),
          ),
        ),
        Scrollbar(
          child: DragTarget(
            builder: (BuildContext context, List<String?> candidateData, List<dynamic> rejectedData) {
              return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: this.widget.panelBackgroundColor,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.stickerList.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: this.widget.panelStickerBackgroundColor,
                            child: TextButton(
                                onPressed: () {
                                  attachSticker(widget.stickerList[i]);
                                },
                                child: MagicCard(widget.stickerList[i])),
                          ));
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: this.widget.panelStickercrossAxisCount, childAspectRatio: this.widget.panelStickerAspectRatio),
                  ),
                  height: this.widget.panelHeight);
            },
          ),
        ),
      ],
    );
  }

  Future<Uint8List> exportImage() async {
    RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: this.widget.devicePixelRatio);
    var byteData = await (image.toByteData(format: ImageByteFormat.png) as FutureOr<ByteData>);
    var pngBytes = byteData.buffer.asUint8List();

    return pngBytes;
  }

  void onTapRemoveSticker(PlayingCard sticker) {
    setState(() {
      attachedList.removeWhere((s) => s.key == sticker.key);
    });
  }
}

class FlutterSimpleStickerView extends StatefulWidget {
  FlutterSimpleStickerView(
    this.source,
    this.stickerList, {
    Key? key,
    this.stickerSize = 100.0,
    this.stickerMaxScale = 2.0,
    this.stickerMinScale = 0.5,
    this.panelHeight = 200.0,
    this.panelBackgroundColor = Colors.black,
    this.panelStickerBackgroundColor = Colors.white10,
    this.panelStickercrossAxisCount = 4,
    this.panelStickerAspectRatio = 1.0,
    this.devicePixelRatio = 3.0,
  }) : super(key: key);

  final Widget source;
  final List<Image> stickerList;

  final double stickerSize;
  final double stickerMaxScale;
  final double stickerMinScale;

  final double panelHeight;
  final Color panelBackgroundColor;
  final Color panelStickerBackgroundColor;
  final int panelStickercrossAxisCount;
  final double panelStickerAspectRatio;
  final double devicePixelRatio;

  final _FlutterSimpleStickerViewState _flutterSimpleStickerViewState = _FlutterSimpleStickerViewState();

  Future<Uint8List> exportImage() async {
    await _flutterSimpleStickerViewState._prepareExport();

    Future<Uint8List> exportImage = _flutterSimpleStickerViewState.exportImage();
    print("export image success!");
    return exportImage;
  }

  @override
  _FlutterSimpleStickerViewState createState() => _flutterSimpleStickerViewState;
}

class _FlutterSimpleStickerViewState extends State<FlutterSimpleStickerView> {
  _FlutterSimpleStickerViewState();

  Size? viewport;

  List<FlutterSimpleStickerImage> attachedList = [];

  final GlobalKey key = GlobalKey();

  void attachSticker(Image image) {
    setState(() {
      attachedList.add(FlutterSimpleStickerImage(
        image,
        key: Key("sticker_${attachedList.length}"),
        width: this.widget.stickerSize,
        height: this.widget.stickerSize,
        viewport: viewport,
        maxScale: this.widget.stickerMaxScale,
        minScale: this.widget.stickerMinScale,
        onTapRemove: (sticker) {
          this.onTapRemoveSticker(sticker);
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: RepaintBoundary(
            key: key,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    viewport = viewport ?? Size(constraints.maxWidth, constraints.maxHeight);
                    return widget.source;
                  },
                ),
                Stack(children: attachedList, fit: StackFit.expand)
              ],
            ),
          ),
        ),
        Scrollbar(
          child: DragTarget(
            builder: (BuildContext context, List<String?> candidateData, List<dynamic> rejectedData) {
              return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: widget.panelBackgroundColor,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.stickerList.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: this.widget.panelStickerBackgroundColor,
                            child: FlatButton(
                                onPressed: () {
                                  attachSticker(widget.stickerList[i]);
                                },
                                child: widget.stickerList[i]),
                          ));
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: this.widget.panelStickercrossAxisCount, childAspectRatio: this.widget.panelStickerAspectRatio),
                  ),
                  height: this.widget.panelHeight);
            },
          ),
        ),
      ],
    );
  }

  Future<Uint8List> exportImage() async {
    RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: this.widget.devicePixelRatio);
    var byteData = await (image.toByteData(format: ImageByteFormat.png) as FutureOr<ByteData>);
    var pngBytes = byteData.buffer.asUint8List();

    return pngBytes;
  }

  void onTapRemoveSticker(FlutterSimpleStickerImage sticker) {
    setState(() {
      this.attachedList.removeWhere((s) => s.key == sticker.key);
    });
  }

  Future<void> _prepareExport() async {
    attachedList.forEach((s) {
      s.prepareExport();
    });
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
