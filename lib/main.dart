import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injector/injector.dart';
import 'package:tavrida_flutter/common/injector_initializer.dart';
import 'package:tavrida_flutter/common/routes.dart';
import 'package:tavrida_flutter/layouts/platform/platform_list_page.dart';
import 'package:tavrida_flutter/services/models/model.dart';
import 'package:tavrida_flutter/services/models/platform.dart';
import 'package:tavrida_flutter/themes/src/theme_default.dart';

import 'layouts/ar_page/loading_page.dart';
import 'layouts/auth_page/auth_page_view.dart';
import 'layouts/home_page.dart';
import 'layouts/models_page/model_list_page.dart';
import 'layouts/platform/forum_detail_page.dart';
import 'layouts/qr_page/qr_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjectorInitializer.initialize(Injector.appInstance);

  runApp(TavridaApp());
}

class TavridaApp extends StatelessWidget {
  TavridaApp({super.key});
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: createLightTheme(),
      key: _rootNavigatorKey,
      routerConfig: GoRouter(
        initialLocation: Routes.platformList,
        routes: [
          ShellRoute(
            builder: (context, state, child) => HomePage(
              location: state.matchedLocation,
              child: child,
            ),
            routes: [
              GoRoute(
                path: Routes.modelsList,
                pageBuilder: (context, state) => const NoTransitionPage<void>(child: ModelListPage()),
              ),
              GoRoute(
                path: Routes.platformList,
                pageBuilder: (context, state) => const NoTransitionPage<void>(child: PlatformListPage()),
              ),
            ],
          ),
          GoRoute(
            path: Routes.platform,
            builder: (context, state) => ForumDetailPage(platform: state.extra as Platform),
          ),
          GoRoute(
            path: Routes.qrScanner,
            builder: (context, state) => const QRPage(),
          ),
          GoRoute(
            path: Routes.auth,
            builder: (context, state) => const AuthPage(),
          ),
          GoRoute(
            path: Routes.loadingPage,
            builder: (context, state) => LoadingPage(model: state.extra as Model,),
          ),
        ],
      ),
    );
  }
}


