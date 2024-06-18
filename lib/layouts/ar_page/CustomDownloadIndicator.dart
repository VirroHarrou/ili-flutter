import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tavrida_flutter/generated/l10n.dart';

class DownloadProgressIndicator extends StatefulWidget {
  final String url;
  final String? filename;
  final Function(File file) onDownloadComplete;

  const DownloadProgressIndicator({
    Key? key,
    required this.url,
    this.filename,
    required this.onDownloadComplete,
  }) : super(key: key);

  @override
  State<DownloadProgressIndicator> createState() => _DownloadProgressIndicatorState();
}

class _DownloadProgressIndicatorState extends State<DownloadProgressIndicator> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _checkFile();
  }

  Future<void> _checkFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${widget.filename}');
    if (!(await file.exists())) {
      _downloadFile('${widget.filename}');
    } else {
      widget.onDownloadComplete(file);
    }
  }

  Future<void> _downloadFile(String? filename) async {
    final dio = Dio();
    final response = await dio.get(
        widget.url,
        onReceiveProgress: (received, total) {
          setState(() {
            _progress = received / total;
          });
        },
        options: Options(
          responseType:  ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
    );
    final file = await _saveFile(response.data, filename);
    widget.onDownloadComplete(file);
  }

  Future<File> _saveFile(Uint8List bytes, String? filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = await File('${dir.path}/$filename').create();
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(S.of(context).loadModel,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16,),
        LinearProgressIndicator(
          value: _progress,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text("${(_progress * 100).round()} %",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}