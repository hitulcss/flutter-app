class BatchSubject {
  bool? status;
  BatchSubjectData? data;
  String? msg;

  BatchSubject({this.status, this.data, this.msg});

  BatchSubject.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data1'] != null ? BatchSubjectData.fromJson(json['data1']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['data1'] = data;
    data['msg'] = msg;
    return data;
  }
}

class BatchSubjectData {
  List<Subjects>? subjects;
  List<BatchFeatures>? batchFeatures;

  BatchSubjectData({this.subjects, this.batchFeatures});

  BatchSubjectData.fromJson(Map<String, dynamic> json) {
    if (json['subjects'] != null) {
      subjects = <Subjects>[];
      json['subjects'].forEach((v) {
        subjects!.add(Subjects.fromJson(v));
      });
    }
    if (json['batchFeatures'] != null) {
      batchFeatures = <BatchFeatures>[];
      json['batchFeatures'].forEach((v) {
        batchFeatures!.add(BatchFeatures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (subjects != null) {
      data['subjects'] = subjects!.map((v) => v.toJson()).toList();
    }
    if (batchFeatures != null) {
      data['batchFeatures'] = batchFeatures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subjects {
  String? id;
  String? title;
  String? icon;

  Subjects({this.id, this.title, this.icon});

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['icon'] = icon;
    return data;
  }
}

class BatchFeatures {
  String? featureId;
  String? icon;
  String? feature;

  BatchFeatures({this.featureId, this.icon, this.feature});

  BatchFeatures.fromJson(Map<String, dynamic> json) {
    featureId = json['featureId'];
    icon = json['icon'];
    feature = json['feature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['featureId'] = featureId;
    data['icon'] = icon;
    data['feature'] = feature;
    return data;
  }
}
