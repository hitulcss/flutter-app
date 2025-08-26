class AlertModel {
  bool? status;
  List<AlertModelData>? data;
  String? msg;

  AlertModel({this.status, this.data, this.msg});

  AlertModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <AlertModelData>[];
      json['data'].forEach((v) {
        data!.add(AlertModelData.fromJson(v));
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

class AlertModelData {
  String? id;
  String? title;
  String? type;
  String? desc;
  String? redirectTo;

  AlertModelData({this.id, this.title, this.desc, this.type, this.redirectTo});

  AlertModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    desc = json['desc'];
    redirectTo = json['redirectTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['title'] = title;
    data['desc'] = desc;
    data['redirectTo'] = redirectTo;
    return data;
  }
}
