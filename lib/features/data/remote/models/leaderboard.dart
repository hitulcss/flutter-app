class   LeaderboardsModel {
  bool? status;
  LeaderboardsModelData? data;
  String? msg;

  LeaderboardsModel({this.status, this.data, this.msg});

  LeaderboardsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? LeaderboardsModelData.fromJson(json['data']) : null;
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

class LeaderboardsModelData {
  String? leaderBoardId;
  String? quizId;
  List<LeaderBoard>? leaderBoard;
  bool? isActive;

  LeaderboardsModelData({this.leaderBoardId, this.quizId, this.leaderBoard, this.isActive});

  LeaderboardsModelData.fromJson(Map<String, dynamic> json) {
    leaderBoardId = json['leaderBoardId'];
    quizId = json['quizId'];
    if (json['leaderBoard'] != null) {
      leaderBoard = <LeaderBoard>[];
      json['leaderBoard'].forEach((v) {
        leaderBoard!.add(LeaderBoard.fromJson(v));
      });
    }
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leaderBoardId'] = leaderBoardId;
    data['quizId'] = quizId;
    if (leaderBoard != null) {
      data['leaderBoard'] = leaderBoard!.map((v) => v.toJson()).toList();
    }
    data['isActive'] = isActive;
    return data;
  }
}

class LeaderBoard {
  String? studentId;
  String? studentName;
  String? myScore;
  String? totalMarks;
  String? accuracy;

  LeaderBoard(
      {this.studentId,
      this.studentName,
      this.myScore,
      this.totalMarks,
      this.accuracy});

  LeaderBoard.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    myScore = json['myScore'];
    totalMarks = json['totalMarks'];
    accuracy = json['accuracy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['studentId'] = studentId;
    data['studentName'] = studentName;
    data['myScore'] = myScore;
    data['totalMarks'] = totalMarks;
    data['accuracy'] = accuracy;
    return data;
  }
}
