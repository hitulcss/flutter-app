class GetNewArrival {
  bool? status;
  List<GetNewArrivalData>? data;
  String? msg;

  GetNewArrival({this.status, this.data, this.msg});

  GetNewArrival.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetNewArrivalData>[];
      json['data'].forEach((v) {
        data!.add(GetNewArrivalData.fromJson(v));
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

class GetNewArrivalData {
  String? id;
  String? title;
  String? featuredImage;

  GetNewArrivalData({this.id, this.title, this.featuredImage});

  GetNewArrivalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    featuredImage = json['featuredImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['featuredImage'] = featuredImage;
    return data;
  }
}
