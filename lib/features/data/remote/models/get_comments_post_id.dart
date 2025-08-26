
import 'package:sd_campus_app/features/data/remote/models/get_post_by_id.dart';

class GetCommentByPostIdModel {
  bool? status;
  GetCommentByPostIdModelData? data;
  String? msg;

  GetCommentByPostIdModel({this.status, this.data, this.msg});

  GetCommentByPostIdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? GetCommentByPostIdModelData.fromJson(json['data']) : null;
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

class GetCommentByPostIdModelData {
  String? id;
  Comments? comments;

  GetCommentByPostIdModelData({this.id, this.comments});

  GetCommentByPostIdModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comments = json['comments'] != null ? Comments.fromJson(json['comments']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (comments != null) {
      data['comments'] = comments!.toJson();
    }
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
