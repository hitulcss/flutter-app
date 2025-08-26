import 'dart:convert';

import 'package:sd_campus_app/features/data/remote/models/batch_community_model.dart';

class GetCommunityComments {
  bool? status;
  GetCommunityCommentsData? data;
  String? msg;

  GetCommunityComments({
    this.status,
    this.data,
    this.msg,
  });

  GetCommunityComments copyWith({
    bool? status,
    GetCommunityCommentsData? data,
    String? msg,
  }) =>
      GetCommunityComments(
        status: status ?? this.status,
        data: data ?? this.data,
        msg: msg ?? this.msg,
      );

  factory GetCommunityComments.fromJson(String str) => GetCommunityComments.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetCommunityComments.fromMap(Map<String, dynamic> json) => GetCommunityComments(
        status: json["status"],
        data: json["data"] == null ? null : GetCommunityCommentsData.fromMap(json["data"]),
        msg: json["msg"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
        "msg": msg,
      };
}

class GetCommunityCommentsData {
  String? batchCommunityId;
  List<Comment>? comments;
  int? totalCounts;

  GetCommunityCommentsData({
    this.batchCommunityId,
    this.comments,
    this.totalCounts,
  });

  GetCommunityCommentsData copyWith({
    String? batchCommunityId,
    List<Comment>? comments,
    int? totalCounts,
  }) =>
      GetCommunityCommentsData(
        batchCommunityId: batchCommunityId ?? this.batchCommunityId,
        comments: comments ?? this.comments,
        totalCounts: totalCounts ?? this.totalCounts,
      );

  factory GetCommunityCommentsData.fromJson(String str) => GetCommunityCommentsData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetCommunityCommentsData.fromMap(Map<String, dynamic> json) => GetCommunityCommentsData(
        batchCommunityId: json["batchCommunityId"],
        comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromMap(x))),
        totalCounts: json["totalCounts"],
      );

  Map<String, dynamic> toMap() => {
        "batchCommunityId": batchCommunityId,
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toMap())),
        "totalCounts": totalCounts,
      };
}

class Comment {
  String? commentId;
  bool? isMyComment;
  User? user;
  String? image;
  String? cmntsMsg;
  String? createdAt;
  List<Reply>? replies;

  Comment({
    this.commentId,
    this.isMyComment,
    this.user,
    this.cmntsMsg,
    this.createdAt,
    this.replies,
    this.image,
  });

  Comment copyWith({
    String? commentId,
    bool? isMyComment,
    User? user,
    String? cmntsMsg,
    String? image,
    String? createdAt,
    List<Reply>? replies,
  }) =>
      Comment(
        commentId: commentId ?? this.commentId,
        isMyComment: isMyComment ?? this.isMyComment,
        user: user ?? this.user,
        cmntsMsg: cmntsMsg ?? this.cmntsMsg,
        createdAt: createdAt ?? this.createdAt,
        replies: replies ?? this.replies,
        image: image ?? this.image,
      );

  factory Comment.fromJson(String str) => Comment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        commentId: json["commentId"],
        isMyComment: json["isMyComment"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        cmntsMsg: json["cmntsMsg"],
        createdAt: json["createdAt"],
        replies: json["replies"] == null ? [] : List<Reply>.from(json["replies"]!.map((x) => Reply.fromMap(x))),
        image: json["image"],
      );

  Map<String, dynamic> toMap() => {
        "commentId": commentId,
        "isMyComment": isMyComment,
        "user": user?.toMap(),
        "cmntsMsg": cmntsMsg,
        "createdAt": createdAt,
        "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x.toMap())),
        "image": image,
      };
}

class Reply {
  String? replyId;
  bool? isMyReplyComment;
  User? user;
  String? cmntsMsg;
  String? createdAt;

  Reply({
    this.replyId,
    this.isMyReplyComment,
    this.user,
    this.cmntsMsg,
    this.createdAt,
  });

  Reply copyWith({
    String? replyId,
    bool? isMyReplyComment,
    User? user,
    String? cmntsMsg,
    String? createdAt,
  }) =>
      Reply(
        replyId: replyId ?? this.replyId,
        isMyReplyComment: isMyReplyComment ?? this.isMyReplyComment,
        user: user ?? this.user,
        cmntsMsg: cmntsMsg ?? this.cmntsMsg,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Reply.fromJson(String str) => Reply.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Reply.fromMap(Map<String, dynamic> json) => Reply(
        replyId: json["replyId"],
        isMyReplyComment: json["isMyReplyComment"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        cmntsMsg: json["cmntsMsg"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toMap() => {
        "replyId": replyId,
        "isMyReplyComment": isMyReplyComment,
        "user": user?.toMap(),
        "cmntsMsg": cmntsMsg,
        "createdAt": createdAt,
      };
}
