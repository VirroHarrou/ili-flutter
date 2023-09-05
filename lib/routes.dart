import 'package:tavrida_flutter/AR/ARGesturesExample.dart';
import 'package:tavrida_flutter/AR/localAndWebObjectsView.dart';
import 'package:tavrida_flutter/layouts/ar_page/ar_page.dart';
import 'package:tavrida_flutter/layouts/auth_page/auth_page_view.dart';
import 'package:tavrida_flutter/layouts/forum_page/view.dart';
import 'package:tavrida_flutter/layouts/home_page.dart';

final routes = {
  "/" : (context) => const AuthPage(),
  "/ForumDetail" : (context) => const ForumDetailPage(),
  "/ar_page" : (context) => ARPage(),
  "/home" : (context) => const HomePage(),
};