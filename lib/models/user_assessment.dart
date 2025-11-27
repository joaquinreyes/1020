import 'package:hop/models/app_user.dart';
import 'package:hop/models/service_detail_model.dart';
import 'package:hop/models/user_bookings.dart';
import '../utils/dubai_date_time.dart';
import 'base_classes/booking_base.dart';

class UserAssessment {
  List<Assessments>? assessments;
  User? customer;

  UserAssessment({this.assessments, this.customer});

  UserAssessment.fromJson(Map<String, dynamic> json) {
    if (json['assessments'] != null) {
      assessments = <Assessments>[];
      json['assessments'].forEach((v) {
        assessments!.add(Assessments.fromJson(v));
      });
    }
    customer =
        json['customer'] != null ? User.fromJson(json['customer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (assessments != null) {
      data['assessments'] = assessments!.map((v) => v.toJson()).toList();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

class Assessments {
  int? id;
  String? date;
  Service? service;
  List<ServiceDetail_Players>? players;
  List<OpenMatchScores>? openMatchScores;
  OpenMatchOptions? options;
  String? startTime;
  String? endTime;
  bool? rankedEvent;
  bool? scoreSubmitted;
  int? maximumCapacity;
  int? minimumCapacity;

  bool get isEvent{
    return service?.event != null;
  }

  DateTime get bookingDate {
    if (date == null) {
      return DubaiDateTime.now().dateTime;
    }
    return DubaiDateTime.parse(date ?? "").dateTime;
  }

  List<int> get teamAScore {
    OpenMatchScores? teamA =
    openMatchScores?.firstWhere((element) => element.team == "A");
    return [teamA?.score1 ?? 0, teamA?.score2 ?? 0, teamA?.score3 ?? 0];
  }

  List<int> get teamBScore {
    OpenMatchScores? teamB =
    openMatchScores?.firstWhere((element) => element.team == "B");
    return [teamB?.score1 ?? 0, teamB?.score2 ?? 0, teamB?.score3 ?? 0];
  }

  List<ServiceDetail_Players> get teamAPlayers {
// first two players are from team A
    List<ServiceDetail_Players> listA = [];
    try {
      var a1 = players?.lastWhere((element) => element.position == 1);
      var a2 = players?.lastWhere((element) => element.position == 2);
      if(a1 != null) {
        listA.add(a1);
      }
      if(a2 != null) {
        listA.add(a2);
      }
      // players?.where((element) => element.position == 1);
      return listA;
    } catch(e) {
      return players?.sublist(0, 2) ?? [];
    }
  }

  List<ServiceDetail_Players> get teamBPlayers {
    List<ServiceDetail_Players> listB = [];
    try {
      var b1 = players?.lastWhere((element) => element.position == 3);
      var b2 = players?.lastWhere((element) => element.position == 4);
      if(b1 != null) {
        listB.add(b1);
      }
      if(b2 != null) {
        listB.add(b2);
      }
      // players?.where((element) => element.position == 1);
      return listB;
    } catch(e) {
      return players?.sublist(0, 2) ?? [];
    }
  }

  Assessments({
    this.id,
    this.date,
    this.service,
    this.players,
    this.openMatchScores,
    this.options,
    this.endTime,
    this.startTime,
    this.minimumCapacity,
    this.maximumCapacity,
    this.scoreSubmitted,
    this.rankedEvent
  });
  String get openMatchLevelRange {
    if (options != null) {
      return "${options!.minLevel} - ${options!.maxLevel}";
    }
    return '-';
  }
  Assessments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    endTime = json['end_time'];
    startTime = json['start_time'];
    minimumCapacity = json['minimum_capacity'];
    maximumCapacity = json['maximum_capacity'];
    scoreSubmitted = json['score_submitted'];
    rankedEvent = json['ranked_event'];
    options =
    json['openMatchOptions'] != null ? OpenMatchOptions.fromJson(json['openMatchOptions']) : null;
    service =
    json['service'] != null ? Service.fromJson(json['service']) : null;
    if (json['players'] != null) {
      players = <ServiceDetail_Players>[];
      json['players'].forEach((v) {
        players!.add(ServiceDetail_Players.fromJson(v));
      });
    }
    if (json['openMatchScores'] != null) {
      openMatchScores = <OpenMatchScores>[];
      json['openMatchScores'].forEach((v) {
        openMatchScores!.add(OpenMatchScores.fromJson(v));
      });
    }
    if(isEvent){
      service?.serviceType = "Event";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['end_time'] = endTime;
    data['start_time'] = startTime;
    data['minimum_capacity'] = minimumCapacity;
    data['maximum_capacity'] = maximumCapacity;
    data['score_submitted'] = scoreSubmitted;
    data['ranked_event'] = rankedEvent;
    data['openMatchOptions'] = options;
    if (service != null) {
      data['service'] = service!.toJson();
    }
    if (players != null) {
      data['players'] = players!.map((v) => v.toJson()).toList();
    }
    if (openMatchScores != null) {
      data['openMatchScores'] =
          openMatchScores!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  UserBookings toUserBookings() {
    return UserBookings(
      id: id,
      date: date,
      startTime: startTime,
      endTime: endTime,
      service: service,
      rankedEvent: rankedEvent,
      minimumCapacity: minimumCapacity,
      maximumCapacity: maximumCapacity,
      scoreSubmitted: scoreSubmitted,
      openMatchOptions: options,
      players: players?.map((p) => Players.fromServiceDetailPlayer(p)).toList(),
      coaches: service?.coaches,
    );
  }
}


class Booking {
  int? id;
  int? maximumCapacity;

  Booking({this.id, this.maximumCapacity});

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maximumCapacity = json['maximum_capacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['maximum_capacity'] = maximumCapacity;
    return data;
  }
}

class OpenMatchScores {
  int? id;
  String? team;
  int? score1;
  int? score2;
  int? score3;

  OpenMatchScores({this.id, this.team, this.score1, this.score2, this.score3});

  OpenMatchScores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    team = json['team'];
    score1 = json['score1'];
    score2 = json['score2'];
    score3 = json['score3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['team'] = team;
    data['score1'] = score1;
    data['score2'] = score2;
    data['score3'] = score3;
    return data;
  }
}
