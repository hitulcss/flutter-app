import 'dart:convert';

class GetShortComments {
    bool? status;
    GetShortCommentsData? data;
    String? msg;

    GetShortComments({
        this.status,
        this.data,
        this.msg,
    });

    GetShortComments copyWith({
        bool? status,
        GetShortCommentsData? data,
        String? msg,
    }) => 
        GetShortComments(
            status: status ?? this.status,
            data: data ?? this.data,
            msg: msg ?? this.msg,
        );

    factory GetShortComments.fromJson(String str) => GetShortComments.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetShortComments.fromMap(Map<String, dynamic> json) => GetShortComments(
        status: json["status"],
        data: json["data"] == null ? null : GetShortCommentsData.fromMap(json["data"]),
        msg: json["msg"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
        "msg": msg,
    };
}

class GetShortCommentsData {
    int? totalCounts;
    List<ShortComment>? comments;

    GetShortCommentsData({
        this.totalCounts,
        this.comments,
    });

    GetShortCommentsData copyWith({
        int? totalCounts,
        List<ShortComment>? comments,
    }) => 
        GetShortCommentsData(
            totalCounts: totalCounts ?? this.totalCounts,
            comments: comments ?? this.comments,
        );

    factory GetShortCommentsData.fromJson(String str) => GetShortCommentsData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetShortCommentsData.fromMap(Map<String, dynamic> json) => GetShortCommentsData(
        totalCounts: json["totalCounts"],
        comments: json["comments"] == null ? [] : List<ShortComment>.from(json["comments"]!.map((x) => ShortComment.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "totalCounts": totalCounts,
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toMap())),
    };
}

class ShortComment {
    User? user;
    String? createdAt;
    List<ShortCommentReply>? replies;
    String? id;
    String? msg;
    bool? isMyComment;

    ShortComment({
        this.user,
        this.createdAt,
        this.replies,
        this.id,
        this.msg,
        this.isMyComment,
    });

    ShortComment copyWith({
        User? user,
        String? createdAt,
        List<ShortCommentReply>? replies,
        String? id,
        String? msg,
        bool? isMyComment,
    }) => 
        ShortComment(
            user: user ?? this.user,
            createdAt: createdAt ?? this.createdAt,
            replies: replies ?? this.replies,
            id: id ?? this.id,
            msg: msg ?? this.msg,
            isMyComment: isMyComment ?? this.isMyComment,
        );

    factory ShortComment.fromJson(String str) => ShortComment.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ShortComment.fromMap(Map<String, dynamic> json) => ShortComment(
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        createdAt: json["createdAt"],
        replies: json["replies"] == null ? [] : List<ShortCommentReply>.from(json["replies"]!.map((x) => ShortCommentReply.fromMap(x))),
        id: json["id"],
        msg: json["msg"],
        isMyComment: json["isMyComment"],
    );

    Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "createdAt": createdAt,
        "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x.toMap())),
        "id": id,
        "msg": msg,
        "isMyComment": isMyComment,
    };
}

class ShortCommentReply {
    User? user;
    User? replyTo;
    String? createdAt;
    String? id;
    String? msg;
    bool? isMyReply;

    ShortCommentReply({
        this.user,
        this.replyTo,
        this.createdAt,
        this.id,
        this.msg,
        this.isMyReply,
    });

    ShortCommentReply copyWith({
        User? user,
        User? replyTo,
        String? createdAt,
        String? id,
        String? msg,
        bool? isMyReply,
    }) => 
        ShortCommentReply(
            user: user ?? this.user,
            replyTo: replyTo ?? this.replyTo,
            createdAt: createdAt ?? this.createdAt,
            id: id ?? this.id,
            msg: msg ?? this.msg,
            isMyReply: isMyReply ?? this.isMyReply,
        );

    factory ShortCommentReply.fromJson(String str) => ShortCommentReply.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ShortCommentReply.fromMap(Map<String, dynamic> json) => ShortCommentReply(
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        replyTo: json["replyTo"] == null ? null : User.fromMap(json["replyTo"]),
        createdAt: json["createdAt"],
        id: json["id"],
        msg: json["msg"],
        isMyReply: json["isMyReply"],
    );

    Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "replyTo": replyTo?.toMap(),
        "createdAt": createdAt,
        "id": id,
        "msg": msg,
        "isMyReply": isMyReply,
    };
}

class User {
    String? id;
    String? name;
    String? profilePhoto;
    bool? isVerified;

    User({
        this.id,
        this.name,
        this.profilePhoto,
        this.isVerified,
    });

    User copyWith({
        String? id,
        String? name,
        String? profilePhoto,
        bool? isVerified,
    }) => 
        User(
            id: id ?? this.id,
            name: name ?? this.name,
            profilePhoto: profilePhoto ?? this.profilePhoto,
            isVerified: isVerified ?? this.isVerified,
        );

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        profilePhoto: json["profilePhoto"],
        isVerified: json["isVerified"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "profilePhoto": profilePhoto,
        "isVerified": isVerified,
    };
}
