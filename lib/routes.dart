import 'package:tavrida_flutter/AR/localAndWebObjectsView.dart';
import 'package:tavrida_flutter/layouts/forum_page/view.dart';
import 'package:tavrida_flutter/layouts/home_page.dart';

final routes = {
  "/" : (context) => const HomePage(),
  "/ForumDetail" : (context) => const ForumDetailPage(),
  "/ar_page" : (context) => const LocalAndWebObjectsWidget(),
};