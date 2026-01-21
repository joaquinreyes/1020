import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';

class SecondaryText extends StatelessWidget {
  const SecondaryText({
    super.key,
    required this.text,
    this.color,
    this.imagePath,
    this.imageSize,
    this.subtitle,
  });
  final String text;
  final Color? color;
  final String? imagePath;
  final double? imageSize;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null) ...[
              Image.asset(
                imagePath!,
                height: imageSize ?? 120.h,
                width: imageSize ?? 120.w,
              ),
              SizedBox(height: 24.h),
            ],
            Text(
              text,
              style: AppTextStyles.sofiaSansMedium(
                fontSize: 22.sp,
                color: color ?? AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: 12.h),
              Text(
                subtitle!,
                style: AppTextStyles.manropeMedium(
                  fontSize: 14.sp,
                  color: AppColors.black70,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
