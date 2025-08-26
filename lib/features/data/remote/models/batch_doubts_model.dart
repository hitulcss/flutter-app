import 'dart:convert';

class GetBatchDoubts {
  bool? status;
  GetBatchDoubtsData? data;
  String? msg;

  GetBatchDoubts({
    this.status,
    this.data,
    this.msg,
  });
  GetBatchDoubts copyWith({
    bool? status,
    GetBatchDoubtsData? data,
    String? msg,
  }) =>
      GetBatchDoubts(
        status: status ?? this.status,
        data: data ?? this.data,
        msg: msg ?? this.msg,
      );

  factory GetBatchDoubts.fromJson(String str) => GetBatchDoubts.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetBatchDoubts.fromMap(Map<String, dynamic> json) => GetBatchDoubts(
        status: json["status"],
        data: json["data"] == null ? null : GetBatchDoubtsData.fromMap(json["data"]),
        msg: json["msg"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
        "msg": msg,
      };
}

class GetBatchDoubtsData {
  int? totalCounts;
  List<Doubt>? doubts;

  GetBatchDoubtsData({
    this.totalCounts,
    this.doubts,
  });
  GetBatchDoubtsData copyWith({
    int? totalCounts,
    List<Doubt>? doubts,
  }) =>
      GetBatchDoubtsData(
        totalCounts: totalCounts ?? this.totalCounts,
        doubts: doubts ?? this.doubts,
      );
  factory GetBatchDoubtsData.fromJson(String str) => GetBatchDoubtsData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetBatchDoubtsData.fromMap(Map<String, dynamic> json) => GetBatchDoubtsData(
        totalCounts: json["totalCounts"],
        doubts: json["doubts"] == null ? [] : List<Doubt>.from(json["doubts"]!.map((x) => Doubt.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "totalCounts": totalCounts,
        "doubts": doubts == null ? [] : List<dynamic>.from(doubts!.map((x) => x.toMap())),
      };
}

class Doubt {
  List<DoubtComment>? comments;
  User? user;
  String? desc;
  String? problemImage;
  String? createdAt;
  String? id;
  String? subject;
  String? lectureName;
  String? teacher;
  bool? isLiked;
  int? likes;
  int? totalComments;
  bool? isResolved;
  bool? isMyDoubt;

  Doubt({
    this.comments,
    this.user,
    this.desc,
    this.problemImage,
    this.createdAt,
    this.id,
    this.subject,
    this.lectureName,
    this.teacher,
    this.isLiked,
    this.likes,
    this.totalComments,
    this.isResolved,
    this.isMyDoubt,
  });
  Doubt copyWith({
    List<DoubtComment>? comments,
    User? user,
    String? desc,
    String? problemImage,
    String? createdAt,
    String? id,
    String? subject,
    String? lectureName,
    String? teacher,
    bool? isLiked,
    int? likes,
    int? totalComments,
    bool? isResolved,
    bool? isMyDoubt,
  }) =>
      Doubt(
        user: user ?? this.user,
        desc: desc ?? this.desc,
        problemImage: problemImage ?? this.problemImage,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        subject: subject ?? this.subject,
        lectureName: lectureName ?? this.lectureName,
        teacher: teacher ?? this.teacher,
        isLiked: isLiked ?? this.isLiked,
        likes: likes ?? this.likes,
        totalComments: totalComments ?? this.totalComments,
        isResolved: isResolved ?? this.isResolved,
        isMyDoubt: isMyDoubt ?? this.isMyDoubt,
      );

  factory Doubt.fromJson(String str) => Doubt.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Doubt.fromMap(Map<String, dynamic> json) => Doubt(
        comments: json["comments"] == null ? [] : List<DoubtComment>.from(json["comments"]!.map((x) => DoubtComment.fromMap(x))),
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        desc: json["desc"],
        problemImage: json["problemImage"],
        createdAt: json["createdAt"],
        id: json["id"],
        subject: json["subject"],
        lectureName: json["lectureName"],
        teacher: json["teacher"],
        isLiked: json["isLiked"],
        likes: json["likes"],
        totalComments: json["totalComments"],
        isResolved: json["isResolved"],
        isMyDoubt: json["isMyDoubt"],
      );

  Map<String, dynamic> toMap() => {
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toMap())),
        "user": user?.toMap(),
        "desc": desc,
        "problemImage": problemImage,
        "createdAt": createdAt,
        "id": id,
        "subject": subject,
        "lectureName": lectureName,
        "teacher": teacher,
        "isLiked": isLiked,
        "likes": likes,
        "totalComments": totalComments,
        "isResolved": isResolved,
        "isMyDoubt": isMyDoubt,
      };
}

class DoubtComment {
  User? user;
  String? image;
  String? commentId;
  String? msg;
  String? createdAt;
  bool? isMyComment;

  DoubtComment({
    this.user,
    this.image,
    this.commentId,
    this.msg,
    this.createdAt,
    this.isMyComment,
  });
  DoubtComment copyWith({
    User? user,
    String? image,
    String? commentId,
    String? msg,
    String? createdAt,
    bool? isMyComment,
  }) =>
      DoubtComment(
        user: user ?? this.user,
        image: image ?? this.image,
        commentId: commentId ?? this.commentId,
        msg: msg ?? this.msg,
        createdAt: createdAt ?? this.createdAt,
        isMyComment: isMyComment ?? this.isMyComment,
      );
  factory DoubtComment.fromJson(String str) => DoubtComment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DoubtComment.fromMap(Map<String, dynamic> json) => DoubtComment(
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        image: json["image"],
        commentId: json["commentId"],
        msg: json["msg"],
        createdAt: json["createdAt"],
        isMyComment: json["isMyComment"],
      );

  Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "image": image,
        "commentId": commentId,
        "msg": msg,
        "createdAt": createdAt,
        "isMyComment": isMyComment,
      };
}

class User {
  String? name;
  String? profilePhoto;
  bool? isVerified;

  User({
    this.name,
    this.profilePhoto,
    this.isVerified,
  });
  User copyWith({
    String? name,
    String? profilePhoto,
    bool? isVerified,
  }) =>
      User(
        name: name ?? this.name,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        isVerified: isVerified ?? this.isVerified,
      );

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        name: json["name"],
        profilePhoto: json["profilePhoto"],
        isVerified: json["isVerified"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "profilePhoto": profilePhoto,
        "isVerified": isVerified,
      };
}
