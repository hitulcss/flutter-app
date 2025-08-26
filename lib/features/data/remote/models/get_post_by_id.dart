import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';

class GetPostsByIdModel {
  bool? status;
  GetPostsByIdModelData? data;
  String? msg;

  GetPostsByIdModel({this.status, this.data, this.msg});

  GetPostsByIdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? GetPostsByIdModelData.fromJson(json['data']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = msg;
    return data;
  }
}

class GetPostsByIdModelData {
  ShareUrl? shareUrl;
  String? id;
  String? title;
  Author? author;
  String? featuredImage;
  String? description;
  String? createdAt;
  String? likeCounts;
  String? shareLink;
  String? viewsCount;
  Comments? comments;
  bool? isLiked;
  bool? isCommentAllowed;

  GetPostsByIdModelData({
    this.shareUrl,
    this.id,
    this.title,
    this.author,
    this.featuredImage,
    this.description,
    this.createdAt,
    this.likeCounts,
    this.shareLink,
    this.viewsCount,
    this.comments,
    this.isLiked,
    this.isCommentAllowed,
  });

  GetPostsByIdModelData.fromJson(Map<String, dynamic> json) {
    shareUrl = json['shareUrl'] != null ? ShareUrl.fromJson(json['shareUrl']) : null;
    id = json['id'];
    title = json['title'];
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    featuredImage = json['featuredImage'];
    description = json['description'];
    createdAt = json['createdAt'];
    likeCounts = json['likeCounts'];
    shareLink = json['shareLink'];
    viewsCount = json['viewsCount'];
    comments = json['comments'] != null ? Comments.fromJson(json['comments']) : null;
    isLiked = json["isLiked"];
    isCommentAllowed = json["isCommentAllowed"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["shareUrl"] = shareUrl;
    data['id'] = id;
    data['title'] = title;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    data['featuredImage'] = featuredImage;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['likeCounts'] = likeCounts;
    data['shareLink'] = shareLink;
    data['viewsCount'] = viewsCount;
    if (comments != null) {
      data['comments'] = comments!.toJson();
    }
    data["isLiked"] = isLiked;
    data["isCommentAllowed"] = isCommentAllowed;
    return data;
  }
}

class Author {
  String? name;
  String? profileIcon;

  Author({this.name, this.profileIcon});

  Author.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profileIcon = json['profileIcon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['profileIcon'] = profileIcon;
    return data;
  }
}

class Comments {
  String? count;
  List<CommentList>? commentList;

  Comments({this.count, this.commentList});

  Comments.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['commentList'] != null) {
      commentList = <CommentList>[];
      json['commentList'].forEach((v) {
        commentList!.add(CommentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (commentList != null) {
      data['commentList'] = commentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentList {
  Author? user;
  String? id;
  bool? myComment;
  String? cmntsMsg;
  String? likesCount;
  String? createdAt;
  bool? isPin;
  List<Replies>? replies;

  CommentList({
    this.id,
    this.myComment,
    this.user,
    this.cmntsMsg,
    this.likesCount,
    this.createdAt,
    this.replies,
    this.isPin,
  });

  CommentList.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    myComment = json["myComment"];
    user = json['user'] != null ? Author.fromJson(json['user']) : null;
    cmntsMsg = json['cmntsMsg'];
    isPin = json["isPin"];
    likesCount = json['likesCount'];
    createdAt = json['createdAt'];
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["myComment"] = myComment;
    data['isPin'] = isPin;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['cmntsMsg'] = cmntsMsg;
    data['likesCount'] = likesCount;
    data['createdAt'] = createdAt;
    if (replies != null) {
      data['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Replies {
  String? id;
  Author? user;
  String? cmntsMsg;
  String? likesCount;
  String? createdAt;
  ReplyTo? replyTo;

  Replies({
    this.id,
    this.user,
    this.cmntsMsg,
    this.likesCount,
    this.createdAt,
    this.replyTo,
  });

  Replies.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    user = json['user'] != null ? Author.fromJson(json['user']) : null;
    cmntsMsg = json['cmntsMsg'];
    likesCount = json['likesCount'];
    createdAt = json['createdAt'];
    replyTo = json['replyTo'] != null ? ReplyTo.fromJson(json['replyTo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['cmntsMsg'] = cmntsMsg;
    data['likesCount'] = likesCount;
    data['createdAt'] = createdAt;
    if (replyTo != null) {
      data['replyTo'] = replyTo!.toJson();
    }
    return data;
  }
}

class ReplyTo {
  String? name;

  ReplyTo({this.name});

  ReplyTo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
