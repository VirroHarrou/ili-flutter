import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavrida_flutter/common/settings.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthContainer extends StatefulWidget{
  const AuthContainer({super.key});

  @override
  State<StatefulWidget> createState() =>
      _AuthContainerState();
}

class _AuthContainerState extends State<AuthContainer> {
  bool isLogin = false;
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
    var list = [
      Padding(
        padding: const EdgeInsets.only(bottom: 30, top: 40),
        child: Image.asset("assets/icon.png", height: 30),
      ),
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
              maxLines: 2,
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
              style: isBadEmail ? theme.textTheme.headlineSmall : theme.textTheme.bodySmall,
              onChanged: (str) {
                email = str;
              },
              onEditingComplete: () {
                setState(() {
                  isBadEmail = false;
                });
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Электронная почта",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isBadEmail ? AppColors.lightRed : AppColors.lightGrey,
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
                isBadRequest = false;
              },
              onEditingComplete: () {
                setState(() {
                  isBadRequest = false;
                });
              },
              style: isBadRequest ? theme.textTheme.headlineSmall : theme.textTheme.bodySmall,
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
                    color: isBadRequest ? AppColors.red : AppColors.grey,
                  ),
                ),
                hintText: "Пароль",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isBadRequest ? AppColors.lightRed : AppColors.lightGrey
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
                onEditingComplete: () {
                  setState(() {
                    isBadPassword = false;
                  });
                },
                style: isBadPassword && !isLogin ? theme.textTheme.headlineSmall : theme.textTheme.bodySmall,
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
                      color: isBadPassword && !isLogin ? AppColors.red : AppColors.grey,
                    ),
                  ),
                  hintText: "Повторите пароль",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: isBadPassword && !isLogin ? AppColors.lightRed : AppColors.lightGrey,
                ),
              ),
            ),
          ElevatedButton(
              onPressed: null, //onButtonPressed,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.black),
                  minimumSize: MaterialStateProperty.all(const Size(300, 50)),
                  enableFeedback: false
              ),
              child: Text(
                isLogin ? "Войти" : "Продолжить",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
          ),
    ];
    if(isLogin){
      list.add(
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
                      passwordRepeat = '';
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
      );
    } else {
      list.addAll(
        [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "Нажимая на кнопку, вы даете согласие на обработку персональных данных и соглашаетесь с",
              style: theme.textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
          ),
          InkWell(
            onTap: _launchUrl,
            child: const Text(
              "политикой конфиденциальности",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
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
        ]
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }

  void _launchUrl() async {
    //Todo: configure
          final url = Uri.parse('link to privacy policy');
          if(!await launchUrl(url)) {
            throw Exception('Could not launch $url');
          }
        }

  // void onButtonPressed() {
  //   if(isLogin){
  //     var response = tryLoginAsync(email, password);
  //     response.then((value) {
  //       setState(() {
  //         isBadRequest = false;
  //         isBadEmail = false;
  //         errorMessage = '';
  //       });
  //       switch (value.type ?? ResponseType.bad) {
  //         case ResponseType.success:
  //           AppSettings.authToken = value.data ?? '';
  //           var data = AppSettings().parseJwt(AppSettings.authToken);
  //           User.email = data["email"];
  //           User.id = data["nameid"];
  //           if(AppSettings.authToken != ''){
  //             AppSettings.isNoName = false;
  //             SharedPreferences.getInstance().then((storage) {
  //               storage.setString("authUserToken", AppSettings.authToken);
  //               storage.setBool("isLogin", true);
  //               storage.setBool("isNoName", false);
  //               storage.setString("userEmail", User.email!);
  //               storage.setString("userId", User.id!);
  //             });
  //             AppSettings.isLogin = true;
  //           }
  //           Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
  //           break;
  //         case ResponseType.bad:
  //           setState(() {
  //             isBadEmail = true;
  //             errorMessage = value.data!;
  //           });
  //           break;
  //         case ResponseType.notFound:
  //           setState(() {
  //             isBadEmail = true;
  //             isBadRequest = true;
  //             errorMessage = value.data!;
  //           });
  //           break;
  //         default:
  //           break;
  //       }
  //     });
  //   } else {
  //     setState(() {
  //       isBadPassword = false;
  //       isBadRequest = false;
  //       isBadEmail = false;
  //       errorMessage = '';
  //     });
  //
  //     if(!RegExp(r"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$").hasMatch(email)){
  //       setState(() {
  //         isBadEmail = true;
  //         errorMessage = 'Почта введена не коректно';
  //       });
  //       return;
  //     }
  //     if(!RegExp(r"^(?=.*[0-9])(?=.*[a-zA-Z]).{8,}$").hasMatch(password)){
  //       setState(() {
  //         isBadRequest = true;
  //         errorMessage = 'Неверный пароль';
  //       });
  //       return;
  //     }
  //     if(password != passwordRepeat){
  //       setState(() {
  //         isBadPassword = true;
  //         errorMessage = 'Пароли не совпадают';
  //       });
  //       return;
  //     }
  //     if(AppSettings.isNoName){
  //       tryUpdate(email, password).then((value) {
  //         if(value.type != ResponseType.success){
  //           setState(() {
  //             errorMessage = 'Пользователь уже существует';
  //           });
  //         } else {
  //           AppSettings.authToken = value.data!;
  //           User.email = AppSettings().parseJwt(AppSettings.authToken)['email'];
  //           User.id = AppSettings().parseJwt(AppSettings.authToken)['nameid'];
  //           SharedPreferences.getInstance().then((storage) {
  //             storage.setString("authUserToken", AppSettings.authToken);
  //             storage.setBool("isLogin", true);
  //             storage.setBool("isNoName", false);
  //             storage.setString("userEmail", User.email!);
  //             storage.setString("userId", User.id!);
  //           });
  //         }
  //       });
  //       return;
  //     }
  //     var result = tryRegister(email, password);
  //     result.then((value) {
  //       if(value.type != ResponseType.success){
  //         setState(() {
  //           errorMessage = 'Пользователь уже существует';
  //         });
  //       } else {
  //         AppSettings.authToken = value.data!;
  //         User.email = AppSettings().parseJwt(AppSettings.authToken)['email'];
  //         User.id = AppSettings().parseJwt(AppSettings.authToken)['nameid'];
  //         isLogin = true;
  //         if(AppSettings.authToken != ''){
  //           SharedPreferences.getInstance().then((storage) {
  //             storage.setString("authUserToken", AppSettings.authToken);
  //             storage.setBool("isLogin", true);
  //             storage.setBool("isNoName", false);
  //             storage.setString("userEmail", User.email!);
  //             storage.setString("userId", User.id!);
  //           });
  //           AppSettings.isLogin = true;
  //         }
  //         Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
  //       }
  //     });
  //   }
  // }
}