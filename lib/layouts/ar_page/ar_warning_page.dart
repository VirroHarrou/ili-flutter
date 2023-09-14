import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/views/models.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

class ARWarningPage extends StatelessWidget{
  const ARWarningPage({super.key});

  @override
  Widget build(BuildContext context) {
    Model model = ModalRoute.of(context)?.settings.arguments as Model;
    var theme = Theme.of(context);
    // set up the buttons
    Widget continueButton = TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.black),
          minimumSize: MaterialStateProperty.all(const Size(150, 40))
      ),
      onPressed:  () {
        AppSettings.isWarning = false;
        Navigator.pushNamed(context, "/ar_page", arguments: model);
      },
      child: Text("Ок", style: theme.textTheme.bodyMedium),
    );
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/roomBackground.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
          ),
        ),
        Center(
          child: AlertDialog(
            icon: const Icon(Icons.warning_amber, size: 45,),
            iconColor: AppColors.black,
            backgroundColor: AppColors.white,
            title: Text("Мы используем AR", style: theme.textTheme.headlineLarge,),
            content: Text("Если вам нет 18, используйте приложение в присутствии родителей."
                " Cледите за своим окружением, AR может искажать объекты.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            actions: [
              Center(child: continueButton),
            ],
          ),
        ),
      ]
    );
  }
}

showAlertDialog(BuildContext context, Model model) async {
  Future.delayed(Duration.zero, null);
  var theme = Theme.of(context);
  // set up the buttons
  Widget continueButton = TextButton(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.black),
        minimumSize: MaterialStateProperty.all(const Size(150, 40))
    ),
    onPressed:  () {
      Navigator.pushNamed(context, "/ar_page", arguments: model);
    },
    child: Text("Ок", style: theme.textTheme.bodyMedium),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    icon: const Icon(Icons.warning_amber, size: 45,),
    iconColor: AppColors.black,
    backgroundColor: AppColors.white,
    title: Text("Мы используем AR", style: theme.textTheme.headlineLarge,),
    content: Text("Если вам нет 18, используйте приложение в присутствии родителей."
        " Cледите за своим окружением, AR может искажать объекты.",
      textAlign: TextAlign.center,
      style: theme.textTheme.bodySmall,
    ),
    actions: [
      Center(child: continueButton),
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}