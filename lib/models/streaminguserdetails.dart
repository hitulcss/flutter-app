class StreamingUserDetails {
  bool? status;
  List<Data>? data;
  String? msg;

  StreamingUserDetails({this.status, this.data, this.msg});

  StreamingUserDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  String? sId;
  String? channelName;
  String? userJoinUID;
  String? profilePicture;
  String? studentName;
  String? userUniqueId;

  Data({
    this.sId,
    this.channelName,
    this.userJoinUID,
    this.profilePicture,
    this.studentName,
    this.userUniqueId,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    channelName = json['channelName'];
    userJoinUID = json['userJoinUID'];
    profilePicture = json['profilePicture'];
    studentName = json['studentName'];
    userUniqueId = json['userUniqueId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['channelName'] = channelName;
    data['userJoinUID'] = userJoinUID;
    data['profilePicture'] = profilePicture;
    data['studentName'] = studentName;
    data['userUniqueId'] = userUniqueId;
    return data;
  }
}
