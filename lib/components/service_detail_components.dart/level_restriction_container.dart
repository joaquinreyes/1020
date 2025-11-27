import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/utils/custom_extensions.dart';

class LevelRestrictionContainer extends StatelessWidget {
  const LevelRestrictionContainer({
    super.key,
    required this.levelRestriction,
  });

  final String? levelRestriction;

  @override
  Widget build(BuildContext context) {
    if (levelRestriction == null || levelRestriction!.isEmpty) {
      return const SizedBox();
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
      decoration: BoxDecoration(
        color: AppColors.white55,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [kBoxShadow],
      ),
      child: Text(
        "${"LEVEL".tr(context)} $levelRestriction",
        style: AppTextStyles.manropeSemiBold(fontSize: 13.sp),
      ),
    );
  }
}
