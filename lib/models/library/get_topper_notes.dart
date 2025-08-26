import 'dart:convert';

class GetLibraryTopperNotes {
    bool? status;
    List<GetLibraryTopperNotesData>? data;
    String? msg;

    GetLibraryTopperNotes({
        this.status,
        this.data,
        this.msg,
    });

    GetLibraryTopperNotes copyWith({
        bool? status,
        List<GetLibraryTopperNotesData>? data,
        String? msg,
    }) => 
        GetLibraryTopperNotes(
            status: status ?? this.status,
            data: data ?? this.data,
            msg: msg ?? this.msg,
        );

    factory GetLibraryTopperNotes.fromJson(String str) => GetLibraryTopperNotes.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetLibraryTopperNotes.fromMap(Map<String, dynamic> json) => GetLibraryTopperNotes(
        status: json["status"],
        data: json["data"] == null ? [] : List<GetLibraryTopperNotesData>.from(json["data"]!.map((x) => GetLibraryTopperNotesData.fromMap(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "msg": msg,
    };
}

class GetLibraryTopperNotesData {
    String? id;
    String? subject;
    List<Note>? notes;

    GetLibraryTopperNotesData({
        this.id,
        this.subject,
        this.notes,
    });

    GetLibraryTopperNotesData copyWith({
        String? id,
        String? subject,
        List<Note>? notes,
    }) => 
        GetLibraryTopperNotesData(
            id: id ?? this.id,
            subject: subject ?? this.subject,
            notes: notes ?? this.notes,
        );

    factory GetLibraryTopperNotesData.fromJson(String str) => GetLibraryTopperNotesData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetLibraryTopperNotesData.fromMap(Map<String, dynamic> json) => GetLibraryTopperNotesData(
        id: json["id"],
        subject: json["subject"],
        notes: json["notes"] == null ? [] : List<Note>.from(json["notes"]!.map((x) => Note.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "subject": subject,
        "notes": notes == null ? [] : List<dynamic>.from(notes!.map((x) => x.toMap())),
    };
}

class Note {
    String? title;
    FileUrl? fileUrl;

    Note({
        this.title,
        this.fileUrl,
    });

    Note copyWith({
        String? title,
        FileUrl? fileUrl,
    }) => 
        Note(
            title: title ?? this.title,
            fileUrl: fileUrl ?? this.fileUrl,
        );

    factory Note.fromJson(String str) => Note.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Note.fromMap(Map<String, dynamic> json) => Note(
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
