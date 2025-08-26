import 'dart:convert';

class AppTour {
    AppData? topcatagory;
    AppData? sideMenu;
    AppData? courseSearchbar;
    AppData? notification;
    AppData? learning;
    AppData? coursebottom;
    AppData? feed;
    AppData? ebookbottom;
    AppData? storebottom;
    AppData? homegroupFeature;
    AppData? mycourse;
    AppData? myDownloads;
    AppData? myebooks;
    AppData? appTourLibrary;
    AppData? mycourseinfo;
    AppData? mycourseLecture;
    AppData? mycourseTest;
    AppData? mycourseannouncement;
    AppData? mycourseDoubt;
    AppData? mycourseCommunity;
    AppData? lectureVideoTab;
    AppData? notesTab;
    AppData? dppsTab;
    AppData? infoLectureTab;
    AppData? resourcesLectureTab;
    AppData? askDoubtLectureTab;
    AppData? pollLectureTab;
    AppData? chatLectureTab;
    AppData? ratingLectureTab;
    AppData? reportLectureTab;
    AppData? libraryTestCardKey;
    AppData? libraryNoteCardKey;
    AppData? libraryPyqsCardKey;
    AppData? librarySyllabusCardKey;
    AppData? libraryVideoLearnCardKey;

    AppTour({
        this.topcatagory,
        this.sideMenu,
        this.courseSearchbar,
        this.notification,
        this.learning,
        this.coursebottom,
        this.feed,
        this.ebookbottom,
        this.storebottom,
        this.homegroupFeature,
        this.mycourse,
        this.myDownloads,
        this.myebooks,
        this.appTourLibrary,
        this.mycourseinfo,
        this.mycourseLecture,
        this.mycourseTest,
        this.mycourseannouncement,
        this.mycourseDoubt,
        this.mycourseCommunity,
        this.lectureVideoTab,
        this.notesTab,
        this.dppsTab,
        this.infoLectureTab,
        this.resourcesLectureTab,
        this.askDoubtLectureTab,
        this.pollLectureTab,
        this.chatLectureTab,
        this.ratingLectureTab,
        this.reportLectureTab,
        this.libraryTestCardKey,
        this.libraryNoteCardKey,
        this.libraryPyqsCardKey,
        this.librarySyllabusCardKey,
        this.libraryVideoLearnCardKey,
    });

    AppTour copyWith({
        AppData? topcatagory,
        AppData? sideMenu,
        AppData? courseSearchbar,
        AppData? notification,
        AppData? learning,
        AppData? coursebottom,
        AppData? feed,
        AppData? ebookbottom,
        AppData? storebottom,
        AppData? homegroupFeature,
        AppData? mycourse,
        AppData? myDownloads,
        AppData? myebooks,
        AppData? appTourLibrary,
        AppData? mycourseinfo,
        AppData? mycourseLecture,
        AppData? mycourseTest,
        AppData? mycourseannouncement,
        AppData? mycourseDoubt,
        AppData? mycourseCommunity,
        AppData? lectureVideoTab,
        AppData? notesTab,
        AppData? dppsTab,
        AppData? infoLectureTab,
        AppData? resourcesLectureTab,
        AppData? askDoubtLectureTab,
        AppData? pollLectureTab,
        AppData? chatLectureTab,
        AppData? ratingLectureTab,
        AppData? reportLectureTab,
        AppData? libraryTestCardKey,
        AppData? libraryNoteCardKey,
        AppData? libraryPyqsCardKey,
        AppData? librarySyllabusCardKey,
        AppData? libraryVideoLearnCardKey,
    }) => 
        AppTour(
            topcatagory: topcatagory ?? this.topcatagory,
            sideMenu: sideMenu ?? this.sideMenu,
            courseSearchbar: courseSearchbar ?? this.courseSearchbar,
            notification: notification ?? this.notification,
            learning: learning ?? this.learning,
            coursebottom: coursebottom ?? this.coursebottom,
            feed: feed ?? this.feed,
            ebookbottom: ebookbottom ?? this.ebookbottom,
            storebottom: storebottom ?? this.storebottom,
            homegroupFeature: homegroupFeature ?? this.homegroupFeature,
            mycourse: mycourse ?? this.mycourse,
            myDownloads: myDownloads ?? this.myDownloads,
            myebooks: myebooks ?? this.myebooks,
            appTourLibrary: appTourLibrary ?? this.appTourLibrary,
            mycourseinfo: mycourseinfo ?? this.mycourseinfo,
            mycourseLecture: mycourseLecture ?? this.mycourseLecture,
            mycourseTest: mycourseTest ?? this.mycourseTest,
            mycourseannouncement: mycourseannouncement ?? this.mycourseannouncement,
            mycourseDoubt: mycourseDoubt ?? this.mycourseDoubt,
            mycourseCommunity: mycourseCommunity ?? this.mycourseCommunity,
            lectureVideoTab: lectureVideoTab ?? this.lectureVideoTab,
            notesTab: notesTab ?? this.notesTab,
            dppsTab: dppsTab ?? this.dppsTab,
            infoLectureTab: infoLectureTab ?? this.infoLectureTab,
            resourcesLectureTab: resourcesLectureTab ?? this.resourcesLectureTab,
            askDoubtLectureTab: askDoubtLectureTab ?? this.askDoubtLectureTab,
            pollLectureTab: pollLectureTab ?? this.pollLectureTab,
            chatLectureTab: chatLectureTab ?? this.chatLectureTab,
            ratingLectureTab: ratingLectureTab ?? this.ratingLectureTab,
            reportLectureTab: reportLectureTab ?? this.reportLectureTab,
            libraryTestCardKey: libraryTestCardKey ?? this.libraryTestCardKey,
            libraryNoteCardKey: libraryNoteCardKey ?? this.libraryNoteCardKey,
            libraryPyqsCardKey: libraryPyqsCardKey ?? this.libraryPyqsCardKey,
            librarySyllabusCardKey: librarySyllabusCardKey ?? this.librarySyllabusCardKey,
            libraryVideoLearnCardKey: libraryVideoLearnCardKey ?? this.libraryVideoLearnCardKey,
        );

