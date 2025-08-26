class RemovefromCart {
  bool? status;
  dynamic data;
  String? msg;

  RemovefromCart({this.status, this.data, this.msg});

  RemovefromCart.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['data'] = this.data;
    data['msg'] = msg;
    return data;
  }
}
