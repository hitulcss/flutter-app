import 'dart:convert';

class NotificationGet {
  final bool status;
  final List<NotificationGetData> data;
  final String msg;

  NotificationGet({
    required this.status,
    required this.data,
    required this.msg,
  });

  factory NotificationGet.fromRawJson(String str) =>
      NotificationGet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationGet.fromJson(Map<String, dynamic> json) =>
      NotificationGet(
        status: json["status"],
        data: List<NotificationGetData>.from(
            json["data"].map((x) => NotificationGetData.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "msg": msg,
      };
}

class NotificationGetData {
  final String id;
  final String title;
  final String message;
  final String route;
  final String imageUrl;
  final String createdAt;
  final bool isRead;

  NotificationGetData({
    required this.id,
    required this.title,
    required this.message,
    required this.route,
    required this.imageUrl,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationGetData.fromRawJson(String str) =>
      NotificationGetData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationGetData.fromJson(Map<String, dynamic> json) =>
      NotificationGetData(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        route: json["route"],
        imageUrl: json["imageUrl"],
        createdAt: json["createdAt"],
        isRead: json["isRead"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "route": route,
        "imageUrl": imageUrl,
        "createdAt": createdAt,
        "isRead": isRead,
      };
}
