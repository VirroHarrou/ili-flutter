import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';

late ARSessionManager arSessionManager;
late ARObjectManager arObjectManager;

//String localObjectReference;
ARNode? localObjectNode;

//String webObjectReference;
ARNode? webObjectNode = ARNode(
    type: NodeType.webGLB,
    uri:
        'http://193.124.118.62/api/1.0/data/model/04582526db404835a735396ca36e9565.gltf');

void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager) {
  // 1
  arSessionManager = arSessionManager;
  arObjectManager = arObjectManager;
  arObjectManager.addNode(webObjectNode as ARNode);
  // 2
  arSessionManager.onInitialize(
    showFeaturePoints: true,
    showPlanes: true,
    customPlaneTexturePath: "triangle.png",
    showWorldOrigin: true,
    handleTaps: true,
    handleRotation: true,
  );
  // 3
  arObjectManager.onInitialize();
}
