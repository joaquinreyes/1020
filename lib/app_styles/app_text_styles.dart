import 'package:hop/app_styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  const AppTextStyles();

  static TextStyle popupHeaderTextStyle = AppTextStyles.sofiaSansMedium(
    color: AppColors.white,
    fontSize: 26.sp,
  );

  static TextStyle get popupBodyTextStyle => AppTextStyles.manropeMedium(
        fontSize: 15.sp,
        color: AppColors.white,
      );

  /// New App Text Style

  static TextStyle manropeBold(
          {double? fontSize,
          Color? color,
          double? letterSpacing,
          double? height}) =>
      TextStyle(
        fontSize: fontSize ?? 19.sp,
        decoration: TextDecoration.none,
        color: color ?? AppColors.black,
        fontFamily: 'Manrope',
        letterSpacing: letterSpacing,
        height: height,
        fontWeight: FontWeight.w700,
      );

  static TextStyle manropeLight(
          {double? fontSize,
          Color? color,
          double? height,
          double? letterSpacing}) =>
      TextStyle(
        fontSize: fontSize ?? 14.sp,
        decoration: TextDecoration.none,
        color: color ?? AppColors.black,
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w300,
        height: height,
        letterSpacing: letterSpacing,
      );

  static TextStyle manropeExtraLight(
          {double? fontSize,
          Color? color,
          double? height,
          double? letterSpacing}) =>
      TextStyle(
        fontSize: fontSize ?? 14.sp,
        decoration: TextDecoration.none,
        color: color ?? AppColors.black,
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w200,
        height: height,
        letterSpacing: letterSpacing,
      );

  static TextStyle manropeRegularItalic(
          {double? fontSize, Color? color, TextDecoration? textDecoration}) =>
      TextStyle(
        fontSize: fontSize ?? 14.sp,
        decoration: textDecoration ?? TextDecoration.none,
        color: color ?? AppColors.black,
        fontFamily: 'Manrope',
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
      );

  static TextStyle manropeMedium(
          {double? fontSize,
          Color? color,
          double? height,
          double? letterSpacing}) =>
      TextStyle(
        fontSize: fontSize ?? 14.sp,
        decoration: TextDecoration.none,
        color: color ?? AppColors.black,
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w500,
        height: height,
        letterSpacing: letterSpacing,
      );

  static TextStyle manropeSemiBold(
          {double? fontSize, Color? color, double? letterSpacing}) =>
      TextStyle(
        fontSize: fontSize ?? 14.sp,
        decoration: TextDecoration.none,
        color: color ?? AppColors.black,
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w600,
        letterSpacing: letterSpacing,
      );

// TODO: not used them remove

static TextStyle sofiaSansMedium({double? fontSize, Color? color, double? letterSpacing,double? height}) => TextStyle(
      fontSize: fontSize ?? 14.sp,
      decoration: TextDecoration.none,
      color: color ?? AppColors.black,
      fontFamily: 'SofiaSansExtraCondensed',
      fontWeight: FontWeight.w500,
      letterSpacing: letterSpacing,
      height: height,
    );

static TextStyle sofiaSansRegular({double? fontSize, Color? color, double? letterSpacing}) => TextStyle(
      fontSize: fontSize ?? 14.sp,
      decoration: TextDecoration.none,
      color: color ?? AppColors.black,
      fontFamily: 'SofiaSansExtraCondensed',
      fontWeight: FontWeight.w400,
      letterSpacing: letterSpacing,
    );
}