    factory AppTour.fromJson(String str) => AppTour.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AppTour.fromMap(Map<String, dynamic> json) => AppTour(
        topcatagory: json["topcatagory"] == null ? null : AppData.fromMap(json["topcatagory"]),
        sideMenu: json["sideMenu"] == null ? null : AppData.fromMap(json["sideMenu"]),
        courseSearchbar: json["courseSearchbar"] == null ? null : AppData.fromMap(json["courseSearchbar"]),
        notification: json["notification"] == null ? null : AppData.fromMap(json["notification"]),
        learning: json["learning"] == null ? null : AppData.fromMap(json["learning"]),
        coursebottom: json["coursebottom"] == null ? null : AppData.fromMap(json["coursebottom"]),
        feed: json["feed"] == null ? null : AppData.fromMap(json["feed"]),
        ebookbottom: json["ebookbottom"] == null ? null : AppData.fromMap(json["ebookbottom"]),
        storebottom: json["storebottom"] == null ? null : AppData.fromMap(json["storebottom"]),
        homegroupFeature: json["homegroupFeature"] == null ? null : AppData.fromMap(json["homegroupFeature"]),
        mycourse: json["mycourse"] == null ? null : AppData.fromMap(json["mycourse"]),
        myDownloads: json["myDownloads"] == null ? null : AppData.fromMap(json["myDownloads"]),
        myebooks: json["myebooks"] == null ? null : AppData.fromMap(json["myebooks"]),
        appTourLibrary: json["library"] == null ? null : AppData.fromMap(json["library"]),
        mycourseinfo: json["mycourseinfo"] == null ? null : AppData.fromMap(json["mycourseinfo"]),
        mycourseLecture: json["mycourseLecture"] == null ? null : AppData.fromMap(json["mycourseLecture"]),
        mycourseTest: json["mycourseTest"] == null ? null : AppData.fromMap(json["mycourseTest"]),
        mycourseannouncement: json["mycourseannouncement"] == null ? null : AppData.fromMap(json["mycourseannouncement"]),
        mycourseDoubt: json["mycourseDoubt"] == null ? null : AppData.fromMap(json["mycourseDoubt"]),
        mycourseCommunity: json["mycourseCommunity"] == null ? null : AppData.fromMap(json["mycourseCommunity"]),
        lectureVideoTab: json["lectureVideoTab"] == null ? null : AppData.fromMap(json["lectureVideoTab"]),
        notesTab: json["notesTab"] == null ? null : AppData.fromMap(json["notesTab"]),
        dppsTab: json["dppsTab"] == null ? null : AppData.fromMap(json["dppsTab"]),
        infoLectureTab: json["infoLectureTab"] == null ? null : AppData.fromMap(json["infoLectureTab"]),
        resourcesLectureTab: json["resourcesLectureTab"] == null ? null : AppData.fromMap(json["resourcesLectureTab"]),
        askDoubtLectureTab: json["askDoubtLectureTab"] == null ? null : AppData.fromMap(json["askDoubtLectureTab"]),
        pollLectureTab: json["pollLectureTab"] == null ? null : AppData.fromMap(json["pollLectureTab"]),
        chatLectureTab: json["chatLectureTab"] == null ? null : AppData.fromMap(json["chatLectureTab"]),
        ratingLectureTab: json["ratingLectureTab"] == null ? null : AppData.fromMap(json["ratingLectureTab"]),
        reportLectureTab: json["reportLectureTab"] == null ? null : AppData.fromMap(json["reportLectureTab"]),
        libraryTestCardKey: json["libraryTestCardKey"] == null ? null : AppData.fromMap(json["libraryTestCardKey"]),
        libraryNoteCardKey: json["libraryNoteCardKey"] == null ? null : AppData.fromMap(json["libraryNoteCardKey"]),
        libraryPyqsCardKey: json["libraryPyqsCardKey"] == null ? null : AppData.fromMap(json["libraryPyqsCardKey"]),
        librarySyllabusCardKey: json["librarySyllabusCardKey"] == null ? null : AppData.fromMap(json["librarySyllabusCardKey"]),
        libraryVideoLearnCardKey: json["libraryVideoLearnCardKey"] == null ? null : AppData.fromMap(json["libraryVideoLearnCardKey"]),
    );

