import 'package:flutter/material.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/user/user_repository.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

import '../repositories/views/user.dart';

class AuthContainer extends StatefulWidget{
  const AuthContainer({super.key});

  @override
  State<StatefulWidget> createState() =>
      _AuthContainerState();

}

class _AuthContainerState extends State<AuthContainer> {
  bool isLogin = true;
  bool isBadRequest = false;
  bool isVisiblePassword = false;
  bool isVisibleRepeatPassword = false;

  String email = '';
  String password = '';

  void onButtonPressed() {
    Map<ResponseType, String> result;
    if(isLogin){
      var response = tryLoginAsync(email, password);
      response.then((value) {
        //Todo: сделать подстветку элементов при ошибке
        if(value[ResponseType.success] != null){
          AppSettings.authToken = value[ResponseType.success] ?? '';
          var data = AppSettings().parseJwt(AppSettings.authToken);
          User.email = data["email"];
          Navigator.pushNamed(context, "/home");
        }
      });
    } else {
     //Todo: логика регистрации
    }

  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SizedBox(
      height: isLogin ? 400 : 500,
      width: 350,
      child: Column(
        children: [
          Text(
            isLogin ? "Добро пожаловать!"
              : "Регистрация",
            style: theme.textTheme.titleSmall,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16),
            child: Text(
              isLogin ? "Войдите, чтобы продолжить"
                : "Пожалуйста, укажите следующие детали"
                  " для Вашей новой учетной записи ",
              textAlign: TextAlign.center,
              maxLines: 2,
              style: theme.textTheme.bodySmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              bottom: 8.0,
              top: 8.0,
            ),
            child: TextField(
              style: theme.textTheme.bodySmall,
              onChanged: (str) {
                email = str;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Электронная почта",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: !isBadRequest ? AppColors.black : AppColors.red, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: !isBadRequest ? AppColors.black : AppColors.red, width: 1),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              bottom: !isLogin ? 8.0 : 24.0,
              top: 8.0,
            ),
            child: TextField(
              onChanged: (str) {
                password = str;
              },
              style: theme.textTheme.bodySmall,
              obscureText: !isVisiblePassword,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isVisiblePassword = !isVisiblePassword;
                    });
                  },
                  icon: Icon(isVisiblePassword
                    ? Icons.remove_red_eye
                    : Icons.remove_red_eye_outlined
                  ),
                ),
                hintText: "Пароль",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: !isBadRequest ? AppColors.black : AppColors.red, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: !isBadRequest ? AppColors.black : AppColors.red, width: 1),
                ),
              ),
            ),
          ),
          isLogin
            ? const SizedBox(
                height: 0,
              )
            : Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                bottom: 24.0,
                top: 8.0,
              ),
              child: TextField(
                style: theme.textTheme.bodySmall,
                obscureText: !isVisibleRepeatPassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisibleRepeatPassword = !isVisibleRepeatPassword;
                      });
                    },
                    icon: Icon(isVisibleRepeatPassword
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined
                    ),
                  ),
                  hintText: "Повторите пароль",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: !isBadRequest ? AppColors.black : AppColors.red, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:  BorderSide(color: !isBadRequest ? AppColors.black : AppColors.red, width: 1),
                  ),
                ),
              ),
            ),
          ElevatedButton(
              onPressed: onButtonPressed,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.black),
                  minimumSize: MaterialStateProperty.all(const Size(300, 50)),
                  enableFeedback: false
              ),
              // ignor3e: sort_child_properties_last
              child: Text(
                isLogin ? "Войти" : "Продолжить",
                style: theme.textTheme.headlineMedium,
              ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLogin ? "Нет аккаунта?" : "Уже есть аккаунт?",
                  style: theme.textTheme.bodySmall,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(
                    isLogin ? " Создать аккаунт" : " Войти",
                    style: theme.textTheme.bodyLarge,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}