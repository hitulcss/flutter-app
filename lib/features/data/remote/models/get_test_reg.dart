class GetTestReg {
  bool? status;
  List<GetTestRegData>? data;
  String? msg;

  GetTestReg({this.status, this.data, this.msg});

  GetTestReg.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetTestRegData>[];
      json['data'].forEach((v) {
        data!.add(GetTestRegData.fromJson(v));
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

class GetTestRegData {
  String? id;
  String? title;
  String? banner;
  String? description;
  String? startingAt;
  String? registrationEndAt;
  String? duration;
  String? resultDeclaration;
  String? quizId;

  GetTestRegData(
      {this.id,
      this.title,
      this.banner,
      this.description,
      this.startingAt,
      this.registrationEndAt,
      this.duration,
      this.resultDeclaration,
      this.quizId});

  GetTestRegData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    banner = json['banner'];
    description = json['description'];
    startingAt = json['startingAt'];
    registrationEndAt = json['registrationEndAt'];
    duration = json['duration'];
    resultDeclaration = json['resultDeclaration'];
    quizId = json['quizId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['banner'] = banner;
    data['description'] = description;
    data['startingAt'] = startingAt;
    data['registrationEndAt'] = registrationEndAt;
    data['duration'] = duration;
    data['resultDeclaration'] = resultDeclaration;
    data['quizId'] = quizId;
    return data;
  }
}
