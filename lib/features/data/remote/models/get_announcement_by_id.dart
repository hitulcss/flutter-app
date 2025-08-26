class getAnnouncement {
  bool? status;
  List<Data>? data;
  String? msg;

  getAnnouncement({this.status, this.data, this.msg});

  getAnnouncement.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  String? sId;
  String? admin;
  String? title;
  String? description;
  String? link;
  String? linkWith;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Data({
    this.sId,
    this.admin,
    this.title,
    this.description,
    this.link,
    this.linkWith,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    admin = json['admin'];
    title = json['title'];
    description = json['description'];
    link = json['link'];
    linkWith = json['linkWith'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['admin'] = admin;
    data['title'] = title;
    data['description'] = description;
    data['link'] = link;
    data['linkWith'] = linkWith;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
