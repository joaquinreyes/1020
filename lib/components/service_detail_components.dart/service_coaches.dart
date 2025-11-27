import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/network_circle_image.dart';
import 'package:hop/models/service_detail_model.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../../globals/constants.dart';

class ServiceCoaches extends StatelessWidget {
  const ServiceCoaches({super.key, required this.coaches});

  final List<ServiceDetailCoach> coaches;

  @override
  Widget build(BuildContext context) {
    if (coaches.isEmpty) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 14.h),
        Text(
          "${"COACH".trU(context)} ${coaches.length}",
          style: AppTextStyles.sofiaSansMedium(
              fontSize: 23.sp,),
        ),
        SizedBox(height: 10.h),
        ListView.separated(
          shrinkWrap: true,
          itemCount: coaches.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          itemBuilder: (context, index) => _coachCard(coaches[index]),
        ),
      ],
    );
  }

  _coachCard(ServiceDetailCoach coach) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.black5,
        borderRadius: BorderRadius.circular(12.r),
        // border: border
      ),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 9.5.w),
                    child: NetworkCircleImage(
                      path: coach.profileUrl,
                      width: 37.w,
                      height: 37.w,
                      borderRadius: BorderRadius.circular(6.r),
                      boxBorder: Border.all(color: AppColors.white25),
                      bgColor: AppColors.blue,
                      logoColor: AppColors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 9.5.w),
                    child: Text(
                      "${coach.fullName?.toUpperCase()}",
                      maxLines: 1,
                      softWrap: true,
                      style: AppTextStyles.sofiaSansMedium(fontSize: 15.sp,),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              coach.description ?? "",
              style: AppTextStyles.manropeMedium(fontSize: 13.sp,),
            ),
          ),
        ],
      ),
    );
  }
}
