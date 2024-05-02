import 'dart:io';

import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tavrida_flutter/repositories/metrics/AddMetric.dart';
import 'package:tavrida_flutter/services/model_service.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

class QRPage extends StatefulWidget{
  final bool mainNav;
  const QRPage({super.key, this.mainNav = false});

  @override
  State<StatefulWidget> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  final modelService = Injector.appInstance.get<ModelService>();
  bool isPushed = false;
  bool isBadRequest = false;
  bool isFirstBuild = true;
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
    if(isFirstBuild) {
      MetricRepos.createRecord("11111111-1111-1111-1111-111111111111", MetricType.qrScreen, 1);
      isFirstBuild = false;
    }
    var theme = Theme.of(context);
    final wight = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    double scanArea = (wight < 400 || height < 400)
        ? (wight < 300 || height < 300)
          ? 150
          : 225
        : 300;
    bool isKeyboardOff = MediaQuery.of(context).viewInsets.bottom == 0;
    return Scaffold(
      floatingActionButton: widget.mainNav ? null : FloatingActionButton(
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
            child: SizedBox(
              height: scanArea * 1.2,
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
              width: scanArea,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "••••",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.grey,
                  counter: const SizedBox(height: 0, width: 0,),
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
                  if (code != 0 && input.length == 4){
                    modelService.getModelDetail(code: code.toString())
                      .then((value) {
                      if(value == null || value.id == null){
                        isBadRequest = true;
                      } else {
                        isBadRequest = false;
                        Navigator.popAndPushNamed(context, "/Load", arguments: value);
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
                    modelService.getModelDetail(code: code.toString())
                      .then((value) {
                      if(value == null || value.id == null){
                        isBadRequest = true;
                      } else {
                        isBadRequest = false;
                        Navigator.popAndPushNamed(context, "/Load", arguments: value);
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
              padding: EdgeInsets.only(bottom: 30.0),
              child: SizedBox(
                width: 334,
                child: Text(
                  'Если вам нет 18, используйте приложение в присутствии родителей. Cледите за своим окружением, AR может искажать объекты.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                ),
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
        var response = await modelService.getModelDetail(id: result!.code);
        if(response != null && !isPushed) {
          isPushed = true;
          Navigator.popAndPushNamed(context, "/Load", arguments: response);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
}
