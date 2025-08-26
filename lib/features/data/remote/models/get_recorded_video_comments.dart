class GetRecordedVideoComments {
  bool? status;
  List<GetRecordedVideoCommentsData>? data;
  String? msg;

  GetRecordedVideoComments({this.status, this.data, this.msg});

  GetRecordedVideoComments.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetRecordedVideoCommentsData>[];
      json['data'].forEach((v) {
        data!.add(GetRecordedVideoCommentsData.fromJson(v));
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

class GetRecordedVideoCommentsData {
  User? user;
  bool? isPin;
  String? createdAt;
  List<Replies>? replies;
  String? id;
  String? comment;

  GetRecordedVideoCommentsData(
      {this.user,
      this.isPin,
      this.createdAt,
      this.replies,
      this.id,
      this.comment});

  GetRecordedVideoCommentsData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    isPin = json['isPin'];
    createdAt = json['createdAt'];
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(Replies.fromJson(v));
      });
    }
    id = json['id'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['isPin'] = isPin;
    data['createdAt'] = createdAt;
    if (replies != null) {
      data['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    data['comment'] = comment;
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? profilePhoto;

  User({this.id, this.name, this.profilePhoto});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profilePhoto = json['profilePhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profilePhoto'] = profilePhoto;
    return data;
  }
}

class Replies {
  User? user;
  String? createdAt;
  String? id;
  String? comment;

  Replies({this.user, this.createdAt, this.id, this.comment});

  Replies.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    createdAt = json['createdAt'];
    id = json['id'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['comment'] = comment;
    return data;
  }
}
