import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hop/models/base_classes/booking_base.dart';
import 'package:hop/utils/dubai_date_time.dart';
import 'package:intl/intl.dart';

extension CustomTranslations on String {
  String tr(BuildContext context, {Map<String, String>? params}) {
    if (params != null) {
      params.forEach((key, value) {
        params[key] = FlutterI18n.translate(context, value);
      });
    }
    return FlutterI18n.translate(context, this, translationParams: params);
  }

  String trU(BuildContext context, {Map<String, String>? params}) {
    if (params != null) {
      params.forEach((key, value) {
        params[key] = FlutterI18n.translate(context, value);
      });
    }
    return FlutterI18n.translate(context, this, translationParams: params)
        .toUpperCase();
  }
}

extension CustomDouble on num {
  formatString() {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

    String s = this.toString().replaceAll(regex, '');
    return s;
  }
}

extension Position on int {
  String get getUserPosition {
    int position = this;
    if (position % 100 >= 11 && position % 100 <= 13) {
      return '${position}th';
    }
    switch (position % 10) {
      case 1:
        return '${position}st';
      case 2:
        return '${position}nd';
      case 3:
        return '${position}rd';
      default:
        return '${position}th';
    }
  }
}

extension StringTranslationExtension on String {
  String capitalWord(BuildContext context, bool canProceed,
      {Map<String, String>? params}) {
    return canProceed
        ? trU(context, params: params)
        : tr(context, params: params);
  }
}

extension StringExtension on String {
  bool get isValidEmail {
    RegExp exp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return exp.hasMatch(this);
  }

  String get capitalizeFirst {
    if (this.isEmpty) {
      return '';
    }
    var result = this.split(" ").map((e) {
      if (e.isNotEmpty) {
        return e[0].toUpperCase() + e.substring(1);
      } else {
        return e;
      }
    }).join(" ");
    return result;
  }
}

extension ListExtension on List {
  String? get(int index) {
    if (this.length > index) return this[index].toString();
    return null;
  }
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = Set();
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

extension CustomDateProperties on DateTime {
  DateTime get withoutTime {
    final now = DubaiDateTime.now().dateTime;
    return DubaiDateTime.custom(now.year, now.month, now.day).dateTime;
  }

  String format(String format) {
    return DateFormat(format).format(this);
  }

  bool get wasYesterday {
    final now = DubaiDateTime.now().dateTime;
    final nowDate = DubaiDateTime.custom(now.year, now.month, now.day).dateTime;
    return nowDate
        .subtract(const Duration(days: 1))
        .isAtSameMomentAs(DubaiDateTime.custom(year, month, day).dateTime);
  }

  bool get isToday {
    final now = DubaiDateTime.now().dateTime;
    return now.year == year && now.month == month && now.day == day;
  }

  bool get isTomorrow {
    final now = DubaiDateTime.now().dateTime;
    final nowDate = DubaiDateTime.custom(now.year, now.month, now.day).dateTime;
    return nowDate
        .add(const Duration(days: 1))
        .isAtSameMomentAs(DubaiDateTime.custom(year, month, day).dateTime);
  }

  bool get isFutureDay {
    final now = DubaiDateTime.now().dateTime;
    final nowDate = DubaiDateTime.custom(now.year, now.month, now.day).dateTime;
    return nowDate.isBefore(DubaiDateTime.custom(year, month, day).dateTime);
  }

  bool get isPastDay {
    final now = DubaiDateTime.now().dateTime;
    final nowDate = DubaiDateTime.custom(now.year, now.month, now.day).dateTime;
    return nowDate.isAfter(DubaiDateTime.custom(year, month, day).dateTime);
  }

  bool get isPresentDay {
    final now = DubaiDateTime.now().dateTime;
    return now.year == year && now.month == month && now.day == day;
  }
}

extension BookingBaseExtension on List<BookingBase> {
  List<DateTime> get dateList {
    final dateList = this.map((e) => e.bookingDate).toSet().toList();
    dateList.sort((a, b) => a.compareTo(b));
    return dateList;
  }
}
