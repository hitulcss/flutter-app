import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';

class GetQuizById {
  bool? status;
  GetQuizByIdData? data;
  String? msg;

  GetQuizById({this.status, this.data, this.msg});

  GetQuizById.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? GetQuizByIdData.fromJson(json['data']) : null;
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

class GetQuizByIdData {
  String? id;
  String? quizTitle;
  String? quizDesc;
  String? quizDuration;
  String? noQues;
  String? quizBanner;
  String? language;
  bool? isNegative;
  ShareUrl? shareUrl;
  String? negativeMarks;
  String? eachQueMarks;
  String? quizCreatedAt;

  GetQuizByIdData(
      {this.id,
      this.quizTitle,
      this.quizDesc,
      this.quizDuration,
      this.noQues,
      this.quizBanner,
      this.language,
      this.isNegative,
      this.negativeMarks,
      this.shareUrl,
      this.eachQueMarks,
      this.quizCreatedAt});

  GetQuizByIdData.fromJson(Map<String, dynamic> json) {
    shareUrl = json['share_url'] != null  ? ShareUrl.fromJson(json['share_url']) : null;
    id = json['id'];
    quizTitle = json['quiz_title'];
    quizDesc = json['quiz_desc'];
    quizDuration = json['quiz_duration'];
    noQues = json['no_ques'];
    quizBanner = json['quiz_banner'];
    language = json['language'];
    isNegative = json['is_negative'];
    negativeMarks = json['negativeMarks'];
    eachQueMarks = json['eachQueMarks'];
    quizCreatedAt = json['quiz_created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['share_url'] = shareUrl;
    data['id'] = id;
    data['quiz_title'] = quizTitle;
    data['quiz_desc'] = quizDesc;
    data['quiz_duration'] = quizDuration;
    data['no_ques'] = noQues;
    data['quiz_banner'] = quizBanner;
    data['language'] = language;
    data['is_negative'] = isNegative;
    data['negativeMarks'] = negativeMarks;
    data['eachQueMarks'] = eachQueMarks;
    data['quiz_created_at'] = quizCreatedAt;
    return data;
  }
}
