import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/c_divider.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/court_booking.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../models/active_memberships.dart';
import '../models/lesson_model_new.dart';
import '../models/membership_model.dart';

class BookCourtInfoCard extends ConsumerWidget {
  BookCourtInfoCard({
    Key? key,
    required this.bookings,
    required this.bookingTime,
    required this.courtName,
    required this.price,
    this.headerTextStyle0,
    this.textPrice,
    this.borderRadius,
    this.dividerColor,
    this.textColor,
    this.dataTextStyle0,
    Color? color,
  }) : color = color ?? AppColors.white;

  final Bookings bookings;
  final DateTime bookingTime;
  final String courtName;
  final String? textPrice;
  final Color color;
  final Color? dividerColor;
  final Color? textColor;
  final TextStyle? headerTextStyle0;
  final TextStyle? dataTextStyle0;
  final BorderRadius? borderRadius;
  final double? price;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime startTime = bookingTime;
    DateTime endTime = bookingTime.add(Duration(minutes: bookings.duration!));
    return Container(
      padding: EdgeInsets.all(15.h),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'LOCATION'.trU(context),
                style: headerTextStyle0 != null
                    ? headerTextStyle0
                    : AppTextStyles.sofiaSansMedium(
                        color: textColor ?? AppColors.brick,
                        fontSize: 21.sp,
                ),
              ),
              const Spacer(),
              Text(
                '${"DATE".trU(context)} & ${"TIME".trU(context)}',
                style: headerTextStyle0 != null
                    ? headerTextStyle0
                    : AppTextStyles.sofiaSansMedium(
                        fontSize: 21.sp,
                        color: textColor ?? AppColors.brick)
              ),
            ],
          ),
          CDivider(
            color: dividerColor ?? AppColors.brick25,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courtName.capitalizeFirst,
                      textAlign: TextAlign.start,
                      style: dataTextStyle0 != null
                          ? dataTextStyle0
                          : AppTextStyles.manropeMedium(
                              fontSize: 15.sp,
                              color: textColor ?? AppColors.brick,
                            ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      bookings.location?.locationName?.capitalizeFirst ?? '',
                      style: dataTextStyle0 != null
                          ? dataTextStyle0
                          : AppTextStyles.manropeMedium(
                        fontSize: 15.sp,
                        color: textColor ?? AppColors.brick,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      textPrice ??
                          "${"PRICE".tr(context)} ${Utils.formatPrice(price?.toDouble())}",
                      textAlign: TextAlign.start,
                      style: dataTextStyle0 != null
                          ? dataTextStyle0
                          : AppTextStyles.manropeMedium(
                        fontSize: 15.sp,
                        color: textColor ?? AppColors.brick,
                      ),
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //
                    //     if((showRefund ?? false) && ((refundAmount ?? 0) > 0))
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             "${"PAID".tr(context)} ${Utils.formatPrice((price ?? 0) + (refundAmount ?? 0))}",
                    //             textAlign: TextAlign.start,
                    //             style: dataTextStyle!=null ? dataTextStyle : AppTextStyles.aeonikRegular14,
                    //           ),
                    //           Text(
                    //             "${"REFUND".tr(context)} ${Utils.formatPrice(refundAmount)}",
                    //             textAlign: TextAlign.start,
                    //             style: dataTextStyle!=null ? dataTextStyle : AppTextStyles.aeonikRegular14,
                    //           )
                    //         ],
                    //       )
                    //   ],
                    // )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${startTime.format("h:mm")} - ${endTime.format("h:mm a").toLowerCase()}",
                      textAlign: TextAlign.center,
                      style: dataTextStyle0 != null
                          ? dataTextStyle0
                          : AppTextStyles.manropeMedium(
                        fontSize: 15.sp,
                        color: textColor ?? AppColors.brick,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      startTime.format("EE dd MMM"),
                      textAlign: TextAlign.center,
                      style: dataTextStyle0 != null
                          ? dataTextStyle0
                          : AppTextStyles.manropeMedium(
                        fontSize: 15.sp,
                        color: textColor ?? AppColors.brick,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "${bookings.duration} min",
                      textAlign: TextAlign.center,
                      style: dataTextStyle0 != null
                          ? dataTextStyle0
                          : AppTextStyles.manropeMedium(
                        fontSize: 15.sp,
                        color: textColor ?? AppColors.brick,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BookCourtInfoCardLesson extends ConsumerWidget {
  const BookCourtInfoCardLesson(
      {super.key,
      this.isBooked = false,
      this.title,
      required this.bookingTime,
      this.bgColor = AppColors.white,
      this.textColor,
      this.dividerColor,
      this.duration,
      this.courtName,
      this.lessonVariant,
      this.coachName,
      this.price,
      this.locationName});

  final Color? bgColor;
  final Color? textColor;
  final Color? dividerColor;
  final bool isBooked;
  final String? title;
  final int? duration;
  final DateTime bookingTime;
  final String? courtName;
  final String? coachName;
  final double? price;
  final String? locationName;
  final LessonVariants? lessonVariant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime startTime = bookingTime;
    DateTime endTime = bookingTime.add(Duration(minutes: duration!));
    return Container(
      padding: EdgeInsets.all(15.h),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(isBooked)
              Expanded(
                  child: Text(
                "${"Coach".trU(context)}  ${coachName?.toUpperCase() ?? ''} - ${courtName?.toUpperCase()} " /*'LOCATION'.tr(context)*/,
                style: AppTextStyles.sofiaSansMedium(
                    color: textColor ?? AppColors.brick,
                    fontSize: 23.sp),
              ),
              ),
              if(!isBooked)...[Text(
                '${"LOCATION".trU(context)}',
                style: AppTextStyles.sofiaSansMedium(
                  color: AppColors.brick,
                  fontSize: 21.sp,
                ),
              ),
              // SizedBox(width: 5.w),
              Text(
                '${"DATE".trU(context)} & ${"TIME".trU(context)}',
                style: AppTextStyles.sofiaSansMedium(
                  color: AppColors.brick,
                  fontSize: 21.sp,
                ),
              ),]
            ],
          ),
          CDivider(
            color: dividerColor ?? AppColors.brick25,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courtName?.capitalizeFirst ?? '',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.manropeMedium(
                        color: textColor ?? AppColors.brick,fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      locationName?.capitalizeFirst ?? '',
                      style: AppTextStyles.manropeMedium(
                        color: textColor ?? AppColors.brick,fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "${"PRICE".tr(context)} ${Utils.formatPrice(price?.toDouble())}",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.manropeMedium(
                        color: textColor ?? AppColors.brick,fontSize: 15.sp,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${startTime.format("h:mm")} - ${endTime.format("h:mm a").toLowerCase()}",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.manropeMedium(
                        color: textColor ?? AppColors.brick,fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      startTime.format("EE dd MMM"),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.manropeMedium(
                        color: textColor ?? AppColors.brick,fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "$duration mins${lessonVariant != null ? " : ${lessonVariant?.maximumCapacity ?? ""} pax" : ''}",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.manropeMedium(
                        color: textColor ?? AppColors.brick,fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WellnessClassesCourtInfoCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(15.h),
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: AppColors.white95,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'DEEP STRETCH',
                style: AppTextStyles.manropeBold(
                    color: AppColors.black, letterSpacing: 14.sp * 0.10),
              ),
            ],
          ),
          CDivider(),
          // SizedBox(height: 5.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Move Room',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.manropeLight(color: AppColors.black),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Price RUB 250',
                      style: AppTextStyles.manropeLight(color: AppColors.black),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Mon 24 Apr",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.manropeLight(color: AppColors.black),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '15:00 - 17:30 pm',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.manropeLight(color: AppColors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WellnessMembershipCourtInfoCard extends ConsumerWidget {
  final MembershipModel membershipModel;
  final ActiveMemberships? activeMembership;
  const WellnessMembershipCourtInfoCard({
    Key? key,
    required this.membershipModel,
    required this.activeMembership,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membershipName = (membershipModel.membershipName ?? "");
    final membershipPrice = membershipModel.price ?? 0;
    final duration = membershipModel.duration ?? "";
    return Container(
      padding: EdgeInsets.all(15.h),
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: AppColors.white95,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                membershipName,
                style: AppTextStyles.manropeBold(
                    color: AppColors.black90, letterSpacing: 14.sp * 0.10),
              ),
            ],
          ),
          CDivider(
            color: AppColors.lightGray,
          ),
          SizedBox(height: 5.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${"PRICE".tr(context)} ${Utils.formatPrice(membershipPrice)}",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.manropeLight(color: AppColors.black),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      duration,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.manropeLight(color: AppColors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
