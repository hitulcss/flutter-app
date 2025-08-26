
class BaseModel {
  BaseModel({
    required this.status,
    required this.data,
    required this.msg,
  });

  final bool status;
  final dynamic data;
  final String msg;

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(
    status: json["status"],
    data: json["data"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data,
    "msg": msg,
  };
}
