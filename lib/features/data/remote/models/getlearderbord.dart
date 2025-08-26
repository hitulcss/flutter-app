class GetLeaderBoard {
  bool? status;
  GetLeaderBoardData? data;
  String? msg;

  GetLeaderBoard({this.status, this.data, this.msg});

  GetLeaderBoard.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? GetLeaderBoardData.fromJson(json['data']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = msg;
    return data;
  }
}

class GetLeaderBoardData {
  Map<String, dynamic>? optionsPercentage;
  List<LeaderBoard>? leaderBoard;

  GetLeaderBoardData({this.optionsPercentage, this.leaderBoard});

  GetLeaderBoardData.fromJson(Map<String, dynamic> json) {
    optionsPercentage = json['optionsPercentage'] as Map<String, dynamic>;
    if (json['leaderBoard'] != null) {
      leaderBoard = <LeaderBoard>[];
      json['leaderBoard'].forEach((v) {
        leaderBoard!.add(LeaderBoard.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (optionsPercentage != null) {
      data['optionsPercentage'] = optionsPercentage!;
    }
    if (leaderBoard != null) {
      data['leaderBoard'] = leaderBoard!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaderBoard {
  int? rank;
  String? name;
  String? duration;

  LeaderBoard({this.rank, this.name, this.duration});

  LeaderBoard.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    name = json['name'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    data['name'] = name;
    data['duration'] = duration;
    return data;
  }
}
