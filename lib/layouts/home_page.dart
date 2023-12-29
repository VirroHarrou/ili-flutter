import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:tavrida_flutter/layouts/forum_page/view.dart';
import 'package:tavrida_flutter/layouts/models_page/model_favorites_page.dart';
import 'package:tavrida_flutter/layouts/profile_page/profile_page.dart';
import 'package:tavrida_flutter/layouts/qr_page/QRScanner.dart';

import '../themes/app_colors.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() =>
      HomePageState();

}

class HomePageState extends State<HomePage> {
  static final List<Widget> _widgetOptions = <Widget>[
    const ForumListPage(),
    const QRPage(mainNav: true),
    ProfilePage(),
  ];

  int _selectedIndex = 1;
  Widget _currentWidget = const QRPage(mainNav: true);

  Widget getCurrentWidget(){
    return _currentWidget;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentWidget = _widgetOptions[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getCurrentWidget(),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixed,
        items: const [
          TabItem(
            icon: Icon(
              Icons.home,
              size: 28,
              color: AppColors.grey,
            ),
            title: 'Площадки',
            activeIcon: Icon(
              Icons.home,
              size: 30,
              color: AppColors.black,
            ),
          ),
          TabItem(
            icon: Icon(
                Icons.qr_code_scanner,
                size: 35,
                color: AppColors.grey,
            ),
            title: 'Сканер',
            activeIcon: Icon(
              Icons.qr_code_scanner,
              size: 40,
              color: AppColors.black,
            ),
          ),
          TabItem(
            icon: Icon(
              Icons.history,
              size: 28,
              color: AppColors.grey,
            ),
            title: 'История',
            activeIcon: Icon(
              Icons.history,
              size: 30,
              color: AppColors.black,
            ),
          ),
        ],
        backgroundColor: AppColors.white,
        color: AppColors.grey,
        activeColor: AppColors.black,
        initialActiveIndex: 1,
        onTap: _onItemTapped,
      ),
    );
  }
}