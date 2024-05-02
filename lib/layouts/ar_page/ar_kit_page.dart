import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../repositories/views/model.dart';

class ARKitPage extends StatefulWidget {
  const ARKitPage({super.key,});

  @override
  State<ARKitPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ARKitPage> {
  bool isLoading = true;
  late Model model;
  String path = '';

  @override
  void initState() {
    da();
    super.initState();
  }

  void da() async {
    // model = (await getModelAsync(null, widget.model.id))!;
    // print(model.valueUrlUSDZ);
    final file = await _downloadFile('https://developer.apple.com/augmented-reality/quick-look/models/vintagerobot2k/robot_walk_idle.usdz', 'robot_walk_idle.usdz');
    path = file.path;
    print(file.path);
    isLoading = false;
    setState(() {

    });
  }

  Future<File> _downloadFile(String url, String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    if(await file.exists()) {
      return file;
    }

    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);

    await file.writeAsBytes(bytes);

    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : Stack(
        children: [
          UiKitView(
            viewType: 'MySwiftUIView',
            creationParams: path,
            creationParamsCodec: StandardMessageCodec(),
          ),
          Positioned(
            top: 30,
            left: 10,
            child: BackButton(),
          ),
        ],
      ),
    );
  }
}