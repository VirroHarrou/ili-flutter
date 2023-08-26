import 'package:flutter/material.dart';
import 'package:tavrida_flutter/layouts/forum_page/forum_detail_page.dart';
import 'package:tavrida_flutter/layouts/forum_page/forum_list_page.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

class BottomNavigationBase extends StatefulWidget {
  const BottomNavigationBase({super.key});
  static Widget _currentWidget = const ForumListPage();

  static Widget getCurrentWidget(){
    return _currentWidget;
  }

  @override
  State<BottomNavigationBase> createState() =>
      _BottomNavigationBaseState();
}

class _BottomNavigationBaseState
    extends State<BottomNavigationBase> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    ForumListPage(),
    ForumListPage(),
    Text('data'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      BottomNavigationBase._currentWidget = _widgetOptions[index];
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
    return navigationBar;
  }
}