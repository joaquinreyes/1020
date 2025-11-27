import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/components/secondary_text.dart';
import 'package:hop/components/secondary_textfield.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/coupon_model.dart';
import 'package:hop/models/payment_methods.dart';
import 'package:hop/repository/payment_repo.dart';
import 'package:hop/repository/stripe_repo.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../globals/constants.dart';
import '../../models/court_price_model.dart';
import '../../repository/booking_repo.dart';
import '../../routes/app_pages.dart';
import '../home_screen/tabs/booking_tab/book_court_dialog/book_court_dialog.dart';

part 'add_card.dart';

part 'payment_components.dart';

final _selectedPaymentMethod = StateProvider<AppPaymentMethods?>((ref) => null);
final _selectedRedeem = StateProvider<AppPaymentMethods?>((ref) => null);
final _selectedWalelt = StateProvider<Wallets?>((ref) => null);
final _appliedCoupon = StateProvider<CouponModel?>((ref) => null);
final _invalidCoupon = StateProvider<bool>((ref) => false);
final _amountPayable = StateProvider<double>((ref) => 0.0);
final _selectedMDR = StateProvider<MDRRates?>((ref) => null);


class PaymentInformation extends ConsumerStatefulWidget {
  const PaymentInformation(
      {super.key,
      required this.locationID,
      required this.price,
      required this.type,
      required this.requestType,
      required this.serviceID,
      required this.startDate,
      required this.duration,
      this.isJoiningApproval = false,
      this.courtPriceModel,
      this.courtId,
      this.variantId,
      this.allowCoupon = true,
      this.bookingToOpenMatch = false,
      this.allowMembership = true,
      this.allowWallet = true,
      this.purchaseMembership = false,
      this.isMultiBooking = false,
      this.getPendingPayment = false,
      this.isOpenMatch = false,
      this.allowPayLater = true,
      this.title});

  final CourtPriceModel? courtPriceModel;

  final bool isMultiBooking;
  final int locationID;
  final double price;
  final int? serviceID;
  final PaymentProcessRequestType requestType;
  final bool isJoiningApproval;
  final PaymentDetailsRequestType type;
  final bool allowCoupon;
  final bool bookingToOpenMatch;
  final String? title;
  final DateTime? startDate;
  final int? duration;
  final int? courtId;
  final int? variantId;
  final bool allowMembership;
  final bool allowWallet;
  final bool purchaseMembership;
  final bool allowPayLater;
  final bool isOpenMatch;
  final bool getPendingPayment;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __PaymentInformationState();
}

class __PaymentInformationState extends ConsumerState<PaymentInformation> {
  @override
  void initState() {
    Future(() {
      ref.read(_selectedPaymentMethod.notifier).state = null;
      ref.read(_selectedRedeem.notifier).state = null;
      ref.read(_selectedWalelt.notifier).state = null;
      ref.read(_appliedCoupon.notifier).state = null;
      ref.read(_invalidCoupon.notifier).state = false;
      ref.read(_amountPayable.notifier).state = widget.price;
      ref.read(_selectedMDR.notifier).state = null;
      ref.read(totalMultiBookingAmount.notifier).state = calculateAmountPayable(ref, widget.price);
    });
    super.initState();
  }

