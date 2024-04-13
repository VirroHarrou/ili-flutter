import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavrida_flutter/services/api_service.dart';
import 'package:tavrida_flutter/services/models/questionnaire.dart';

class QuestionnaireService{
  final SharedPreferences _prefs;
  late List<String> _answers;

  get answers => _answers;

  QuestionnaireService({
    required SharedPreferences prefs,
  }) : _prefs = prefs {
    _answers = _prefs.getStringList("answers") ?? [];
  }


  Future<List<Questionnaire>?> getQuestionnaireList({required String id}) async {
    var response =
        await ApiService.sendRequest(
          request: "questionnaire/list/$id",
        );
    if (response == null) return null;
    if (response.statusCode! >= 400) return null;
    try {
      List jsons = response.data['questionnaires'];
      List<Questionnaire> result = [];
      for (var element in jsons) {
        var q = Questionnaire.fromJson(element);
        q = await getQuestionnaire(id: q.id ?? '') ?? q;
        result.add(q);
      }
      return result;
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Questionnaire?> getQuestionnaire({required String id}) async {
    var response =
      await ApiService.sendRequest(
        request: "questionnaire/$id",
      );
    if (response == null) return null;
    if (response.statusCode! >= 400) return null;
    try {
      return Questionnaire.fromJson(response.data);
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<Question>?> getQuestionList({required String id}) async {
    var response =
    await ApiService.sendRequest(
      request: "question/list/$id",
    );
    if (response == null) return null;
    if (response.statusCode! >= 400) return null;
    try {
      List jsons = response.data['questions'];
      List<Question> result = [];
      for (var element in jsons) {
        result.add(Question.fromJson(element));
      }
      return result;
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> sendAnswer({required String id, required String value}) async {
    var response =
        await ApiService.sendRequest(
          method: RequestMethod.patch,
          request: "answer",
          data: {
            "questionId" : id,
            "value": value,
          },
        );
    if (response == null) return;
    if (response.statusCode == 204) {
      _answers.add(id);
      await _prefs.setStringList("answers", answers);
    } else {
      debugPrint("Answer don`t send, something wrong");
    }
  }
}