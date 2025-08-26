class VideoModel {
  VideoModel({
    required this.status,
    required this.data,
    required this.msg,
  });

  final bool status;
  final List<VideoDataModel> data;
  final String msg;

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        status: json["status"],
        data: List<VideoDataModel>.from(
            json["data"].map((x) => VideoDataModel.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "msg": msg,
      };
}

class VideoDataModel {
  VideoDataModel({
    required this.id,
    required this.user,
    required this.title,
    required this.videoUrl,
    required this.isActive,
    required this.createdAt,
    required this.language,
  });

  final String id;
  final String user;
  final String title;
  final String videoUrl;
  final bool isActive;
  final String createdAt;
  final String language;

  factory VideoDataModel.fromJson(Map<String, dynamic> json) => VideoDataModel(
        id: json["_id"],
        user: json["user"],
        title: json["title"],
        videoUrl: json["video_url"],
        createdAt: json["created_at"],
        language: json["language"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "title": title,
        "video_url": videoUrl,
        "created_at": createdAt,
        "language": language,
        "is_active": isActive,
      };
}