  final TextEditingController _couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final paymentDetails =
        ref.watch(fetchAllPaymentMethodsProvider(widget.locationID, widget.serviceID ?? 0, widget.type, widget.startDate, widget.duration,courtId: widget.courtId,variantId: widget.variantId,isOpenMatch: widget.isOpenMatch));
    final appliedCoupon = ref.watch(_appliedCoupon);
    final cancellationHour = widget.courtPriceModel?.cancellationPolicy?.cancellationTimeInHours;
    return CustomDialog(
      maxHeight: MediaQuery.of(context).size.height * 0.85,
      onTapCloseIcon: () async {
        final confirmationDialog = await showDialog(
          context: context,
          builder: (context) {
            return _CloseConfirmationDialog(showDescription: !widget.purchaseMembership);
          },
        );

        if (confirmationDialog == true) {
          if (widget.isMultiBooking) {
            ref.invalidate(fetchBookingCartListProvider);
          }
          Navigator.pop(context);
        }
      },
      child: Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SizedBox(height: 5.h),
            Text(
              "PAYMENT_INFORMATION".trU(context),
              style: AppTextStyles.popupHeaderTextStyle,
            ),
            SizedBox(height: 5.h),
            cancellationHour != null
                ? Text(
                    cancellationHour == 0
                        ? "YOU_WILL_NOT_GET_REFUND_ON_THIS_BOOKING".tr(context)
                        : "CANCELLATION_POLICY_HOURS".tr(context, params: {"HOUR": cancellationHour.toString()}),
                    style: AppTextStyles.popupBodyTextStyle,
                    textAlign: TextAlign.center,
                  )
                : Text(
                    "PAYMENT_INFORMATION_TEXT".tr(context),
                    style: AppTextStyles.popupBodyTextStyle,
                    textAlign: TextAlign.center,
                  ),

            if (widget.allowCoupon)
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Expanded(
                        child: Text(
                          "DO_YOU_HAVE_A_DISCOUNT_COUPON".trU(context),
                          style: AppTextStyles.sofiaSansMedium(fontSize: 21.sp,color: AppColors.white,),
                        ),
                      ),
                      Text(
                        " ${"OPTIONAL".tr(context).toLowerCase()}",
                        style: AppTextStyles.manropeMedium(
                          fontSize: 15.sp,
                          color: AppColors.white,
                        ),
                      )
                    ]),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white25,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: SecondaryTextField(
                      hintText: "ENTER_COUPON_HERE".tr(context),
                      controller: _couponController,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      onChanged: (value) {
                        setState(() {});
                        ref.read(_appliedCoupon.notifier).state = null;
                        ref.read(_invalidCoupon.notifier).state = false;
                        ref.read(totalMultiBookingAmount.notifier).state = calculateAmountPayable(ref, widget.price);
                      },
                      hintTextStyle: AppTextStyles.manropeLight(
                          color: AppColors.white55, fontSize: 13.sp),
                      style: AppTextStyles.manropeMedium()
                          .copyWith(color: AppColors.white, fontSize: 13.sp),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (appliedCoupon == null || _couponController.text != appliedCoupon.coupon) ...[
                            _CouponApplyButton(
                              price: widget.price,
                              couponController: _couponController,
                            ),
                          ] else ...[
                            Image.asset(
                              AppImages.checkMark.path,
                              width: 16.h,
                              height: 16.h,
                              color: AppColors.yellow,
                            ),
                          ],
                          SizedBox(width: 4.w),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 10.h),
            _AmountPayable(
              originalAmount: widget.price,
            ),
            20.verticalSpace,
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     "${"Add_PAYMENT_METHOD".trU(context)}",
            //     style: AppTextStyles.sofiaSansMedium(fontSize: 21.sp,color: AppColors.white,),
            //     textAlign: TextAlign.start,
            //   ),
            // ),
            // 5.verticalSpace,
            // _buildAddCardWidget(),
            // SizedBox(height: 20.h),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${"SELECT_PAYMENT_METHOD".trU(context)}",
                  style: AppTextStyles.sofiaSansMedium(fontSize: 21.sp,color: AppColors.white),
                  textAlign: TextAlign.start,
                )),
            15.verticalSpace,
            paymentDetails.when(
              skipLoadingOnRefresh: false,
              data: (data) {
                // return Container();
                return Flexible(child: _body(data));
              },
              error: (error, stackTrace) {
                myPrint("Error: $error");
                myPrint("Stack Trace: $stackTrace");
                return SecondaryText(
                  text: error.toString(),
                  color: AppColors.white,
                );
              },
              loading: () => Center(
                child: CupertinoActivityIndicator(color: AppColors.black25),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _body(
    PaymentDetails data,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: _PaymentMethods(
            allowPayLater: widget.allowPayLater,
            isOpenMatch: widget.isOpenMatch,
            courtId: widget.courtId,
            variantId: widget.variantId,
            bookingToOpenMatch: widget.bookingToOpenMatch,
            isMultiBooking: widget.isMultiBooking,
            paymentDetails: data,
            price: widget.price,
            locationID: widget.locationID,
            serviceID: widget.serviceID,
            requestType: widget.type,
            allowMembership: widget.allowMembership,
            allowWallet: widget.allowWallet,
            duration: widget.duration,
            startDate: widget.startDate,
          ),
        ),
        SizedBox(height: 10.h),
        _PaymentButton(
          title: widget.title,
          // boldPosition: widget.boldPosition,
          getPendingPayment: widget.getPendingPayment,
          bookingToOpenMatch: widget.bookingToOpenMatch,
          isMultiBooking: widget.isMultiBooking,
          price: widget.price,
          requestType: widget.requestType,
          serviceID: widget.serviceID,
          locationID: widget.locationID,
          purchaseMembership: widget.purchaseMembership,
          isJoiningApproval: widget.isJoiningApproval,
        )
      ],
    );
  }

  Widget _buildAddCardWidget() {
    return InkWell(
      onTap: () async {
        final bool? added = await showDialog(
          context: context,
          builder: (context) {
            return _AddCard();
          },
        );
        if (added == true) {
          ref.invalidate(fetchAllPaymentMethodsProvider(widget.locationID, widget.serviceID ?? 0, widget.type, widget.startDate, widget.duration,courtId: widget.courtId,variantId: widget.variantId,isOpenMatch: widget.isOpenMatch));
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 15.h, bottom: 10.h),
        decoration: BoxDecoration(
          color: AppColors.white25,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppImages.creditCardIcon.path,
              height: 67.h,
              width: 67.h,
              color: AppColors.white,
            ),
            SizedBox(height: 15.h),
            Text(
              "ADD_CREDIT_DEBIT_CARD".tr(context),
              style: AppTextStyles.manropeMedium(fontSize: 15.sp,color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }

// double _calculateAmountPayable() {
//   final coupon = ref.watch(_appliedCoupon);
//   final redeem = ref.watch(_selectedRedeem);
//   double? payableAmount = widget.price;
//   if (coupon != null) {
//     payableAmount -= coupon.discount ?? 0;
//   }
//   if (redeem != null) {
//     payableAmount -= redeem.walletBallance ?? 0;
//   }
//   return payableAmount;
// }
}

double calculateAmountPayable(WidgetRef ref, double price) {
  final coupon = ref.watch(_appliedCoupon);
  final redeem = ref.watch(_selectedRedeem);
  double payableAmount = price;
  if (coupon != null) {
    payableAmount -= coupon.discount ?? 0;
  }
  if (redeem != null) {
    payableAmount -= redeem.walletBalance ?? 0;
  }
  return payableAmount;
}
