import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tavrida_flutter/layouts/forum_page/view.dart';
import 'package:tavrida_flutter/layouts/models_page/model_list_page.dart';

import '../themes/app_colors.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() =>
      HomePageState();

}

class HomePageState extends State<HomePage> {

  List<StatefulWidget> get widgets => const [
    ForumListPage(),
    ModelListPage(),
  ];
  int _selectedWidget = 0;

  @override
  Widget build(BuildContext context) {
    final fab = InkWell(
      onTap: () => context.go('/QR'),
          // Navigator.pushNamed(context, "/QR"),
      //onLongPress: () => Navigator.pushNamed(context, "/ModelList"),
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
      body: widgets[_selectedWidget],
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
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
        onTap: (index) => setState(() {
          _selectedWidget = index;
        }),
        currentIndex: _selectedWidget,
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
      )
    );
  }
}