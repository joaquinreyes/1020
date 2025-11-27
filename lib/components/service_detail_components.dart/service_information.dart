import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/models/service_detail_model.dart';
import 'package:hop/utils/custom_extensions.dart';

class ServiceInformationText extends StatelessWidget {
  const ServiceInformationText({
    super.key,
    required this.service,
    this.desStyle,
    this.titleStyle,
  });

  final ServiceDetail service;
  final TextStyle? desStyle;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    if (service.info.isEmpty) {
      return SizedBox();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Row(
          children: [
            Image.asset(
              AppImages.infoIcon.path,
              width: 12.w,
              height: 12.h,
              color: AppColors.black,
            ),
            SizedBox(width: 10.w),
            Text(
              "INFORMATION".trU(context),
              style: titleStyle ??
                  AppTextStyles.sofiaSansMedium(
                      fontSize: 23.sp,),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
          child: Text(
            service.info,
            style: desStyle ??
                AppTextStyles.manropeMedium(
                    color: AppColors.black, fontSize: 13.sp),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
