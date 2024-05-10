import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show Platform;
import '../../services/models/model.dart';
import 'CustomDownloadIndicator.dart';
import 'package:flutter/services.dart';

class LoadingPage extends StatefulWidget{
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {

  Future<String> navigateToNative() async {
    try {
      final model = ModalRoute.of(context)?.settings.arguments as Model;
      final dir = (await getApplicationDocumentsDirectory());
      var data = await const MethodChannel('com.hendrick.navigateChannel').invokeMethod('flutterNavigate', {"argKey": '${dir.path}/${model.id}.glb'});
      return data;
    } on PlatformException catch (e) {
      return 'Failed to invoke: ${e.message}';
    }
  }
  @override
  Widget build(BuildContext context) {
    final model = ModalRoute.of(context)?.settings.arguments as Model;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DownloadProgressIndicator(
              url: model.valueUrl ?? '',
              filename: '${model.id}.glb' ?? '',
              onDownloadComplete: (file) {
                if (Platform.isAndroid) {
                  Navigator.of(context).pop();
                  navigateToNative();
                }
                else {
                  Navigator.pushReplacementNamed(context, "/ar_page", arguments: model);
                }
              },
            ),
            const SizedBox(height: 32,),
            InkWell(
              onTap: () => Navigator.of(context).pop(),
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

