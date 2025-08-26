import 'dart:convert';

class GetPyqsNotes {
    bool? status;
    List<GetPyqsNotesData>? data;
    String? msg;

    GetPyqsNotes({
        this.status,
        this.data,
        this.msg,
    });

    GetPyqsNotes copyWith({
        bool? status,
        List<GetPyqsNotesData>? data,
        String? msg,
    }) => 
        GetPyqsNotes(
            status: status ?? this.status,
            data: data ?? this.data,
            msg: msg ?? this.msg,
        );

    factory GetPyqsNotes.fromJson(String str) => GetPyqsNotes.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetPyqsNotes.fromMap(Map<String, dynamic> json) => GetPyqsNotes(
        status: json["status"],
        data: json["data"] == null ? [] : List<GetPyqsNotesData>.from(json["data"]!.map((x) => GetPyqsNotesData.fromMap(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "msg": msg,
    };
}

class GetPyqsNotesData {
    String? title;
    FileUrl? fileUrl;

    GetPyqsNotesData({
        this.title,
        this.fileUrl,
    });

    GetPyqsNotesData copyWith({
        String? title,
        FileUrl? fileUrl,
    }) => 
        GetPyqsNotesData(
            title: title ?? this.title,
            fileUrl: fileUrl ?? this.fileUrl,
        );

    factory GetPyqsNotesData.fromJson(String str) => GetPyqsNotesData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetPyqsNotesData.fromMap(Map<String, dynamic> json) => GetPyqsNotesData(
        title: json["title"],
        fileUrl: json["file_url"] == null ? null : FileUrl.fromMap(json["file_url"]),
    );

    Map<String, dynamic> toMap() => {
        "title": title,
        "file_url": fileUrl?.toMap(),
    };
}

class FileUrl {
    String? fileLoc;
    String? fileName;
    String? fileSize;

    FileUrl({
        this.fileLoc,
        this.fileName,
        this.fileSize,
    });

    FileUrl copyWith({
        String? fileLoc,
        String? fileName,
        String? fileSize,
    }) => 
        FileUrl(
            fileLoc: fileLoc ?? this.fileLoc,
            fileName: fileName ?? this.fileName,
            fileSize: fileSize ?? this.fileSize,
        );

    factory FileUrl.fromJson(String str) => FileUrl.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory FileUrl.fromMap(Map<String, dynamic> json) => FileUrl(
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
