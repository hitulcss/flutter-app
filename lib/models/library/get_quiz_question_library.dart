import 'dart:convert';

class   GetQuizQuestionLibrary {
    bool? status;
    List<GetQuizQuestionLibraryData>? data;
    String? msg;

    GetQuizQuestionLibrary({
        this.status,
        this.data,
        this.msg,
    });

    GetQuizQuestionLibrary copyWith({
        bool? status,
        List<GetQuizQuestionLibraryData>? data,
        String? msg,
    }) => 
        GetQuizQuestionLibrary(
            status: status ?? this.status,
            data: data ?? this.data,
            msg: msg ?? this.msg,
        );

    factory GetQuizQuestionLibrary.fromJson(String str) => GetQuizQuestionLibrary.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetQuizQuestionLibrary.fromMap(Map<String, dynamic> json) => GetQuizQuestionLibrary(
        status: json["status"],
        data: json["data"] == null ? [] : List<GetQuizQuestionLibraryData>.from(json["data"]!.map((x) => GetQuizQuestionLibraryData.fromMap(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "msg": msg,
    };
}

class GetQuizQuestionLibraryData {
    String? id;
    String? quizId;
    SectionId? sectionId;
    Option1? questionTitle;
    Option1? option1;
    Option1? option2;
    Option1? option3;
    Option1? option4;

    GetQuizQuestionLibraryData({
        this.id,
        this.quizId,
        this.sectionId,
        this.questionTitle,
        this.option1,
        this.option2,
        this.option3,
        this.option4,
    });

    GetQuizQuestionLibraryData copyWith({
        String? id,
        String? quizId,
        SectionId? sectionId,
        Option1? questionTitle,
        Option1? option1,
        Option1? option2,
        Option1? option3,
        Option1? option4,
    }) => 
        GetQuizQuestionLibraryData(
            id: id ?? this.id,
            quizId: quizId ?? this.quizId,
            sectionId: sectionId ?? this.sectionId,
            questionTitle: questionTitle ?? this.questionTitle,
            option1: option1 ?? this.option1,
            option2: option2 ?? this.option2,
            option3: option3 ?? this.option3,
            option4: option4 ?? this.option4,
        );

    factory GetQuizQuestionLibraryData.fromJson(String str) => GetQuizQuestionLibraryData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetQuizQuestionLibraryData.fromMap(Map<String, dynamic> json) => GetQuizQuestionLibraryData(
        id: json["_id"],
        quizId: json["quiz_id"],
        sectionId: json["sectionId"] == null ? null : SectionId.fromMap(json["sectionId"]),
        questionTitle: json["question_title"] == null ? null : Option1.fromMap(json["question_title"]),
        option1: json["option1"] == null ? null : Option1.fromMap(json["option1"]),
        option2: json["option2"] == null ? null : Option1.fromMap(json["option2"]),
        option3: json["option3"] == null ? null : Option1.fromMap(json["option3"]),
        option4: json["option4"] == null ? null : Option1.fromMap(json["option4"]),
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "quiz_id": quizId,
        "sectionId": sectionId?.toMap(),
        "question_title": questionTitle?.toMap(),
        "option1": option1?.toMap(),
        "option2": option2?.toMap(),
        "option3": option3?.toMap(),
        "option4": option4?.toMap(),
    };
}

class Option1 {
    String? e;
    String? h;
    String? id;

    Option1({
        this.e,
        this.h,
        this.id,
    });

    Option1 copyWith({
        String? e,
        String? h,
        String? id,
    }) => 
        Option1(
            e: e ?? this.e,
            h: h ?? this.h,
            id: id ?? this.id,
        );

    factory Option1.fromJson(String str) => Option1.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Option1.fromMap(Map<String, dynamic> json) => Option1(
        e: json["e"],
        h: json["h"],
        id: json["_id"],
    );

    Map<String, dynamic> toMap() => {
        "e": e,
        "h": h,
        "_id": id,
    };
}

class SectionId {
    String? id;
    String? title;
    String? sectionId;

    SectionId({
        this.id,
        this.title,
        this.sectionId,
    });

    SectionId copyWith({
        String? id,
        String? title,
        String? sectionId,
    }) => 
        SectionId(
            id: id ?? this.id,
            title: title ?? this.title,
            sectionId: sectionId ?? this.sectionId,
        );

    factory SectionId.fromJson(String str) => SectionId.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SectionId.fromMap(Map<String, dynamic> json) => SectionId(
        id: json["_id"],
        title: json["title"],
        sectionId: json["sectionId"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "title": title,
        "sectionId": sectionId,
    };
}
