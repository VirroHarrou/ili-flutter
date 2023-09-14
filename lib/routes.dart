import 'package:tavrida_flutter/layouts/ar_page/ar_page.dart';
import 'package:tavrida_flutter/layouts/ar_page/ar_warning_page.dart';
import 'package:tavrida_flutter/layouts/auth_page/auth_page_view.dart';
import 'package:tavrida_flutter/layouts/forum_page/view.dart';
import 'package:tavrida_flutter/layouts/home_page.dart';
import 'package:tavrida_flutter/layouts/splash_screen_page.dart';
import 'package:tavrida_flutter/widgets/QRScanner.dart';

final routes = {
  "/" : (context) => SplashScreen(),
  "/auth" : (context) => const AuthPage(),
  "/ForumDetail" : (context) => const ForumDetailPage(),
  "/ar_page" : (context) => ARPage(),
  "/ar_warning" : (context) => const ARWarningPage(),
  "/home" : (context) => const HomePage(),
  "/QR" : (context) => const QRViewExample(),
};