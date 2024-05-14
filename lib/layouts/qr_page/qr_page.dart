import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tavrida_flutter/layouts/qr_page/bloc/qr_bloc.dart';
import 'package:tavrida_flutter/layouts/qr_page/widgets/code_widget.dart';

import '../../themes/app_colors.dart';


class QRPage extends StatefulWidget {
  const QRPage({super.key});

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  final bloc = QRBloc();
  final key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRBloc, QRState>(
      bloc: bloc,
      builder: (context, state) {
        switch (state) {
          case QRDefault():
            return buildScanner();
          case QRCodeFailure():
            return buildScanner(codeError: true);
          case QRBarCodeFailure():
            return buildScanner(barCodeError: true);
          case QRFailure():
            return buildFailure();
          default:
            return Container();
        }
      },
    );
  }

  Widget buildScanner({bool barCodeError = false, bool codeError = false}) {
    final qrViewSize = MediaQuery.of(context).size.width * 0.8;
    final theme = Theme.of(context);
    final isKeyboardOff = MediaQuery.of(context).viewInsets.bottom == 0;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            QRView(
              key: key,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: barCodeError ? AppColors.red : Colors.grey,
                borderRadius: 10,
                cutOutSize: qrViewSize,
                overlayColor: const Color(0xBB000000),
              ),
              formatsAllowed: const [
                BarcodeFormat.qrcode,
              ],
            ),
            Positioned(
              height: qrViewSize + 140,
              width: qrViewSize,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Text("Наведите камеру на QR-код", style: theme.textTheme.bodyMedium,),
                  ),
                  Text(
                    'Если вам нет 18, используйте приложение в присутствии родителей. Cледите за своим окружением, AR может искажать объекты.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Container(
                height: double.infinity,
                color: isKeyboardOff ? Colors.transparent : Colors.black87,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: const Alignment(-.98, -.92),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: FloatingActionButton(
                          onPressed: ()  => Navigator.pop(context),
                          shape: const CircleBorder(),
                          backgroundColor: AppColors.grey,
                          child: const Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    Positioned(
                      width: qrViewSize * 0.6,
                      bottom: 20,
                      child: Column(
                        children: [
                          Text("Введите код модели", style: theme.textTheme.bodyMedium,),
                          const SizedBox(height: 8,),
                          CodeDisplay(
                            count: 4,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Open Sans',
                              color: codeError ? AppColors.red : AppColors.black,
                            ),
                            onComplete: (code) {
                              bloc.add(QRCodeCompleteEvent(code: code, context: context));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    controller.scannedDataStream.listen(
          (event) async {
        final code = event.code;
        if (code.isEmptyOrNull) return;
        bloc.add(QRBarCodeFindEvent(barCode: code!, context: context));
      },
    );
  }

  Widget buildFailure() {
    return Center(
      child: Container(
        color: Colors.red,
        child: Text("Что-то сломалось", style: Theme.of(context).textTheme.bodyLarge,),
      ),
    );
  }
}