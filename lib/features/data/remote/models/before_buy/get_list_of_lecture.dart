import 'package:sd_campus_app/models/classschedule.dart';

class GetListOfLectureModel {
  bool? status;
  List<ClassScheduleModel>? data;
  String? msg;

  GetListOfLectureModel({
    this.status,
    this.data,
    this.msg,
  });

  GetListOfLectureModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ClassScheduleModel>[];
      json['data'].forEach((v) {
        data!.add(ClassScheduleModel.fromMap(v));
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
