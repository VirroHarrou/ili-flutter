import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injector/injector.dart';
import 'package:tavrida_flutter/common/injector_initializer.dart';
import 'package:tavrida_flutter/themes/src/theme_default.dart';

import 'layouts/ar_page/ar_page.dart';
import 'layouts/ar_page/loading_page.dart';
import 'layouts/auth_page/auth_page_view.dart';
import 'layouts/forum_page/forum_detail_page.dart';
import 'layouts/home_page.dart';
import 'layouts/models_page/model_list_page.dart';
import 'layouts/qr_page/QRScanner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjectorInitializer.initialize(Injector.appInstance);

  runApp(TavridaApp());
}

class TavridaApp extends StatelessWidget {
  TavridaApp({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'ForumDetail',
            builder: (context, state) => const ForumDetailPage(),
          ),
          GoRoute(
            path: 'QR',
            builder: (context, state) => const QRPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: '/ForumDetail',
        builder: (context, state) => const ForumDetailPage(),
      ),
      GoRoute(
        path: '/ar_page',
        builder: (context, state) => ARPage(),
      ),
      GoRoute(
        path: '/Load',
        builder: (context, state) => const LoadingPage(),
      ),
      GoRoute(
        path: '/ModelList',
        builder: (context, state) => const ModelListPage(),
      ),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: createLightTheme(),
      routerConfig: _router,
    );
  }
}


