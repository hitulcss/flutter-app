import 'dart:convert';

class GetListVideoLearingLibrary {
    bool? status;
    List<GetListVideoLearingLibraryData>? data;
    String? msg;

    GetListVideoLearingLibrary({
        this.status,
        this.data,
        this.msg,
    });

    GetListVideoLearingLibrary copyWith({
        bool? status,
        List<GetListVideoLearingLibraryData>? data,
        String? msg,
    }) => 
        GetListVideoLearingLibrary(
            status: status ?? this.status,
            data: data ?? this.data,
            msg: msg ?? this.msg,
        );

    factory GetListVideoLearingLibrary.fromJson(String str) => GetListVideoLearingLibrary.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetListVideoLearingLibrary.fromMap(Map<String, dynamic> json) => GetListVideoLearingLibrary(
        status: json["status"],
        data: json["data"] == null ? [] : List<GetListVideoLearingLibraryData>.from(json["data"]!.map((x) => GetListVideoLearingLibraryData.fromMap(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "msg": msg,
    };
}

class GetListVideoLearingLibraryData {
    String? id;
    String? subject;
    List<Video>? videos;

    GetListVideoLearingLibraryData({
        this.id,
        this.subject,
        this.videos,
    });

    GetListVideoLearingLibraryData copyWith({
        String? id,
        String? subject,
        List<Video>? videos,
    }) => 
        GetListVideoLearingLibraryData(
            id: id ?? this.id,
            subject: subject ?? this.subject,
            videos: videos ?? this.videos,
        );

    factory GetListVideoLearingLibraryData.fromJson(String str) => GetListVideoLearingLibraryData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetListVideoLearingLibraryData.fromMap(Map<String, dynamic> json) => GetListVideoLearingLibraryData(
        id: json["id"],
        subject: json["subject"],
        videos: json["videos"] == null ? [] : List<Video>.from(json["videos"]!.map((x) => Video.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "subject": subject,
        "videos": videos == null ? [] : List<dynamic>.from(videos!.map((x) => x.toMap())),
    };
}

class Video {
    String? id;
    String? title;
    String? url;
    List<Note>? notes;
    String? info;
    ShareUrl? shareUrl;

    Video({
        this.id,
        this.title,
        this.url,
        this.notes,
        this.info,
        this.shareUrl,
    });

    Video copyWith({
        String? id,
        String? title,
        String? url,
        List<Note>? notes,
        String? info,
        ShareUrl? shareUrl,
    }) => 
        Video(
            id: id ?? this.id,
            title: title ?? this.title,
            url: url ?? this.url,
            notes: notes ?? this.notes,
            info: info ?? this.info,
            shareUrl: shareUrl ?? this.shareUrl,
        );

    factory Video.fromJson(String str) => Video.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Video.fromMap(Map<String, dynamic> json) => Video(
        id: json["id"],
        title: json["title"],
        url: json["url"],
        notes: json["notes"] == null ? [] : List<Note>.from(json["notes"]!.map((x) => Note.fromMap(x))),
        info: json["info"],
        shareUrl: json["shareUrl"] == null ? null : ShareUrl.fromMap(json["shareUrl"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "url": url,
        "notes": notes == null ? [] : List<dynamic>.from(notes!.map((x) => x.toMap())),
        "info": info,
        "shareUrl": shareUrl?.toMap(),
    };
}

class Note {
    String? fileLoc;
    String? fileName;
    String? fileSize;

    Note({
        this.fileLoc,
        this.fileName,
        this.fileSize,
    });

    Note copyWith({
        String? fileLoc,
        String? fileName,
        String? fileSize,
    }) => 
        Note(
            fileLoc: fileLoc ?? this.fileLoc,
            fileName: fileName ?? this.fileName,
            fileSize: fileSize ?? this.fileSize,
        );

    factory Note.fromJson(String str) => Note.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Note.fromMap(Map<String, dynamic> json) => Note(
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

class ShareUrl {
    String? link;
    String? text;

    ShareUrl({
        this.link,
        this.text,
    });

    ShareUrl copyWith({
        String? link,
        String? text,
    }) => 
        ShareUrl(
            link: link ?? this.link,
            text: text ?? this.text,
        );

    factory ShareUrl.fromJson(String str) => ShareUrl.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ShareUrl.fromMap(Map<String, dynamic> json) => ShareUrl(
        link: json["link"],
        text: json["text"],
    );

    Map<String, dynamic> toMap() => {
        "link": link,
        "text": text,
    };
}
