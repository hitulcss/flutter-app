import 'dart:convert';

class GetPlannerModel {
    bool? status;
    GetPlannerModelData? data;
    String? message;

    GetPlannerModel({
        this.status,
        this.data,
        this.message,
    });

    GetPlannerModel copyWith({
        bool? status,
        GetPlannerModelData? data,
        String? message,
    }) => 
        GetPlannerModel(
            status: status ?? this.status,
            data: data ?? this.data,
            message: message ?? this.message,
        );

    factory GetPlannerModel.fromJson(String str) => GetPlannerModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetPlannerModel.fromMap(Map<String, dynamic> json) => GetPlannerModel(
        status: json["status"],
        data: json["data"] == null ? null : GetPlannerModelData.fromMap(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
        "message": message,
    };
}

class GetPlannerModelData {
    Planner? planner;

    GetPlannerModelData({
        this.planner,
    });

    GetPlannerModelData copyWith({
        Planner? planner,
    }) => 
        GetPlannerModelData(
            planner: planner ?? this.planner,
        );

    factory GetPlannerModelData.fromJson(String str) => GetPlannerModelData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetPlannerModelData.fromMap(Map<String, dynamic> json) => GetPlannerModelData(
        planner: json["planner"] == null ? null : Planner.fromMap(json["planner"]),
    );

    Map<String, dynamic> toMap() => {
        "planner": planner?.toMap(),
    };
}

class Planner {
    String? fileLoc;
    String? fileName;
    String? fileSize;

    Planner({
        this.fileLoc,
        this.fileName,
        this.fileSize,
    });

    Planner copyWith({
        String? fileLoc,
        String? fileName,
        String? fileSize,
    }) => 
        Planner(
            fileLoc: fileLoc ?? this.fileLoc,
            fileName: fileName ?? this.fileName,
            fileSize: fileSize ?? this.fileSize,
        );

    factory Planner.fromJson(String str) => Planner.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Planner.fromMap(Map<String, dynamic> json) => Planner(
        fileLoc: json["fileLoc"],
        fileName: json["fileName"],
        fileSize: json["fileSize"],
    );

    Map<String, dynamic> toMap() => {
        "fileLoc": fileLoc,
        "fileName": fileName,
        "fileSize": fileSize,
    };
}
