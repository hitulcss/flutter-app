class MySchedulerModel {
  MySchedulerModel({
    required this.status,
    required this.data,
    required this.msg,
  });

  final bool status;
  final List<MySchedulerDataModel> data;
  final String msg;

  factory MySchedulerModel.fromJson(Map<String, dynamic> json) => MySchedulerModel(
        status: json["status"],
        data: List<MySchedulerDataModel>.from(json["data"].map((x) => MySchedulerDataModel.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "msg": msg,
      };
}

class MySchedulerDataModel {
  MySchedulerDataModel({
    //this.loggedIn,//
    required this.id,
    required this.user,
    required this.createdAt,
    required this.task,
    required this.notifyAt,
    required this.isActive,
  });

  final String id;
  final String user;
  final String createdAt;
  final String task;
  final String notifyAt;
  final bool isActive;
  //final bool loggedIn;//

  factory MySchedulerDataModel.fromJson(Map<String, dynamic> json) => MySchedulerDataModel(
        id: json["_id"],
        user: json["user"],
        createdAt: json["created_at"],
        task: json["task"],
        notifyAt: json["notify_at"],
        isActive: json["is_active"],
        //loggedIn: json["loggedIn"],//
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "created_at": createdAt,
        "task": task,
        "notify_at": notifyAt,
        "is_active": isActive,
        //"loggedIn":loggedIn,//
      };
}
