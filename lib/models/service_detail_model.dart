import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hop/models/base_classes/booking_base.dart';
import 'package:hop/models/base_classes/booking_player_base.dart';
import 'package:hop/models/court_booking.dart';
import 'package:hop/models/user_bookings.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../managers/user_manager.dart';
import '../screens/app_provider.dart';

class ServiceDetail extends BookingBase {
  bool? isCancelled;
  ServiceDetail_Service? service;
  List<ServiceDetail_Courts>? courts;
  List<ServiceDetail_Players>? players;

  bool get isWellnessSport {
    return sportName.toLowerCase() == "wellness";
  }
  int? get maxPaxValue => minimumCapacity == null ? maximumCapacity : null ;

  String get info {
    return eventInfo ?? service?.event?.eventInfo ?? service?.lesson?.eventInfo ?? service?.additionalService ?? "";
  }

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


  int get getMinimumCapacity =>
      minimumCapacity ??
      service?.event?.minimumCapacity ??
      service?.lesson?.minimumCapacity ??
      0;

  int get getMaximumCapacity =>
      maximumCapacity ??
      service?.event?.maximumCapacity ??
      service?.lesson?.maximumCapacity ??
      0;

  double pricePaid(WidgetRef ref) {
    final currentUserID = ref.read(userManagerProvider).user?.user?.id;
    final index2 = (players ?? []).indexWhere(
      (element) => element.customer?.id == currentUserID,
    );
    if (index2 != -1) {
      return (players?[index2].paidPrice ?? 0) +
          (players?[index2].pendingPrice ?? 0);
    }
    return service?.price ?? 0;
  }

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

  bool get isPrivate => false;


  String get courtName {
    if (courts != null && (courts?.isNotEmpty ?? true)) {
      return courts!.first.courtName!;
    }
    return 'COURT NAME';
  }

  String get sportName {
    if (courts != null && (courts?.isNotEmpty ?? true)) {
      return courts!.first.sport?.sportName?.capitalizeFirst ?? '';
    }
    return "";
  }

  int get courtId {
    if (courts != null && (courts?.isNotEmpty ?? true)) {
      return courts!.first.id ?? 0;
    }
    return 0;
  }

