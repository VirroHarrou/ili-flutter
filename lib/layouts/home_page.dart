import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tavrida_flutter/common/routes.dart';
import 'package:tavrida_flutter/generated/l10n.dart';
import 'package:tavrida_flutter/layouts/models_page/model_list_page.dart';
import 'package:tavrida_flutter/layouts/platform/view.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    final fab = InkWell(
      onTap: () {
        context.push(Routes.qrScanner);
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
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: S.of(context).homePage,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite_outline),
          activeIcon: const Icon(Icons.favorite),
          label: S.of(context).favorites,
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