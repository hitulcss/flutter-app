import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';

class ListOfQuizModel {
  bool? status;
  ListOfQuizModelData? data;
  String? msg;

  ListOfQuizModel({this.status, this.data, this.msg});

  ListOfQuizModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? ListOfQuizModelData.fromJson(json['data']) : null;
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

class ListOfQuizModelData {
  List<IsAttempted>? isAttempted;
  List<NotAttempted>? notAttempted;

  ListOfQuizModelData({this.isAttempted, this.notAttempted});

  ListOfQuizModelData.fromJson(Map<String, dynamic> json) {
    if (json['is_attempted'] != null) {
      isAttempted = <IsAttempted>[];
      json['is_attempted'].forEach((v) {
        isAttempted!.add(IsAttempted.fromJson(v));
      });
    }
    if (json['not_attempted'] != null) {
      notAttempted = <NotAttempted>[];
      json['not_attempted'].forEach((v) {
        notAttempted!.add(NotAttempted.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (isAttempted != null) {
      data['is_attempted'] = isAttempted!.map((v) => v.toJson()).toList();
    }
    if (notAttempted != null) {
      data['not_attempted'] = notAttempted!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IsAttempted {
  String? id;
  String? quizTitle;
  String? quizDesc;
  String? quizDuration;
  String? noQues;
  String? quizBanner;
  String? language;
  String? shareLink;
  ShareUrl? shareUrl;
  bool? isNegative;
  String? negativeMarks;
  String? eachQueMarks;
  String? quizCreatedAt;

  IsAttempted({
    this.id,
    this.quizTitle,
    this.quizDesc,
    this.quizDuration,
    this.noQues,
    this.quizBanner,
    this.language,
    this.shareLink,
    this.shareUrl,
    this.isNegative,
    this.negativeMarks,
    this.eachQueMarks,
    this.quizCreatedAt,
  });

  IsAttempted.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quizTitle = json['quiz_title'];
    quizDesc = json['quiz_desc'];
    quizDuration = json['quiz_duration'];
    noQues = json['no_ques'];
    quizBanner = json['quiz_banner'];
    language = json['language'];
    shareLink = json['shareLink'];
    shareUrl = json['shareUrl'] != null ? ShareUrl.fromJson(json['shareUrl']) : null;
    isNegative = json['is_negative'];
    negativeMarks = json['negativeMarks'];
    eachQueMarks = json['eachQueMarks'];
    quizCreatedAt = json['quiz_created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quiz_title'] = quizTitle;
    data['quiz_desc'] = quizDesc;
    data['quiz_duration'] = quizDuration;
    data['no_ques'] = noQues;
    data['quiz_banner'] = quizBanner;
    data['language'] = language;
    data['shareLink'] = shareLink;
    if (shareUrl != null) {
      data['shareUrl'] = shareUrl!.toJson();
    }
    data['is_negative'] = isNegative;
    data['negativeMarks'] = negativeMarks;
    data['eachQueMarks'] = eachQueMarks;
    data['quiz_created_at'] = quizCreatedAt;
    return data;
  }
}

class NotAttempted {
  String? id;
  String? quizTitle;
  String? quizDesc;
  String? quizDuration;
  String? noQues;
  String? quizBanner;
  String? language;
  String? shareLink;
  ShareUrl? shareUrl;
  bool? isNegative;
  String? negativeMarks;
  String? eachQueMarks;
  String? quizCreatedAt;

  NotAttempted({
    this.id,
    this.quizTitle,
    this.quizDesc,
    this.quizDuration,
    this.noQues,
    this.quizBanner,
    this.language,
    this.shareLink,
    this.shareUrl,
    this.isNegative,
    this.negativeMarks,
    this.eachQueMarks,
    this.quizCreatedAt,
  });

  NotAttempted.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quizTitle = json['quiz_title'];
    quizDesc = json['quiz_desc'];
    quizDuration = json['quiz_duration'];
    noQues = json['no_ques'];
    quizBanner = json['quiz_banner'];
    language = json['language'];
    shareLink = json['shareLink'];
    shareUrl = json['shareUrl'] != null ? ShareUrl.fromJson(json['shareUrl']) : null;
    isNegative = json['is_negative'];
    negativeMarks = json['negativeMarks'];
    eachQueMarks = json['eachQueMarks'];
    quizCreatedAt = json['quiz_created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quiz_title'] = quizTitle;
    data['quiz_desc'] = quizDesc;
    data['quiz_duration'] = quizDuration;
    data['no_ques'] = noQues;
    data['quiz_banner'] = quizBanner;
    data['language'] = language;
    data['shareLink'] = shareLink;
    if (shareUrl != null) {
      data['shareUrl'] = shareUrl!.toJson();
    }
    data['is_negative'] = isNegative;
    data['negativeMarks'] = negativeMarks;
    data['eachQueMarks'] = eachQueMarks;
    data['quiz_created_at'] = quizCreatedAt;
    return data;
  }
}
