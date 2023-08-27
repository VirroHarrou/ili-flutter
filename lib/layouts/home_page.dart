import 'package:flutter/material.dart';
import 'package:tavrida_flutter/AR/localAndWebObjectsView.dart';
import 'package:tavrida_flutter/layouts/forum_page/view.dart';
import 'package:tavrida_flutter/layouts/models_page/model_favorites_page.dart';
import 'package:tavrida_flutter/layouts/profile_page/profile_page.dart';

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
    ModelFavoritesPage(),
    ProfilePage(),
  ];

  int _selectedIndex = 0;
  Widget _currentWidget = const ForumListPage();

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
    var navigationBar = BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Площадки',
          activeIcon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Избранное',
          activeIcon: Icon(Icons.favorite),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Аккаунт',
            activeIcon: Icon(Icons.person_2)
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppColors.buttonPrimary,
      onTap: _onItemTapped,
    );

    return Scaffold(
      body: getCurrentWidget(),
      bottomNavigationBar: navigationBar,
    );
  }
}