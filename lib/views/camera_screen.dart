import 'package:blur/blur.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:magician_app/provider/data_manager.dart';
import 'package:magician_app/utils/cards_icons.dart';
import 'package:magician_app/utils/constants.dart';
import 'package:magician_app/utils/magician_icons_icons.dart';
import 'package:magician_app/views/photo_editor.dart';
import 'package:magician_app/widgets/playing_card.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  //To control the camera
  int selectedCamera = 0;
  bool isFlashOn = true;

  @override
  void initState() {
    context.read<DataManager>().initializeCamera(0); //Initially selectedCamera = 0

    super.initState();
  }

  void takePicture(CameraController controller) async {
    final image = await controller.takePicture();

    final path = image.path;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhotoEditor(
          source: path,
        ),
      ),
    );
  }

  Map<String, dynamic> cardMaker(String cardName) {
    final type = cardName.split('-');
    final name = type[1];
    Icon? _cardTypeIcon;
    Color? cardColor;

    switch (type[0]) {
      case "D":
        _cardTypeIcon = Icon(
          CardsIcons.carreau,
          color: context.watch<DataManager>().coeurCarreau,
        );
        cardColor = context.watch<DataManager>().coeurCarreau;
        break;
      case "H":
        _cardTypeIcon = Icon(
          CardsIcons.coeur,
          color: context.watch<DataManager>().coeurCarreau,
        );
        cardColor = context.watch<DataManager>().coeurCarreau;
        break;
      case "C":
        _cardTypeIcon = Icon(
          CardsIcons.trefle,
          color: context.watch<DataManager>().treflePique,
        );
        cardColor = context.watch<DataManager>().treflePique;
        break;
      case "S":
        _cardTypeIcon = Icon(
          CardsIcons.pique,
          color: context.watch<DataManager>().treflePique,
        );
        cardColor = context.watch<DataManager>().treflePique;
        break;
      default:
    }
    return {
      "name": name,
      "icon": _cardTypeIcon,
      "color": cardColor,
    };
  }

  @override
  Widget build(BuildContext context) {
    var _controller = context.watch<DataManager>().controller;
    Widget ghostImage = GhostSticker(
      Stack(
        children: [
          SvgPicture.asset("assets/images/Ghost.svg"),
          Positioned(
            child: HandCard(
              context.watch<DataManager>().selectedCard,
            ),
          ),
        ],
      ),
      key: Key("sticker_${context.watch<DataManager>().selectedCard}"),
      viewport: Size(kWidth(context), kHeight(context)),
    );
    Widget child;
    if (_controller.value.isInitialized) {
      child = RepaintBoundary(
        child: Stack(
          fit: StackFit.expand,
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return CameraPreview(
                  _controller,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 10,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: backgroundColor,
                                titleTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                title: const Text("Select a card"),
                                content: SizedBox(
                                  height: kHeight(context) * .7,
                                  width: kWidth(context),
                                  child: GridView.builder(
                                    itemCount: cardsList.length,
                                    itemBuilder: (_, index) {
                                      final data = cardMaker(cardsList[index]);
                                      return GestureDetector(
                                        onTap: () {
                                          context.read<DataManager>().selectCard(cardsList[index]);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(5),
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Text(
                                                data['name'],
                                                style: TextStyle(fontSize: 20, color: data['color'], fontWeight: FontWeight.bold),
                                              ),
                                              data["icon"]
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      // A grid view with 3 items per row
                                      crossAxisCount: 4,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xff181B30).withOpacity(.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/CardSelector.svg',
                              width: kWidth(context) * .06,
                              height: kHeight(context) * .04,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Blur(
                          blur: 2.5,
                          blurColor: const Color(0xff181B30).withOpacity(.5),
                          child: Container(
                            height: MediaQuery.of(context).size.height * .06,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (isFlashOn) {
                                    _controller.setFlashMode(FlashMode.off);
                                    setState(() {
                                      isFlashOn = false;
                                    });
                                  } else {
                                    _controller.setFlashMode(FlashMode.always);
                                    setState(() {
                                      isFlashOn = true;
                                    });
                                  }
                                },
                                icon: Icon(
                                  isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                                  color: Colors.grey[200],
                                  size: 35,
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () => takePicture(_controller),
                                child: const CircleAvatar(
                                  backgroundColor: mainGrayColor,
                                  radius: 35,
                                  child: Center(
                                    child: Icon(
                                      MagicianIcons.camera,
                                      color: Colors.black,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                onPressed: () {
                                  if (context.read<DataManager>().cameras.length > 1) {
                                    setState(() {
                                      selectedCamera = selectedCamera == 0 ? 1 : 0;
                                      context.read<DataManager>().initializeCamera(selectedCamera);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('No secondary camera found'),
                                      duration: Duration(seconds: 2),
                                    ));
                                  }
                                },
                                icon: Icon(
                                  MagicianIcons.rotatecamera,
                                  color: Colors.grey[200],
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            ghostImage,
          ],
        ),
      );
    } else {
      child = const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }
    setState(() {});
    return child;
  }
}
