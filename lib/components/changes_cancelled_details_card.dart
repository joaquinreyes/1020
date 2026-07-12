import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/secondary_button.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../globals/utils.dart';

class ChangesCancelledDetailsCard extends StatelessWidget {
  const ChangesCancelledDetailsCard(
      {super.key, required this.heading, required this.description, this.contactPhone});

  final String heading;
  final String description;
  final String? contactPhone;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.only(
        left: 15.w,
        right: 10.w,
        top: 10.h,
        bottom: 15.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppImages.warning.path,
                width: 13.w,
                height: 13.w,
                color: AppColors.white,
              ),
              SizedBox(width: 10.w),
              Text(
                heading.toUpperCase(),
                style: AppTextStyles.sofiaSansMedium(
                  fontSize: 19.sp,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            description,
            style: AppTextStyles.manropeMedium(
              fontSize: 13.sp,
              color: AppColors.white,
            ),
          ),
          // SizedBox(height: 2.h),
          Align(
            alignment: Alignment.centerRight,
            child: SecondaryImageButton(
              onTap: () async {
                // await launchUrl(Uri.parse(sendUsMessageUrl));
                await Utils.openWhatsappSupport(context: context, phone: contactPhone);
              },
              label: "SEND_US_A_MESSAGE".tr(context),
              image: AppImages.whatsaapIcon.path,
              iconColor: AppColors.white,
              imageHeight: 14.w,
              imageWidth: 14.w,
              color: AppColors.white25,
              textColor: AppColors.white,
              applyShadow: false,
            ),
          ),
        ],
      ),
    );
  }
}
