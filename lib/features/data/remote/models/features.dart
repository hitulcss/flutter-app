import 'dart:convert';

class Features {
    List<Sidebar>? sidebar;

    Features({
        this.sidebar,
    });

    Features copyWith({
        List<Sidebar>? sidebar,
    }) => 
        Features(
            sidebar: sidebar ?? this.sidebar,
        );

    factory Features.fromJson(String str) => Features.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Features.fromMap(Map<String, dynamic> json) => Features(
        sidebar: json["sidebar"] == null ? [] : List<Sidebar>.from(json["sidebar"]!.map((x) => Sidebar.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "sidebar": sidebar == null ? [] : List<dynamic>.from(sidebar!.map((x) => x.toMap())),
    };
}

class Sidebar {
    String? sidebarEnum;
    String? title;
    String? icon;
    bool? isEnabled;
    bool? isNew;

    Sidebar({
        this.sidebarEnum,
        this.title,
        this.icon,
        this.isEnabled,
        this.isNew,
    });

    Sidebar copyWith({
        String? sidebarEnum,
        String? title,
        String? icon,
        bool? isEnabled,
        bool? isNew,
    }) => 
        Sidebar(
            sidebarEnum: sidebarEnum ?? this.sidebarEnum,
            title: title ?? this.title,
            icon: icon ?? this.icon,
            isEnabled: isEnabled ?? this.isEnabled,
            isNew: isNew ?? this.isNew,
        );

    factory Sidebar.fromJson(String str) => Sidebar.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Sidebar.fromMap(Map<String, dynamic> json) => Sidebar(
        sidebarEnum: json["enum"],
        title: json["title"],
        icon: json["icon"],
        isEnabled: json["isEnabled"],
        isNew: json["isNew"],
    );

    Map<String, dynamic> toMap() => {
        "enum": sidebarEnum,
        "title": title,
        "icon": icon,
        "isEnabled": isEnabled,
        "isNew": isNew,
    };
}
