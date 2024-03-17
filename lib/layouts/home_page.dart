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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ForumListPage(),
      floatingActionButton: InkWell(
        onTap: () => Navigator.pushNamed(context, "/QR"),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(0, 2),
                spreadRadius: 1,
                blurRadius: 4,
              ),
            ],
            color: Colors.white.withOpacity(0.75),
            borderRadius:  BorderRadius.circular(90),
          ),
          child: const Icon(
            Icons.qr_code_2,
            size: 48,
            color: Colors.black,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}