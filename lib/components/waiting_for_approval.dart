import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/utils/custom_extensions.dart';

class WaitingForApproval extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  const WaitingForApproval({
    super.key,
    this.title,
    this.backgroundColor,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.blue,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 2.h,
        ),
        child: Text(
          title ?? "WAITING_FOR_APPROVAL".tr(context),
          style: titleStyle ??
              AppTextStyles.manropeSemiBold(
                color: AppColors.white,
                fontSize: 13.sp,
              ),
        ),
      ),
    );
  }
}
