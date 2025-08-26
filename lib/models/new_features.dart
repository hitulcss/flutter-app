import 'dart:convert';

class NewFeatures {
    bool? doubt;
    bool? community;
    bool? homeShortLearning;
    bool? scholarshiptest;
    bool? quickLearningComment;

    NewFeatures({
        this.doubt,
        this.community,
        this.homeShortLearning,
        this.scholarshiptest,
        this.quickLearningComment
    });

    factory NewFeatures.fromJson(String str) => NewFeatures.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory NewFeatures.fromMap(Map<String, dynamic> json) => NewFeatures(
        doubt: json["Doubt"],
        community: json["community"],
        homeShortLearning: json["homeShortLearning"],
        scholarshiptest: json["scholarshiptest"],
        quickLearningComment: json["quickLearningComment"],
    );

    Map<String, dynamic> toMap() => {
        "Doubt": doubt,
        "community": community,
        "homeShortLearning": homeShortLearning,
        "scholarshiptest": scholarshiptest,
        "quickLearningComment": quickLearningComment
    };
}
