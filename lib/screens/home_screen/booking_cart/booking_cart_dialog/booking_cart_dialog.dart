import 'package:hop/components/multi_style_text.dart';
import 'package:hop/models/multi_booking_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/repository/booking_repo.dart';
import 'package:hop/utils/custom_extensions.dart';
import '../../../../components/custom_dialog.dart';
import '../../../../components/multi_booking_info_card.dart';
import '../../../../components/secondary_text.dart';
import '../../../../globals/utils.dart';
import '../../../../repository/payment_repo.dart';
import '../../../payment_information/payment_information.dart';
import '../cart_booked_dialog.dart';

part 'components.dart';

part 'providers.dart';

class BookingCartDialog extends ConsumerStatefulWidget {
  const BookingCartDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookCourtDialogState();
}

class _BookCourtDialogState extends ConsumerState<BookingCartDialog> {
  @override
  Widget build(BuildContext context) {
    final bookingCartList = ref.watch(fetchBookingCartListProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        // maxHeight: MediaQuery.of(context).size.height / 1.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "BOOKING_INFORMATION".trU(context),
              style: AppTextStyles.popupHeaderTextStyle,
            ),
            // Text("BOOKING_INFORMATION".trU(context),
            //     style: AppTextStyles.gothamNarrowBold(
            //             fontSize: 19.sp, color: Colors.white)
            //         .copyWith(letterSpacing: 2.sp)),
            SizedBox(height: 5.h),
            Text(
              "CANCELLATION_POLICY".tr(context),
              textAlign: TextAlign.center,
              style: AppTextStyles.popupBodyTextStyle,
            ),
            SizedBox(height: 15.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${"YOUR_BOOKING_CART_DETAILS".trU(context)}:",
                style: AppTextStyles.sofiaSansMedium(
                  fontSize: 21.sp,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 20.h),
            bookingCartList.when(
              data: (data) {
                Future(() {
                  ref.read(totalMultiBookingAmount.notifier).state =
                      calculateAmountPayable(ref, data.fold(0.0, (sum, item) => sum + (item.totalPrice ?? 0)));
                });
                if (data.isEmpty) {
                  return SecondaryText(text: "NO_BOOKING_CART_FOUND".trU(context), color: Colors.white);
                }
                return Column(
                  children: [
                    MultiBookingCourtInfoCard(bookings: data, onTapDeleteBooking: _deleteBooking),
                    SizedBox(height: 26.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "BOOKING_PAYMENT".trU(context),
                        style: AppTextStyles.sofiaSansMedium(fontSize: 23.sp,color: AppColors.white),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    MainButton(
                      isForPopup: true,
                      label: "PAY_ALL_BOOKINGS".trU(context),
                      // child: MultiStyleTextFirstPositionBold(
                      //     text: "PAY_ALL_BOOKINGS".trU(context), fontSize: 18.sp, color: AppColors.black, textBoldPosition: 2),
                      onTap: () {
                        _payCourt(data);
                      },
                    ),
                    30.verticalSpace,
                  ],
                );
              },
              error: (error, stackTrace) {
                Future(() {
                  ref.read(totalMultiBookingAmount.notifier).state = 0;
                });
                return SecondaryText(text: error.toString(), color: AppColors.white);
              },
              loading: () {
                return const CupertinoActivityIndicator(radius: 10);
              },
            ),
          ],
        ),
      ),
    );
  }

  _payCourt(List<MultipleBookings> data) async {
    double price = data.fold(0.0, (sum, item) => sum + (item.totalPrice ?? 0));

    List<MultipleBookings>? multiBookingList = await showDialog(
      context: context,
      builder: (context) {
        return PaymentInformation(
            serviceID: data.first.bookingId,
            type: PaymentDetailsRequestType.booking,
            isMultiBooking: true,
            allowCoupon: false,
            locationID: data.first.locationId ?? 0,
            requestType: PaymentProcessRequestType.courtBooking,
            price: price,
            duration: null,
            startDate: null);
      },
    );
    ref.invalidate(fetchBookingCartListProvider);

    if (multiBookingList != null && mounted) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return CartBookedDialog(bookings: multiBookingList.isEmpty ? data : multiBookingList);
        },
      );
    }
  }

  _deleteBooking(MultipleBookings data) async {
    final provider = deleteCartProvider(data.sId ?? "");
    final bool? check = await Utils.showLoadingDialog(context, provider, ref);
    if (!mounted) {
      return;
    }
    if (check == null) {
      return;
    }
    ref.invalidate(fetchBookingCartListProvider);
  }
}
