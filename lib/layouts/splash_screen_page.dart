import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavrida_flutter/main.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/views/models.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _storageRead();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/logo2.png', width: 200,),
      ),
    );
  }

  Future<void> _storageRead() async {

    final storage = await SharedPreferences.getInstance();
    AppSettings.isWarning = storage.getBool('isWarning') ?? true;
    AppSettings.authToken = storage.getString('authUserToken') ?? '';
    AppSettings.isLogin = storage.getBool('isLogin') ?? false;
    User.email = storage.getString('userEmail');

    if(AppSettings.isLogin){
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (r) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, "/auth", (r) => false);
    }
  }
}