import 'dart:developer';
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
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/screens/payment_information/midtrans_helper/midtrans_helper.dart';
import 'package:hop/screens/payment_information/modern_payment_sheet.dart';

import '../../globals/constants.dart';
import '../../models/court_price_model.dart';
import '../../repository/booking_repo.dart';
import '../../routes/app_pages.dart';
import '../home_screen/tabs/booking_tab/book_court_dialog/book_court_dialog.dart';

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
    final isInvalidCoupon = ref.watch(_invalidCoupon);
    final cancellationHour = widget.courtPriceModel?.cancellationPolicy?.cancellationTimeInHours;

    return ModernPaymentSheet(
      title: "PAYMENT_INFORMATION".tr(context),
      subtitle: cancellationHour != null
          ? (cancellationHour == 0
              ? "YOU_WILL_NOT_GET_REFUND_ON_THIS_BOOKING".tr(context)
              : "CANCELLATION_POLICY_HOURS".tr(context, params: {"HOUR": cancellationHour.toString()}))
          : "PAYMENT_INFORMATION_TEXT".tr(context),
      onClose: () async {
        if (widget.isMultiBooking) {
          ref.invalidate(fetchBookingCartListProvider);
        }
        Navigator.pop(context);
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coupon Section
            if (widget.allowCoupon) ...[
              ModernCouponSection(
                controller: _couponController,
                isApplied: appliedCoupon != null && _couponController.text == appliedCoupon.coupon,
                isInvalid: isInvalidCoupon,
                onChanged: (value) {
                  setState(() {});
                  ref.read(_appliedCoupon.notifier).state = null;
                  ref.read(_invalidCoupon.notifier).state = false;
                  ref.read(totalMultiBookingAmount.notifier).state = calculateAmountPayable(ref, widget.price);
                },
                onApply: () async {
                  if (_couponController.text.isEmpty) return;
                  final done = await Utils.showLoadingDialog(
                    context,
                    verifyCouponProvider(
                      coupon: _couponController.text,
                      price: widget.price,
                    ),
                    ref,
                  );
                  if (done is CouponModel) {
                    done.coupon = _couponController.text;
                    ref.read(_appliedCoupon.notifier).state = done;
                    ref.read(_invalidCoupon.notifier).state = false;
                  } else {
                    ref.read(_invalidCoupon.notifier).state = true;
                  }
                  ref.read(totalMultiBookingAmount.notifier).state = calculateAmountPayable(ref, widget.price);
                },
              ),
              SizedBox(height: 12.h),
            ],

            // Amount Display
            _ModernAmountPayableWidget(originalAmount: widget.price),

            // Payment Methods Section
            ModernSectionHeader(title: "SELECT_PAYMENT_METHOD".tr(context)),

            paymentDetails.when(
              skipLoadingOnRefresh: false,
              data: (data) {
                return _body(data);
              },
              error: (error, stackTrace) {
                myPrint("Error: $error");
                myPrint("Stack Trace: $stackTrace");
                return Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    error.toString(),
                    style: TextStyle(
                      color: PaymentSheetColors.destructive,
                      fontSize: 14.sp,
                    ),
                  ),
                );
              },
              loading: () => Padding(
                padding: EdgeInsets.all(32.w),
                child: Center(
                  child: CupertinoActivityIndicator(color: PaymentSheetColors.accent),
                ),
              ),
            ),

            SizedBox(height: 8.h),
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
