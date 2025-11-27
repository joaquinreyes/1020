import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../app_styles/app_colors.dart';
import '../app_styles/app_text_styles.dart';
import '../routes/app_pages.dart';
import 'custom_dialog.dart';
import 'main_button.dart';

class TermsAndCondition extends ConsumerWidget {
  final bool showButton;
  final bool isTerms;
  final ScrollController scrollController;

  const TermsAndCondition(
      {super.key, this.isTerms = true, this.showButton = false,required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomDialog(
        color: AppColors.white,
        closeIconColor: AppColors.blue,
        contentPadding: EdgeInsets.only(top: 15.w, right: 15.w, left: 15.w,bottom: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              isTerms
                  ? "TERMS_AND_CONDITIONS".trU(context)
                  : "COMMUNICATIONS".trU(context),
              style: AppTextStyles.popupHeaderTextStyle.copyWith(color: AppColors.blue),
            ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              isTerms
                  ? "TERMS_AND_CONDITIONS_TEXT".tr(context)
                  : "COMMUNICATIONS_TEXT".tr(context),
              style: AppTextStyles.manropeMedium(
                  fontSize: 15.sp, color: AppColors.blue,),
              textAlign: TextAlign.center,
            ),

            if (showButton)
              Padding(
                  padding: EdgeInsets.only(top: 20.h, left: 15, right: 15),
                  child: MainButton(
                    label: "AGREE_AND_CONTINUE".trU(context),
                    isForPopup: true,
                    onTap: () {
                      ref.read(goRouterProvider).pop(true);
                    },
                    borderRadius: 12.r,
                    height: 40.h,
                    width: double.infinity,
                  )),
            SizedBox(
              height: 20.h,
            ),
          ],
        ));
  }
}
