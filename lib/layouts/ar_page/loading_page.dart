import 'package:flutter/material.dart';

import '../../services/models/model.dart';
import 'CustomDownloadIndicator.dart';
import 'dart:io' show Platform;

class LoadingPage extends StatefulWidget{
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
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
              url: (Platform.isIOS ? model.valueUrlUSDZ : model.valueUrl) ?? '',
              filename: '${model.id}.${Platform.isIOS ? 'usdz' : 'glb'}',
              onDownloadComplete: (file) {
                Navigator.pushReplacementNamed(context, "/ar_page", arguments: model);
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

