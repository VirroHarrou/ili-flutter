import 'package:tavrida_flutter/layouts/auth_page/auth_page_view.dart';
import 'package:tavrida_flutter/layouts/forum_page/view.dart';
import 'package:tavrida_flutter/layouts/home_page.dart';
import 'package:tavrida_flutter/widgets/BottomNavigationBase.dart';

final routes = {
  "/" : (context) => const HomePage(),
  "/ForumDetail" : (context) => ForumDetailPage(),
  "/auth" : (context) => AuthPage(),
};