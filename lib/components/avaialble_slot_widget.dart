import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';

class AvailableSlotWidget extends StatelessWidget {
  AvailableSlotWidget({
    super.key,
    required this.text,
    required this.index,
    this.onTap,
    this.isHorizontal = false,
    this.otherTeamMemberID,
    this.textColor = AppColors.white,
    Color? backgroundColor,
    this.iconColor = AppColors.white,
    this.borderColor,
    this.padding,
  }) : backGroundColor = backgroundColor ?? AppColors.yellow;

  final String text;
  final Color textColor;
  final Color? backGroundColor;
  final Function(int, int?)? onTap;
  final int index;
  final bool isHorizontal;
  final int? otherTeamMemberID;
  final Color iconColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap!(index, otherTeamMemberID) : null,
      child: isHorizontal ? _horizontal() : _vertical(),
    );
  }

  _horizontal() {
    return Container(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: 5.w,
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _circle(),
          SizedBox(width: 15.h),
          _text(),
        ],
      ),
    );
  }

  Container _vertical() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      width: 62.w,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _circle(),
          SizedBox(height: 5.h),
          _text(),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  AutoSizeText _text() {
    return AutoSizeText(
      text,
      textAlign: TextAlign.center,
      maxFontSize: 15.sp,
      minFontSize: 9.sp,
      maxLines: 1,
      stepGranularity: 1.sp,
      style: AppTextStyles.sofiaSansMedium(
        color: textColor,
        fontSize: 15.sp,
      ),
    );
  }

  Container _circle() {
    return Container(
      height: 37.h,
      width: 37.w,
      decoration: BoxDecoration(
        color: backGroundColor != null ? backGroundColor : AppColors.yellow,
        borderRadius: BorderRadius.circular(6.r),
      ),
      padding: EdgeInsets.all(1.5.w),
      child: DottedBorder(
        borderType: BorderType.RRect,
        dashPattern: const [4, 4],
        radius: Radius.circular(6.r),
        color: iconColor,
        borderPadding: EdgeInsets.all(1.w),
        strokeWidth: 2.w,
        child: Container(
          // height: 48.h,
          // width: 37.w,
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            color: iconColor,
            size: 16.h,
          ),
        ),
      ),
    );
  }
}
