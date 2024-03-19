import 'package:flutter/cupertino.dart';
import 'package:tavrida_flutter/layouts/ar_page/ar_page.dart';
import 'package:tavrida_flutter/layouts/auth_page/auth_page_view.dart';
import 'package:tavrida_flutter/layouts/forum_page/view.dart';
import 'package:tavrida_flutter/layouts/home_page.dart';
import 'package:tavrida_flutter/layouts/splash_screen_page.dart';
import 'package:tavrida_flutter/layouts/qr_page/QRScanner.dart';
import 'package:tavrida_flutter/repositories/views/model.dart';

import 'layouts/ar_page/ar_page_ios.dart';

final routes = {
  "/" : (context) => const SplashScreen(),
  "/auth" : (context) => const AuthPage(),
  "/ForumDetail" : (context) => const ForumDetailPage(),
  "/ar_page" : (context) => ARPageIOS(model: ModalRoute.of(context)?.settings.arguments as Model),//ARPage(),
  "/home" : (context) => const HomePage(),
  "/QR" : (context) => const QRPage(),
};