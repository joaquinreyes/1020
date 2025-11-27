import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';

class SecondaryText extends StatelessWidget {
  const SecondaryText({
    super.key,
    required this.text,
    this.color,
  });
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: AppTextStyles.manropeMedium(
          fontSize: 13.sp,
          color: color ?? AppColors.black,
        ),
      ),
    );
  }
}
