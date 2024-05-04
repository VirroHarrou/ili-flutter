import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injector/injector.dart';
import 'package:tavrida_flutter/layouts/forum_page/question_dialog.dart';
import 'package:tavrida_flutter/services/models/questionnaire.dart';
import 'package:tavrida_flutter/services/questionnaire_service.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

class QuestionController {
  final Questionnaire questionnaire;
  ValueSetter<String>? onComplete;
  ValueSetter<Map<String, int>> answersCountCallback;
  late int _iterator;
  late final List<Question> questions;
  final questionnaireService = Injector.appInstance.get<QuestionnaireService>();
  get i => _iterator;

  QuestionController({
    required this.questionnaire,
    this.onComplete,
    required this.answersCountCallback,
  })  {
    _iterator = 0;
    initController();
  }

  Future<void> initController() async {
    var data = await questionnaireService.getQuestionList(id: questionnaire.id ?? '');
    questions = data ?? [];
    _getAnswersCount().then((value) => _iterator = value);
  }

  Widget startQuestionnaire(BuildContext context) {
    return QuestionDialog(questionController: this);
  }

  Future<int> _getAnswersCount() async {
    var answers = questionnaireService.answers as List<String>?;
    if (answers.isEmptyOrNull) return 0;
    int count = 0;
    for(var question in questions){
      if(answers!.any((element) => element == question.id)) count++;
    }
    answersCountCallback({questionnaire.id! : count});
    return count;
  }

  Future<void> next(String answer, BuildContext context) async {
    await questionnaireService.sendAnswer(id: questions[i].id ?? '', value: answer);
    _iterator++;
    answersCountCallback({questionnaire.id! : _iterator});
    if (context.mounted) {
      context.pop();
    }
    if(i >= questions.length){
      showDialog(context: context, builder: (context) => _buildEndDialog(context));
      if (onComplete != null) onComplete!(questionnaire.id ?? '');
      return;
    }
    showDialog(context: context, builder: (context) => startQuestionnaire(context),);
  }

  Widget _buildEndDialog(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              onPressed: () => context.pop(),
              shape: const CircleBorder(),
              backgroundColor: AppColors.white.withOpacity(0.6),
              child: const Icon(Icons.close, color: Colors.black,),
            ),
          ),
          const SizedBox(height: 12,),
          Container(
            width: 336,
            padding: const EdgeInsets.only(
              top: 36,
              right: 20,
              left: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.white,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 20,
                  color: Color.fromRGBO(0, 0, 0, 0.12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Спасибо! Вы успешно прошли опрос',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: buildButton("Ок", () {
                      context.pop();
                    }),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildButton(String title, void Function() onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: AppColors.black,
        ),
        child: Text(title, style: const TextStyle(
          color: AppColors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),),
      ),
    );
  }
}