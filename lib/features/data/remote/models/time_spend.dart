class TimeSpendL {
  bool? status;
  String? data;
  String? msg;

  TimeSpendL({this.status, this.data, this.msg});

  TimeSpendL.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['data'] = data;
    data['msg'] = msg;
    return data;
  }
}
