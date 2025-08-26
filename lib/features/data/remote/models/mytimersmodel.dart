class MyTimersModel {
  bool? status;
  List<MyTimersModelData>? data;
  String? msg;

  MyTimersModel({this.status, this.data, this.msg});

  MyTimersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <MyTimersModelData>[];
      json['data'].forEach((v) {
        data!.add(MyTimersModelData.fromJson(v));
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

class MyTimersModelData {
  String? id;
  String? userId;
  String? timerDuration;
  String? timerTitle;
  String? createdAt;

  MyTimersModelData(
      {this.id,
      this.userId,
      this.timerDuration,
      this.timerTitle,
      this.createdAt});

  MyTimersModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    timerDuration = json['timerDuration'];
    timerTitle = json['TimerTitle'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['timerDuration'] = timerDuration;
    data['TimerTitle'] = timerTitle;
    data['created_at'] = createdAt;
    return data;
  }
}
