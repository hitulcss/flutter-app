class Getpoll {
  bool? status;
  GetpollData? data;
  String? msg;

  Getpoll({this.status, this.data, this.msg});

  Getpoll.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? GetpollData.fromJson(json['data']) : null;
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

class GetpollData {
  List<String>? options;
  String? duration;
  String? pollId;
  String? lectureId;
  String? pollType;

  GetpollData({this.options, this.duration, this.pollId, this.lectureId});

  GetpollData.fromJson(Map<String, dynamic> json) {
    options = json['options'].cast<String>();
    duration = json['duration'];
    pollId = json['pollId'];
    lectureId = json["lectureId"];
    pollType = json["pollType"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['options'] = options;
    data['duration'] = duration;
    data['pollId'] = pollId;
    data["lectureId"] = lectureId;
    data["pollType"] = pollType;
    return data;
  }
}
