import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

Widget generateNotAvailable(BuildContext context){
  var theme = Theme.of(context);
  return Center(
    child: SizedBox(
      height: 400,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: SvgPicture.asset("assets/no_results_found.svg"),
          ),
          Text(
            "Доступно только\nзарегистрированным пользователям",
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "Все сохраненные вами 3D-объекты станут доступны после регистрации или входа в аккаунт",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => context.go('/auth'),
            // Navigator.pushNamed(context, "/auth"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.black),
                minimumSize: MaterialStateProperty.all(const Size(300, 50)),
                enableFeedback: false
            ),
            // ignor3e: sort_child_properties_last
            child: Text(
              "Зарегистрироваться",
              style: theme.textTheme.headlineMedium,
            ),
          )
        ],
      ),
    ),
  );
}
