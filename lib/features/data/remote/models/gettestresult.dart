class GetTestResultsModel {
  bool? status;
  GetTestResultsModelData? data;
  String? msg;

  GetTestResultsModel({this.status, this.data, this.msg});

  GetTestResultsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? GetTestResultsModelData.fromJson(json['data']) : null;
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

class GetTestResultsModelData {
  Objective? objective;
  Subjective? subjective;

  GetTestResultsModelData({this.objective, this.subjective});

  GetTestResultsModelData.fromJson(Map<String, dynamic> json) {
    objective = json['objective'] != null
        ? Objective.fromJson(json['objective'])
        : null;
    subjective = json['subjective'] != null
        ? Subjective.fromJson(json['subjective'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (objective != null) {
      data['objective'] = objective!.toJson();
    }
    if (subjective != null) {
      data['subjective'] = subjective!.toJson();
    }
    return data;
  }
}

class Objective {
  List<Online>? online;
  List<Offline>? offline;

  Objective({this.online, this.offline});

  Objective.fromJson(Map<String, dynamic> json) {
    if (json['online'] != null) {
      online = <Online>[];
      json['online'].forEach((v) {
        online!.add(Online.fromJson(v));
      });
    }
    if (json['offline'] != null) {
      offline = <Offline>[];
      json['offline'].forEach((v) {
        offline!.add(Offline.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (online != null) {
      data['online'] = online!.map((v) => v.toJson()).toList();
    }
    if (offline != null) {
      data['offline'] = offline!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Online {
  String? id;
  String? testSeriesId;
  String? testId;
  String? testTitle;
  String? testCode;
  String? attemptedAt;
  String? attemptedtype;
  String? totalMarks;
  String? totalDucation;
  String? timeSpent;
  bool? isResultPublished;

  Online(
      {this.id,
      this.testSeriesId,
      this.testId,
      this.testTitle,
      this.testCode,
      this.attemptedAt,
      this.attemptedtype,
      this.totalMarks,
      this.totalDucation,
      this.timeSpent,
      this.isResultPublished});

  Online.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    testSeriesId = json['testSeriesId'];
    testId = json['testId'];
    testTitle = json['Test_title'];
    testCode = json['Test_code'];
    attemptedAt = json['attemptedAt'];
    attemptedtype = json['attemptedtype'];
    totalMarks = json['totalMarks'];
    totalDucation = json['totalDucation'];
    timeSpent = json['timeSpent'];
    isResultPublished = json['isResultPublished'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['testSeriesId'] = testSeriesId;
    data['testId'] = testId;
    data['Test_title'] = testTitle;
    data['Test_code'] = testCode;
    data['attemptedAt'] = attemptedAt;
    data['attemptedtype'] = attemptedtype;
    data['totalMarks'] = totalMarks;
    data['totalDucation'] = totalDucation;
    data['timeSpent'] = timeSpent;
    data['isResultPublished'] = isResultPublished;
    return data;
  }
}

class Offline {
  String? id;
  String? testSeriesId;
  String? testId;
  String? testTitle;
  String? testCode;
  String? attemptedAt;
  String? attemptedtype;
  String? totalMarks;
  String? totalDucation;
  String? timeSpent;
  CheckedAnswerSheet? checkedAnswerSheet;
  CheckedAnswerSheet? answerSheet;
  String? score;
  bool? isResultPublished;

  Offline(
      {this.id,
      this.testSeriesId,
      this.testId,
      this.testTitle,
      this.testCode,
      this.attemptedAt,
      this.attemptedtype,
      this.totalMarks,
      this.totalDucation,
      this.timeSpent,
      this.checkedAnswerSheet,
      this.answerSheet,
      this.score,
      this.isResultPublished});

  Offline.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    testSeriesId = json['testSeriesId'];
    testId = json['testId'];
    testTitle = json['Test_title'];
    testCode = json['Test_code'];
    attemptedAt = json['attemptedAt'];
    attemptedtype = json['attemptedtype'];
    totalMarks = json['totalMarks'];
    totalDucation = json['totalDucation'];
    timeSpent = json['timeSpent'];
    checkedAnswerSheet = json['checked_answer_sheet'] != null
        ? CheckedAnswerSheet.fromJson(json['checked_answer_sheet'])
        : null;
    answerSheet = json['answer_sheet'] != null
        ? CheckedAnswerSheet.fromJson(json['answer_sheet'])
        : null;
    score = json['Score'];
    isResultPublished = json['isResultPublished'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['testSeriesId'] = testSeriesId;
    data['testId'] = testId;
    data['Test_title'] = testTitle;
    data['Test_code'] = testCode;
    data['attemptedAt'] = attemptedAt;
    data['attemptedtype'] = attemptedtype;
    data['totalMarks'] = totalMarks;
    data['totalDucation'] = totalDucation;
    data['timeSpent'] = timeSpent;
    if (checkedAnswerSheet != null) {
      data['checked_answer_sheet'] = checkedAnswerSheet!.toJson();
    }
    if (answerSheet != null) {
      data['answer_sheet'] = answerSheet!.toJson();
    }
    data['Score'] = score;
    data['isResultPublished'] = isResultPublished;
    return data;
  }
}

class CheckedAnswerSheet {
  String? fileLoc;
  String? fileName;
  String? fileSize;

  CheckedAnswerSheet({this.fileLoc, this.fileName, this.fileSize});

  CheckedAnswerSheet.fromJson(Map<String, dynamic> json) {
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

class Subjective {
  List<Offline>? offline;

  Subjective({this.offline});

  Subjective.fromJson(Map<String, dynamic> json) {
    if (json['offline'] != null) {
      offline = <Offline>[];
      json['offline'].forEach((v) {
        offline!.add(Offline.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (offline != null) {
      data['offline'] = offline!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
