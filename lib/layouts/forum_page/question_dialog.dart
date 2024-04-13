import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tavrida_flutter/layouts/forum_page/question_controller.dart';
import 'package:tavrida_flutter/services/models/questionnaire.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:tavrida_flutter/widgets/CustomTextField.dart';

class QuestionDialog extends StatefulWidget{
  final QuestionController questionController;

  const QuestionDialog({
    super.key,
    required this.questionController,
  });

  @override
  State<QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  late List<Question> questions;
  String? _answer;

  @override
  void initState() {
    questions = widget.questionController.questions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => Navigator.of(context).pop(),
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
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Вопрос ${widget.questionController.i + 1}/${questions.length}', style: theme.textTheme.labelMedium,)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '${questions[widget.questionController.i].description}',
                    style: theme.textTheme.titleLarge,
                  ),
                ),

                if (questions[widget.questionController.i].answers == null) ...[
                  _buildQuestionAlternative(),
                ]
                else ...[
                  _buildQuestionVariants(questions[widget.questionController.i].answers!),
                ],
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: buildButton("Далее", () {
                      if (!_answer.isEmptyOrNull) {
                        widget.questionController.next(_answer!, context);
                      }
                    }),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuestionVariants(List<String> answers) {
    return SizedBox(
      height: answers.length * 40,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: answers.length,
        itemBuilder: (context, i) {
          return RadioListTile<String>(
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            contentPadding: EdgeInsets.zero,
            title: Text(answers[i],
              style: const TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 14
              ),
              maxLines: 1,
            ),
            groupValue: _answer,
            value: answers[i],
            activeColor: AppColors.black,
            onChanged: (value) {
              setState((){
                _answer = value;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildQuestionAlternative() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: CustomTextField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(160),
        ],
        hintText: 'Введите ответ',
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF60666C),
        ),
        onChanged: (answer) => _answer = answer,
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