    Map<String, dynamic> toMap() => {
        "topcatagory": topcatagory?.toMap(),
        "sideMenu": sideMenu?.toMap(),
        "courseSearchbar": courseSearchbar?.toMap(),
        "notification": notification?.toMap(),
        "learning": learning?.toMap(),
        "coursebottom": coursebottom?.toMap(),
        "feed": feed?.toMap(),
        "ebookbottom": ebookbottom?.toMap(),
        "storebottom": storebottom?.toMap(),
        "homegroupFeature": homegroupFeature?.toMap(),
        "mycourse": mycourse?.toMap(),
        "myDownloads": myDownloads?.toMap(),
        "myebooks": myebooks?.toMap(),
        "library": appTourLibrary?.toMap(),
        "mycourseinfo": mycourseinfo?.toMap(),
        "mycourseLecture": mycourseLecture?.toMap(),
        "mycourseTest": mycourseTest?.toMap(),
        "mycourseannouncement": mycourseannouncement?.toMap(),
        "mycourseDoubt": mycourseDoubt?.toMap(),
        "mycourseCommunity": mycourseCommunity?.toMap(),
        "lectureVideoTab": lectureVideoTab?.toMap(),
        "notesTab": notesTab?.toMap(),
        "dppsTab": dppsTab?.toMap(),
        "infoLectureTab": infoLectureTab?.toMap(),
        "resourcesLectureTab": resourcesLectureTab?.toMap(),
        "askDoubtLectureTab": askDoubtLectureTab?.toMap(),
        "pollLectureTab": pollLectureTab?.toMap(),
        "chatLectureTab": chatLectureTab?.toMap(),
        "ratingLectureTab": ratingLectureTab?.toMap(),
        "reportLectureTab": reportLectureTab?.toMap(),
        "libraryTestCardKey": libraryTestCardKey?.toMap(),
        "libraryNoteCardKey": libraryNoteCardKey?.toMap(),
        "libraryPyqsCardKey": libraryPyqsCardKey?.toMap(),
        "librarySyllabusCardKey": librarySyllabusCardKey?.toMap(),
        "libraryVideoLearnCardKey": libraryVideoLearnCardKey?.toMap(),
    };
}

class AppData {
    String? title;
    String? des;

    AppData({
        this.title,
        this.des,
    });

    AppData copyWith({
        String? title,
        String? des,
    }) => 
        AppData(
            title: title ?? this.title,
            des: des ?? this.des,
        );

    factory AppData.fromJson(String str) => AppData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AppData.fromMap(Map<String, dynamic> json) => AppData(
        title: json["title"],
        des: json["des"],
    );

    Map<String, dynamic> toMap() => {
        "title": title,
        "des": des,
    };
}
