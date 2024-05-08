import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../services/models/model.dart';

class ARKitPage extends StatefulWidget {
  const ARKitPage({super.key});

  @override
  State<ARKitPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ARKitPage> {
  bool isLoading = true;
  String path = '';

  @override
  void initState() {
    getFile();
    super.initState();
  }

  void getFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    if (mounted) {
      path = "$dir/${(ModalRoute.of(context)?.settings.arguments as Model).id!}.usdz";
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? const Center(
        child: CircularProgressIndicator(),
      ) : Stack(
        children: [
          UiKitView(
            viewType: 'MySwiftUIView',
            creationParams: path,
            creationParamsCodec: const StandardMessageCodec(),
          ),
          const Positioned(
            top: 30,
            left: 10,
            child: BackButton(),
          ),
        ],
      ),
    );
  }
}