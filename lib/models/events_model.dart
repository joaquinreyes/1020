import 'package:hop/models/base_classes/booking_base.dart';
import 'package:hop/models/service_detail_model.dart';

import 'court_booking.dart';

class EventsModel extends BookingBase {
  EventsService? service;
  List<EventsPlayers>? players;
  List<BookingCourts>? courts;

  bool get isFull => players?.length == service?.event?.maximumCapacity;

  String get courtName {
    return courts?.map((e) => e.courtName).join(', ') ?? '';
  }

  int get getMinimumCapacity =>
      minimumCapacity ?? service?.event?.minimumCapacity ?? 0;

  int get getMaximumCapacity =>
      maximumCapacity ?? service?.event?.maximumCapacity ?? 0;


  EventsModel(
      {super.id,
      super.date,
      super.startTime,
      super.endTime,
      super.coaches,
      this.service,
      this.courts,
      this.players});

  List<ServiceDetailCoach> get getCoaches {
    final seenIds = <dynamic>{};
    final allCoaches = [
      if (coaches != null) ...coaches!,
      if (service?.coaches != null) ...service!.coaches!,
    ];

    return allCoaches.where((coach) {
      final id = coach.id;
      if (seenIds.contains(id)) return false;
      seenIds.add(id);
      return true;
    }).toList();
  }

  EventsModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    service = json['service'] != null
        ? EventsService.fromJson(json['service'])
        : null;

    if (json['players'] != null) {
      players = <EventsPlayers>[];
      json['players'].forEach((v) {
        players!.add(EventsPlayers.fromJson(v));
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

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (service != null) {
      data['service'] = service!.toJson();
    }
    if (players != null) {
      data['players'] = players!.map((v) => v.toJson()).toList();
    }
    if (courts != null) {
      data['courts'] = courts!.map((v) => v.toJson()).toList();
    }
    super.toJson().forEach((key, value) {
      data[key] = value;
    });
    return data;
  }
}

class EventsService {
  double? price;
  String? additionalService;
  EventsLocation? location;
  Event? event;
  List<ServiceDetailCoach>? coaches;

  EventsService(
      {this.price, this.additionalService, this.location, this.event});

  EventsService.fromJson(Map<String, dynamic> json) {
    price = json['price'].toDouble();
    additionalService = json['additional_service'];
    location = json['location'] != null
        ? EventsLocation.fromJson(json['location'])
        : null;
    event = json['event'] != null ? Event.fromJson(json['event']) : null;
    if (json['coaches'] != null) {
      coaches = <ServiceDetailCoach>[];
      json['coaches'].forEach((v) {
        coaches!.add(ServiceDetailCoach.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['additional_service'] = additionalService;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (event != null) {
      data['event'] = event!.toJson();
    }
    return data;
  }
}

class EventsLocation {
  int? id;
  String? locationName;
  String? currency;

  EventsLocation({this.id, this.locationName, this.currency});

  EventsLocation.fromJson(Map<String, dynamic> json) {
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

class Event {
  int? minimumCapacity;
  int? maximumCapacity;
  String? eventName;
  double? minLevelRestriction;
  double? maxLevelRestriction;
  EventCategory? eventCategory;

  Event(
      {this.minimumCapacity,
      this.maximumCapacity,
      this.eventName,
      this.minLevelRestriction,
      this.maxLevelRestriction,
      this.eventCategory});

  String? get levelRestriction {
    if (minLevelRestriction == null && maxLevelRestriction == null) {
      return null;
    }
    if (minLevelRestriction == 0.0 && maxLevelRestriction == 0.0) {
      return null;
    }
    return '$minLevelRestriction - $maxLevelRestriction';
  }

  Event.fromJson(Map<String, dynamic> json) {
    minimumCapacity = json['minimum_capacity'];
    maximumCapacity = json['maximum_capacity'];
    eventName = json['event_name'];
    minLevelRestriction = json['min_level_restrication']?.toDouble();
    maxLevelRestriction = json['max_level_restrication']?.toDouble();
    eventCategory = json['eventCategory'] != null
        ? new EventCategory.fromJson(json['eventCategory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['minimum_capacity'] = minimumCapacity;
    data['maximum_capacity'] = maximumCapacity;
    data['event_name'] = eventName;
    data['min_level_restriction'] = minLevelRestriction;
    data['max_level_restriction'] = maxLevelRestriction;
    if (this.eventCategory != null) {
      data['eventCategory'] = this.eventCategory!.toJson();
    }
    return data;
  }
}

class EventCategory {
  int? id;
  String? categoryName;

  EventCategory({this.id, this.categoryName});

  EventCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    return data;
  }
}

class EventsPlayers {
  int? id;

  EventsPlayers({this.id});

  EventsPlayers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
