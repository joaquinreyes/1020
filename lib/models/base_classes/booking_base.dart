import 'package:hop/utils/dubai_date_time.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/globals/utils.dart';

import '../service_detail_model.dart';
import '../user_bookings.dart';

class BookingBase {
  String? startTime;
  String? endTime;
  String? date;
  String? eventInfo;
  int? id;
  bool? isFriendlyMatch;
  bool? isPrivateMatch;
  List<ServiceDetailCoach>? coaches;
  bool? approveBeforeJoin;
  String? organizerNote;
  bool? rankedEvent;
  bool? scoreSubmitted;
  OpenMatchOptions? options;
  List<RequestWaitingList>? requestWaitingList;

  int? minimumCapacity;
  int? maximumCapacity;

  BookingBase({
    this.date,
    this.startTime,
    this.endTime,
    this.eventInfo,
    this.id,
    this.coaches,
    this.isPrivateMatch,
    this.minimumCapacity,
    this.maximumCapacity,
    this.approveBeforeJoin,
    this.organizerNote,
    this.isFriendlyMatch,
    this.requestWaitingList,
    this.rankedEvent,
    this.scoreSubmitted,
    this.options,
  });

  int get timeDifferent {
    final startParts = startTime!.split(':').map(int.parse).toList();
    final endParts = endTime!.split(':').map(int.parse).toList();

    final startDateTime =
        DateTime(0, 1, 1, startParts[0], startParts[1], startParts[2]);
    var endDateTime = DateTime(0, 1, 1, endParts[0], endParts[1], endParts[2]);

    if (endDateTime.isBefore(startDateTime)) {
      endDateTime = endDateTime.add(const Duration(days: 1));
    }

    return endDateTime.difference(startDateTime).inMinutes;
  }

  String get openMatchLevelRange {
    if (options != null) {
      return "${options!.minLevel} - ${options!.maxLevel}";
    }
    return '';
  }

  bool get isPast {
    final now = DubaiDateTime.now().dateTime;

    return now.isAfter(bookingStartTime);
  }

  DateTime get bookingDate {
    if (date == null) {
      return DubaiDateTime.now().dateTime;
    }
    return DubaiDateTime.parse(date!).dateTime;
  }

  String get formatBookingDate {
    return bookingDate.format("EEE dd MMM");
  }

  DateTime get bookingStartTime {
    if (this.date == null) {
      return DubaiDateTime.now().dateTime;
    }
    final date = DubaiDateTime.parse(this.date!).dateTime;
    return Utils.serverTimeToDateTime(startTime!, date);
  }

  DateTime get bookingEndTime {
    if (this.date == null) {
      return DubaiDateTime.now().dateTime;
    }
    final date = DubaiDateTime.parse(this.date!).dateTime;
    return Utils.serverTimeToDateTime(endTime!, date);
  }

  String durationInMinutes() {
    return "${bookingEndTime.difference(bookingStartTime).inMinutes} min";
  }

  String get formattedDateStartEndTime {
    if (startTime == null) {
      return '';
    }
    return "${bookingDate.format("EEE dd MMM")} | ${bookingStartTime.format("HH:mm")} - ${bookingEndTime.format("HH:mm")}";
  }

  String get formattedDateStartEndTimeAM {
    if (startTime == null) {
      return '';
    }
    return "${bookingDate.format("EEE dd MMM")} | ${bookingStartTime.format("HH:mm")} - ${bookingEndTime.format("HH:mm a").toLowerCase()}";
  }

  String get formattedDateStartEndTimeAMH {
    if (startTime == null) {
      return '';
    }
    return "${bookingDate.format("EEE dd MMM")} | ${bookingStartTime.format("h:mm")} - ${bookingEndTime.format("h:mm a").toLowerCase()}";
  }

  String get formattedDateStartEndTimeAM12 {
    if (startTime == null) {
      return '';
    }
    return "${bookingDate.format("EEE dd MMM")} | ${bookingStartTime.format("h:mm")} - ${bookingEndTime.format("h:mm a").toLowerCase()}";
  }

  String get formatStartEndTime {
    if (startTime == null) {
      return '';
    }
    return "${bookingStartTime.format("HH:mm")} - ${bookingEndTime.format("HH:mm")}";
  }

  String get formatStartEndTimeAM {
    if (startTime == null) {
      return '';
    }
    return "${bookingStartTime.format("HH:mm")} - ${bookingEndTime.format("HH:mm a")}";
  }

  String get formatStartEndTimeAM12 {
    if (startTime == null) {
      return '';
    }
    return "${bookingStartTime.format("h:mm")} - ${bookingEndTime.format("h:mm a")}";
  }

  String get formattedDateStartEndTimeForShare {
    if (startTime == null) {
      return '';
    }
    return "${bookingDate.format("EEE dd MMM")}, ${bookingStartTime.format("HH:mm")} (${durationInMinutes()})";
  }

  BookingBase.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    eventInfo = json['event_info'];
    date = json['date'];
    isPrivateMatch = json['is_private_match'];
    id = json['id'];
    isFriendlyMatch = json['friendly_match'];
    approveBeforeJoin = json['approve_before_join'];
    organizerNote = json['organizer_notes'];
    minimumCapacity = json['minimum_capacity'];
    maximumCapacity = json['maximum_capacity'];
    rankedEvent = json['ranked_event'];
    if (json['requestWaitingList'] != null) {
      requestWaitingList = <RequestWaitingList>[];
      json['requestWaitingList'].forEach((v) {
        requestWaitingList!.add(RequestWaitingList.fromJson(v));
      });
    } else {
      requestWaitingList = null;
    }
    scoreSubmitted = json['score_submitted'];
    if (json['openMatchOptions'] != null) {
      options = OpenMatchOptions.fromJson(json['openMatchOptions']);
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
    data['date'] = date;
    data['event_info'] = eventInfo;
    data['start_time'] = startTime;
    data['is_private_match'] = isPrivateMatch;
    data['end_time'] = endTime;
    data['approve_before_join'] = approveBeforeJoin;
    data['organizer_notes'] = organizerNote;
    data['ranked_event'] = rankedEvent;
    data['score_submitted'] = scoreSubmitted;

    data['friendly_match'] = isFriendlyMatch;
    return data;
  }
}

class OpenMatchOptions {
  double? maxLevel;
  double? minLevel;

  OpenMatchOptions({this.maxLevel, this.minLevel});

  OpenMatchOptions.fromJson(Map<String, dynamic> json) {
    maxLevel = double.tryParse(json['max_level']?.toString() ?? '');
    minLevel = double.tryParse(json['min_level']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'max_level': maxLevel,
      'min_level': minLevel,
    };
  }
}
