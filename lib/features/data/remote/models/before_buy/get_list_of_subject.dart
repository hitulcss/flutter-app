import 'dart:convert';

class GetListOfSubjectsModel {
    bool? status;
    List<GetListOfSubjectsModelData>? data;
    String? msg;

    GetListOfSubjectsModel({
        this.status,
        this.data,
        this.msg,
    });

    factory GetListOfSubjectsModel.fromJson(String str) => GetListOfSubjectsModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetListOfSubjectsModel.fromMap(Map<String, dynamic> json) => GetListOfSubjectsModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<GetListOfSubjectsModelData>.from(json["data"]!.map((x) => GetListOfSubjectsModelData.fromMap(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "msg": msg,
    };
}

class GetListOfSubjectsModelData {
    String? id;
    String? title;
    String? icon;

    GetListOfSubjectsModelData({
        this.id,
        this.title,
        this.icon,
    });

    factory GetListOfSubjectsModelData.fromJson(String str) => GetListOfSubjectsModelData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetListOfSubjectsModelData.fromMap(Map<String, dynamic> json) => GetListOfSubjectsModelData(
        id: json["id"],
        title: json["title"],
        icon: json["icon"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "icon": icon,
    };
}
