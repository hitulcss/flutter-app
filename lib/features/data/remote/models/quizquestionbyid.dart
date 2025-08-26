class QuestionsById {
  bool? status;
  List<QuestionsByIdData>? data;
  String? msg;

  QuestionsById({this.status, this.data, this.msg});

  QuestionsById.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <QuestionsByIdData>[];
      json['data'].forEach((v) {
        data!.add(QuestionsByIdData.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = msg;
    return data;
  }
}

class QuestionsByIdData {
  String? sId;
  String? quizId;
  QuestionTitle? questionTitle;
  QuestionTitle? option1;
  QuestionTitle? option2;
  QuestionTitle? option3;
  QuestionTitle? option4;

  QuestionsByIdData(
      {this.sId,
      this.quizId,
      this.questionTitle,
      this.option1,
      this.option2,
      this.option3,
      this.option4});

  QuestionsByIdData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    quizId = json['quiz_id'];
    questionTitle = json['question_title'] != null
        ? QuestionTitle.fromJson(json['question_title'])
        : null;
    option1 = json['option1'] != null
        ? QuestionTitle.fromJson(json['option1'])
        : null;
    option2 = json['option2'] != null
        ? QuestionTitle.fromJson(json['option2'])
        : null;
    option3 = json['option3'] != null
        ? QuestionTitle.fromJson(json['option3'])
        : null;
    option4 = json['option4'] != null
        ? QuestionTitle.fromJson(json['option4'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['quiz_id'] = quizId;
    if (questionTitle != null) {
      data['question_title'] = questionTitle!.toJson();
    }
    if (option1 != null) {
      data['option1'] = option1!.toJson();
    }
    if (option2 != null) {
      data['option2'] = option2!.toJson();
    }
    if (option3 != null) {
      data['option3'] = option3!.toJson();
    }
    if (option4 != null) {
      data['option4'] = option4!.toJson();
    }
    return data;
  }
}

class QuestionTitle {
  String? e;
  String? h;

  QuestionTitle({this.e, this.h});

  QuestionTitle.fromJson(Map<String, dynamic> json) {
    e = json['e'];
    h = json['h'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['e'] = e;
    data['h'] = h;
    return data;
  }
}
