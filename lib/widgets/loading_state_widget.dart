import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildLoading(BuildContext context) {
  return Center(
    child: Platform.isIOS
        ? const CupertinoActivityIndicator()
        : const CircularProgressIndicator(),
  );
}