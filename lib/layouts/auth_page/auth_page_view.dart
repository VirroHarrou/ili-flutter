import 'package:flutter/material.dart';
import 'package:tavrida_flutter/widgets/AuthContainer.dart';

class AuthPage extends StatelessWidget{
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 110, bottom: 60),
              child: Image.asset("assets/logo.png", height: 32),
            ),
            const AuthContainer(),
          ],
        ),
      ),
    );
  }
}