import 'package:hop/components/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/multi_style_text.dart';
import 'package:hop/components/secondary_button.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/screens/app_provider.dart';
import 'package:hop/utils/custom_extensions.dart';
import '../../../components/multi_booking_info_card.dart';
import '../../../models/multi_booking_model.dart';

class CartBookedDialog extends ConsumerStatefulWidget {
  const CartBookedDialog({super.key, required this.bookings});

  final List<MultipleBookings> bookings;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourtBookedDialogState();
}

class _CourtBookedDialogState extends ConsumerState<CartBookedDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        maxHeight: MediaQuery.of(context).size.height / 1.5,
        // contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Text(
              "BOOKING_CONFIRMED".trU(context),
              style: AppTextStyles.popupHeaderTextStyle,
              textAlign: TextAlign.center,
            )),
            SizedBox(height: 5.h),
            Text(
              "CANCELLATION_POLICY".tr(context),
              style: AppTextStyles.popupBodyTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            MultiBookingCourtInfoCard(
              bookings: widget.bookings,
              dividerColor: AppColors.black25,
              color: AppColors.yellow,
              textColor: AppColors.black2,
              showDelete: false,
            ),
            SizedBox(height: 15.h),
            SecondaryImageButton(
              label: "SEE_MY_MATCHES".tr(context),
              image: AppImages.tennisBall.path,
              isForPopup: true,
              applyShadow: false,
              imageHeight: 13.h,
              borderRadius: 5.r,
              imageWidth: 13.h,
              // labelStyle: AppTextStyles.qanelasLight(
              //     fontSize: 13.sp, color: AppColors.white),
              onTap: () {
                Future(() {
                  ref.read(pageControllerProvider).animateToPage(
                        2,
                        duration: kAnimationDuration,
                        curve: Curves.linear,
                      );
                  ref.read(pageIndexProvider.notifier).index = 2;
                });
                Navigator.pop(context);
              },
            ),
            // 30.verticalSpace,
          ],
        ));
  }
}
