import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

Widget generateDataEmpty(BuildContext context, String message){
  var theme = Theme.of(context);
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
            "Здесь пока пусто",
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
