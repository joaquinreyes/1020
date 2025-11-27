import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hop/models/base_classes/booking_base.dart';
import 'package:hop/models/base_classes/booking_player_base.dart';
import 'package:hop/models/service_detail_model.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../managers/user_manager.dart';

class UserBookings extends BookingBase {
  bool? isCancelled;
  Service? service;
  List<Courts>? courts;
  List<Players>? players;
  List<RequestWaitingList>? requestWaitingList;
  OpenMatchOptions? openMatchOptions;
  int get getMinimumCapacity =>
      minimumCapacity ?? service?.event?.minimumCapacity ?? service?.lesson?.minimumCapacity ?? 0;

  int get getMaximumCapacity =>
      maximumCapacity ?? service?.event?.maximumCapacity ?? service?.lesson?.maximumCapacity ?? 0;

  bool isPlayerPendingPayment(WidgetRef ref){
    final currentUserID = ref.read(userManagerProvider).user?.user?.id;
    return (players ?? []).any((element) =>
    element.customer?.id ==
        currentUserID && (element.status ?? "").toLowerCase() == "pending payment" &&
        !(element.isCanceled ?? false));
  }

  UserBookings(
      {super.id,
      super.date,
      super.startTime,
      super.coaches,
      super.endTime,
      super.isPrivateMatch,
      super.minimumCapacity,
      super.maximumCapacity,
      super.approveBeforeJoin,
      super.organizerNote,
      super.isFriendlyMatch,
      super.rankedEvent,
      super.scoreSubmitted,
      super.options,
      this.isCancelled,
      this.service,
      this.courts,
      this.openMatchOptions,
      this.players,
      this.requestWaitingList});


