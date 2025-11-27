import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../../app_styles/app_text_styles.dart';

class PrivateRankedComponent extends StatelessWidget {
  final bool isRanked;
  final bool isPrivate;

  const PrivateRankedComponent(
      {super.key, required this.isRanked, required this.isPrivate});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment:
          isPrivate ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
      children: [
        if (isPrivate)
          Container(
              decoration: BoxDecoration(
                boxShadow: [kBoxShadow],
                color: AppColors.white55,
                borderRadius: BorderRadius.circular(100.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
              child: Text(
                "PRIVATE".tr(context),
                style: AppTextStyles.manropeSemiBold(
                  fontSize: 13.sp,
                ),
              )),
        Container(
            decoration: BoxDecoration(
              boxShadow: [kBoxShadow],
              color: AppColors.white55,
              borderRadius: BorderRadius.circular(100.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
            child: Text(
              (isRanked ? "RANKED" : "FRIENDLY").tr(context),
              style: AppTextStyles.manropeSemiBold(
                fontSize: 13.sp,
              ),
            )),
        // isDupr
        //     ? Container(
        //         decoration: BoxDecoration(
        //             color: Colors.white),
        //         padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
        //         child: Text(
        //           "DUPR".tr(context),
        //           style: AppTextStyles.gothatmNarrowMedium(
        //               fontSize: 15.sp, color: Colors.black),
        //         ))
        //     : SizedBox(),
      ],
    );
  }
}