  String get duration {
    final dif = bookingEndTime.difference(bookingStartTime).inMinutes;
    if (dif < 0) {
      return "";
    }
    if (dif < 60) {
      return "${dif} min";
    }
    // return "${dif ~/ 60} hr ${dif % 60} min";
    double hours = dif / 60;
    double minutes = dif % 60;
    if (minutes == 0) {
      return "${hours.toInt()} hr";
    }
    return "${hours.toInt()} hr ${minutes.toInt()} min";
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

  String get formattedDateStartEndTime {
    if (startTime == null) {
      return '';
    }
    return "${bookingDate.format("EEE dd MMM")} | ${bookingStartTime.format("HH:mm")} - ${bookingEndTime.format("HH:mm")}";
  }

  String get formattedDateStartEndTimeForShare {
    if (startTime == null) {
      return '';
    }
    return "${bookingDate.format("EEE dd MMM")}, ${bookingStartTime.format("HH:mm")} (${duration})";
  }

  String get formattedDateStartTime {
    if (startTime == null) {
      return '';
    }
    return "${bookingDate.format("EEE dd MMM")} | ${bookingStartTime.format("HH:mm")}";
  }

  String get formatStartEndTime {
    if (startTime == null) {
      return '';
    }
    return "${bookingStartTime.format("HH:mm")} - ${bookingEndTime.format("HH:mm")}";
  }

  String get formatStartEndTime12 {
    if (startTime == null) {
      return '';
    }
    return "${bookingStartTime.format("h:mm")} - ${bookingEndTime.format("h:mm a")}";
  }

  String get formatStartTime {
    if (startTime == null) {
      return '';
    }
    return bookingStartTime.format("HH:mm");
  }

  ServiceDetail_Players? get organizer {
    if (players == null || players!.isEmpty) {
      return null;
    }
    ServiceDetail_Players? value = players?.firstWhere(
      (element) => element.isOrganizer == true,
      orElse: () => ServiceDetail_Players(),
    );

    if (value?.id != null) {
      return value;
    }
    return null;
  }

  ServiceDetail(
      {super.id,
      super.date,
      super.startTime,
      this.isCancelled,
      super.endTime,
      super.coaches,
      super.approveBeforeJoin,
      this.service,
      this.courts,
      this.players});

  ServiceDetail.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json['id'];
    date = json['date'];
    isCancelled = json['is_cancelled'];
    isFriendlyMatch = json['friendly_match'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    organizerNote = json['organizer_notes'];
    approveBeforeJoin = json['approve_before_join'];
    service = json['service'] != null
        ? ServiceDetail_Service.fromJson(json['service'])
        : null;
    if (json['courts'] != null) {
      courts = <ServiceDetail_Courts>[];
      json['courts'].forEach((v) {
        courts!.add(ServiceDetail_Courts.fromJson(v));
      });
    }
    if (json['players'] != null) {
      players = <ServiceDetail_Players>[];
      json['players'].forEach((v) {
        players!.add(ServiceDetail_Players.fromJson(v));
      });
    }
    if (json['openMatchOptions'] != null) {
      options = OpenMatchOptions.fromJson(json['openMatchOptions']);
    }
    if (json['coaches'] != null) {
      coaches = <ServiceDetailCoach>[];
      json['coaches'].forEach((v) {
        coaches!.add(ServiceDetailCoach.fromJson(v));
      });
    }
    // Sort players if scores are submitted
    if ((scoreSubmitted ?? false) && (service?.isEvent ?? false)) {
      if (service?.isDoubleEvent ?? false) {
        players?.map((e) {
          e.position = e.getPlayerPosition ?? e.position;
        }).toList();
      } else {
        players?.sort((a, b) {
          final posA = a.getPlayerPosition;
          final posB = b.getPlayerPosition;

          // Players with positions come first
          if (posA == null && posB == null) return 0;
          if (posA == null) return 1;
          if (posB == null) return -1;

          // Sort by position ascending
          return posA.compareTo(posB);
        });
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (service != null) {
      data['service'] = service!.toJson();
    }
    data['is_cancelled'] = isCancelled;

    if (courts != null) {
      data['courts'] = courts!.map((v) => v.toJson()).toList();
    }
    if (players != null) {
      data['players'] = players!.map((v) => v.toJson()).toList();
    }
    super.toJson().forEach((key, value) {
      data[key] = value;
    });
    return data;
  }
}

class ServiceDetail_Service {
  double? price;
  String? serviceType;
  String? eventType;
  String? additionalService;
  ServiceDetail_Location? location;
  List<ServiceDetailCoach>? coaches;
  ServiceDetail_Event? event;
  ServiceDetail_Lesson? lesson;

  bool get isEvent => serviceType?.toLowerCase() == "event";

  bool get isDoubleEvent => eventType?.toLowerCase() == "double";

  int get coachesId {
    if ((coaches ?? []).isNotEmpty) {
      return coaches?.first.id ?? 0;
    }
    return 0;
  }

  ServiceDetail_Service({
    this.price,
    this.serviceType,
    this.eventType,
    this.additionalService,
    this.location,
    this.coaches,
    this.event,
    this.lesson,
  });

  ServiceDetail_Service.fromJson(Map<String, dynamic> json) {
    price = json['price'].toDouble();
    serviceType = json['service_type'];
    eventType = json['event_type'];
    additionalService = json['additional_service'];
    location = json['location'] != null
        ? ServiceDetail_Location.fromJson(json['location'])
        : null;
    if (json['coaches'] != null) {
      coaches = <ServiceDetailCoach>[];
      json['coaches'].forEach((v) {
        coaches!.add(ServiceDetailCoach.fromJson(v));
      });
    }

    event = json['event'] != null
        ? ServiceDetail_Event.fromJson(json['event'])
        : null;

    if (json['lesson'] != null) {
      lesson = ServiceDetail_Lesson.fromJson(json['lesson']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['service_type'] = serviceType;
    data['event_type'] = eventType;
    data['additional_service'] = additionalService;
    if (location != null) {
      data['location'] = location!.toJson();
    }

    if (coaches != null) {
      data['coaches'] = coaches!.map((v) => v.toJson()).toList();
    }
    if (event != null) {
      data['event'] = event!.toJson();
    }
    if (lesson != null) {
      data['lesson'] = lesson!.toJson();
    }
    return data;
  }
}

class ServiceDetail_Location {
  int? id;
  String? _locationName;
  String? currency;

  String get locationName => _locationName?.capitalizeFirst ?? '';

  ServiceDetail_Location({this.id, String? locationName, this.currency})
      : _locationName = locationName;

  ServiceDetail_Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    _locationName = json['location_name'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location_name'] = _locationName;
    data['currency'] = currency;
    return data;
  }
}

class ServiceDetail_Event {
  int? id;
  int? maximumCapacity;
  int? minimumCapacity;
  String? eventName;
  String? eventInfo;
  bool? waitingList;
  double? minLevelRestriction;
  double? maxLevelRestriction;

  String? get levelRestriction {
    if (minLevelRestriction == null && maxLevelRestriction == null) {
      return null;
    }
    if (minLevelRestriction == 0.0 && maxLevelRestriction == 0.0) {
      return null;
    }
    return '$minLevelRestriction - $maxLevelRestriction';
  }

  ServiceDetail_Event(
      {this.id,
      this.maximumCapacity,
      this.eventName,
      this.eventInfo,
      this.waitingList,
      this.minimumCapacity,
      this.minLevelRestriction,
      this.maxLevelRestriction});

  ServiceDetail_Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maximumCapacity = json['maximum_capacity'];
    eventName = json['event_name'];
    eventInfo = json['event_info'];
    waitingList = json['waiting_list'];
    minimumCapacity = json['minimum_capacity'];
    minLevelRestriction = json['min_level_restrication']?.toDouble();
    maxLevelRestriction = json['max_level_restrication']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['maximum_capacity'] = maximumCapacity;
    data['event_name'] = eventName;
    data['event_info'] = eventInfo;
    data['waiting_list'] = waitingList;
    data['minimum_capacity'] = minimumCapacity;
    data['min_level_restriction'] = minLevelRestriction;
    data['max_level_restriction'] = maxLevelRestriction;
    return data;
  }
}

class ServiceDetail_Courts {
  int? id;
  String? courtName;
  Sport? sport;

  ServiceDetail_Courts({this.id, this.courtName, this.sport});

  ServiceDetail_Courts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courtName = json['court_name'];
    sport = json['sport'] != null ? Sport.fromJson(json['sport']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['court_name'] = courtName;
    if (sport != null) {
      data['sport'] = sport!.toJson();
    }
    return data;
  }
}

class ServiceDetail_Players extends BookingPlayerBase {
  ServiceDetail_Players(
      {super.reservedPlayersCount,
      super.isWaiting,
      super.customer,
      super.otherPlayer,
      super.id,
      super.position});

  ServiceDetail_Players.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    customer = json['customer'] != null
        ? BookingCustomerBase.fromJson(json['customer'])
        : null;
  }
}

class ServiceDetail_Lesson {
  int? id;
  int? minimumCapacity;
  int? maximumCapacity;
  String? lessonName;
  String? eventInfo;
  double? minLevelRestriction;
  double? maxLevelRestriction;

  String? get levelRestriction {
    if (minLevelRestriction == null && maxLevelRestriction == null) {
      return null;
    }
    if (minLevelRestriction == 0.0 && maxLevelRestriction == 0.0) {
      return null;
    }
    return '$minLevelRestriction - $maxLevelRestriction';
  }

  ServiceDetail_Lesson(
      {this.id,
      this.minimumCapacity,
      this.maximumCapacity,
      this.lessonName,
      this.eventInfo,
      this.minLevelRestriction,
      this.maxLevelRestriction});

  ServiceDetail_Lesson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    minimumCapacity = json['minimum_capacity'];
    maximumCapacity = json['maximum_capacity'];
    lessonName = json['lesson_name'];
    eventInfo = json['event_info'];
    minLevelRestriction = json['min_level_restrication']?.toDouble();
    maxLevelRestriction = json['max_level_restrication']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['minimum_capacity'] = minimumCapacity;
    data['maximum_capacity'] = maximumCapacity;
    data['lesson_name'] = lessonName;
    data['event_info'] = eventInfo;
    data['min_level_restriction'] = minLevelRestriction;
    data['max_level_restriction'] = maxLevelRestriction;
    return data;
  }
}

class ServiceDetailCoach {
  String? fullName;
  int? id;
  String? profileUrl;
  String? description;

  ServiceDetailCoach({this.fullName, this.id, this.profileUrl});

  ServiceDetailCoach.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    id = json['id'];
    profileUrl = json['profile_url'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['id'] = id;
    data['profile_url'] = profileUrl;
    data['description'] = description;
    return data;
  }
}
