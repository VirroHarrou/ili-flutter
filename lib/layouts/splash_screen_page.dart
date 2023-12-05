import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/metrics/AddMetric.dart';
import 'package:tavrida_flutter/repositories/user/user_repository.dart';
import 'package:tavrida_flutter/repositories/views/models.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
      body: Stack(
        children: [
          Center(
            child: Image.asset('assets/icon.png', width: 200,),
          ),
          Align(
            alignment: const Alignment(0, 0.95),
            child: Text("© Created by Virro Harrou", style: Theme.of(context).textTheme.displaySmall),
          )
        ],
      ),
    );
  }

  Future<void> _storageRead() async {

    final storage = await SharedPreferences.getInstance();
    AppSettings.isWarning = storage.getBool('isWarning') ?? true;
    AppSettings.authToken = storage.getString('authUserToken') ?? '';
    AppSettings.isLogin = storage.getBool('isLogin') ?? false;
    AppSettings.isNoName = storage.getBool('isNoName') ?? true;
    User.email = storage.getString('userEmail');
    User.id = storage.getString('userId');

    if(AppSettings.isNoName && AppSettings.isLogin == false){
      tryCreateNoNameUser().then((response) {
        AppSettings.authToken = response.data ?? '';
        AppSettings.isLogin = true;

        storage.setBool('isLogin', true);
        storage.setString('authUserToken', AppSettings.authToken);
        storage.setBool('isNoName', true);
      });
    }
    Future.delayed(const Duration(seconds: 1, milliseconds: 300), () {
      MetricRepos.createRecord(User.id ?? '11111111-1111-1111-1111-111111111111', MetricType.users, 1);
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (r) => false);
    });
  }
}