  int? getMyPositionEvent(int customerId) {
    final player = players?.firstWhere(
            (e) => e.customer?.id == customerId,
        orElse: () => Players());
    return player?.getPlayerPosition;
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

  String get courtName {
    if (courts != null && (courts?.isNotEmpty ?? true)) {
      return courts!.first.courtName!;
    }
    return '';
  }

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

  String get bookingLevel {
    if (openMatchOptions != null &&
        openMatchOptions!.maxLevel != null &&
        openMatchOptions!.minLevel != null) {
      return "${openMatchOptions!.minLevel ?? ""} - ${openMatchOptions!.maxLevel ?? ""}";
    }
    return '';
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

  UserBookings.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    isCancelled = json['is_cancelled'];
    isFriendlyMatch = json['friendly_match'];
    service =
        json['service'] != null ? Service.fromJson(json['service']) : null;
    if (json['courts'] != null) {
      courts = <Courts>[];
      json['courts'].forEach((v) {
        courts!.add(new Courts.fromJson(v));
      });
    } else {
      courts = null;
    }
    if (json['players'] != null) {
      players = <Players>[];
      json['players'].forEach((v) {
        players!.add(Players.fromJson(v));
      });
    } else {
      players = null;
    }
    if (json['requestWaitingList'] != null) {
      requestWaitingList = <RequestWaitingList>[];
      json['requestWaitingList'].forEach((v) {
        requestWaitingList!.add(RequestWaitingList.fromJson(v));
      });
    } else {
      requestWaitingList = null;
    }
    if (json['coaches'] != null) {
      coaches = <ServiceDetailCoach>[];
      json['coaches'].forEach((v) {
        coaches!.add(ServiceDetailCoach.fromJson(v));
      });
    }
    openMatchOptions = json['openMatchOptions'] != null
        ? new OpenMatchOptions.fromJson(json['openMatchOptions'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_cancelled'] = isCancelled;
    if (service != null) {
      data['service'] = service!.toJson();
    }
    if (courts != null) {
      data['courts'] = courts!.map((v) => v.toJson()).toList();
    }
    if (players != null) {
      data['players'] = players!.map((v) => v.toJson()).toList();
    }

    if (this.openMatchOptions != null) {
      data['openMatchOptions'] = this.openMatchOptions!.toJson();
    }
    super.toJson().forEach((key, value) {
      data[key] = value;
    });
    return data;
  }
}


class Service {
  double? price;
  String? serviceType;
  String? eventType;
  String? bookingType;
  Location? location;
  ServiceDetail_Event? event;
  ServiceDetail_Lesson? lesson;
  List<ServiceDetailCoach>? coaches;

  bool get isOpenMatch =>
      bookingType?.toLowerCase() == 'Open Match'.toLowerCase();

  bool get isEvent => serviceType?.toLowerCase() == 'Event'.toLowerCase();

  bool get isLesson => serviceType?.toLowerCase() == 'Lesson'.toLowerCase();

  bool get isSingleEvent => eventType?.toLowerCase() == 'Single'.toLowerCase();

  String get eventLessonName =>
      (isEvent ? event?.eventName ?? '' : lesson?.lessonName ?? '')
          .capitalizeFirst;

  Service(
      {this.price,
      this.serviceType,
      this.eventType,
      this.bookingType,
      this.location,
      this.event,
      this.lesson});

  Service.fromJson(Map<String, dynamic> json) {
    price = double.tryParse(json['price'].toString());
    serviceType = json['service_type'];
    eventType = json['event_type'];
    bookingType = json['booking_type'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    event = json['event'] != null
        ? new ServiceDetail_Event.fromJson(json['event'])
        : null;
    lesson = json['lesson'] != null
        ? new ServiceDetail_Lesson.fromJson(json['lesson'])
        : null;

    // If location is not directly in service, check inside event or lesson
    if (location == null) {
      if (json['event'] != null && json['event']['location'] != null) {
        location = new Location.fromJson(json['event']['location']);
      } else if (json['lesson'] != null && json['lesson']['location'] != null) {
        location = new Location.fromJson(json['lesson']['location']);
      }
    }

    if (json['coaches'] != null) {
      coaches = <ServiceDetailCoach>[];
      json['coaches'].forEach((v) {
        coaches!.add(new ServiceDetailCoach.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = price;
    data['service_type'] = serviceType;
    data['event_type'] = eventType;
    data['booking_type'] = bookingType;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (event != null) {
      data['event'] = event!.toJson();
    }
    if (lesson != null) {
      data['lesson'] = lesson!.toJson();
    }
    if (coaches != null) {
      data['coaches'] = coaches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Location {
  int? id;
  String? _locationName;
  String? currency;

  String get locationName => _locationName?.capitalizeFirst ?? '';

  Location({this.id, String? location, this.currency})
      : _locationName = location;

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    _locationName = json['location_name'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['location_name'] = locationName;
    data['currency'] = currency;
    return data;
  }
}

class Players extends BookingPlayerBase {
  Players({
    super.id,
    super.isWaiting,
    super.reservedPlayersCount,
    super.isOrganizer,
    super.otherPlayer,
    super.paidPrice,
    super.pendingPrice,
    super.isCanceled,
    super.position,
    super.customer,
    super.status,
  });

  Players.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    customer = json['customer'] != null
        ? new BookingCustomerBase.fromJson(json['customer'])
        : null;
  }

  Players.fromServiceDetailPlayer(ServiceDetail_Players player)
      : super(
          id: player.id,
          position: player.position,
          isCanceled: player.isCanceled,
          isOrganizer: player.isOrganizer,
          isWaiting: player.isWaiting,
          reservedPlayersCount: player.reservedPlayersCount,
          otherPlayer: player.otherPlayer,
          paidPrice: player.paidPrice,
          pendingPrice: player.pendingPrice,
          playerEventRanking: player.playerEventRanking,
          guest: player.guest,
          customer: player.customer != null
              ? BookingCustomerBase(
                  id: player.customer!.id,
                  firstName: player.customer!.firstName,
                  lastName: player.customer!.lastName,
                  customFields: player.customer!.customFields,
                  profileUrl: player.customer!.profileUrl,
                  last21Evaluation: player.customer!.last21Evaluation,
                  rankedMatchesPlayed: player.customer!.rankedMatchesPlayed,
                  winningStrike: player.customer!.winningStrike,
                )
              : null,
        );
}

class Courts {
  int? id;
  String? courtName;

  Courts({this.id, this.courtName});

  Courts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courtName = json['court_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['court_name'] = courtName;
    return data;
  }
}

class RequestWaitingList {
  final int? id;
  final String? status;

  RequestWaitingList({required this.id, required this.status});

  RequestWaitingList.fromJson(Map<String, dynamic> json)
      : id = json['customer_id'],
        status = json['status'];

  Map<String, dynamic> toJson() {
    return {
      'customer_id': id,
      'status': status,
    };
  }
}
