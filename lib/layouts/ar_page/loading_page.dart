import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../../services/models/model.dart';
import 'CustomDownloadIndicator.dart';

class LoadingPage extends StatefulWidget{
  const LoadingPage({super.key, required this.model});

  final Model model;

  @override
  State<LoadingPage> createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {

  Future<String> navigateToNative() async {
    try {
      final model = widget.model;
      final dir = (await getApplicationDocumentsDirectory());
      var data = await const MethodChannel('com.hendrick.navigateChannel').invokeMethod('flutterNavigate', {"access_token": '${dir.path}/${model.id}.${Platform.isIOS ? 'usdz' : 'glb'}'});
      return data;
    } on PlatformException catch (e) {
      return 'Failed to invoke: ${e.message}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DownloadProgressIndicator(
              url: (Platform.isIOS ? model.valueUrlUSDZ : model.valueUrl) ?? '',
              filename: '${model.id}.${Platform.isIOS ? 'usdz' : 'glb'}',
              onDownloadComplete: (file) {
                context.pop();
                navigateToNative();
              },
            ),
            const SizedBox(height: 32,),
            InkWell(
              onTap: () => context.pop(),
              child: Container(
                height: 32,
                width: 96,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Center(
                  child: Text("Отмена",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

