import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/custom_extensions.dart';
import 'main_button.dart';

class ImageSourceSheet extends StatelessWidget {
  const ImageSourceSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.r),
          topRight: Radius.circular(5.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close,
                color: AppColors.blue,
                size: 16.sp,
              ),
            ),
          ),
          // MultiStyleTextFirstBold(text: 'CHANGE_PROFILE_PICTURE'.trU(context), fontSize: 19.sp, color: AppColors.black),
          Text(
            'CHANGE_PROFILE_PICTURE'.trU(context),
            style: AppTextStyles.popupHeaderTextStyle.copyWith(color: AppColors.blue),
          ),
          SizedBox(height: 20.h),
          MainButton(
            label: 'CAMERA'.tr(context),
            enabled: true,
            showArrow: true,
            color: AppColors.blue,
            borderColor: AppColors.blue,
            labelStyle: AppTextStyles.manropeSemiBold(
              fontSize: 17.sp,
              color: AppColors.white,
            ),
            onTap: () {
              Navigator.pop(context, ImageSource.camera);
            },
          ),
          SizedBox(height: 10.h),
          MainButton(
            label: 'GALLERY'.tr(context),
            enabled: true,
            showArrow: true,
            color: AppColors.blue,
            borderColor: AppColors.blue,
            labelStyle: AppTextStyles.manropeSemiBold(
              fontSize: 17.sp,
              color: AppColors.white,
            ),
            onTap: () {
              Navigator.pop(context, ImageSource.gallery);
            },
          ),
          // SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
