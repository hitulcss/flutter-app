class GetTopic {
  bool? status;
  GetTopicData? data;
  String? msg;

  GetTopic({this.status, this.data, this.msg});

  GetTopic.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? GetTopicData.fromJson(json['data']) : null;
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

class GetTopicData {
  FileDetails? fileDetails;
  String? title;

  GetTopicData({this.fileDetails, this.title});

  GetTopicData.fromJson(Map<String, dynamic> json) {
    fileDetails = json['fileDetails'] != null
        ? FileDetails.fromJson(json['fileDetails'])
        : null;
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fileDetails != null) {
      data['fileDetails'] = fileDetails!.toJson();
    }
    data['title'] = title;
    return data;
  }
}

class FileDetails {
  String? fileUrl;
  String? name;
  String? size;

  FileDetails({this.fileUrl, this.name, this.size});

  FileDetails.fromJson(Map<String, dynamic> json) {
    fileUrl = json['fileUrl'];
    name = json['name'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileUrl'] = fileUrl;
    data['name'] = name;
    data['size'] = size;
    return data;
  }
}
