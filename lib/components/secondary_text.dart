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
  });
  final String text;
  final Color? color;
  final String? imagePath;
  final double? imageSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath != null) ...[
            Image.asset(
              imagePath!,
              height: imageSize ?? 60.h,
              width: imageSize ?? 60.w,
            ),
            SizedBox(height: 8.h),
          ],
          Text(
            text,
            style: AppTextStyles.manropeMedium(
              fontSize: 13.sp,
              color: color ?? AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
