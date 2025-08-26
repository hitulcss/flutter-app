class ReferalContentModel {
  bool? status;
  ReferalContentModelData? data;
  String? msg;

  ReferalContentModel({this.status, this.data, this.msg});

  ReferalContentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? ReferalContentModelData.fromJson(json['data']) : null;
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

class ReferalContentModelData {
  String? referialAmount;
  String? url;

  ReferalContentModelData({this.referialAmount, this.url});

  ReferalContentModelData.fromJson(Map<String, dynamic> json) {
    referialAmount = json['referial_amount'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['referial_amount'] = referialAmount;
    data['url'] = url;
    return data;
  }
}
