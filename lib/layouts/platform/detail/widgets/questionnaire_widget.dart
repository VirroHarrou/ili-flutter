import 'package:flutter/material.dart';
import 'package:tavrida_flutter/generated/l10n.dart';
import 'package:tavrida_flutter/layouts/platform/detail/widgets/question_controller.dart';
import 'package:tavrida_flutter/services/models/questionnaire.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

class QuestionnaireWidget extends StatefulWidget{
  final List<Questionnaire> questionnaires;

  const QuestionnaireWidget({
    super.key,
    required this.questionnaires,
  });

  @override
  State<QuestionnaireWidget> createState() => _QuestionnaireWidgetState();
}

class _QuestionnaireWidgetState extends State<QuestionnaireWidget> {
  final List<QuestionController> controllers = [];

  @override
  void initState() {
    super.initState();

    for (var el in widget.questionnaires) {
      if (context.mounted) {
        controllers.add(QuestionController(
          questionnaire: el,
          answersCountCallback: _setCountAnswers,
        ));
      }
    }
    setState(() {});
  }

  void _setCountAnswers(Map<String, int> data){
    setState(() {
      widget.questionnaires[widget.questionnaires.indexWhere((element) =>
        element.id == data.keys.first)].answerCount = data.values.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20, right: 20),
        scrollDirection: Axis.horizontal,
        itemCount: widget.questionnaires.length,
        itemBuilder: (context, i) =>
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: buildItem(
                widget.questionnaires[i],
                controllers[i],
              ),
            ),
      ),
    );
  }

  Widget buildItem(Questionnaire survey, QuestionController controller) {
    final remain = survey.questionsCount - survey.answerCount;
    final bool completed = remain == 0;
    return InkWell(
      onTap: () {
        if (!completed) {
          showDialog(
              context: context,
              builder: (context) => controller.startQuestionnaire(context)
          );
        }
      },
      child: Container(
        width: 115,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: completed ?
          AppColors.black : const Color(0xFFECECED),
          boxShadow: !completed ? [
            const BoxShadow(
              color: Color.fromRGBO(51, 51, 51, 0.15),
              offset: Offset(3, 4),
              blurRadius: 4,
            ),
          ] : [],
          border: !completed ? Border.all(color: const Color.fromRGBO(51, 51, 51, 0.1))
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(survey.title!.length <= 50 ? survey.title!
                :'${survey.title?.characters.take(30).string}...',
              style: TextStyle(
                color: completed ? AppColors.white : AppColors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              maxLines: 3,
            ),
            Text(completed ? S.of(context).complete :
            '$remain ${S.of(context).questions(remain)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: completed ? AppColors.white.withOpacity(0.8) :
                AppColors.black.withOpacity(0.8),
              ),),
          ],
        ),
      ),
    );
  }
}