class Questionnaire {
  String? id;
  String? title;
  late int answerCount;
  late int questionsCount;
  List<Question>? questions;

  Questionnaire({this.id, this.title, this.questionsCount = 0, this.answerCount = 0, this.questions});

  Questionnaire.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    answerCount = 0;
    questionsCount = json['questionsCount'] ?? 0;
    if (json['questions'] != null) {
      questions = <Question>[];
      json['questions'].forEach((v) {
        questions!.add(Question.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['questionsCount'] = questionsCount;
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Question {
  String? id;
  String? description;
  List<String>? answers;

  Question({this.id, this.description, this.answers});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    answers = json['answers'] == null ? null : List<String>.from(json['answers'].map((x) => x));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['answers'] = answers;
    return data;
  }
}