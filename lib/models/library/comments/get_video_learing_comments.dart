import 'dart:convert';

class GetListVideoLearingCommentLibrary {
    bool? status;
    List<GetListVideoLearingCommentLibraryData>? data;
    String? msg;

    GetListVideoLearingCommentLibrary({
        this.status,
        this.data,
        this.msg,
    });

    GetListVideoLearingCommentLibrary copyWith({
        bool? status,
        List<GetListVideoLearingCommentLibraryData>? data,
        String? msg,
    }) => 
        GetListVideoLearingCommentLibrary(
            status: status ?? this.status,
            data: data ?? this.data,
            msg: msg ?? this.msg,
        );

    factory GetListVideoLearingCommentLibrary.fromJson(String str) => GetListVideoLearingCommentLibrary.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetListVideoLearingCommentLibrary.fromMap(Map<String, dynamic> json) => GetListVideoLearingCommentLibrary(
        status: json["status"],
        data: json["data"] == null ? [] : List<GetListVideoLearingCommentLibraryData>.from(json["data"]!.map((x) => GetListVideoLearingCommentLibraryData.fromMap(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "msg": msg,
    };
}

class GetListVideoLearingCommentLibraryData {
    String? id;
    String? msg;
    bool? isMyComment;
    User? user;
    String? createdAt;
    List<Reply>? replies;

    GetListVideoLearingCommentLibraryData({
        this.id,
        this.msg,
        this.isMyComment,
        this.user,
        this.createdAt,
        this.replies,
    });

    GetListVideoLearingCommentLibraryData copyWith({
        String? id,
        String? msg,
        bool? isMyComment,
        User? user,
        String? createdAt,
        List<Reply>? replies,
    }) => 
        GetListVideoLearingCommentLibraryData(
            id: id ?? this.id,
            msg: msg ?? this.msg,
            isMyComment: isMyComment ?? this.isMyComment,
            user: user ?? this.user,
            createdAt: createdAt ?? this.createdAt,
            replies: replies ?? this.replies,
        );

    factory GetListVideoLearingCommentLibraryData.fromJson(String str) => GetListVideoLearingCommentLibraryData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetListVideoLearingCommentLibraryData.fromMap(Map<String, dynamic> json) => GetListVideoLearingCommentLibraryData(
        id: json["id"],
        msg: json["msg"],
        isMyComment: json["isMyComment"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        createdAt: json["createdAt"],
        replies: json["replies"] == null ? [] : List<Reply>.from(json["replies"]!.map((x) => Reply.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "msg": msg,
        "isMyComment": isMyComment,
        "user": user?.toMap(),
        "createdAt": createdAt,
        "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x.toMap())),
    };
}

class Reply {
    String? id;
    String? msg;
    bool? isMyReplyComment;
    User? user;
    String? createdAt;

    Reply({
        this.id,
        this.msg,
        this.isMyReplyComment,
        this.user,
        this.createdAt,
    });

    Reply copyWith({
        String? id,
        String? msg,
        bool? isMyReplyComment,
        User? user,
        String? createdAt,
    }) => 
        Reply(
            id: id ?? this.id,
            msg: msg ?? this.msg,
            isMyReplyComment: isMyReplyComment ?? this.isMyReplyComment,
            user: user ?? this.user,
            createdAt: createdAt ?? this.createdAt,
        );

    factory Reply.fromJson(String str) => Reply.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Reply.fromMap(Map<String, dynamic> json) => Reply(
        id: json["id"],
        msg: json["msg"],
        isMyReplyComment: json["isMyReplyComment"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "msg": msg,
        "isMyReplyComment": isMyReplyComment,
        "user": user?.toMap(),
        "createdAt": createdAt,
    };
}

class User {
    String? id;
    String? name;
    String? profilePhoto;

    User({
        this.id,
        this.name,
        this.profilePhoto,
    });

    User copyWith({
        String? id,
        String? name,
        String? profilePhoto,
    }) => 
        User(
            id: id ?? this.id,
            name: name ?? this.name,
            profilePhoto: profilePhoto ?? this.profilePhoto,
        );

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        profilePhoto: json["profilePhoto"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "profilePhoto": profilePhoto,
    };
}
