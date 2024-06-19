import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:tavrida_flutter/ui/app_text_styles.dart';

class FailureContent extends StatelessWidget {
  final String title;
  final String message;

  const FailureContent({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/images/something_went_wrong.svg', height: 200, fit: BoxFit.cover,),
            const SizedBox(height: 24,),
            Text(
              title,
              style: AppTextStyles.titleH2,
            ),
            const SizedBox(height: 8,),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.label,
            ),
          ],
        ),
      ),
    );
  }
}