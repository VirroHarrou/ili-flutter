import 'package:flutter/material.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

@immutable
class AppTextButton extends StatelessWidget {
  final Widget? icon;
  final String text;
  final VoidCallback onTap;
  final TextStyle style;
  late final Color? outlineColor;
  late final Color backgroundColor;
  final double borderRadius;

  AppTextButton.outlined({
    super.key,
    required this.text,
    this.borderRadius = 24,
    this.outlineColor = AppColors.black,
    this.icon,
    this.style = const TextStyle(
      color: AppColors.black,
      fontSize: 16,
      fontFamily: 'Open Sans',
      fontWeight: FontWeight.w600,
    ),
    required this.onTap,
  }) {
    backgroundColor = Colors.transparent;
  }

  AppTextButton.filled({
    super.key,
    required this.text,
    this.borderRadius = 28,
    this.style = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: 'Open Sans',
      fontWeight: FontWeight.w600,
    ),
    this.backgroundColor = AppColors.black,
    this.icon,
    required this.onTap,
  }) {
    outlineColor = null;
  }

  AppTextButton.custom({
    super.key,
    this.icon,
    required this.text,
    required this.style,
    required this.outlineColor,
    required this.backgroundColor,
    required this.borderRadius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              width: outlineColor == null ? 0 : 1,
              color: outlineColor ?? Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (icon != null) ...[Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: icon!,
              )],
              Text(
                text,
                style: style,
              ),
            ],
          ),
        ),
      ),
    );
  }

}