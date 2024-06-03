import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

Widget buildLoading(BuildContext context) {
  return Center(
    child: Platform.isIOS
        ? const CupertinoActivityIndicator(
        color: AppColors.black,
    )
        : const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
    ),
  );
}