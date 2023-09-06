import 'package:flutter/material.dart';
import 'package:tavrida_flutter/routes.dart';
import 'package:tavrida_flutter/themes/src/theme_default.dart';

void main() {
  runApp(const TavridaApp());
}

class TavridaApp extends StatelessWidget {
  const TavridaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: createLightTheme(),
      routes: routes,
    );
  }
}


