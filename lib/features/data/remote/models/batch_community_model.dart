import 'dart:convert';

import 'package:sd_campus_app/features/data/remote/models/get_community_comments.dart';

class GetCommunity {
  bool? status;
  GetCommunityData? data;
  String? msg;

  GetCommunity({
    this.status,
    this.data,
    this.msg,
  });

  GetCommunity copyWith({
    bool? status,
    GetCommunityData? data,
    String? msg,
  }) =>
      GetCommunity(
        status: status ?? this.status,
        data: data ?? this.data,
        msg: msg ?? this.msg,
      );

  factory GetCommunity.fromJson(String str) => GetCommunity.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetCommunity.fromMap(Map<String, dynamic> json) => GetCommunity(
        status: json["status"],
        data: json["data"] == null ? null : GetCommunityData.fromMap(json["data"]),
        msg: json["msg"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
        "msg": msg,
      };
}

class GetCommunityData {
  int? totalCounts;
  List<Community>? communities;

  GetCommunityData({
    this.totalCounts,
    this.communities,
  });

  GetCommunityData copyWith({
    int? totalCounts,
    List<Community>? communities,
  }) =>
      GetCommunityData(
        totalCounts: totalCounts ?? this.totalCounts,
        communities: communities ?? this.communities,
      );

  factory GetCommunityData.fromJson(String str) => GetCommunityData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetCommunityData.fromMap(Map<String, dynamic> json) => GetCommunityData(
        totalCounts: json["totalCounts"],
        communities: json["communities"] == null ? [] : List<Community>.from(json["communities"]!.map((x) => Community.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "totalCounts": totalCounts,
        "communities": communities == null ? [] : List<dynamic>.from(communities!.map((x) => x.toMap())),
      };
}

class Community {
  User? user;
  String? desc;
  String? problemImage;
  String? createdAt;
  String? id;
  bool? isLiked;
  bool? isMyCommunity;
  int? likes;
  int? views;
  int? commentCounts;
  List<Comment?>? comments;

  Community({
    this.user,
    this.desc,
    this.problemImage,
    this.createdAt,
    this.id,
    this.isLiked,
    this.isMyCommunity,
    this.likes,
    this.views,
    this.commentCounts,
    this.comments,
  });

  Community copyWith({
    User? user,
    String? desc,
    String? problemImage,
    String? createdAt,
    String? id,
    bool? isLiked,
    bool? isMyCommunity,
    int? likes,
    int? views,
    int? commentCounts,
    List<Comment?>? comments,
  }) =>
      Community(
        user: user ?? this.user,
        desc: desc ?? this.desc,
        problemImage: problemImage ?? this.problemImage,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        isLiked: isLiked ?? this.isLiked,
        isMyCommunity: isMyCommunity ?? this.isMyCommunity,
        likes: likes ?? this.likes,
        views: views ?? this.views,
        commentCounts: commentCounts ?? this.commentCounts,
        comments: comments ?? this.comments,
      );

  factory Community.fromJson(String str) => Community.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Community.fromMap(Map<String, dynamic> json) => Community(
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        desc: json["desc"],
        problemImage: json["problemImage"],
        createdAt: json["createdAt"],
        id: json["id"],
        isLiked: json["isLiked"],
        isMyCommunity: json["isMyCommunity"],
        likes: json["likes"],
        views: json["views"],
        commentCounts: json["commentCounts"],
        comments: json["comments"] == null ? null : List<Comment>.from(json["comments"].map((x) => Comment.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "desc": desc,
        "problemImage": problemImage,
        "createdAt": createdAt,
        "id": id,
        "isLiked": isLiked,
        "isMyCommunity": isMyCommunity,
        "likes": likes,
        "views": views,
        "commentCounts": commentCounts,
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x?.toMap())),
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
        isVerified: isVerified?? this.isVerified,
      );

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        name: json["name"],
        profilePhoto: json["profileIcon"] ?? json["profilePhoto"],
        isVerified: json["isVerified"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "profileIcon": profilePhoto,
        "isVerified": isVerified,
      };
}
