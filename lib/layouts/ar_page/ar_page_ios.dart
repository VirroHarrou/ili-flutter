// import 'dart:io';
// import 'package:arkit_plugin/arkit_plugin.dart';
// import 'package:collection/collection.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:path_provider/path_provider.dart';
// import '../../repositories/metrics/AddMetric.dart';
// import '../../repositories/models/GetModel.dart';
// import '../../repositories/models/LikeModel.dart';
// import '../../repositories/views/model.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;
// import 'dart:math' as math;
// import '../../themes/app_colors.dart';
// import '../../widgets/TalkerWidget.dart';
//
// class ARPageIOS extends StatefulWidget {
//   const ARPageIOS({super.key, required this.model,});
//
//   final Model model;
//
//   @override
//   State<ARPageIOS> createState() => _ARPageIOSState();
// }
//
// class _ARPageIOSState extends State<ARPageIOS> {
//   late Model model;
//   final _httpClient = HttpClient();
//   late ARKitController arkitController;
//   ARKitGltfNode? boxNode;
//   bool isLoading = true;
//   int scale = 5;
//
//   var talker = TalkerWidget(
//     height: 50,
//     wight: 250,
//     duration: 0,
//     text: '',
//     icon: const Icon(Icons.touch_app),
//   );
//
//   @override
//   void dispose() {
//     arkitController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _updateModel() async {
//     model = widget.model;
//     var result = await getModelAsync(null, model.id);
//     model = result ?? model;
//     print(model.id);
//     MetricRepos.createRecord("11111111-1111-1111-1111-111111111111", MetricType.arScreen, 1);
//     MetricRepos.createRecord(model.id.toString(), MetricType.modelViews, 1);
//     final da = await _downloadFile(model.valueUrl ?? '', "${model.id}.glb");
//     print(da.path);
//   }
//
//   Future<File> _downloadFile(String url, String filename) async {
//     String dir = (await getApplicationDocumentsDirectory()).path;
//     File file = File('$dir/$filename');
//     if(await file.exists()) {
//       setState(() {
//         isLoading = false;
//       });
//
//       return file;
//     }
//
//     var request = await _httpClient.getUrl(Uri.parse(url));
//     var response = await request.close();
//     var bytes = await consolidateHttpClientResponseBytes(response);
//
//     await file.writeAsBytes(bytes);
//
//     setState(() {
//       isLoading = false;
//     });
//
//     return file;
//   }
//
//   @override
//   void initState() {
//     _updateModel();
//     super.initState();
//   }
//
//   Future<void> _onLike() async {
//     setState(() {
//       model.like = !model.like!;
//       talker = TalkerWidget(
//         text: model.like!  ? 'В избранном' : 'Удалено из избранного',
//         icon: Icon(
//           model.like! ? Icons.check : Icons.heart_broken,
//           color: AppColors.black,
//         ),
//         wight: 300,
//         height: 50,
//       );
//     });
//     await likeModelAsync(model.id!);
//   }
//
//   Future<void> _onInfo() async {
//     await showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         alignment: Alignment.bottomCenter,
//         insetPadding: EdgeInsets.zero,
//         backgroundColor: Colors.transparent,
//         child: Padding(
//           padding: const EdgeInsets.all(0.0),
//           child: Container(
//             decoration: const BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//             ),
//             height: model.description == null ? 200 : model.description!.length <= 200 ? 200 : 400,
//             width: 400,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     top: 20,
//                     left: 20,
//                     right: 20,
//                   ),
//                   child: Text(
//                     "${model.title}",
//                     style: Theme.of(context).textTheme.headlineLarge,
//                     textAlign: TextAlign.left,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     top: 20,
//                     left: 20,
//                     right: 20,
//                   ),
//                   child: Text(
//                     model.description ?? 'Описание у данной модели отсутствует',
//                     style: Theme.of(context).textTheme.bodySmall,
//                     textAlign: TextAlign.left,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//       appBar: AppBar(title: const Text('ARKit in Flutter')),
//       body: isLoading ? const Center(child: CircularProgressIndicator()) : Stack(
//         children: [
//           ARKitSceneView(
//             showFeaturePoints: true,
//             enableTapRecognizer: true,
//             enableRotationRecognizer: true,
//             enablePanRecognizer: true,
//             enablePinchRecognizer: true,
//             planeDetection: ARPlaneDetection.horizontalAndVertical,
//             onARKitViewCreated: onARKitViewCreated,
//           ),
//           Align(
//             alignment: FractionalOffset.bottomRight,
//             child: SizedBox(
//               height: 300,
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                   bottom: 30,
//                   right: 14,
//                 ),
//                 child: Column(
//                   verticalDirection: VerticalDirection.up,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           top: 8.0
//                       ),
//                       child: IconButton(
//                           onPressed: () {
//                             _onInfo();
//                           },
//                           color: AppColors.white,
//                           icon: const Icon(Icons.info_outline)
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           top: 8.0
//                       ),
//                       child: IconButton(
//                         onPressed: () {
//                           Clipboard.setData(ClipboardData(text: model.code!));
//                           setState(() {
//                             talker = TalkerWidget(
//                               text: 'Код модели скопирован в буфер',
//                               icon: const Icon(Icons.check, color: AppColors.black,),
//                               wight: 300,
//                               height: 50,
//                             );
//                           });
//                         },
//                         color: AppColors.white,
//                         icon: const Icon(Icons.reply),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           top: 8.0
//                       ),
//                       child: IconButton(
//                         onPressed: () {
//                           _onLike();
//                         },
//                         color: AppColors.white,
//                         icon: Icon(model.like ?? false ? Icons.favorite : Icons.favorite_border),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Align(
//             alignment: FractionalOffset.bottomLeft,
//             child: Padding(
//               padding: const EdgeInsets.all(30),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       if (scale < 11) {
//                         scale++;
//                         setState(() {});
//                         boxNode?.scale = vector.Vector3(scale / 100, scale / 100, scale / 100);
//                       }
//                     },
//                     icon: const Icon(Icons.add_circle_outline, color: AppColors.white),
//                   ),
//                  Text("${scale}x", style: Theme.of(context).textTheme.headlineMedium,),
//                   IconButton(
//                     onPressed: () {
//                       if (scale > 1) {
//                         scale--;
//                         setState(() {});
//                         boxNode?.scale = vector.Vector3(scale / 100, scale / 100, scale / 100);
//                       }
//                     },
//                     icon: const Icon(Icons.remove_circle_outline, color: AppColors.white),
//                   ),
//                   IconButton(
//                     color: AppColors.white,
//                     onPressed: () {
//                       arkitController.remove(boxNode!.name);
//                     },
//                     icon: SvgPicture.asset("assets/icons/eos-icons_content-deleted.svg", color: AppColors.white, width: 24,),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Align(
//             alignment: const Alignment(0.9, -0.9),
//             child: talker,
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: InkWell(
//               onTap: () {},//onTakeScreenshot,
//               child: Padding(
//                 padding: const EdgeInsets.all(30.0),
//                 child: Container(
//                   width: 80,
//                   height: 80,
//                   clipBehavior: Clip.antiAlias,
//                   decoration: const BoxDecoration(),
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         left: 0,
//                         top: 0,
//                         child: Container(
//                           width: 80,
//                           height: 80,
//                           decoration: const ShapeDecoration(
//                             color: Colors.white,
//                             shape: OvalBorder(),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         left: 10,
//                         top: 10,
//                         child: Container(
//                           width: 60,
//                           height: 60,
//                           decoration: const ShapeDecoration(
//                             color: Colors.transparent,
//                             shape: OvalBorder(side: BorderSide(width: 2)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//   );
//
//   void onARKitViewCreated(ARKitController arkitController) {
//     this.arkitController = arkitController;
//     this.arkitController.onARTap = (ar) {
//       final point = ar.firstWhere(
//             (o) => o.type == ARKitHitTestResultType.featurePoint,
//       );
//       if (point != null) {
//         _onARTapHandler(point);
//       }
//     };
//     this.arkitController.onNodeRotation =
//         (rotation) => _onRotationHandler(rotation);
//     this.arkitController.onNodePinch = (pinch) => _onPinchHandler(pinch);
//     this.arkitController.onNodePan = (pan) => _onPanHandler(pan);
//     addNode();
//   }
//
//   void _onPanHandler(List<ARKitNodePanResult> pan) {
//     final panNode = pan.firstWhereOrNull((e) => e.nodeName == boxNode?.name);
//     print('pan');
//     if (panNode != null) {
//       final old = boxNode?.eulerAngles;
//       final newAngleY = panNode.translation.x * math.pi / 180;
//       boxNode?.eulerAngles =
//           vector.Vector3(old?.x ?? 0, newAngleY, old?.z ?? 0);
//     }
//   }
//
//   void _onARTapHandler(ARKitTestResult point) {
//     final position = vector.Vector3(
//       point.worldTransform.getColumn(3).x,
//       point.worldTransform.getColumn(3).y,
//       point.worldTransform.getColumn(3).z,
//     );
//     if (boxNode == null) {
//       boxNode = _getNodeFromFlutterAsset(position);
//       arkitController.add(boxNode!);
//     }
//     else {
//       boxNode?.position = position;
//     }
//     //
//     // boxNode = _getNodeFromFlutterAsset(position);
//     // // final node = _getNodeFromNetwork(position);
//     // arkitController.add(boxNode);
//   }
//
//   void addNode() {
//     boxNode = _getNodeFromFlutterAsset(vector.Vector3(0, 0, -0.5));
//     arkitController.add(boxNode!);
//   }
//
//   ARKitGltfNode _getNodeFromFlutterAsset(vector.Vector3 position) =>
//       ARKitGltfNode(
//         assetType: AssetType.documents,
//         url: "${model.id}.glb",
//         scale: vector.Vector3(0.05, 0.05, 0.05),
//         position: position,
//         name: 'Куб.003'
//       );
//
//   void _onRotationHandler(List<ARKitNodeRotationResult> rotation) {
//     final rotationNode = rotation.firstWhere(
//           (e) => e.nodeName == boxNode?.name,
//     );
//     if (rotationNode != null) {
//       final rotation = boxNode?.eulerAngles ??
//           vector.Vector3.zero() + vector.Vector3.all(rotationNode.rotation);
//       boxNode?.eulerAngles = rotation;
//     }
//   }
//
//   void _onPinchHandler(List<ARKitNodePinchResult> pinch) {
//     final pinchNode = pinch.firstWhere(
//           (e) => e.nodeName == boxNode?.name,
//     );
//     if (pinchNode != null) {
//       final scale = vector.Vector3.all(pinchNode.scale);
//       boxNode?.scale = scale;
//     }
//   }
// }
