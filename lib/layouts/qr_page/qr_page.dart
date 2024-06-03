import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tavrida_flutter/layouts/qr_page/bloc/qr_bloc.dart';
import 'package:tavrida_flutter/layouts/qr_page/widgets/code_widget.dart';
import 'package:tavrida_flutter/layouts/qr_page/widgets/qr_widget.dart';

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
    final additionalMargin = MediaQuery.of(context).viewInsets.bottom;
    final qrViewVerticalMargin = (MediaQuery.of(context).size.height - additionalMargin - qrViewSize) / 2 - 5;
    final theme = Theme.of(context);
    final isKeyboardOff = additionalMargin == 0;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            QRWidget(
              output: (code) {
                bloc.add(QRBarCodeFindEvent(barCode: code, context: context));
              },
            ),
            Positioned(
              top: qrViewVerticalMargin - 20,
              width: qrViewSize,
              child: Center(
                  child: Text("Наведите камеру на QR-код", style: theme.textTheme.bodyMedium,),
              ),
            ),
            Positioned(
              bottom: qrViewVerticalMargin - 60,
              width: qrViewSize,
              child: Text(
                'Если вам нет 18, используйте приложение в присутствии родителей. Cледите за своим окружением, AR может искажать объекты.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
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
                          onPressed: ()  => context.pop(),
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

  Widget buildFailure() {
    return Center(
      child: Container(
        color: Colors.red,
        child: Text("Что-то сломалось", style: Theme.of(context).textTheme.bodyLarge,),
      ),
    );
  }
}