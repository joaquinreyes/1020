import 'package:flutter/material.dart';
import 'package:hop/globals/utils.dart';

// https://www.figma.com/community/plugin/1267503782684933309/export-colors-as-dart
class AppColors {
  static const Color yellow = Color(0xFFFFDD77);
  static Color yellow25 = const Color(0xFFFFDD77).withOpacity(0.25);
  static Color yellow30 = const Color(0xFFFFDD77).withOpacity(0.30);
  static Color yellow50 = const Color(0xFFFFDD77).withOpacity(0.50);

  static const Color brick = Color(0xFF994433);
  static Color brick50 = const Color(0xFF994433).withOpacity(0.50);
  static Color brick25 = const Color(0xFF994433).withOpacity(0.25);

  static const Color black2 = Color(0xFF333333);
  static const Color intenseGreen = Color(0xFF595E49);

  static const Color black = Color(0xFF333333);
  static Color black90 = const Color(0xFF333333).withOpacity(0.90);
  static Color black70 = const Color(0xFF333333).withOpacity(0.70);
  static Color black25 = const Color(0xFF333333).withOpacity(0.25);
  static Color black5 = const Color(0xFF333333).withOpacity(0.05);
  static Color black10 = black2.withOpacity(0.10);
  static Color black50 = black2.withOpacity(0.5);

  static const blue = Color(0xFF335577);
  static Color blue50 = Color(0xFF335577).withOpacity(0.50);

  static const Color chatColor = Color(0xFFE5E5D7);
  static const Color alysumWhite = Color(0xFFF9F9F7);
  static const Color white = Color(0xFFEEEEE0);
  static Color white95 = const Color(0xFFEEEEE0).withOpacity(0.95);
  static Color white55 = const Color(0xFFEEEEE0).withOpacity(0.55);
  static Color white25 = const Color(0xFFEEEEE0).withOpacity(0.25);
  static Color white10 = const Color(0xFFEEEEE0).withOpacity(0.10);
  static Color backgroundColor = Color(0xFFEEEEE0);
  static Color tileBgColor = Color(0xFFF3F3F3);
  static Color circleBgColor = Color(0xFF90A1AB);
  static Color transparentColor = Colors.transparent;

  static Color darkRosewood = Color(0xffAA867B);

  static const Color darkGray = Color(0xff69756F);
  static Color darkGray50 = const Color(0xff69756F).withOpacity(0.50);
  static const Color lightGray = Color(0xffF4F4F4);

  static const errorColor = Color(0xFFD32F2F);

  static Color get standardGold50Popup => Utils.calculateColorOverBackground(AppColors.yellow50, "80", AppColors.white);

//TODO: IF not used remove all
  static const orange = Color(0xFFF26A2B);
  static const orange50 = Color(0x7FF26A2B);
  static const lightOrange35 = Color(0x59FDE4C5);
  static const blue2 = Color(0xFF0B63AA);

  static Color get orange50Popup => Utils.calculateColorOverBackground(AppColors.orange50, "7F", AppColors.white);

  static Color get lightOrange35Popup => Utils.calculateColorOverBackground(AppColors.lightOrange35, "59", AppColors.white);

  static Color get white25Popup => Utils.calculateColorOverBackground(AppColors.white, "3F", AppColors.white);
}
