import 'dart:convert';

class Scholarshipguidance {
    String? heading;
    String? description;

    Scholarshipguidance({
        this.heading,
        this.description,
    });

    Scholarshipguidance copyWith({
        String? heading,
        String? description,
    }) => 
        Scholarshipguidance(
            heading: heading ?? this.heading,
            description: description ?? this.description,
        );

    factory Scholarshipguidance.fromJson(String str) => Scholarshipguidance.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Scholarshipguidance.fromMap(Map<String, dynamic> json) => Scholarshipguidance(
        heading: json["heading"],
        description: json["description"],
    );

    Map<String, dynamic> toMap() => {
        "heading": heading,
        "description": description,
    };
}
