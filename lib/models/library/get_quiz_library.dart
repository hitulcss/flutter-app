import 'dart:convert';

class GetQuizLibrary {
    bool? status;
    GetQuizLibraryData? data;
    String? msg;

    GetQuizLibrary({
        this.status,
        this.data,
        this.msg,
    });

    GetQuizLibrary copyWith({
        bool? status,
        GetQuizLibraryData? data,
        String? msg,
    }) => 
        GetQuizLibrary(
            status: status ?? this.status,
            data: data ?? this.data,
            msg: msg ?? this.msg,
        );

    factory GetQuizLibrary.fromJson(String str) => GetQuizLibrary.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetQuizLibrary.fromMap(Map<String, dynamic> json) => GetQuizLibrary(
        status: json["status"],
        data: json["data"] == null ? null : GetQuizLibraryData.fromMap(json["data"]),
        msg: json["msg"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
        "msg": msg,
    };
}

class GetQuizLibraryData {
    List<Quize>? quizes;
    int? totalCounts;

    GetQuizLibraryData({
        this.quizes,
        this.totalCounts,
    });

    GetQuizLibraryData copyWith({
        List<Quize>? quizes,
        int? totalCounts,
    }) => 
        GetQuizLibraryData(
            quizes: quizes ?? this.quizes,
            totalCounts: totalCounts ?? this.totalCounts,
        );

    factory GetQuizLibraryData.fromJson(String str) => GetQuizLibraryData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetQuizLibraryData.fromMap(Map<String, dynamic> json) => GetQuizLibraryData(
        quizes: json["quizes"] == null ? [] : List<Quize>.from(json["quizes"]!.map((x) => Quize.fromMap(x))),
        totalCounts: json["totalCounts"],
    );

    Map<String, dynamic> toMap() => {
        "quizes": quizes == null ? [] : List<dynamic>.from(quizes!.map((x) => x.toMap())),
        "totalCounts": totalCounts,
    };
}

class Quize {
    bool? isAttempted;
    String? quizId;
    String? title;
    String? noOfQuestion;
    String? duration;
    int? totalMarks;

    Quize({
        this.isAttempted,
        this.quizId,
        this.title,
        this.noOfQuestion,
        this.duration,
        this.totalMarks,
    });

    Quize copyWith({
        bool? isAttempted,
        String? quizId,
        String? title,
        String? noOfQuestion,
        String? duration,
        int? totalMarks,
    }) => 
        Quize(
            isAttempted: isAttempted ?? this.isAttempted,
            quizId: quizId ?? this.quizId,
            title: title ?? this.title,
            noOfQuestion: noOfQuestion ?? this.noOfQuestion,
            duration: duration ?? this.duration,
            totalMarks: totalMarks ?? this.totalMarks,
        );

    factory Quize.fromJson(String str) => Quize.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Quize.fromMap(Map<String, dynamic> json) => Quize(
        isAttempted: json["isAttempted"],
        quizId: json["quizId"],
        title: json["title"],
        noOfQuestion: json["noOfQuestion"],
        duration: json["duration"],
        totalMarks: json["totalMarks"],
    );

    Map<String, dynamic> toMap() => {
        "isAttempted": isAttempted,
        "quizId": quizId,
        "title": title,
        "noOfQuestion": noOfQuestion,
        "duration": duration,
        "totalMarks": totalMarks,
    };
}
