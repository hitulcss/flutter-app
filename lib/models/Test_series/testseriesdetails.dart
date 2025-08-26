class TestSeriesDetails {
  bool? status;
  List<TestSeriesDetailsData>? data;
  String? msg;

  TestSeriesDetails({this.status, this.data, this.msg});

  TestSeriesDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <TestSeriesDetailsData>[];
      json['data'].forEach((v) {
        data!.add(TestSeriesDetailsData.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = msg;
    return data;
  }
}

class TestSeriesDetailsData {
  String? testSeriesId;
  String? testId;
  String? testTitle;
  String? testCode;
  String? instructions;
  String? startDate;
  int? noOfQuestions;
  QuestionPaper? questionPaper;
  QuestionPaper? answerTemplate;
  String? totalMarkes;
  String? questionsPaperType;
  bool? isNegativeMarking;
  String? duration;
  String? createdAt;
  String? updatedAt;
  String? score;
  QuestionPaper? checkedAnswerSheet;
  QuestionPaper? answerSheet;
  bool? isOnline;
  String? testMode;
  bool? isAttempted;

  TestSeriesDetailsData(
      {this.testSeriesId,
      this.testId,
      this.testTitle,
      this.testCode,
      this.instructions,
      this.startDate,
      this.noOfQuestions,
      this.questionPaper,
      this.answerTemplate,
      this.totalMarkes,
      this.questionsPaperType,
      this.isNegativeMarking,
      this.duration,
      this.createdAt,
      this.updatedAt,
      this.score,
      this.checkedAnswerSheet,
      this.answerSheet,
      this.isOnline,
      this.testMode,
      this.isAttempted});

  TestSeriesDetailsData.fromJson(Map<String, dynamic> json) {
    testSeriesId = json['testSeriesId'];
    testId = json['testId'];
    testTitle = json['testTitle'];
    testCode = json['testCode'];
    instructions = json['instructions'];
    startDate = json['startDate'];
    noOfQuestions = json['noOfQuestions'];
    questionPaper = json['questionPaper'] != null
        ? QuestionPaper.fromJson(json['questionPaper'])
        : null;
    answerTemplate = json['answerTemplate'] != null
        ? QuestionPaper.fromJson(json['answerTemplate'])
        : null;
    totalMarkes = json['totalMarkes'];
    questionsPaperType = json['questionsPaperType'];
    isNegativeMarking = json['isNegativeMarking'];
    duration = json['duration'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    score = json['score'];
    checkedAnswerSheet = json['checkedAnswerSheet'] != null
        ? QuestionPaper.fromJson(json['checkedAnswerSheet'])
        : null;
    answerSheet = json['answerSheet'] != null
        ? QuestionPaper.fromJson(json['answerSheet'])
        : null;
    isOnline = json['is_online'];
    testMode = json['test_mode'];
    isAttempted = json['is_attempted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['testSeriesId'] = testSeriesId;
    data['testId'] = testId;
    data['testTitle'] = testTitle;
    data['testCode'] = testCode;
    data['instructions'] = instructions;
    data['startDate'] = startDate;
    data['noOfQuestions'] = noOfQuestions;
    if (questionPaper != null) {
      data['questionPaper'] = questionPaper!.toJson();
    }
    if (answerTemplate != null) {
      data['answerTemplate'] = answerTemplate!.toJson();
    }
    data['totalMarkes'] = totalMarkes;
    data['questionsPaperType'] = questionsPaperType;
    data['isNegativeMarking'] = isNegativeMarking;
    data['duration'] = duration;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['score'] = score;
    if (checkedAnswerSheet != null) {
      data['checkedAnswerSheet'] = checkedAnswerSheet!.toJson();
    }
    if (answerSheet != null) {
      data['answerSheet'] = answerSheet!.toJson();
    }
    data['is_online'] = isOnline;
    data['test_mode'] = testMode;
    data['is_attempted'] = isAttempted;
    return data;
  }
}

class QuestionPaper {
  String? fileLoc;
  String? fileName;
  String? fileSize;

  QuestionPaper({this.fileLoc, this.fileName, this.fileSize});

  QuestionPaper.fromJson(Map<String, dynamic> json) {
    fileLoc = json['fileLoc'];
    fileName = json['fileName'];
    fileSize = json['fileSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileLoc'] = fileLoc;
    data['fileName'] = fileName;
    data['fileSize'] = fileSize;
    return data;
  }
}
