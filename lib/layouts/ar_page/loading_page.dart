import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tavrida_flutter/widgets/failures/failure.dart';

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
      if (Platform.isIOS) {
        var data = await const MethodChannel('com.hendrick.navigateChannel').invokeMethod(
            'flutterNavigate',
            {
              "path": '${dir.path}/${model.id}.usdz',
              "id": model.id,
              "title": model.title,
              "description": model.description,
              "like": model.like,
            }
        );
        return data;
      }
      else {
        var data = await const MethodChannel('com.hendrick.navigateChannel').invokeMethod(
            'flutterNavigate',
            {
              "access_token": '${dir.path}/${model.id}.${Platform.isIOS ? 'usdz' : 'glb'}'
            }
        );
        return data;
      }
    } on PlatformException catch (e) {
      return 'Failed to invoke: ${e.message}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final indicator = DownloadProgressIndicator(
              url: (Platform.isIOS ? model.valueUrlUSDZ : model.valueUrl) ?? '',
              filename: '${model.id}.${Platform.isIOS ? 'usdz' : 'glb'}',
              onDownloadComplete: (file) {
                context.pop();
                navigateToNative();
              },
            );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _validateUrl(model) ? indicator :
              const FailureContent(
                title: 'Ошибка в данных модели!',
                message: 'Ссылка на модель не корректна для вашей платформы',
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
                child: Center(
                  child: Text(
                    _validateUrl(model) ? "Отмена" : "Выйти",
                    style: const TextStyle(
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

  bool _validateUrl(Model model){
    if (Platform.isIOS) {
      return model.valueUrlUSDZ?.endsWith('.usdz') ?? false;
    } else {
      return  model.valueUrl?.endsWith('.glb') ?? false;
    }
  }
}

