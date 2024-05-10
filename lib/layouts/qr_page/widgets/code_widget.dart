import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

class CodeDisplay extends StatefulWidget {
  final TextStyle style;
  final int count;
  final void Function(String code) onComplete;

  const CodeDisplay({
    super.key,
    this.style = const TextStyle(),
    required this.count,
    required this.onComplete,
  });

  @override
  State<CodeDisplay> createState() => _CodeDisplayState();
}

class _CodeDisplayState extends State<CodeDisplay> {
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      length: widget.count,
      obscureText: false,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      hintCharacter: '•',
      hintStyle: const TextStyle(color: AppColors.black),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldOuterPadding: EdgeInsets.zero,
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.grey,
        activeColor: Colors.transparent,
        inactiveFillColor: AppColors.grey,
        inactiveColor: Colors.transparent,
      ),
      textStyle: widget.style,
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      controller: textEditingController,
      onCompleted: (v) {
        widget.onComplete(v);
      },
      onChanged: (value) {
        debugPrint(value);
        setState(() {
          currentText = value;
        });
      },
      beforeTextPaste: (text) {
        return true;
      },
      appContext: context,
    );
  }
}