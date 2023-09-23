import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tavrida_flutter/repositories/models/GetModel.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

class QRViewExample extends StatefulWidget{
  const QRViewExample({super.key});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  bool isPushed = false;
  bool isBadRequest = false;
  bool isLocked = false;
  int code = 0;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.grey,
              borderRadius: 10,
              cutOutSize: scanArea,
              overlayColor: const Color(0xBB000000),
            ),
          ),
          Align(
            alignment: const Alignment(0.0,0.2),
            child: SizedBox(
              height: 450,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text("Наведите камеру на QR-код", style: theme.textTheme.bodyMedium,),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Text("или введите код модели", style: theme.textTheme.bodyMedium,),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 4.0,
                            left: 50.0,
                            right: 50.0,
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: const Color(0xAAFFFFFF),
                              counter: Container(),
                            ),
                            style: TextStyle(
                                color: !isBadRequest ? AppColors.black : AppColors.red,
                                fontSize: 30,
                                height: 1,
                                textBaseline: TextBaseline.ideographic,
                                letterSpacing: 16.0,
                                fontWeight: FontWeight.w500
                            ),
                            textAlign: TextAlign.center,
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            onChanged: (input) {
                              if(input.length == 4) {
                                code = int.tryParse(input) ?? 0;
                              }
                              if (code != 0){
                                var response = getModelAsync(code, null);
                                response.then((value) {
                                  if(value == null || value.id == null){
                                    isBadRequest = true;
                                  } else {
                                    isBadRequest = false;
                                    Navigator.pushNamed(context, "/ar_page", arguments: value);
                                  }
                                  setState(() {});
                                });
                              }
                            },
                            onSubmitted: (input) {
                              if(input.length == 4) {
                                code = int.tryParse(input) ?? 0;
                              }
                              if (code != 0){
                                var response = getModelAsync(code, null);
                                response.then((value) {
                                  if(value == null || value.id == null){
                                    isBadRequest = true;
                                  } else {
                                    isBadRequest = false;
                                    Navigator.pushNamed(context, "/ar_page", arguments: value);
                                  }
                                  setState(() {});
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      if(result != null) {
        var response = await getModelAsync(null, result!.code);
        if(response != null && !isPushed) {
          isPushed = true;
            Navigator.pushNamed(context, "/ar_page", arguments: response);
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
