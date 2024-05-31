import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavrida_flutter/common/routes.dart';
import 'package:tavrida_flutter/layouts/models_page/model_list_page.dart';
import 'package:tavrida_flutter/layouts/platform/view.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'dart:io' show Platform;

import '../services/auth_service.dart';

class HomePage extends StatefulWidget{
  final String location;
  final Widget child;

  const HomePage({
    super.key,
    required this.location,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() =>
      HomePageState();

}

class HomePageState extends State<HomePage> {

  List<StatefulWidget> get widgets => const [
    PlatformListPage(),
    ModelListPage(),
  ];
  int get _currentIndex => NavigatorRoute.values
      .firstWhere((e) => widget.location.contains(e.path))
      .index;

  Future<String> navigateToNative() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString("access_token") == null) {
        await AuthService(prefs: prefs).loginNoName();
      }
      var data = await const MethodChannel('com.arChannel').invokeMethod(
          'flutterNavigate',
          {
            "access_token": prefs.getString("access_token")
          }
      );
      return data;
    } on PlatformException catch (e) {
      return 'Failed to invoke: ${e.message}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final fab = InkWell(
      onTap: () {
        if (Platform.isIOS) {
          navigateToNative();
        }
        else {
          context.push(Routes.qrScanner);
        }
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:  BorderRadius.circular(90),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0, 0),
              spreadRadius: 0.5,
              blurRadius: 8,
            )
          ]
        ),
        child: const Icon(
          Icons.qr_code_2,
          size: 48,
          color: AppColors.black,
        ),
      ),
    );

    return Scaffold(
      body: widget.child,
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildBottomNavigationBar()
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          activeIcon: Icon(Icons.favorite),
          label: 'Сохраненные',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _onItemTaped(
        context,
        NavigatorRoute.values[index],
      ),
      currentIndex: _currentIndex,
      fixedColor: AppColors.black,
      selectedLabelStyle: const TextStyle(
        fontFamily: 'Open Sans',
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'Open Sans',
      ),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      iconSize: 26,
    );
  }

  void _onItemTaped(BuildContext context, NavigatorRoute navigatorRoute) {
    if (navigatorRoute.index != _currentIndex) {
      context.go(navigatorRoute.path);
    }
  }
}