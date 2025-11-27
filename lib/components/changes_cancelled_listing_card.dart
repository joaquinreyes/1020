import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/globals/images.dart';

class ChangesCancelledListingCard extends StatelessWidget {
  const ChangesCancelledListingCard({super.key,
    required this.text,
    this.color,
    this.iconColor,
    this.textColor,
    this.isUpperCase = true,
    this.padding,
    this.style});

  final String text;
  final Color? color;
  final Color? iconColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final TextStyle? style;
  final bool isUpperCase;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.yellow,
        borderRadius: BorderRadius.circular(100.r),
      ),
      padding: padding ?? EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppImages.warning.path,
            width: 13.h,
            height: 13.h,
            color: iconColor ?? AppColors.brick,
          ),
          SizedBox(width: 10.w),
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(
              isUpperCase ? text.toUpperCase() : text,
              style: style ?? AppTextStyles.sofiaSansMedium(fontSize: 17.sp, color: textColor ?? AppColors.brick),
            ),
          ),
        ],
      ),
    );
  }
}
