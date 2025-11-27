import 'package:hop/globals/constants.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/service_detail_model.dart';

class ClubLocationData {
  int? id;
  String? locationName;
  String? currency;
  String? geoReferenced;
  List<ClubLocationSports> sports = [];
  List<ServiceDetailCoach> coaches = [];

  double getLocationRadius(double? lat, double? long) {
    if (lat == null || long == null || (geoReferenced?.isEmpty ?? true)) {
      return -1;
    }
    final lat1 = double.tryParse(geoReferenced!.split(',')[0]);
    final long1 = double.tryParse(geoReferenced!.split(',')[1]);
    if (lat1 == null || long1 == null) {
      return -1;
    }
    final distance =
    Utils.calculateDistance(lat, long, lat1, long1).toStringAsFixed(2);
    return double.tryParse(distance) ?? -1;
  }

  double getLat() {
    return double.tryParse(geoReferenced!.split(',')[0]) ?? 0;
  }

  double getLong() {
    return double.tryParse(geoReferenced!.split(',')[1]) ?? 0;
  }

  ClubLocationData(
      {this.id, this.locationName, this.currency, this.geoReferenced});

  ClubLocationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationName = json['location_name'];
    currency = json['currency'];
    geoReferenced = json['georeferenced'];
    if (json['sports'] != null && json['sports'].isNotEmpty) {
      sports = <ClubLocationSports>[];
      json['sports'].forEach((v) {
        sports.add(ClubLocationSports.fromJson(v));
      });
    }
    if (json['coaches'] != null) {
      coaches = <ServiceDetailCoach>[];
      json['coaches'].forEach((v) {
        coaches.add(ServiceDetailCoach.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location_name'] = locationName;
    data['currency'] = currency;
    data['georeferenced'] = geoReferenced;
    if (sports.isNotEmpty) {
      data['sports'] = sports.map((v) => v.toJson()).toList();
    }
    if (coaches.isNotEmpty) {
      data['coaches'] = coaches.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClubLocationSports {
  int? id;
  String? sportName;
  List<ClubLocationSportsCourts>? courts;

  ClubLocationSports({this.id, this.sportName, this.courts});

  ClubLocationSports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sportName = json['sport_name'];
    if (json['courts'] != null && json['courts'].isNotEmpty) {
      courts = <ClubLocationSportsCourts>[];
      json['courts'].forEach((v) {
        courts!.add(ClubLocationSportsCourts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sport_name'] = sportName;
    return data;
  }
}

class ClubLocationSportsCourts {
  int? id;
  int? appBookableDaysInFuture;

  ClubLocationSportsCourts({this.id, this.appBookableDaysInFuture});

  ClubLocationSportsCourts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appBookableDaysInFuture = json['app_bookable_days_in_future'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['app_bookable_days_in_future'] = appBookableDaysInFuture;
    return data;
  }
}
