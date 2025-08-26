import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';

class GetTestRegById {
  bool? status;
  GetTestRegByIdData? data;
  String? msg;

  GetTestRegById({this.status, this.data, this.msg});

  GetTestRegById.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? GetTestRegByIdData.fromJson(json['data']) : null;
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

class GetTestRegByIdData {
  String? id;
  String? title;
  String? banner;
  String? quizId;
  String? description;
  String? startingAt;
  String? duration;
  String? registrationEndAt;
  String? resultDeclaration;
  ShareUrl? shareUrl;
  bool? isRegister;

  GetTestRegByIdData(
      {this.id,
      this.title,
      this.banner,
      this.quizId,
      this.description,
      this.startingAt,
      this.duration,
      this.registrationEndAt,
      this.resultDeclaration,
      this.shareUrl,
      this.isRegister});

  GetTestRegByIdData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    banner = json['banner'];
    quizId = json['quizId'];
    shareUrl= ShareUrl.fromJson(json['shareUrl']);
    description = json['description'];
    startingAt = json['startingAt'];
    duration = json['duration'];
    registrationEndAt = json['registrationEndAt'];
    resultDeclaration = json['resultDeclaration'];
    isRegister = json['isRegister'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['banner'] = banner;
    data['quizId'] = quizId;
    data['description'] = description;
    data['startingAt'] = startingAt;
    data['duration'] = duration;
    data['registrationEndAt'] = registrationEndAt;
    data['resultDeclaration'] = resultDeclaration;
    data['isRegister'] = isRegister;
    return data;
  }
}
