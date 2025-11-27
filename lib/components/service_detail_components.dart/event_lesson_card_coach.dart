import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/network_circle_image.dart';
import 'package:hop/models/service_detail_model.dart';
import 'package:hop/utils/custom_extensions.dart';

class EventLessonCardCoach extends StatelessWidget {
  const EventLessonCardCoach({
    super.key,
    required this.coaches,
    this.textColor,
    this.borderRadius,
  });
  final List<ServiceDetailCoach>? coaches;
  final Color? textColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    if (coaches == null || coaches!.isEmpty) {
      return const SizedBox();
    }
    final coach = coaches!.first;
    int coachCount = coaches?.length ?? 0;
    String coachName = coach.fullName ?? "";
    if (coachCount > 1) {
      coachName = "$coachName +${coachCount - 1}";
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        NetworkCircleImage(
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          path: coach.profileUrl,
          boxBorder: Border.all(color: AppColors.white25),
          width: 28.w,
          height: 28.w,
          bgColor: AppColors.blue,
          logoColor: AppColors.white,
        ),
        SizedBox(width: 5.w),
        Flexible(
          child: Text(
            coachName.trU(context),
            style: AppTextStyles.sofiaSansMedium(
              color: textColor ?? AppColors.black,
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class ClassCardCoach extends StatelessWidget {
  const ClassCardCoach({
    super.key,
    required this.coaches,
    this.textColor,
  });
  final List<ServiceDetailCoach>? coaches;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    if (coaches == null || coaches!.isEmpty) {
      return const SizedBox();
    }
    final coach = coaches!.first;
    int coachCount = coaches?.length ?? 0;
    String coachName = coach.fullName ?? "";
    if (coachCount > 1) {
      coachName = "$coachName +${coachCount - 1}";
    }
    return Container(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          NetworkCircleImage(
            borderRadius: BorderRadius.circular(4.r),
            path: coach.profileUrl,
            boxBorder: Border.all(color: AppColors.white25),
            width: 28.w,
            height: 28.w,
            bgColor: AppColors.black2,
            logoColor: AppColors.white,
          ),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              '${"COACH".trU(context)} ${coachName.trU(context)}',
              style: AppTextStyles.sofiaSansMedium(
                color: textColor ?? AppColors.black2,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
