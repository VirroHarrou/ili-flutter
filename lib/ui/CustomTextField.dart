import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final double? height;
  final String? label;
  final bool marked;
  final String? hintText;
  final TextStyle hintStyle;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.height,
    this.label,
    this.hintText,
    this.hintStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.black,
    ),
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.marked = false,
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(
      width: 2.0,
      style: BorderStyle.solid,
      color: AppColors.black,
    ),
  );
  final OutlineInputBorder disabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(
      width: 1.0,
      style: BorderStyle.solid,
      color: AppColors.grey,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (widget.label != null)
              ? Row(
            children: [
              Text(
                widget.label!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              widget.marked ?
              const Text(
                '*',
                style: TextStyle(
                  color: AppColors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ) : const Center(),
            ],
          )
              : const SizedBox(),
          (widget.label != null)
              ? const SizedBox(
            height: 8,
          )
              : const SizedBox(),
          TextFormField(
            keyboardType: TextInputType.text,
            cursorColor: Colors.black,
            maxLines: null,
            minLines: (widget.height != null) ? widget.height! ~/ 30 : 1,
            autofocus: widget.autofocus,
            onChanged: widget.onChanged,
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              enabledBorder: disabledBorder,
              disabledBorder: disabledBorder,
              focusedBorder: enabledBorder,
              hintText: widget.hintText,
              hintStyle: widget.hintStyle,
            ),
          ),
        ],
      ),
    );
  }
}