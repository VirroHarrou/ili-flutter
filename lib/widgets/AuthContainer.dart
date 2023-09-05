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
  bool isBadEmail = false;
  bool isBadRequest = false;
  bool isBadPassword = false;
  bool isVisiblePassword = false;
  bool isVisibleRepeatPassword = false;

  String email = '';
  String password = '';
  String passwordRepeat = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(
            isLogin ? "Добро пожаловать!"
              : "Регистрация",
            style: theme.textTheme.titleSmall,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
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
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: Text(errorMessage,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: theme.textTheme.headlineSmall,
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
                  borderSide: BorderSide(color: isBadEmail ? AppColors.red : AppColors.black, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: isBadEmail ? AppColors.red : AppColors.black, width: 1),
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
                    : Icons.remove_red_eye_outlined,
                    color: isBadRequest && isLogin ? AppColors.red : AppColors.black,
                  ),
                ),
                hintText: "Пароль",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: isBadRequest && isLogin ? AppColors.red : AppColors.black, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: isBadRequest && isLogin ? AppColors.red : AppColors.black, width: 1),
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
                onChanged: (str) {
                  passwordRepeat = str;
                },
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
                        : Icons.remove_red_eye_outlined,
                      color: isBadPassword && !isLogin ? AppColors.red : AppColors.black,
                    ),
                  ),
                  hintText: "Повторите пароль",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: isBadPassword && !isLogin ? AppColors.red : AppColors.black, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:  BorderSide(color: isBadPassword && !isLogin ? AppColors.red : AppColors.black, width: 1),
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
                      errorMessage = '';
                      isBadRequest = false;
                      isBadEmail = false;
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

  void onButtonPressed() {
    if(isLogin){
      var response = tryLoginAsync(email, password);
      response.then((value) {
        setState(() {
          isBadRequest = false;
          isBadEmail = false;
          errorMessage = '';
        });
        switch (value.type ?? ResponseType.bad) {
          case ResponseType.success:
            AppSettings.authToken = value.data ?? '';
            var data = AppSettings().parseJwt(AppSettings.authToken);
            User.email = data["email"];
            if(AppSettings.authToken != ''){
              AppSettings.isLogin = true;
            }
            Navigator.pushNamed(context, "/home");
            break;
          case ResponseType.bad:
            setState(() {
              isBadEmail = true;
              errorMessage = value.data!;
            });
            break;
          case ResponseType.notFound:
            setState(() {
              isBadRequest = true;
              errorMessage = value.data!;
            });
            break;
          default:
            break;
        }
      });
    } else {
      setState(() {
        isBadPassword = false;
        isBadEmail = false;
        errorMessage = '';
      });
      if(password != passwordRepeat){
        setState(() {
          isBadPassword = true;
        });
        return;
      }
      if(!RegExp(r"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$").hasMatch(email)){
        setState(() {
          isBadEmail = true;
          errorMessage = 'Почта введена не коректно';
        });
        return;
      }
      var result = tryRegister(email, password);
      result.then((value) {
        if(value != ResponseType.success){
          setState(() {
            errorMessage = 'Пользователь уже существует';
          });
        } else {
          isLogin = true;
        }
      });
    }
  }
}