import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:tavrida_flutter/ui/app_text_styles.dart';

class EmptyContent extends StatelessWidget {
  final String title;
  final String? message;

  const EmptyContent({
    super.key,
    required this.title,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: SvgPicture.asset("assets/icons/nothing_here.svg",),
            ),
            Text(
              title,
              style: AppTextStyles.titleH2,
              textAlign: TextAlign.center,
            ),
            if (!message.isEmptyOrNull) ... [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.label,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}