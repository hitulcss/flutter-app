import 'dart:convert';

class GetListOfNotesModel {
    bool? status;
    List<GetListOfNotesModelData>? data;
    String? msg;

    GetListOfNotesModel({
        this.status,
        this.data,
        this.msg,
    });

    factory GetListOfNotesModel.fromJson(String str) => GetListOfNotesModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetListOfNotesModel.fromMap(Map<String, dynamic> json) => GetListOfNotesModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<GetListOfNotesModelData>.from(json["data"]!.map((x) => GetListOfNotesModelData.fromMap(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "msg": msg,
    };
}

class GetListOfNotesModelData {
    String? title;
    List<Re>? res;

    GetListOfNotesModelData({
        this.title,
        this.res,
    });

    factory GetListOfNotesModelData.fromJson(String str) => GetListOfNotesModelData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetListOfNotesModelData.fromMap(Map<String, dynamic> json) => GetListOfNotesModelData(
        title: json["title"],
        res: json["res"] == null ? [] : List<Re>.from(json["res"]!.map((x) => Re.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "title": title,
        "res": res == null ? [] : List<dynamic>.from(res!.map((x) => x.toMap())),
    };
}

class Re {
    String? resourceTitle;
    String? resourceType;
    FileClass? file;

    Re({
        this.resourceTitle,
        this.resourceType,
        this.file,
    });

    factory Re.fromJson(String str) => Re.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Re.fromMap(Map<String, dynamic> json) => Re(
        resourceTitle: json["resource_title"],
        resourceType: json["resourceType"],
        file: json["file"] == null ? null : FileClass.fromMap(json["file"]),
    );

    Map<String, dynamic> toMap() => {
        "resource_title": resourceTitle,
        "resourceType": resourceType,
        "file": file?.toMap(),
    };
}

class FileClass {
    String? fileLoc;
    String? fileName;
    String? fileSize;

    FileClass({
        this.fileLoc,
        this.fileName,
        this.fileSize,
    });

    factory FileClass.fromJson(String str) => FileClass.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory FileClass.fromMap(Map<String, dynamic> json) => FileClass(
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
