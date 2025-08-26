class GetStoreAlert {
  bool? status;
  List<GetStoreAlertData>? data;
  String? msg;

  GetStoreAlert({this.status, this.data, this.msg});

  GetStoreAlert.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetStoreAlertData>[];
      json['data'].forEach((v) {
        data!.add(GetStoreAlertData.fromJson(v));
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

class GetStoreAlertData {
  String? id;
  String? title;
  String? link;
  LinkWith? linkWith;

  GetStoreAlertData({this.id, this.title, this.link, this.linkWith});

  GetStoreAlertData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    link = json['link'];
    linkWith = json['linkWith'] != null
        ? LinkWith.fromJson(json['linkWith'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['link'] = link;
    if (linkWith != null) {
      data['linkWith'] = linkWith!.toJson();
    }
    return data;
  }
}

class LinkWith {
  String? id;
  String? title;

  LinkWith({this.id, this.title});

  LinkWith.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}
