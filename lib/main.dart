import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tavrida_flutter/routes.dart';
import 'package:tavrida_flutter/themes/src/theme_default.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const storage = FlutterSecureStorage();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: createLightTheme(),
      routes: routes,
    );
  }
}


