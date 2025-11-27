import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/box_shadow/flutter_inset_box_shadow.dart' as inset;
import '../globals/constants.dart';

class RankedOrFriendly extends StatelessWidget {
  const RankedOrFriendly({
    super.key,
    this.isRanked = true,
  });

  final bool isRanked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: inset.BoxDecoration(
        boxShadow: kInsetShadow,
        color: AppColors.black5,
        borderRadius: BorderRadius.circular(100.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
      child: Row(
        children: [
          _buildWidget("FRIENDLY".tr(context), !isRanked),
          2.horizontalSpace,
          _buildWidget("RANKED".tr(context), isRanked),
        ],
      ),
    );
  }

  _buildWidget(String text, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(100.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
      child: Text(
        text,
        style: isSelected
            ? AppTextStyles.manropeSemiBold(
          fontSize: 13.sp,
          color: AppColors.white,
        )
            : AppTextStyles.manropeMedium(
          color: AppColors.black70,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}
