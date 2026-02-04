import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lob/components/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lob/app_styles/app_colors.dart';
import 'package:lob/app_styles/app_text_styles.dart';
import 'package:lob/components/main_button.dart';
import 'package:lob/components/secondary_text.dart';
import 'package:lob/components/secondary_textfield.dart';
import 'package:lob/globals/images.dart';
import 'package:lob/globals/utils.dart';
import 'package:lob/models/coupon_model.dart';
import 'package:lob/models/payment_methods.dart';
import 'package:lob/repository/payment_repo.dart';
import 'package:lob/repository/stripe_repo.dart';
import 'package:lob/utils/custom_extensions.dart';
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

// class PaymentInformation extends StatefulWidget {
//   const PaymentInformation({
//     super.key,
//     required this.locationID,
//     required this.price,
//     required this.type,
//     required this.requestType,
//     required this.serviceID,
//     required this.startDate,
//     required this.duration,
//     this.isJoiningApproval = false,
//     this.allowCoupon = true,
//     this.bookingToOpenMatch = false,
//     this.allowMembership = true,
//     this.allowWallet = true,
//     this.purchaseMembership = false,
//     this.isMultiBooking = false,
//     this.title
//   });
//
//   final bool isMultiBooking;
//   final int locationID;
//   final double price;
//   final int? serviceID;
//   final PaymentProcessRequestType requestType;
//   final bool isJoiningApproval;
//   final PaymentDetailsRequestType type;
//   final bool allowCoupon;
//   final bool bookingToOpenMatch;
//   final String? title;
//   final DateTime? startDate;
//   final int? duration;
//   final bool allowMembership;
//   final bool allowWallet;
//   final bool purchaseMembership;
//
//   @override
//   State<PaymentInformation> createState() => _PaymentInformationState();
// }
//
// class _PaymentInformationState extends State<PaymentInformation> {
//   // bool proceed = true;
//   // ScrollController scrollController = ScrollController();
//
//   @override
//   Widget build(BuildContext context) {
//     // if (proceed) {
//     return _PaymentInformation(
//       isMultiBooking: widget.isMultiBooking,
//       type: widget.type,
//       locationID: widget.locationID,
//       price: widget.price,
//       requestType: widget.requestType,
//       serviceID: widget.serviceID,
//       isJoiningApproval: widget.isJoiningApproval,
//       allowCoupon: widget.allowCoupon,
//       bookingToOpenMatch: widget.bookingToOpenMatch,
//       duration: widget.duration,
//       startDate: widget.startDate,
//       purchaseMembership: widget.purchaseMembership,
//       title: widget.title,
//     );
//     // }
//     // return CustomDialog(
//     //    physics: NeverScrollableScrollPhysics(),
//     //     color: AppColors.green,
//     //     child: Flexible(
//     //       child: Column(
//     //         mainAxisSize: MainAxisSize.min,
//     //         children: [
//     //           Text(
//     //             "RELEASE_OF_LIABILITY".trU(context),
//     //             style: AppTextStyles.aronExtrabold()
//     //                 .copyWith(color: AppColors.white, fontSize: 19.sp),
//     //           ),
//     //           SizedBox(height: 20.h),
//     //           CupertinoScrollbar(
//     //             thumbVisibility: true,
//     //             controller: scrollController,
//     //             child: Container(
//     //               padding:
//     //                   EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
//     //               height: MediaQuery.of(context).size.height * 0.3,
//     //               decoration: BoxDecoration(
//     //                 color: AppColors.white,
//     //                 borderRadius: BorderRadius.circular(7.r),
//     //               ),
//     //               child: SingleChildScrollView(
//     //                 physics: BouncingScrollPhysics(),
//     //                 controller:scrollController,
//     //                 child: Text(
//     //                   "RELEASE_OF_LIABILITY_DESC".tr(context),
//     //                   textAlign: TextAlign.center,
//     //                   style: AppTextStyles.aronMedium().copyWith(
//     //                     color: Colors.black,
//     //                   ),
//     //                 ),
//     //               ),
//     //             ),
//     //           ),
//     //           SizedBox(height: 20.h),
//     //           InkWell(
//     //             onTap: () {
//     //               setState(() {
//     //                 proceed = !proceed;
//     //               });
//     //             },
//     //             child: Row(
//     //               children: [
//     //                 _CustomCheckBox(
//     //                   isChecked: proceed,
//     //                   onChanged: (value) {
//     //                     setState(() {
//     //                       proceed = value;
//     //                     });
//     //                   },
//     //                 ),
//     //                 SizedBox(width: 10.w),
//     //                 // DM Sans/Regular/Aeonik Regular 15
//     //                 Text(
//     //                   "ACCEPT_TERMS_AND_PROCEED_TO_PAYMENT".tr(context),
//     //                   style: AppTextStyles.aronMedium().copyWith(
//     //                     color: AppColors.white,
//     //                   ),
//     //                 ),
//     //               ],
//     //             ),
//     //           )
//     //         ],
//     //       ),
//     //     ));
//   }
// }

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
      this.title});

  final CourtPriceModel? courtPriceModel;

  final bool isMultiBooking;
  final int locationID;
  final double price;
  final int? serviceID;
  final int? courtId;
  final int? variantId;
  final PaymentProcessRequestType requestType;
  final bool isJoiningApproval;
  final PaymentDetailsRequestType type;
  final bool allowCoupon;
  final bool bookingToOpenMatch;
  final String? title;
  final DateTime? startDate;
  final int? duration;
  final bool allowMembership;
  final bool allowWallet;
  final bool purchaseMembership;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __PaymentInformationState();
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
      ref.read(totalMultiBookingAmount.notifier).state =
          calculateAmountPayable(ref, widget.price);
    });
    super.initState();
  }

  final TextEditingController _couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final paymentDetails = ref.watch(fetchAllPaymentMethodsProvider(
        widget.locationID,
        widget.serviceID ?? 0,
        widget.type,
        widget.startDate,
        widget.duration));
    final appliedCoupon = ref.watch(_appliedCoupon);
    final cancellationHour = widget.courtPriceModel?.cancellationPolicy?.cancellationTimeInHours;
    return CustomDialog(
      maxHeight: MediaQuery.of(context).size.height * 0.85,
      onTapCloseIcon: () async {
        if (widget.isMultiBooking) {
          ref.invalidate(fetchBookingCartListProvider);
        }
        Navigator.pop(context);
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
                      ? "YOU_WILL_NOT_GET_REFUND_ON_THIS_BOOKING"
                          .tr(context)
                      : "CANCELLATION_POLICY_HOURS".tr(context,
                          params: {"HOUR": cancellationHour.toString()}),
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
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              "DO_YOU_HAVE_A_DISCOUNT_COUPON".tr(context),
                              style: AppTextStyles.popupBodyTextStyle,
                            ),
                          ),
                          Text(
                            " ${"OPTIONAL".tr(context).toLowerCase()}",
                            style: AppTextStyles.gothicLight(
                              color: AppColors.white,
                            ),
                          )
                        ]),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white25,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: SecondaryTextField(
                      hintText: "ENTER_COUPON_HERE".tr(context),
                      controller: _couponController,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8),
                      onChanged: (value) {
                        setState(() {});
                        ref.read(_appliedCoupon.notifier).state = null;
                        ref.read(_invalidCoupon.notifier).state = false;
                        ref.read(totalMultiBookingAmount.notifier).state =
                            calculateAmountPayable(ref, widget.price);
                      },
                      cursorColor: AppColors.white,
                      borderColor: AppColors.mediumGreen,
                      hintTextStyle: AppTextStyles.gothicLight(
                          color: AppColors.white55, fontSize: 13.sp),
                      style: AppTextStyles.gothicRegular()
                          .copyWith(color: AppColors.white, fontSize: 13.sp),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (appliedCoupon == null ||
                              _couponController.text !=
                                  appliedCoupon.coupon) ...[
                            _CouponApplyButton(
                              price: widget.price,
                              couponController: _couponController,
                            ),
                          ] else ...[
                            Image.asset(
                              AppImages.checkMark.path,
                              width: 18.w,
                              height: 18.w,
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
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${"Add_PAYMENT_METHOD".tr(context)}",
                style: AppTextStyles.gothicRegular(
                    color: AppColors.white, fontSize: 17.sp),
                textAlign: TextAlign.start,
              ),
            ),
            5.verticalSpace,
            _buildAddCardWidget(),
            SizedBox(height: 20.h),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${"SELECT_PAYMENT_METHOD".tr(context)}",
                  style: AppTextStyles.gothicLight(
                      color: AppColors.white, fontSize: 17.sp),
                  textAlign: TextAlign.start,
                )),
            SizedBox(height: 15.h),
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
                child: CupertinoActivityIndicator(color: AppColors.white25),
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
            bookingToOpenMatch: widget.bookingToOpenMatch,
            isMultiBooking: widget.isMultiBooking,
            paymentDetails: data,
            price: widget.price,
            finalPrice : getAmountByCoupon(ref, widget.price),
            locationID: widget.locationID,
            serviceID: widget.serviceID,
            requestType: widget.type,
            allowMembership: widget.allowMembership,
            allowWallet: widget.allowWallet,
            duration: widget.duration,
            startDate: widget.startDate,
          ),
        ),
        SizedBox(height: 5.h),
        _PaymentButton(
          title: widget.title,
          // boldPosition: widget.boldPosition,
          bookingToOpenMatch: widget.bookingToOpenMatch,
          isMultiBooking: widget.isMultiBooking,
          price: widget.price,
          requestType: widget.requestType,
          finalPrice : getAmountByCoupon(ref, widget.price),
          serviceID: widget.serviceID,
          locationID: widget.locationID,
          purchaseMembership: widget.purchaseMembership,
          isJoiningApproval: widget.isJoiningApproval,
        )
      ],
    );
  }
  double getAmountByCoupon(WidgetRef ref, double price) {
    final coupon = ref.watch(_appliedCoupon);
    double payableAmount = price;
    if (coupon != null) {
      payableAmount -= coupon.discount ?? 0;
    }
    return payableAmount;
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
          ref.invalidate(fetchAllPaymentMethodsProvider(
              widget.locationID,
              widget.serviceID ?? 0,
              widget.type,
              widget.startDate,
              widget.duration));
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 15.h, bottom: 10.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppImages.creditCardIcon.path,
              height: 67.h,
              width: 67.h,
              color: Colors.black,
            ),
            SizedBox(height: 15.h),
            Text(
              "ADD_CREDIT_DEBIT_CARD".tr(context),
              style: AppTextStyles.gothicLight(fontSize: 15.sp),
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
