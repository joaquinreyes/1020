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

  String format(String format, [String? locale]) {
    return DateFormat(format, locale ?? Intl.getCurrentLocale()).format(this);
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

/// Maps questionnaire text from API to translation keys
String translateQuestionnaireText(BuildContext context, String text) {
  // Normalize text by removing extra whitespace and line breaks
  final normalizedText = text.replaceAll(RegExp(r'\s+'), ' ').trim();

  final mapping = {
    // Questions
    'How long have you been playing pickleball?': 'Q_HOW_LONG_PLAYING_PICKLEBALL',
    'How long have you been playing padel?': 'Q_HOW_LONG_PLAYING_PADEL',
    'How often do you play pickleball?': 'Q_HOW_OFTEN_PLAY_PICKLEBALL',
    'How often do you play padel?': 'Q_HOW_OFTEN_PLAY_PADEL',
    "What's the highest level of competition you've played in?": 'Q_HIGHEST_COMPETITION_LEVEL',
    'How would you rate your serve?': 'Q_RATE_YOUR_SERVE',
    'How comfortable are you with volleys and smashes?': 'Q_COMFORTABLE_VOLLEYS_SMASHES',
    'How would you rate your overall strategy and court positioning?': 'Q_STRATEGY_COURT_POSITIONING',
    'How would you rate your ability to play dinks?': 'Q_RATE_ABILITY_DINKS',
    'How would you rate your footwork and ability to get to the ball?': 'Q_FOOTWORK_ABILITY_GET_TO_BALL',

    // Options - Duration
    'Less than 6 months': 'Q_LESS_THAN_6_MONTHS',
    '6 months to 1 year': 'Q_6_MONTHS_TO_1_YEAR',
    '1-2 years': 'Q_1_2_YEARS',
    '2-3 years': 'Q_2_3_YEARS',
    'More than 3 years': 'Q_MORE_THAN_3_YEARS',

    // Options - Frequency
    'Less than once a month': 'Q_LESS_THAN_ONCE_A_MONTH',
    '1-3 times a month': 'Q_1_3_TIMES_A_MONTH',
    '1-2 times a week': 'Q_1_2_TIMES_A_WEEK',
    '3 or more times a week': 'Q_3_OR_MORE_TIMES_A_WEEK',

    // Options - Competition
    'Friendly games only': 'Q_FRIENDLY_GAMES_ONLY',
    'Local tournaments': 'Q_LOCAL_TOURNAMENTS',
    'Regional tournaments': 'Q_REGIONAL_TOURNAMENTS',
    'National tournaments': 'Q_NATIONAL_TOURNAMENTS',

    // Options - Serve
    'Beginner - still learning basics': 'Q_BEGINNER_LEARNING_BASICS',
    'Intermediate - consistent but not powerful': 'Q_INTERMEDIATE_CONSISTENT_NOT_POWERFUL',
    'Intermediate+ - can place serves with some power': 'Q_INTERMEDIATE_PLUS_PLACE_SERVES_SOME_POWER',
    'Advanced - can place serves with good power': 'Q_ADVANCED_PLACE_SERVES_GOOD_POWER',
    'Expert - can consistently serve with power and placement': 'Q_EXPERT_CONSISTENTLY_SERVE_POWER_PLACEMENT',

    // Options - Volleys and Smashes
    'Not comfortable, avoid them when possible': 'Q_NOT_COMFORTABLE_AVOID',
    'Somewhat comfortable with volleys, struggle with smashes': 'Q_SOMEWHAT_COMFORTABLE_VOLLEYS_STRUGGLE_SMASHES',
    'Comfortable with volleys, can execute some smashes': 'Q_COMFORTABLE_VOLLEYS_SOME_SMASHES',
    'Comfortable with volleys, can execute most smashes': 'Q_COMFORTABLE_VOLLEYS_MOST_SMASHES',
    'Very comfortable, can consistently win points with volleys and smashes': 'Q_VERY_COMFORTABLE_WIN_POINTS',

    // Options - Strategy
    'Still learning basic positioning': 'Q_STILL_LEARNING_BASIC_POSITIONING',
    'Understand basic strategies but often struggle to implement': 'Q_UNDERSTAND_BASIC_STRUGGLE_IMPLEMENT',
    'Decent understanding of strategy, sometimes well-positioned': 'Q_DECENT_UNDERSTANDING_SOMETIMES_POSITIONED',
    'Good understanding of strategy, usually well-positioned': 'Q_GOOD_UNDERSTANDING_USUALLY_POSITIONED',
    'Advanced understanding, can adapt strategy mid-game': 'Q_ADVANCED_UNDERSTANDING_ADAPT_MID_GAME',

    // Options - Dinks
    'Beginner - I struggle with dinks': 'Q_BEGINNER_STRUGGLE_DINKS',
    'Intermediate - I can play basic defensive dinks': 'Q_INTERMEDIATE_BASIC_DEFENSIVE_DINKS',
    'Intermediate+ - I can play basic offensive and defensive dinks': 'Q_INTERMEDIATE_PLUS_OFFENSIVE_DEFENSIVE_DINKS',
    'Advanced - I can play offensive and defensive dinks effectively': 'Q_ADVANCED_OFFENSIVE_DEFENSIVE_EFFECTIVELY',
    'Expert - I can consistently win points with dinks': 'Q_EXPERT_CONSISTENTLY_WIN_POINTS_DINKS',

    // Options - Footwork
    'My footwork is inconsistent and often lags': 'Q_FOOTWORK_INCONSISTENT_LAGS',
    'Basic footwork but frequently slow to respond': 'Q_BASIC_FOOTWORK_FREQUENTLY_SLOW',
    'Decent footwork but occasionally slow to respond': 'Q_DECENT_FOOTWORK_OCCASIONALLY_SLOW',
    'Good footwork, typically well-positioned': 'Q_GOOD_FOOTWORK_TYPICALLY_POSITIONED',
    'Excellent footwork, always in position and agile': 'Q_EXCELLENT_FOOTWORK_ALWAYS_POSITIONED_AGILE',

    // Lobs question and options
    'How would you rate your ability to play lobs?': 'Q_RATE_ABILITY_LOBS',
    'Beginner - I struggle with lobs.': 'Q_BEGINNER_STRUGGLE_LOBS',
    'Intermediate - I can play basic defensive lobs.': 'Q_INTERMEDIATE_BASIC_DEFENSIVE_LOBS',
    'Intermediate+ - I can play basic offensive and defensive lobs.': 'Q_INTERMEDIATE_PLUS_OFFENSIVE_DEFENSIVE_LOBS',
    'Advanced - I can play offensive and defensive lobs effectively.': 'Q_ADVANCED_OFFENSIVE_DEFENSIVE_LOBS_EFFECTIVELY',
    'Expert - I can consistently win points with lobs.': 'Q_EXPERT_CONSISTENTLY_WIN_POINTS_LOBS',
  };

  // Try exact match first
  var key = mapping[text];
  if (key != null) {
    return key.tr(context);
  }

  // Try normalized match
  key = mapping[normalizedText];
  if (key != null) {
    return key.tr(context);
  }

  // Try matching with normalized keys
  for (final entry in mapping.entries) {
    final normalizedKey = entry.key.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalizedKey == normalizedText) {
      return entry.value.tr(context);
    }
  }

  return text;
}
