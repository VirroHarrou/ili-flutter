import 'dart:io';

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
import 'package:path_provider/path_provider.dart';
import 'package:tavrida_flutter/repositories/models/GetModel.dart';
import 'package:tavrida_flutter/repositories/models/LikeModel.dart';
import 'package:tavrida_flutter/repositories/views/models.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;


class ARPage extends StatefulWidget {
  ARPage({super.key});
  final GlobalKey _key = GlobalKey();

  @override
  State<StatefulWidget> createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  late Model model;
  HttpClient httpClient = HttpClient();
  bool isFirstBuild = true;

  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(isFirstBuild) {
      model = ModalRoute.of(context)?.settings.arguments as Model;
      _updateModel();
      isFirstBuild = false;
    }
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
                  icon: const Icon(Icons.layers_clear),
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
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0
                          ),
                          child: IconButton(
                              onPressed: () => onTakeScreenshot(),
                              color: AppColors.white,
                              icon: const Icon(Icons.photo_camera)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0
                          ),
                          child: IconButton(
                              onPressed: onInfo,
                              color: AppColors.white,
                              icon: const Icon(Icons.info_outline)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0
                          ),
                          child: IconButton(
                              onPressed: () {},
                              color: AppColors.white,
                              icon: const Icon(Icons.reply_outlined)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0
                          ),
                          child: IconButton(
                              onPressed: onLike,
                              color: AppColors.white,
                              icon: Icon(model?.like ?? false ? Icons.favorite : Icons.favorite_border),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ),
          ];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.settings.name == "/home");
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Container(
        color: const Color(0xFF066677),
        child: Stack(
          children: items,
        ),
      ),
    );
  }

  Future<void> onTakeScreenshot() async {
    ImageProvider<Object> image = await arSessionManager!.snapshot();
    await showDialog(
        context: context,
        builder: (_) => Dialog(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: image, fit: BoxFit.cover)),
          ),
        ));
    //Todo: настроить сохранение скриншотов или сделать фотки
  }

  Future<void> onLike() async {
    setState(() {
      model!.like = !model!.like!;
    });
    await likeModelAsync(model!.id!);
  }

  Future<void> onInfo() async {
    await showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${model?.title}\n${model?.description ?? ''}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ));
  }

  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
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
    anchors.forEach((anchor) {
      arAnchorManager!.removeAnchor(anchor);
    });
    anchors = [];
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
            (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor =
      ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
            type: NodeType.fileSystemAppFolderGLB,
            uri: "${model?.id}.glb",
            scale: Vector3(0.2, 0.2, 0.2),
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
  }

  onPanStarted(String nodeName) {
    print("Started panning node " + nodeName);
  }

  onPanChanged(String nodeName) {
    print("Continued panning node " + nodeName);
  }

  onPanEnded(String nodeName, Matrix4 newTransform) {
    print("Ended panning node " + nodeName);
    final pannedNode =
    nodes.firstWhere((element) => element.name == nodeName);

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
    final rotatedNode =
    nodes.firstWhere((element) => element.name == nodeName);

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
}
