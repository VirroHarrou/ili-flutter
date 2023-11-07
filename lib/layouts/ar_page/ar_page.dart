import 'dart:io';
import 'dart:ui';

import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/models/GetModel.dart';
import 'package:tavrida_flutter/repositories/models/LikeModel.dart';
import 'package:tavrida_flutter/repositories/views/models.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tavrida_flutter/widgets/TalkerWidget.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:path/path.dart' as Path;
import 'dart:io' show Platform;


class ARPage extends StatefulWidget {
  ARPage({super.key});

  @override
  State<StatefulWidget> createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  late Model model;
  final _httpClient = HttpClient();
  bool _isFirstBuild = true;
  bool _isShowMessage = false;
  bool _showIcon = false;
  bool _isPhotoCreating = false;
  double _wightContainer = 0;
  String _messageText = '';
  double _scale = 1.0;

  var talker = TalkerWidget(
    height: 50,
    wight: 250,
    duration: 0,
    text: '',
    icon: const Icon(Icons.touch_app),
  );

  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  @override
  void dispose() {
    arSessionManager!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(_isFirstBuild) {
      model = ModalRoute.of(context)?.settings.arguments as Model;
      _updateModel();
      _isFirstBuild = false;
      _isShowMessage = true;
      _messageText = 'Поводите по горизонтальной поверхности,\nчтобы определить плоскость';
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _isShowMessage = true;
          _wightContainer = 414;
          _messageText = 'Поводите по горизонтальной поверхности,\nчтобы определить плоскость';
        });
        Future.delayed(const Duration(seconds: 6),() {
          setState(() {
            _wightContainer = 0;
          });
          Future.delayed(const Duration(milliseconds: 400), () {
            setState(() {
              _wightContainer = 414;
              _showIcon = true;
              _messageText = "Нажмите на горизонтальную поверхность и\nдождитесь появления 3D-модели";
            });
            Future.delayed(const Duration(seconds: 6), () {
              setState(() {
                _wightContainer = 0;
              });
              Future.delayed(const Duration(seconds: 400), () {
                setState(() {
                  _isShowMessage = false;
                });
              });
            });
          });
        });
      });
    }

    var rightButtons = [
      Padding(
        padding: const EdgeInsets.only(
            top: 8.0
        ),
        child: IconButton(
            onPressed: _onInfo,
            color: AppColors.white,
            icon: const Icon(Icons.info_outline)
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
            top: 8.0
        ),
        child: IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: model.code!));
              setState(() {
                talker = TalkerWidget(
                  text: 'Код модели скопирован в буфер',
                  icon: const Icon(Icons.check, color: AppColors.black,),
                  wight: 300,
                  height: 50,
                );
              });
            },
            color: AppColors.white,
            icon: const Icon(Icons.reply),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
            top: 8.0
        ),
        child: IconButton(
          onPressed: _onLike,
          color: AppColors.white,
          icon: Icon(model.like ?? false ? Icons.favorite : Icons.favorite_border),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
            top: 8.0
        ),
        child: IconButton(
            onPressed: () => onTakeScreenshot(),
            color: AppColors.white,
            icon: _isPhotoCreating
              ? const Icon(Icons.downloading, weight: 24,)
              : SvgPicture.asset("assets/icons/solar_camera-linear.svg", color: AppColors.white, width: 24,)
        ),
      ),
    ];
    List<Widget> items = [
      ARView(
        onARViewCreated: onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 30,
            left: 14,
          ),
          child: IconButton(
            color: AppColors.white,
            onPressed: onRemoveEverything,
            icon: SvgPicture.asset("assets/icons/eos-icons_content-deleted.svg", color: AppColors.white, width: 24,),
          ),
        ),
      ),
      Align(
        alignment: FractionalOffset.bottomRight,
        child: SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 30,
              right: 14,
            ),
            child: Column(
              verticalDirection: VerticalDirection.up,
              children: rightButtons,
            ),
          ),
        ),
      ),
      Align(
        alignment: FractionalOffset.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _downscaleModel,
                icon: const Icon(Icons.remove_circle_outline, color: AppColors.white),
              ),
              Text("${_scale.toStringAsFixed(1)}x", style: Theme.of(context).textTheme.headlineMedium,),
              IconButton(
                onPressed: _upscaleModel,
                icon: const Icon(Icons.add_circle_outline, color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
      Align(
        alignment: const Alignment(0.9, -0.9),
        child: talker,
      )
    ];

    if (_isShowMessage) {
      var container = AnimatedContainer(
        width: _wightContainer,
        height: 155,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        duration: const Duration(milliseconds: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                child: Text(
                  _messageText,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            _showIcon? Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset("assets/icons/horizon-alt.svg", height: 75,),
            ) : const Align(),
          ],
        ),
      );
      items.add(Align(
        alignment: const Alignment(0, -0.5),
        child: container,
      ));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
        elevation: 0,
        backgroundColor: AppColors.lightWhite,
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Container(
        color: AppColors.black,
        child: Stack(
          children: items,
        ),
      ),
    );
  }

  void onTakeScreenshot() async {
    if (_isPhotoCreating) return;

    final photo = await arSessionManager!.snapshot();
    await showDialog(
        context: context,
        builder: (_) {
          DecorationImage decorationImage = DecorationImage(
              image: photo,
              fit: BoxFit.cover
          );
          return Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            child: SizedBox(
              height: 650,
              width: 374,
              child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                          image: decorationImage
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.95),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, bottom: 20, right: 7),
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: SvgPicture.asset("assets/icons/restart-fill.svg"),
                              label: const Text(
                                'Переснять',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 16,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w500,
                                  height: 0.09,
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(AppColors.buttonSecondary),
                                  fixedSize: MaterialStateProperty.all(const Size(160, 48))
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7, bottom: 20, right: 20),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _isPhotoCreating = true;
                                });
                                saveImage(photo);
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.save_alt, color: AppColors.white,),
                              label: const Text(
                                'Сохранить',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w500,
                                  height: 0.09,
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(AppColors.buttonPrimary),
                                  fixedSize: MaterialStateProperty.all(const Size(160, 48))
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
              ),
            ),
          );
        });

  }

  Future<void> saveImage(ImageProvider image) async {

    //Todo: ссылку на логотип приложения
    final Image networkImage = Image.network(model.forumLogoUrl ?? AppSettings.imageNotFoundUrl);

    final imageBytes = await image.getBytes(context, format: ImageByteFormat.png);
    final networkBytes = await networkImage.image.getBytes(context, format: ImageByteFormat.png);

    final mainImage = img.decodePng(imageBytes ?? Uint8List(0));
    final logoImage = img.decodePng(networkBytes ?? Uint8List(0));
    final resizedImage = img.copyResize(logoImage!, width: (mainImage!.width / 3).floor());

    print("ssdasd");
    final imageResult = img.compositeImage(mainImage, resizedImage, dstX: 40, dstY: 40);

    Directory path = await getApplicationDocumentsDirectory();
    File file = File(Path.join(path.path,
        "${DateTime.now().toString().replaceAll(" ", ":")}.png"));
    await file.writeAsBytes(img.encodePng(imageResult));
    await GallerySaver.saveImage(file.path, toDcim: true, albumName: "ili - photos");
    file.delete();

    setState(() {
      _isPhotoCreating = false;
      talker = TalkerWidget(
        text: 'Фото сохранено',
        icon: const Icon(
          Icons.check_circle,
          color: AppColors.black,
        ),
        wight: 300,
        height: 50,
      );
    });
  }

  Future<void> _onLike() async {
    setState(() {
      model.like = !model.like!;
      talker = TalkerWidget(
        text: model.like!  ? 'В избранном' : 'Удалено из избранного',
        icon: Icon(
          model.like! ? Icons.check : Icons.heart_broken,
          color: AppColors.black,
        ),
        wight: 300,
        height: 50,
      );
    });
    await likeModelAsync(model.id!);
  }

  Future<void> _onInfo() async {
    await showDialog(
        context: context,
        builder: (_) => Dialog(
          alignment: Alignment.bottomCenter,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              height: model.description == null ? 200 : model.description!.length <= 200 ? 200 : 400,
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: Text(
                      "${model.title}",
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: Text(
                      model.description ?? 'Описание у данной модели отсутствует',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<File> _downloadFile(String url, String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    if(await file.exists()) {
      return file;
    }

    var request = await _httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);

    await file.writeAsBytes(bytes);

    return file;
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
      showAnimatedGuide: Platform.isAndroid,
      showFeaturePoints: false,
      showPlanes: false,
      customPlaneTexturePath: "Images/triangle.png",
      showWorldOrigin: false,
      handlePans: true,
      handleRotation: true,
    );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onPanStart = onPanStarted;
    this.arObjectManager!.onPanChange = onPanChanged;
    this.arObjectManager!.onPanEnd = onPanEnded;
    this.arObjectManager!.onRotationStart = onRotationStarted;
    this.arObjectManager!.onRotationChange = onRotationChanged;
    this.arObjectManager!.onRotationEnd = onRotationEnded;
  }

  Future<void> onRemoveEverything() async {
    /*nodes.forEach((node) {
      this.arObjectManager.removeNode(node);
    });*/
    for (var anchor in anchors) {
      arAnchorManager!.removeAnchor(anchor);
    }
    anchors = [];
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
            (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    var newAnchor =
    ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
    bool? didAddAnchor = await arAnchorManager!.addAnchor(newAnchor);
    if(anchors.isNotEmpty) {
      return;
    }
    if (didAddAnchor!) {
      anchors.add(newAnchor);
      final double scale = Platform.isAndroid ? 0.4 : 6;
      // Add note to anchor
      var newNode = ARNode(
          type: NodeType.fileSystemAppFolderGLB,
          uri: "${model.id}.glb",
          scale: Vector3(scale, scale, scale) * _scale,
          position: Vector3(0.0, 0.0, 0.0),
          rotation: Vector4(1.0, 0.0, 0.0, 0.0));
      bool? didAddNodeToAnchor =
      await arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
      if (didAddNodeToAnchor!) {
        nodes.add(newNode);
      } else {
        arSessionManager!.onError("Adding Node to Anchor failed");
      }
    } else {
      arSessionManager!.onError("Adding Anchor failed");
    }
    }

  onPanStarted(String nodeName) {
    print("Started panning node " + nodeName);
  }

  onPanChanged(String nodeName) {
    print("Continued panning node " + nodeName);
  }

  onPanEnded(String nodeName, Matrix4 newTransform) {
    print("Ended panning node " + nodeName);
    // final pannedNode =
    // nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //pannedNode.transform = newTransform;
  }

  onRotationStarted(String nodeName) {
    print("Started rotating node " + nodeName);
  }

  onRotationChanged(String nodeName) {
    print("Continued rotating node " + nodeName);
  }

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Ended rotating node " + nodeName);
    // final rotatedNode =
    // nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //rotatedNode.transform = newTransform;
  }

  Future<void> _updateModel() async {
    var result = await getModelAsync(null, model.id);
    setState(() {
      model = result ?? model;
    });
    _downloadFile(model.valueUrl ?? '', "${model.id}.glb");
  }

  void _upscaleModel() {
    final double scale = Platform.isAndroid ? 0.4 : 6;
    setState(() {
      if(_scale >= 4.71) {
        return;
      }
      _scale += 0.3;
    });
    for (var element in nodes) {
      element.scale = Vector3(scale, scale, scale) * _scale;
    }
  }

  void _downscaleModel() {
    final double scale = Platform.isAndroid ? 0.4 : 6;
    setState(() {
      if(_scale <= 0.33) {
        return;
      }
      _scale -= 0.3;
    });
    for (var element in nodes) {
      element.scale = Vector3(scale, scale, scale) * _scale;
    }
  }
}
