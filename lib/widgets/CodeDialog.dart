import 'package:flutter/material.dart';
import 'package:tavrida_flutter/repositories/models/GetModel.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

class CodeDialog extends StatefulWidget{
  const CodeDialog({super.key});

  @override
  State<CodeDialog> createState() => _CodeDialogState();
}

class _CodeDialogState extends State<CodeDialog> {
  int code = 0;
  bool isLocked = true;
  bool isBadRequest = false;

  void _onButtonTapped() {
    setState(() {
      var response = getModelAsync(code, null);
      response.then((value) {
        if(value == null){
          isBadRequest = true;
        } else {
          isBadRequest = false;
          Navigator.pushNamed(context, "/ar_page");
        }
      });
    });
  }

  //Todo: настроить для конкретной модели

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(20.0)),
      child: SizedBox(
        height: 300,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.clear),
                color: AppColors.grey,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
            title: Text('Введите код', style: theme.textTheme.headlineLarge,),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Введите 4-значный код 3D-модели, который вам отправили',
                  style: theme.textTheme.bodySmall,),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: !isBadRequest ? AppColors.black : AppColors.red, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:  BorderSide(color: !isBadRequest ? AppColors.black : AppColors.red, width: 1),
                      ),
                      counter: Container(),
                    ),
                    style: TextStyle(
                      color: !isBadRequest ? AppColors.black : AppColors.red,
                      fontSize: 30,
                      height: 1,
                      textBaseline: TextBaseline.ideographic,
                      letterSpacing: 16.0,
                      fontWeight: FontWeight.w500
                    ),
                    textAlign: TextAlign.center,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    onChanged: (input) {
                      setState(() {
                        if(input.length == 4) {
                          isLocked = false;
                          code = int.tryParse(input) ?? 0;
                        }
                        else{
                          isLocked = true;
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12.0,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(isBadRequest? '3D-модели с таким кодом не существует' : '',
                      style: const TextStyle(
                        color: AppColors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLocked
                      ? null
                      : _onButtonTapped,
                  style: !isLocked
                    ? ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(AppColors.black),
                        minimumSize: MaterialStateProperty.all(const Size(350, 50)),
                        enableFeedback: false
                      )
                    : ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black26),
                        minimumSize: MaterialStateProperty.all(const Size(350, 50)),
                        enableFeedback: false,
                      ),
                  child: Text('Продолжить', style: theme.textTheme.headlineMedium),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}