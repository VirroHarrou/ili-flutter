import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:tavrida_flutter/common/injector_initializer.dart';
import 'package:tavrida_flutter/routes.dart';
import 'package:tavrida_flutter/themes/src/theme_default.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjectorInitializer.initialize(Injector.appInstance);

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