class ResultModel {
  bool? status;
  ResultModelData? data;
  String? msg;

  ResultModel({this.status, this.data, this.msg});

  ResultModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? ResultModelData.fromJson(json['data']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = msg;
    return data;
  }
}

class ResultModelData {
  String? quizId;
  bool? isPublished;
  String? totalMarks;
  bool? isNegative;
  String? negativeMarks;
  MyScore? myScore;
  MyScore? accuracy;
  MyScore? toperScore;
  Summary? summary;
  Difficulty? difficulty;
  List<QuestionResponse>? response;

  ResultModelData(
      {this.quizId,
      this.isPublished,
      this.totalMarks,
      this.isNegative,
      this.negativeMarks,
      this.myScore,
      this.accuracy,
      this.toperScore,
      this.summary,
      this.difficulty,
      this.response});

  ResultModelData.fromJson(Map<String, dynamic> json) {
    quizId = json['quizId'];
    isPublished = json['is_published'];
    totalMarks = json['totalMarks'];
    isNegative = json['is_negative'];
    negativeMarks = json['negativeMarks'];
    myScore =
        json['myScore'] != null ? MyScore.fromJson(json['myScore']) : null;
    accuracy = json['accuracy'] != null
        ? MyScore.fromJson(json['accuracy'])
        : null;
    toperScore = json['toperScore'] != null
        ? MyScore.fromJson(json['toperScore'])
        : null;
    summary =
        json['summary'] != null ? Summary.fromJson(json['summary']) : null;
    difficulty = json['difficulty'] != null
        ? Difficulty.fromJson(json['difficulty'])
        : null;
    if (json['response'] != null) {
      response = <QuestionResponse>[];
      json['response'].forEach((v) {
        response!.add(QuestionResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quizId'] = quizId;
    data['is_published'] = isPublished;
    data['totalMarks'] = totalMarks;
    data['is_negative'] = isNegative;
    data['negativeMarks'] = negativeMarks;
    if (myScore != null) {
      data['myScore'] = myScore!.toJson();
    }
    if (accuracy != null) {
      data['accuracy'] = accuracy!.toJson();
    }
    if (toperScore != null) {
      data['toperScore'] = toperScore!.toJson();
    }
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    if (difficulty != null) {
      data['difficulty'] = difficulty!.toJson();
    }
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyScore {
  String? percentage;
  String? number;

  MyScore({this.percentage, this.number});

  MyScore.fromJson(Map<String, dynamic> json) {
    percentage = json['percentage'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['percentage'] = percentage;
    data['number'] = number;
    return data;
  }
}

class Summary {
  int? noOfQues;
  int? attempted;
  int? skipped;
  int? correctAns;
  int? wrongAnswers;

  Summary(
      {this.noOfQues,
      this.attempted,
      this.skipped,
      this.correctAns,
      this.wrongAnswers});

  Summary.fromJson(Map<String, dynamic> json) {
    noOfQues = json['noOfQues'];
    attempted = json['Attempted'];
    skipped = json['skipped'];
    correctAns = json['correctAns'];
    wrongAnswers = json['wrongAnswers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['noOfQues'] = noOfQues;
    data['Attempted'] = attempted;
    data['skipped'] = skipped;
    data['correctAns'] = correctAns;
    data['wrongAnswers'] = wrongAnswers;
    return data;
  }
}

class Difficulty {
  MyScore? easy;
  MyScore? medium;
  MyScore? hard;

  Difficulty({this.easy, this.medium, this.hard});

  Difficulty.fromJson(Map<String, dynamic> json) {
    easy = json['easy'] != null ? MyScore.fromJson(json['easy']) : null;
    medium =
        json['medium'] != null ? MyScore.fromJson(json['medium']) : null;
    hard = json['hard'] != null ? MyScore.fromJson(json['hard']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (easy != null) {
      data['easy'] = easy!.toJson();
    }
    if (medium != null) {
      data['medium'] = medium!.toJson();
    }
    if (hard != null) {
      data['hard'] = hard!.toJson();
    }
    return data;
  }
}

class QuestionResponse {
  String? ansId;
  QuestionTitle? questionTitle;
  QuestionTitle? queLevel;
  QuestionTitle? option1;
  QuestionTitle? option2;
  QuestionTitle? option3;
  QuestionTitle? option4;
  QuestionTitle? answer;
  String? correctOption;
  String? myAnswer;

  QuestionResponse(
      {this.ansId,
      this.questionTitle,
      this.queLevel,
      this.option1,
      this.option2,
      this.option3,
      this.option4,
      this.answer,
      this.correctOption,
      this.myAnswer});

  QuestionResponse.fromJson(Map<String, dynamic> json) {
    ansId = json['ans_id'];
    questionTitle = json['question_title'] != null
        ? QuestionTitle.fromJson(json['question_title'])
        : null;
    queLevel = json['que_level'] != null
        ? QuestionTitle.fromJson(json['que_level'])
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
    answer = json['answer'] != null
        ? QuestionTitle.fromJson(json['answer'])
        : null;
    correctOption = json['correctOption'];
    myAnswer = json['myAnswer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ans_id'] = ansId;
    if (questionTitle != null) {
      data['question_title'] = questionTitle!.toJson();
    }
    if (queLevel != null) {
      data['que_level'] = queLevel!.toJson();
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
    if (answer != null) {
      data['answer'] = answer!.toJson();
    }
    data['correctOption'] = correctOption;
    data['myAnswer'] = myAnswer;
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
