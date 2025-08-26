class AllPostsModel {
  bool? status;
  List<AllPostsModelData>? data;
  String? msg;

  AllPostsModel({this.status, this.data, this.msg});

  AllPostsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <AllPostsModelData>[];
      json['data'].forEach((v) {
        data!.add(AllPostsModelData.fromJson(v));
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

class AllPostsModelData {
  String? id;
  String? title;
  Author? author;
  String? featuredImage;
  String? createdAt;
  String? likeCounts;
  String? shareLink;
  String? viewsCount;
  String? tags;
  bool? isCommentAllowed;
  Comments? comments;
  bool? isLiked;

  AllPostsModelData({
    this.id,
    this.title,
    this.tags,
    this.author,
    this.featuredImage,
    this.createdAt,
    this.likeCounts,
    this.shareLink,
    this.viewsCount,
    this.comments,
    this.isLiked,
    this.isCommentAllowed
  });

  AllPostsModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    tags = json['tags'];
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    featuredImage = json['featuredImage'];
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
    data['id'] = id;
    data['title'] = title;
    data['tags'] = tags;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    data['featuredImage'] = featuredImage;
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
  String? cmntsMsg;
  String? createdAt;

  CommentList({this.user, this.cmntsMsg, this.createdAt});

  CommentList.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? Author.fromJson(json['user']) : null;
    cmntsMsg = json['cmntsMsg'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['cmntsMsg'] = cmntsMsg;
    data['createdAt'] = createdAt;
    return data;
  }
}
