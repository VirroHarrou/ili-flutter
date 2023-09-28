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
  bool onInput = false;

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
    var layout = Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.grey,
              borderRadius: 16,
              cutOutSize: scanArea,
              overlayColor: const Color(0xBB000000),
            ),
          ),
          Align(
            alignment: const Alignment(0.0,0.0),
            child: SizedBox(
              height: 370,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text("Наведите камеру на QR-код", style: theme.textTheme.bodyMedium,),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text("или введите код модели", style: theme.textTheme.bodyMedium,),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.65),
            child: SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "••••",
                  hintStyle: onInput ? const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ) : const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white54,
                  ),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  counter: const SizedBox(
                    height: 0,
                    width: 0,
                  ),
                  filled: true,
                  fillColor: onInput ? AppColors.grey: const Color(0x3394A1B2),
                ),
                style: TextStyle(
                    color: !isBadRequest ? AppColors.black : AppColors.red,
                    fontSize: 30,
                    textBaseline: TextBaseline.ideographic,
                    letterSpacing: 16.0,
                    fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
                maxLength: 4,
                keyboardType: TextInputType.number,
                onSubmitted: (input) {
                  if(input.length == 4) {
                    code = int.tryParse(input) ?? 0;
                  }
                  if (code != 0){
                    var response = getModelAsync(code, null);
                    response.then((value) {
                      if(value == null || value.id == null){
                        isBadRequest = true;
                        onInput = false;
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
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              child: Text('Если вам нет 18, используйте приложение в присутствии родителей. Cледите за своим окружением, AR может искажать объекты.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      );
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
        },
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: layout,
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
