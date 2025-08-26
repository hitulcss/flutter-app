class GetDoubt {
  bool? status;
  List<GetDoubtData>? data;
  String? msg;

  GetDoubt({this.status, this.data, this.msg});

  GetDoubt.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetDoubtData>[];
      json['data'].forEach((v) {
        data!.add(GetDoubtData.fromJson(v));
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

class GetDoubtData {
  String? id;
  String? title;
  bool? isResolved;
  String? time;
  Resolver? resolver;
  String? resolveTime;
  String? answer;

  GetDoubtData(
      {this.id,
      this.title,
      this.isResolved,
      this.time,
      this.resolver,
      this.resolveTime,
      this.answer});

  GetDoubtData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isResolved = json['isResolved'];
    time = json['time'];
    resolver = json['resolver'] != null
        ? Resolver.fromJson(json['resolver'])
        : null;
    resolveTime = json['resolveTime'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['isResolved'] = isResolved;
    data['time'] = time;
    if (resolver != null) {
      data['resolver'] = resolver!.toJson();
    }
    data['resolveTime'] = resolveTime;
    data['answer'] = answer;
    return data;
  }
}

class Resolver {
  String? name;
  String? id;

  Resolver({this.name, this.id});

  Resolver.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
