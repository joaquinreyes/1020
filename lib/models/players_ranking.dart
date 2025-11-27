import 'app_user.dart';

class PlayersRanking {
  List<Levels>? levels;
  Result? result;
  int? totalPages;

  PlayersRanking({this.levels, this.result, this.totalPages});

  PlayersRanking.fromJson(Map<String, dynamic> json) {
    if (json['levels'] != null) {
      levels = <Levels>[];
      json['levels'].forEach((v) {
        levels!.add(new Levels.fromJson(v));
      });
    }
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.levels != null) {
      data['levels'] = this.levels!.map((v) => v.toJson()).toList();
    }
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['totalPages'] = totalPages;

    return data;
  }
}

class Levels {
  String? level;
  User? customer;
  int? index;

  Levels({this.level, this.customer, this.index});

  Levels.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    customer =
        json['customer'] != null ? new User.fromJson(json['customer']) : null;
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['index'] = this.index;
    return data;
  }
}

class Result {
  String? position;

  Result({this.position});

  Result.fromJson(Map<String, dynamic> json) {
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['position'] = this.position;
    return data;
  }
}
