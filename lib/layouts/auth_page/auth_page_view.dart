import 'package:flutter/material.dart';
import 'package:tavrida_flutter/widgets/AuthContainer.dart';

class AuthPage extends StatelessWidget{
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return const Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.only(
          left: 40.0,
          right: 40.0,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: AuthContainer(),
            ),
          ],
        ),
      ),
    );
  }
}