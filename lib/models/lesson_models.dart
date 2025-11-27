import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hop/models/base_classes/booking_base.dart';
import 'package:hop/models/court_booking.dart';
import 'package:hop/models/service_detail_model.dart';

import '../screens/app_provider.dart';

class LessonsModel {
  int? locationId;
  String? lessonName;
  int? duration;
  int? minimumCapacity;
  int? maximumCapacity;
  double? price;
  String? eventInfo;
  String? shortDescription;
  LessonSport? sport;
  LessonLocation? location;
  List<LessonServices>? services;
  double? minLevelRestriction;
  double? maxLevelRestriction;
  int? selectedCoach;


  String get description {
    return shortDescription ?? eventInfo ?? '';
  }

  List<ServiceDetailCoach> get coaches {
    final List<ServiceDetailCoach> coaches = <ServiceDetailCoach>[];
    services?.forEach((element) {
      element.serviceBookings?.forEach((value) {
        coaches.addAll(value.coaches ?? []);
      });
      coaches.addAll(element.coaches ?? []);
    });
    return coaches;
  }

  LessonsModel(
      {this.locationId,
      this.lessonName,
      this.duration,
      this.minimumCapacity,
      this.maximumCapacity,
      this.price,
      this.shortDescription,
      this.eventInfo,
      this.sport,
      this.location,
      this.services,
      this.selectedCoach,
      this.minLevelRestriction,
      this.maxLevelRestriction});

  String? get levelRestriction {
    if (minLevelRestriction == null && maxLevelRestriction == null) {
      return null;
    }
    if (minLevelRestriction == 0.0 && maxLevelRestriction == 0.0) {
      return null;
    }
    return '$minLevelRestriction - $maxLevelRestriction';
  }

  LessonsModel.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    lessonName = json['lesson_name'];
    duration = json['duration'];
    shortDescription = json['short_description'];
    minimumCapacity = json['minimum_capacity'];
    maximumCapacity = json['maximum_capacity'];
    price = json['price'].toDouble();
    eventInfo = json['event_info'];
    sport = json['sport'] != null ? LessonSport.fromJson(json['sport']) : null;
    location = json['location'] != null
        ? LessonLocation.fromJson(json['location'])
        : null;
    if (json['services'] != null) {
      services = <LessonServices>[];
      json['services'].forEach((v) {
        services!.add(LessonServices.fromJson(v));
      });
    }
    if (coaches.isNotEmpty && selectedCoach == null) {
      selectedCoach = coaches.first.id;
    }
    minLevelRestriction = json['min_level_restrication']?.toDouble();
    maxLevelRestriction = json['max_level_restrication']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location_id'] = locationId;
    data['lesson_name'] = lessonName;
    data['duration'] = duration;
    data['short_description'] = shortDescription;

    data['minimum_capacity'] = minimumCapacity;
    data['maximum_capacity'] = maximumCapacity;
    data['price'] = price;
    data['event_info'] = eventInfo;
    if (sport != null) {
      data['sport'] = sport!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    data['min_level_restrication'] = minLevelRestriction;
    data['max_level_restrication'] = maxLevelRestriction;
    return data;
  }
}

class LessonSport {
  int? id;
  String? sportName;

  LessonSport({this.id, this.sportName});

  LessonSport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sportName = json['sport_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sport_name'] = sportName;
    return data;
  }
}

class LessonLocation {
  int? id;
  String? locationName;
  String? currency;

  LessonLocation({this.id, this.locationName, this.currency});

  LessonLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationName = json['location_name'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location_name'] = locationName;
    data['currency'] = currency;
    return data;
  }
}

class LessonServices {
  int? id;
  List<LessonServiceBookings>? serviceBookings;
  List<ServiceDetailCoach>? coaches;

  LessonServices({this.id, this.serviceBookings});

  LessonServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['serviceBookings'] != null) {
      serviceBookings = <LessonServiceBookings>[];
      json['serviceBookings'].forEach((v) {
        serviceBookings!.add(LessonServiceBookings.fromJson(v));
      });
    }
    if (json['coaches'] != null) {
      coaches = <ServiceDetailCoach>[];
      json['coaches'].forEach((v) {
        coaches!.add(ServiceDetailCoach.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (serviceBookings != null) {
      data['serviceBookings'] =
          serviceBookings!.map((v) => v.toJson()).toList();
    }
    if (coaches != null) {
      data['coaches'] = coaches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LessonServiceBookings extends BookingBase {
  List<LessonPlayers>? players;
  List<BookingCourts>? courts;

  LessonServiceBookings(
      {super.id,
      super.date,
      super.startTime,
      super.endTime,
      this.players,
      super.coaches,
      this.courts});

  String? getSportsName(WidgetRef ref) {
    if ((courts ?? []).isNotEmpty) {
      final list = ref.read(sportListProvider.notifier).sport;
      final index =
      list.indexWhere((element) => element.id == courts?[0].sport?.id);
      if (index != -1) {
        return list[index].sportName;
      }
    }
    return null;
  }

  LessonServiceBookings.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    if (json['players'] != null) {
      players = <LessonPlayers>[];
      json['players'].forEach((v) {
        players!.add(LessonPlayers.fromJson(v));
      });
    }
    if (json['coaches'] != null) {
      coaches = <ServiceDetailCoach>[];
      json['coaches'].forEach((v) {
        coaches!.add(ServiceDetailCoach.fromJson(v));
      });
    }
    if (json['courts'] != null) {
      courts = <BookingCourts>[];
      json['courts'].forEach((v) {
        courts!.add(BookingCourts.fromJson(v));
      });
    }
  }

  int get duration2 {
    DateTime tempBookingEndTime = DateTime.parse(bookingEndTime.toString());
    final dif = tempBookingEndTime.difference(bookingStartTime).inMinutes;
    if (dif < 0) {
      tempBookingEndTime = DateTime.parse(
          tempBookingEndTime.add(const Duration(days: 1)).toString());
      final dif2 = tempBookingEndTime.difference(bookingStartTime).inMinutes;
      if (dif2 < 0) {
        return 0;
      }
      return dif2;
    }
    return dif;
  }

  int get coachesId {
    if ((coaches ?? []).isNotEmpty) {
      return coaches?.first.id ?? 0;
    }
    return 0;
  }

  int get courtId {
    if ((courts ?? []).isNotEmpty) {
      return courts?.first.id ?? 0;
    }
    return 0;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (courts != null) {
      data['courts'] = courts!.map((v) => v.toJson()).toList();
    }
    if (players != null) {
      data['players'] = players!.map((v) => v.toJson()).toList();
    }
    if (coaches != null) {
      data['coaches'] = coaches!.map((v) => v.toJson()).toList();
    }
    super.toJson().forEach((key, value) {
      data[key] = value;
    });
    return data;
  }
}

class LessonPlayers {
  int? id;

  LessonPlayers({this.id});

  LessonPlayers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
