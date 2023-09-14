import 'package:flutter/material.dart';
import 'package:tavrida_flutter/widgets/AuthContainer.dart';

class AuthPage extends StatelessWidget{
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 40.0,
          right: 40.0,
          top: 40.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 90, bottom: 40),
              child: Image.asset("assets/logo2.png", height: 80),
            ),
            const AuthContainer(),
          ],
        ),
      ),
    );
  }
}