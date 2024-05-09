import 'package:tavrida_flutter/layouts/ar_page/ar_page.dart';
import 'package:tavrida_flutter/layouts/ar_page/loading_page.dart';
import 'package:tavrida_flutter/layouts/auth_page/auth_page_view.dart';
import 'package:tavrida_flutter/layouts/home_page.dart';
import 'package:tavrida_flutter/layouts/models_page/model_list_page.dart';
import 'package:tavrida_flutter/layouts/platform/view.dart';
import 'package:tavrida_flutter/layouts/qr_page/qr_page.dart';

final routes = {
  "/" : (context) => const HomePage(),
  "/auth" : (context) => const AuthPage(),
  "/ForumDetail" : (context) => const ForumDetailPage(),
  "/ar_page" : (context) => ARPage(),
  "/home" : (context) => const HomePage(),
  "/QR" : (context) => const QRPage(),
  "/Load" : (context) => const LoadingPage(),
  "/ModelList" : (context) => const ModelListPage(),
};