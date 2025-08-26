import 'dart:convert';

class GetBatchPlan {
    bool? status;
    List<GetBatchPlanData>? data;
    String? msg;

    GetBatchPlan({
        this.status,
        this.data,
        this.msg,
    });

    GetBatchPlan copyWith({
        bool? status,
        List<GetBatchPlanData>? data,
        String? msg,
    }) => 
        GetBatchPlan(
            status: status ?? this.status,
            data: data ?? this.data,
            msg: msg ?? this.msg,
        );

    factory GetBatchPlan.fromJson(String str) => GetBatchPlan.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetBatchPlan.fromMap(Map<String, dynamic> json) => GetBatchPlan(
        status: json["status"],
        data: json["data"] == null ? [] : List<GetBatchPlanData>.from(json["data"]!.map((x) => GetBatchPlanData.fromMap(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "msg": msg,
    };
}

class GetBatchPlanData {
    String? validityId;
    String? name;
    bool? isRecommended;
    int? month;
    int? salePrice;
    int? regularPrice;
    List<Feature>? features;

    GetBatchPlanData({
        this.validityId,
        this.name,
        this.isRecommended,
        this.month,
        this.salePrice,
        this.regularPrice,
        this.features,
    });

    GetBatchPlanData copyWith({
        String? validityId,
        String? name,
        bool? isRecommended,
        int? month,
        int? salePrice,
        int? regularPrice,
        List<Feature>? features,
    }) => 
        GetBatchPlanData(
            validityId: validityId ?? this.validityId,
            name: name ?? this.name,
            isRecommended: isRecommended ?? this.isRecommended,
            month: month ?? this.month,
            salePrice: salePrice ?? this.salePrice,
            regularPrice: regularPrice ?? this.regularPrice,
            features: features ?? this.features,
        );

    factory GetBatchPlanData.fromJson(String str) => GetBatchPlanData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetBatchPlanData.fromMap(Map<String, dynamic> json) => GetBatchPlanData(
        validityId: json["validityId"],
        name: json["name"],
        isRecommended: json["isRecommended"],
        month: json["month"],
        salePrice: json["salePrice"],
        regularPrice: json["regularPrice"],
        features: json["features"] == null ? [] : List<Feature>.from(json["features"]!.map((x) => Feature.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "validityId": validityId,
        "name": name,
        "isRecommended": isRecommended,
        "month": month,
        "salePrice": salePrice,
        "regularPrice": regularPrice,
        "features": features == null ? [] : List<dynamic>.from(features!.map((x) => x.toMap())),
    };
}

class Feature {
    String? featureName;
    String? info;
    bool? isEnable;

    Feature({
        this.featureName,
        this.info,
        this.isEnable,
    });

    Feature copyWith({
        String? featureName,
        String? info,
        bool? isEnable,
    }) => 
        Feature(
            featureName: featureName ?? this.featureName,
            info: info ?? this.info,
            isEnable: isEnable ?? this.isEnable,
        );

    factory Feature.fromJson(String str) => Feature.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Feature.fromMap(Map<String, dynamic> json) => Feature(
        featureName: json["featureName"],
        info: json["info"],
        isEnable: json["isEnable"],
    );

    Map<String, dynamic> toMap() => {
        "featureName": featureName,
        "info": info,
        "isEnable": isEnable,
    };
}
