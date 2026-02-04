import 'package:flutter/cupertino.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:hop/components/custom_textfield.dart';
import 'package:hop/components/secondary_textfield.dart';
import 'package:hop/components/selected_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/book_court_info_card.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/managers/user_manager.dart';
import 'package:hop/models/court_booking.dart';
import 'package:hop/repository/booking_repo.dart';
import 'package:hop/repository/club_repo.dart';
import 'package:hop/repository/payment_repo.dart';
import 'package:hop/screens/home_screen/tabs/booking_tab/court_booked_dialog.dart';
import 'package:hop/screens/payment_information/payment_information.dart';
import 'package:hop/screens/payment_information/modern_payment_sheet.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:intl/intl.dart';

import '../../../../../components/secondary_text.dart';
import '../../../../../models/court_price_model.dart';
import '../../../../../models/lesson_model_new.dart';
import '../../../../../repository/play_repo.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../components/open_match_participant_row.dart';
import '../../../../../models/base_classes/booking_player_base.dart';
import '../../../../../models/follow_list.dart';
import '../../../../../repository/user_repo.dart';
import '../../../../../components/network_circle_image.dart';
import '../../../../../utils/debouncer.dart';
import '../../../../../models/app_user.dart';
part 'components.dart';

part 'providers.dart';

class BookCourtDialog extends ConsumerStatefulWidget {
  const BookCourtDialog(
      {super.key,
        required this.bookings,
        required this.bookingTime,
        required this.coachId,
        this.isOnlyOpenMatch = false,
        this.getPendingPayment = false,
        this.showRefund = false,
        this.allowPayLater = true,
        this.joinEvent = false,
        this.defaultOpenMatch = false,
        this.eventDoubleJoin = false,
        this.joinLesson = false,
        this.joinOpenMatch = true,
        this.courtPriceRequestType,
        required this.court});

  final Bookings bookings;
  final DateTime bookingTime;
  final Map<int, String> court;
  final CourtPriceRequestType? courtPriceRequestType;
  final bool isOnlyOpenMatch;
  final bool showRefund;
  final int? coachId;
  final bool getPendingPayment;
  final bool allowPayLater;
  final bool defaultOpenMatch;
  final bool joinEvent;
  final bool joinOpenMatch;
  final bool eventDoubleJoin;
  final bool joinLesson;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookCourtDialogState();
}

class _BookCourtDialogState extends ConsumerState<BookCourtDialog> {
  bool isPaid = true;
  late final List<int> courtIdList;

  @override
  void initState() {
    courtIdList = [widget.court.keys.first];

    Future(() {
      if (widget.isOnlyOpenMatch) {
        ref.read(_isOpenMatchProvider.notifier).state = widget.isOnlyOpenMatch;
      } else if (widget.defaultOpenMatch) {
        ref.read(_isOpenMatchProvider.notifier).state = true;
      } else {
        ref.invalidate(_isOpenMatchProvider);
      }
      ref.refresh(_isFriendlyMatchProvider);
      ref.refresh(_isApprovePlayersProvider);
      ref.refresh(_organizerNoteProvider);
      ref.refresh(_matchLevelProvider);
      ref.refresh(_reserveSpotsForMatchProvider);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isOpenMatch = ref.watch(_isOpenMatchProvider);
    final reserveSpotsForMatch = ref.watch(_reserveSpotsForMatchProvider);

    // final provider = courtPriceProvider(
    //     serviceId: widget.bookings.id ?? 0,
    //     coachId: widget.coachId,
    //     courtId: [widget.court.keys.first],
    //     durationInMin: widget.bookings.duration ?? 0,
    //     requestType:
    //         widget.courtPriceRequestType ?? CourtPriceRequestType.booking,
    //     dateTime: widget.bookingTime);

    final provider = ref.watch(fetchCourtPriceProvider(
        serviceId: widget.bookings.id ?? 0,
        pendingPayment: widget.getPendingPayment,
        reserveCounter: reserveSpotsForMatch,
        isOpenMatch: widget.isOnlyOpenMatch,
        coachId: widget.coachId,
        durationInMin: widget.bookings.duration ?? 0,
        courtId: courtIdList,
        requestType:
        widget.courtPriceRequestType ?? CourtPriceRequestType.booking,
        dateTime: widget.bookingTime));

    double price = 0;
    double refundAmount = 0;

    return Scaffold(
      backgroundColor: AppColors.alysumWhite,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "BOOKING_INFORMATION".trU(context),
                                  style: AppTextStyles.sofiaSansMedium(
                                    fontSize: 22.sp,
                                    color: AppColors.black,
                                  ),
                                ),
                                6.verticalSpace,
                                Container(
                                  height: 2.h,
                                  width: 32.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.brick,
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(100.r),
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding: EdgeInsets.all(4.w),
                              child: Icon(
                                Icons.close,
                                size: 20.h,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      18.verticalSpace,
            // Text(
            //   "CANCELLATION_POLICY".tr(context),
            //   textAlign: TextAlign.center,
            //   style: AppTextStyles.popupBodyTextStyle,
            // ),
            // SizedBox(height: 20.h),
            // BookCourtInfoCard(
            //     showRefund: widget.showRefund,
            //     refundAmount: (widget.bookings.price ?? 0) - price,
            //     isLoading: isLoading,
            //     bookings: widget.bookings,
            //     bookingTime: widget.bookingTime,
            //     courtName: widget.court.values.first,
            //     price: price),

            provider.when(
              data: (data) {
                String? textPrice;
                double pricePaid = 0;
                int? cancellationHour;

                if (data is String) {
                  if (data.contains("pay your remaining")) {
                    isPaid = true;
                    textPrice = "PRICE".trU(context);
                  } else {
                    isPaid = false;
                    textPrice = "REFUND".trU(context);
                  }
                  data.split(" ").map((e) {
                    if (double.tryParse(e.toString()) != null) {
                      if (isPaid) {
                        price = double.tryParse(e.toString()) ?? 0;
                      } else {
                        price = widget.bookings.price ?? 0;
                        refundAmount = double.tryParse(e.toString()) ?? 0;
                      }
                      textPrice =
                      "$textPrice : ${Utils.formatPrice(isPaid ? price : refundAmount)}";
                    }
                  }).toList();
                } else {
                  CourtPriceModel value = data;
                  final double discountedPrice = value.discountedPrice ?? 0;
                  final double openMatchDiscountedPrice =
                      value.openMatchDiscountedPrice ?? 0;
                  pricePaid = price = ref.read(_isOpenMatchProvider)
                      ? (openMatchDiscountedPrice *
                      (widget.isOnlyOpenMatch
                          ? 1
                          : (reserveSpotsForMatch + 1)))
                      : discountedPrice;

                  cancellationHour = isOpenMatch
                      ? value
                      .cancellationPolicy?.openMatchCancellationTimeInHours
                      : value.cancellationPolicy?.cancellationTimeInHours;
                }
                return Column(
                  children: [
                    if (cancellationHour != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 14.h),
                        child: Text(
                          cancellationHour == 0
                              ? "YOU_WILL_NOT_GET_REFUND_ON_THIS_BOOKING"
                              .tr(context)
                              : "CANCELLATION_POLICY_HOURS".tr(context,
                              params: {
                                "HOUR": cancellationHour.toString()
                              }),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.manropeMedium(
                            fontSize: 14.sp,
                            color: AppColors.black70,
                          ),
                        ),
                      ),
                    BookCourtInfoCard(
                      textPrice: textPrice,
                      price: pricePaid,
                      bookings: widget.bookings,
                      bookingTime: widget.bookingTime,
                      courtName: widget.court.values.first,
                      color: AppColors.white,
                      textColor: AppColors.black,
                      dividerColor: AppColors.black10,
                      borderRadius: BorderRadius.circular(14.r),
                      headerTextStyle0: AppTextStyles.manropeSemiBold(
                        fontSize: 12.sp,
                        color: AppColors.black70,
                        letterSpacing: 0.4,
                      ),
                      dataTextStyle0: AppTextStyles.manropeMedium(
                        fontSize: 14.sp,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                );
              },
              loading: () => const CupertinoActivityIndicator(
                radius: 10,
                color: AppColors.brick,
              ),
              error: (error, stackTrace) {
                return SecondaryText(
                    text: error.toString(), color: AppColors.black70);
              },
            ),
            // if (!widget.getPendingPayment) SizedBox(height: 20.h),
            if (widget.bookings.isOpenMatch == true &&
                !widget.getPendingPayment) ...[
                  20.verticalSpace,
              if (!widget.isOnlyOpenMatch)
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            "DO_YOU_WANT_TO_OPEN_THIS_MATCH".trU(context),
                            style: AppTextStyles.sofiaSansMedium(
                              color: AppColors.black,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                        Text(
                          " ${"OPTIONAL".tr(context).toLowerCase()}",
                          style: AppTextStyles.manropeMedium(
                            color: AppColors.black70,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    _selectionRowContainer(
                      text: "OPEN_MATCH_TO_FIND_PLAYERS".tr(context),
                      isSelected: isOpenMatch,
                      onTap: () {
                        ref.read(_isOpenMatchProvider.notifier).state =
                        !isOpenMatch;
                      },
                    ),
                  ],
                ),
              if (isOpenMatch && !widget.getPendingPayment) const _OpenMatch(),
            ],
                      24.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h),
              decoration: BoxDecoration(
                color: AppColors.alysumWhite,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BOOKING_PAYMENT".trU(context),
                    style: AppTextStyles.sofiaSansMedium(
                      fontSize: 18.sp,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: double.infinity,
                    child: MainButton(
                      enabled: price > 0,
                      label: isOpenMatch
                          ? "PAY_MY_SHARE".trU(context)
                          : "PAY_FULL_COURT".trU(context),
                      isForPopup: false,
                      color: AppColors.brick,
                      labelStyle: AppTextStyles.sofiaSansMedium(
                        fontSize: 20.sp,
                        color: AppColors.white,
                      ),
                      applyShadow: true,
                      applySize: false,
                      height: 48.h,
                      onTap: () {
                        _payCourt(false, isPaid ? price : (price - refundAmount),
                            refundAmount);
                      },
                    ),
                  ),
                  SizedBox(height: 8.h),
                  if (!widget.isOnlyOpenMatch && !widget.getPendingPayment && !isOpenMatch)
                    SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        color: AppColors.white,
                        borderColor: AppColors.brick,
                        label: "ADD_TO_CART".trU(context),
                        labelStyle: AppTextStyles.sofiaSansMedium(
                          color: AppColors.brick,
                          fontSize: 20.sp,
                        ),
                        isForPopup: false,
                        applySize: false,
                        height: 48.h,
                        onTap: () {
                          _payCourt(true, isPaid ? price : (price - refundAmount),
                              refundAmount);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }


  Widget _selectionRowContainer(
      {required String text,
        required bool isSelected,
        required Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brick : AppColors.black5,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? AppColors.brick : AppColors.black10,
          ),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: AppTextStyles.manropeSemiBold(
                fontSize: 13.sp,
                color: isSelected ? AppColors.white : AppColors.black,
              ),
            ),
            const Spacer(),
            SelectedTag(
              isSelected: isSelected,
              selectedColor: AppColors.yellow,
              selectedBorderColor: AppColors.brick,
              unSelectedColor: AppColors.white,
              unSelectedBorderColor: AppColors.black10,
            )
          ],
        ),
      ),
    );
  }

  _payCourt(bool isAddToCart, double amountPaid, double refundAmount) async {
    final isOpenMatch = ref.read(_isOpenMatchProvider);
    final reservedPlayers = ref.read(_reserveSpotsForMatchProvider);
    final organizerNote = ref.read(_organizerNoteProvider);
    final isFriendlyMatch = ref.read(_isFriendlyMatchProvider);
    final isApprovalNeeded = ref.read(_isApprovePlayersProvider);
    final matchLevel = ref.read(_matchLevelProvider);
    final maxLevel = matchLevel.isNotEmpty ? matchLevel.last : null;
    final minLevel = matchLevel.isNotEmpty ? matchLevel.first : null;

    if (isOpenMatch && !widget.getPendingPayment) {
      final canProceed = await Utils().checkForLevelAssessment(
        ref: ref,
        context: context,
        sportsName: widget.bookings.sport?.sportName ?? "padel",
        isOpenMatchFlow: true,
      );
      if (!canProceed) {
        return;
      }
    }

    if (widget.getPendingPayment) {
      final provider = joinServiceProvider(widget.bookings.id!,
          position: 1,
          pendingPayment: widget.getPendingPayment,
          isEvent: widget.joinEvent,
          isOpenMatch: widget.joinOpenMatch,
          isDouble: widget.eventDoubleJoin,
          isReserve: false,
          isLesson: widget.joinLesson,
          isApprovalNeeded: isApprovalNeeded);
      final double? price =
      await Utils.showLoadingDialog(context, provider, ref);

      if (!mounted || price == null) {
        return;
      }

      final data = await showPaymentSheet(
        context: context,
        child: PaymentInformation(
            allowPayLater: widget.allowPayLater,
            isOpenMatch: true,
            getPendingPayment: true,
            type: PaymentDetailsRequestType.join,
            locationID: widget.bookings.location!.id!,
            isJoiningApproval: false,
            price: price,
            requestType: PaymentProcessRequestType.join,
            serviceID: widget.bookings.id!,
            duration: widget.bookings.duration,
            startDate: widget.bookingTime,
            // transactionRequestType: TransactionRequestType.normal
        ),
      );

      var (int? paymentDone, double? amount) = (null, null);
      if (data is (int, double?)) {
        (paymentDone, amount) = data;
      } else if (data is int) {
        paymentDone = data;
      }
      if (paymentDone != null && mounted) {
        Navigator.pop(context, true);
      }
      return;
    }

    if (widget.isOnlyOpenMatch) {
      final provider = upgradeBookingToOpenProvider(
        booking: widget.bookings,
        openMatchMinLevel: minLevel,
        openMatchMaxLevel: maxLevel,
        reservedPlayers: isOpenMatch ? reservedPlayers : 1,
        organizerNote: isOpenMatch ? organizerNote : null,
        isFriendlyMatch: isOpenMatch ? isFriendlyMatch : null,
        approvalNeeded: isOpenMatch ? isApprovalNeeded : null,
      );
      final double? serviceId =
      await Utils.showLoadingDialog(context, provider, ref);
      ref.invalidate(getCourtBookingProvider);
      if (serviceId != null && mounted) {
        await showDialog(
          context: context,
          builder: (context) {
            return CourtBookedDialog(
              bookings: widget.bookings,
              bookingTime: widget.bookingTime,
              court: widget.court,
              amountPaid: amountPaid,
              refundAmount: refundAmount,
              isOpenMatch: isOpenMatch,
              serviceID: widget.bookings.id,
            );
          },
        );
      }
      ref.read(goRouterProvider).pop(widget.bookings.id);

      return;
    }

    final provider = bookCourtProvider(
      payMyShare: false,
      requestType: isAddToCart
          ? BookingRequestType.addToCart
          : BookingRequestType.processingBooking,
      booking: widget.bookings,
      courtID: widget.court.keys.first,
      dateTime: widget.bookingTime,
      openMatchMinLevel: minLevel,
      openMatchMaxLevel: maxLevel,
      isOpenMatch: isOpenMatch,
      reservedPlayers: isOpenMatch ? reservedPlayers : 1,
      organizerNote: isOpenMatch ? organizerNote : null,
      isFriendlyMatch: isOpenMatch ? isFriendlyMatch : null,
      approvalNeeded: isOpenMatch ? isApprovalNeeded : null,
    );
    final double? price = await Utils.showLoadingDialog(context, provider, ref);

    if (!mounted) {
      return;
    }
    if (isAddToCart) {
      ref.invalidate(getCourtBookingProvider);
      ref.invalidate(fetchBookingCartListProvider);
      ref.read(goRouterProvider).pop();
      return;
    }
    if (price == null) {
      return;
    }
    final time = DateTime.now();

    final data = await showPaymentSheet(
      context: context,
      child: PaymentInformation(
          // transactionRequestType: TransactionRequestType.normal,
          serviceID: widget.bookings.id,
          type: PaymentDetailsRequestType.booking,
          locationID: widget.bookings.location!.id!,
          requestType: PaymentProcessRequestType.courtBooking,
          price: price,
          duration: widget.bookings.duration ?? 0,
          startDate: time),
    );
    var (int? serviceID, double? amount) = (null, null);
    if (data is (int, double?)) {
      (serviceID, amount) = data;
    } else if (data is int) {
      serviceID = data;
    }
    ref.refresh(getCourtBookingProvider);
    if (serviceID != null && mounted) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return CourtBookedDialog(
            bookings: widget.bookings,
            amountPaid: amountPaid,
            // amountPaid: (amount ?? 0) > 0 ? amount : null,
            bookingTime: widget.bookingTime,
            court: widget.court,
            isOpenMatch: isOpenMatch,
            serviceID: serviceID,
          );
        },
      );
    }
  }
}


// class BookCourtDialog extends ConsumerStatefulWidget {
//   const BookCourtDialog(
//       {super.key,
//       required this.bookings,
//       this.courtPriceRequestType,
//       this.isOnlyOpenMatch = false,
//       this.showRefund = false,
//       required this.coachId,
//       required this.bookingTime,
//       this.defaultOpenMatch = false,
//       this.allowPayLater = true,
//       this.allowAddPlayer = true,
//       this.getPendingPayment = false,
//       this.joinEvent = false,
//       this.eventDoubleJoin = false,
//       this.joinLesson = false,
//       this.joinOpenMatch = true,
//       required this.court});
//
//   final Bookings bookings;
//   final DateTime bookingTime;
//   final Map<int, String> court;
//   final CourtPriceRequestType? courtPriceRequestType;
//   final bool isOnlyOpenMatch;
//   final bool allowAddPlayer;
//   final bool showRefund;
//   final int? coachId;
//
//   final bool getPendingPayment;
//   final bool allowPayLater;
//   final bool joinEvent;
//   final bool joinOpenMatch;
//   final bool eventDoubleJoin;
//   final bool joinLesson;
//   final bool defaultOpenMatch;
//
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _BookCourtDialogState();
// }
//
// class _BookCourtDialogState extends ConsumerState<BookCourtDialog> {
//   bool isPaid = true;
//   late final List<int> courtIdList;
//   CourtPriceModel? courtPriceModel;
//   bool _isProcessing = false;
//
//   @override
//   void initState() {
//     courtIdList = [widget.court.keys.first];
//     Future(() {
//       // Always open match now (both payment options are open matches)
//       ref.read(_isOpenMatchProvider.notifier).state = true;
//
//       // Default to "Pay your part" (public open match, not private)
//       ref.read(_isPrivateMatchProvider.notifier).state = false;
//
//       // Always ranked matches (not friendly)
//       ref.read(_isFriendlyMatchProvider.notifier).state = false;
//
//       // Always approve players before they join
//       ref.read(_isApprovePlayersProvider.notifier).state = true;
//
//       ref.invalidate(_organizerNoteProvider);
//       ref.invalidate(_matchLevelProvider);
//       ref.invalidate(_reserveSpotsForMatchProvider);
//       ref.invalidate(_selectedPlayersProvider);
//       ref.invalidate(_payFullCourtInPrivateProvider);
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final sportName = (widget.bookings.sport?.sportName ?? "").toLowerCase();
//     final allowPayMyShare = sportName == "padel" || sportName == "pickleball";
//     final isOpenMatch = ref.watch(_isOpenMatchProvider);
//     final reserveSpotsForMatch = ref.watch(_reserveSpotsForMatchProvider);
//     final isInfraredSauna =
//         (widget.bookings.sport?.sportName ?? "").toLowerCase() == "recovery";
//     final provider = ref.watch(fetchCourtPriceProvider(
//         coachId: widget.coachId,
//         serviceId: widget.bookings.id ?? 0,
//         reserveCounter: reserveSpotsForMatch,
//         isOpenMatch: widget.isOnlyOpenMatch,
//         pendingPayment: widget.getPendingPayment,
//         durationInMin: widget.bookings.duration ?? 0,
//         courtId: courtIdList,
//         requestType:
//             widget.courtPriceRequestType ?? CourtPriceRequestType.booking,
//         dateTime: widget.bookingTime));
//
//     double? price;
//     double refundAmount = 0;
//
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.zero,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Back button and title section
//                   SafeArea(
//                     bottom: false,
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               GestureDetector(
//                                 onTap: () => Navigator.of(context).pop(),
//                                 child: Padding(
//                                   padding: EdgeInsets.all(8.h),
//                                   child: Image.asset(
//                                     AppImages.back_arrow_new.path,
//                                     height: 24.h,
//                                     width: 24.h,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 10.h),
//                           Text(
//                             "BOOKING_INFORMATION".trU(context),
//                             style: AppTextStyles.popupHeaderTextStyle.copyWith(
//                               color: AppColors.black2,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20.w),
//                     child: Column(
//                       children: [
//                         SizedBox(height: 10.h),
//                   provider.when(
//                     data: (data) {
//                 int? cancellationHour;
//
//                 String? textPrice;
//                 double pricePaid = 0;
//                 if (data is String) {
//                   if (data.contains("pay your remaining")) {
//                     isPaid = true;
//                     textPrice = "PRICE".trU(context);
//                   } else {
//                     isPaid = false;
//                     textPrice = "REFUND".trU(context);
//                   }
//                   data.split(" ").map((e) {
//                     if (double.tryParse(e.toString()) != null) {
//                       if (isPaid) {
//                         price = double.tryParse(e.toString()) ?? 0;
//                       } else {
//                         price = widget.bookings.price ?? 0;
//                         refundAmount = double.tryParse(e.toString()) ?? 0;
//                       }
//                       textPrice =
//                           "$textPrice : ${Utils.formatPrice(isPaid ? price : refundAmount)}";
//                     }
//                   }).toList();
//                 } else {
//                   CourtPriceModel value = courtPriceModel = data;
//                   final double discountedPrice =
//                       value.discountedPrice ?? 0;
//                   final double openMatchDiscountedPrice =
//                       value.openMatchDiscountedPrice ?? 0;
//                   final double reservePrice = value.reservePrice ?? 0;
//
//                   final isPrivate = ref.watch(_isPrivateMatchProvider);
//                   final payFullCourt = ref.watch(_payFullCourtInPrivateProvider);
//
//                   // Calculate price based on match type and payment option
//                   if (isPrivate) {
//                     // Private Match
//                     pricePaid = price = payFullCourt
//                         ? discountedPrice  // Pay full court
//                         : (discountedPrice / 4);  // Pay my share (1/4 of price)
//                   } else {
//                     // Open Match (public) - always per-person pricing
//                     pricePaid = price = (openMatchDiscountedPrice +
//                         (reservePrice *
//                             (widget.isOnlyOpenMatch
//                                 ? 1
//                                 : (reserveSpotsForMatch))));
//                   }
//
//                   cancellationHour = value.cancellationPolicy
//                       ?.openMatchCancellationTimeInHours;
//                 }
//
//                 return Column(
//                   children: [
//                     if (cancellationHour != null)
//                       Padding(
//                         padding: EdgeInsets.only(bottom: 20.h),
//                         child: Text(
//                           cancellationHour == 0
//                               ? "YOU_WILL_NOT_GET_REFUND_ON_THIS_BOOKING"
//                                   .tr(context)
//                               : "CANCELLATION_POLICY_HOURS".tr(context,
//                                   params: {
//                                       "HOUR": cancellationHour.toString()
//                                     }),
//                           textAlign: TextAlign.center,
//                           style: AppTextStyles.popupBodyTextStyle,
//                         ),
//                       ),
//                     BookCourtInfoCard(
//                         textPrice: textPrice,
//                         price: pricePaid,
//                         bookings: widget.bookings,
//                         bookingTime: widget.bookingTime,
//                         courtName: isInfraredSauna
//                             ? widget.court.values.first
//                             : "${widget.court.values.first}",
//                         borderRadius: BorderRadius.circular(12.r)),
//                   ],
//                 );
//                     },
//                     loading: () => const CupertinoActivityIndicator(radius: 10),
//                     error: (error, stackTrace) {
//                       myPrint("stackTrace: $stackTrace");
//                       return SecondaryText(text: error.toString());
//                     },
//                   ),
//                   SizedBox(height: 20.h),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "BOOKING_PAYMENT".tr(context),
//                       style: AppTextStyles.sofiaSansMedium(fontSize: 15.sp),
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                   // Show both buttons for pay full court and pay my share
//                   if (!widget.isOnlyOpenMatch &&
//                       !isInfraredSauna &&
//                       allowPayMyShare) ...[
//                     // Tab selector for payment type
//                     Container(
//                       decoration: BoxDecoration(
//                         color: AppColors.tileBgColor,
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       padding: EdgeInsets.all(4.h),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: () async {
//                                 if (!_isProcessing && price != null) {
//                                   setState(() => _isProcessing = true);
//                                   try {
//                                     // Pay your part = Public open match
//                                     if (!isOpenMatch) {
//                                       final user = ref.read(userProvider);
//                                       final userLevel = user?.user?.level(
//                                               widget.bookings.sport?.sportName ??
//                                                   "padel") ??
//                                           0.0;
//
//                                       // If user has level 0, show quiz assessment
//                                       if (userLevel == 0.0) {
//                                         final shouldProceed =
//                                             await Utils().checkForLevelAssessment(
//                                           ref: ref,
//                                           context: context,
//                                           sportsName:
//                                               widget.bookings.sport?.sportName ?? "padel",
//                                         );
//
//                                         if (!shouldProceed) {
//                                           return; // Don't proceed if assessment not completed
//                                         }
//                                       }
//                                     }
//                                     // Always open match, public (not private)
//                                     ref.read(_isOpenMatchProvider.notifier).state = true;
//                                     ref.read(_isPrivateMatchProvider.notifier).state = false;
//                                   } finally {
//                                     setState(() => _isProcessing = false);
//                                   }
//                                 }
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(vertical: 8.h),
//                                 decoration: BoxDecoration(
//                                   color: !ref.watch(_isPrivateMatchProvider) ? AppColors.yellow : Colors.transparent,
//                                   borderRadius: BorderRadius.circular(10.r),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     _isProcessing && !ref.watch(_isPrivateMatchProvider)
//                                         ? "Loading..."
//                                         : "PAY_MY_SHARE".tr(context),
//                                     style: !ref.watch(_isPrivateMatchProvider)
//                                         ? AppTextStyles.manropeBold(
//                                             fontSize: 14.sp,
//                                             color: AppColors.black,
//                                           )
//                                         : AppTextStyles.sofiaSansMedium(
//                                             fontSize: 14.sp,
//                                             color: AppColors.black70,
//                                           ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 4.w),
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: () async {
//                                 if (!_isProcessing && price != null) {
//                                   setState(() => _isProcessing = true);
//                                   try {
//                                     // Pay everything = Private open match
//                                     // Always open match, private (not public)
//                                     ref.read(_isOpenMatchProvider.notifier).state = true;
//                                     ref.read(_isPrivateMatchProvider.notifier).state = true;
//                                   } finally {
//                                     setState(() => _isProcessing = false);
//                                   }
//                                 }
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(vertical: 8.h),
//                                 decoration: BoxDecoration(
//                                   color: ref.watch(_isPrivateMatchProvider) ? AppColors.yellow : Colors.transparent,
//                                   borderRadius: BorderRadius.circular(10.r),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     "PAY_FULL_COURT".tr(context),
//                                     style: ref.watch(_isPrivateMatchProvider)
//                                         ? AppTextStyles.manropeBold(
//                                             fontSize: 14.sp,
//                                             color: AppColors.black,
//                                           )
//                                         : AppTextStyles.sofiaSansMedium(
//                                             fontSize: 14.sp,
//                                             color: AppColors.black70,
//                                           ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Disclaimer for Open Match
//                     if (!ref.watch(_isPrivateMatchProvider)) ...[
//                       SizedBox(height: 15.h),
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//                         decoration: BoxDecoration(
//                           color: AppColors.yellow30,
//                           borderRadius: BorderRadius.circular(12.r),
//                           border: Border.all(color: AppColors.black2.withOpacity(.05)),
//                         ),
//                         child: RichText(
//                           textAlign: TextAlign.center,
//                           text: TextSpan(
//                             style: AppTextStyles.manropeMedium(
//                               fontSize: 13.sp,
//                               color: AppColors.black2,
//                             ),
//                             children: [
//                               const TextSpan(
//                                   text: "We will put on hold the remaining amount of the booking. If other players do not pay before "),
//                               TextSpan(
//                                 text:
//                                     "${DateFormat('dd MMMM HH:mm').format(widget.bookingTime.add(Duration(hours: 2)))}",
//                                 style: AppTextStyles.manropeBold(
//                                   fontSize: 13.sp,
//                                   color: AppColors.black2,
//                                 ),
//                               ),
//                               const TextSpan(
//                                   text: " you will be charged the remaining amount."),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                     // Disclaimer for Private Match
//                     if (ref.watch(_isPrivateMatchProvider)) ...[
//                       SizedBox(height: 15.h),
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//                         decoration: BoxDecoration(
//                           color: AppColors.yellow30,
//                           borderRadius: BorderRadius.circular(12.r),
//                           border: Border.all(color: AppColors.black2.withOpacity(.05)),
//                         ),
//                         child: Text(
//                           "We will charge the full amount. You will be refunded to your club wallet when someone else joins and pays their share.",
//                           textAlign: TextAlign.center,
//                           style: AppTextStyles.manropeMedium(
//                             fontSize: 13.sp,
//                             color: AppColors.black2,
//                           ),
//                         ),
//                       ),
//                     ],
//             ] else
//               MainButton(
//                 enabled: price != null,
//                 label: widget.isOnlyOpenMatch
//                     ? "GET_REFUND_AND_OPEN_MATCH".tr(context)
//                     : (isOpenMatch && !isInfraredSauna)
//                         ? "PAY_MY_SHARE".trU(context)
//                         : "PAY_BOOKING".trU(context),
//                 isForPopup: true,
//                 onTap: () async {
//                   await _payCourt(
//                       false,
//                       isPaid ? price! : (price! - refundAmount),
//                       refundAmount,
//                       false);
//                 },
//               ),
//             // Show add players component for both Open Match and Private Match
//             if (widget.bookings.isOpenMatch == true &&
//                 allowOpenMatch &&
//                 !isInfraredSauna) ...[
//               SizedBox(height: 35.h),
//               _OpenMatch(allowAddPlayer: widget.allowAddPlayer,),
//             ],
//             if (!widget.isOnlyOpenMatch)
//               if (!isOpenMatch && allowAddToCart) ...[
//                 5.verticalSpace,
//                 MainButton(
//                   // color: AppColors.selectedGreen,
//                   enabled: price != null,
//                   label: "ADD_TO_CART".trU(context),
//                   labelStyle: AppTextStyles.sofiaSansMedium(
//                       fontSize: 18.sp, color: AppColors.white),
//                   color: AppColors.white25,
//                   isForPopup: true,
//                   onTap: () async {
//                     await _payCourt(true, price!, 0, false);
//                   },
//                 ),
//               ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Fixed bottom payment button(s)
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: Offset(0, -2),
//                 ),
//               ],
//             ),
//             padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 16.h, bottom: 16.h),
//             child: SafeArea(
//               top: false,
//               child: ref.watch(_isPrivateMatchProvider)
//                   ? // Private Match - Show only PAY FULL COURT button
//                   MainButton(
//                       color: AppColors.yellow,
//                       enabled: price != null && !_isProcessing,
//                       isForPopup: false,
//                       labelStyle: AppTextStyles.sofiaSansMedium(
//                           fontSize: 18.sp, color: AppColors.black),
//                       label: "Pay Full Court",
//                       onTap: () async {
//                         // Pay full court - use full court price (discountedPrice)
//                         ref.read(_payFullCourtInPrivateProvider.notifier).state = true;
//                         final fullCourtPrice = courtPriceModel?.discountedPrice ?? price!;
//                         // payMyShare = false means pay full court
//                         await _payCourt(
//                             false, fullCourtPrice, refundAmount, false);
//                       },
//                     )
//                   : // Open Match - Show single continue button
//                   MainButton(
//                       color: AppColors.yellow,
//                       enabled: price != null && !_isProcessing,
//                       isForPopup: false,
//                       labelStyle: AppTextStyles.sofiaSansMedium(
//                           fontSize: 18.sp, color: AppColors.black),
//                       label: widget.isOnlyOpenMatch
//                           ? "GET_REFUND_AND_OPEN_MATCH".tr(context)
//                           : "Pay My Share",
//                       onTap: () async {
//                         // Open Match - always pay my share
//                         await _payCourt(
//                             false,
//                             price!,
//                             refundAmount,
//                             true); // Always payMyShare = true for Open Match
//                       },
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _showPaymentInfoDialog(
//       double price, double refundAmount, bool isPaid) async {
//     // Show disclaimer popup (only used for Private Match - Pay My Share)
//     bool? shouldProceed = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return _PayMyShareInfoDialog(
//           bookingTime: widget.bookingTime,
//         );
//       },
//     );
//
//     // If dialog was confirmed (not dismissed), proceed with payment
//     if (shouldProceed == true && mounted) {
//       await _payCourt(
//           false, isPaid ? price : (price - refundAmount), refundAmount, false);
//     }
//   }
//
//   List<BookingPlayerBase> _buildPlayersList() {
//     final currentUser = ref.read(userProvider)?.user;
//     final selectedPlayers = ref.read(_selectedPlayersProvider);
//
//     final List<BookingPlayerBase> playersList = [];
//
//     // Always add current user in first position
//     if (currentUser != null) {
//       final currentUserPlayer = BookingPlayerBase(
//         id: currentUser.id,
//         customer: BookingCustomerBase(
//           id: currentUser.id,
//           firstName: currentUser.firstName,
//           lastName: currentUser.lastName,
//           profileUrl: currentUser.profileUrl,
//         ),
//         position: 1,
//         isOrganizer: true,
//       );
//       playersList.add(currentUserPlayer);
//     }
//
//     // Add selected players - preserve their selected positions
//     for (var i = 0; i < selectedPlayers.length; i++) {
//       final player = selectedPlayers[i];
//       playersList.add(player);
//     }
//
//     return playersList;
//   }
//
//   _payCourt(bool isAddToCart, double amountPaid, double refundAmount,
//       bool payMyShare) async {
//     final isOpenMatch = ref.read(_isOpenMatchProvider);
//     final reservedPlayers = ref.read(_reserveSpotsForMatchProvider);
//     final organizerNote = ref.read(_organizerNoteProvider);
//     final isFriendlyMatch = ref.read(_isFriendlyMatchProvider);
//     final isPrivateMatch = ref.read(_isPrivateMatchProvider);
//     final isApprovalNeeded = ref.read(_isApprovePlayersProvider);
//     final matchLevel = ref.read(_matchLevelProvider);
//     final maxLevel = matchLevel.isNotEmpty ? matchLevel.last : null;
//     final minLevel = matchLevel.isNotEmpty ? matchLevel.first : null;
//     final selectedPlayers = ref.read(_selectedPlayersProvider);
//
//     if (widget.getPendingPayment) {
//       final provider = joinServiceProvider(widget.bookings.id!,
//           position: 1,
//           pendingPayment: widget.getPendingPayment,
//           isEvent: widget.joinEvent,
//           isOpenMatch: widget.joinOpenMatch,
//           isDouble: widget.eventDoubleJoin,
//           isReserve: false,
//           isLesson: widget.joinLesson,
//           isApprovalNeeded: false);
//       final double? price =
//           await Utils.showLoadingDialog(context, provider, ref);
//
//       if (!mounted || price == null) {
//         return;
//       }
//
//       final data = await showDialog(
//         context: context,
//         builder: (context) {
//           return PaymentInformation(
//               courtId: widget.court.keys.first,
//               allowPayLater: widget.allowPayLater,
//               isOpenMatch: isOpenMatch,
//               getPendingPayment: true,
//               title: "PAY_MY_SHARE".trU(context),
//               type: PaymentDetailsRequestType.join,
//               locationID: widget.bookings.location!.id!,
//               isJoiningApproval: false,
//               price: price,
//               requestType: PaymentProcessRequestType.join,
//               serviceID: widget.bookings.id!,
//               duration: widget.bookings.duration,
//               startDate: widget.bookingTime);
//         },
//       );
//
//       var (int? paymentDone, double? amount) = (null, null);
//       if (data is (int, double?)) {
//         (paymentDone, amount) = data;
//       }
//       if (paymentDone != null && mounted) {
//         Navigator.pop(context, true);
//       }
//       return;
//     }
//
//     if (widget.isOnlyOpenMatch) {
//       int? id;
//
//       final provider = upgradeBookingToOpenProvider(
//         booking: widget.bookings,
//         openMatchMinLevel: minLevel,
//         openMatchMaxLevel: maxLevel,
//         reservedPlayers: isOpenMatch ? reservedPlayers : 1,
//         isPrivateMatch: isPrivateMatch,
//         organizerNote: isOpenMatch ? organizerNote : null,
//         isFriendlyMatch: isOpenMatch ? isFriendlyMatch : null,
//         approvalNeeded: isOpenMatch ? isApprovalNeeded : null,
//       );
//       final data = await Utils.showLoadingDialog(context, provider, ref);
//       var (int? serviceID, double? amount) = (null, null);
//       if (data is (int?, double?)) {
//         (serviceID, amount) = data;
//       }
//
//       ref.invalidate(getCourtBookingProvider);
//       if (serviceID != null && mounted) {
//         await showDialog(
//           context: context,
//           builder: (context) {
//             return CourtBookedDialog(
//               refundAmount: refundAmount,
//               courtPriceModel: courtPriceModel,
//               amountPaid: amount ?? amountPaid,
//               bookings: widget.bookings,
//               bookingTime: widget.bookingTime,
//               court: widget.court,
//               isOpenMatch: isOpenMatch,
//               serviceID: widget.bookings.id,
//               additionalPlayers: selectedPlayers.isNotEmpty ? selectedPlayers : null,
//             );
//           },
//         );
//         id = widget.bookings.id;
//       } else if (amount != null && mounted) {
//         final date = DateTime.now();
//         final data = await showDialog(
//           context: context,
//           builder: (context) {
//             return PaymentInformation(
//                 allowCoupon: false,
//                 bookingToOpenMatch: true,
//                 serviceID: widget.bookings.id,
//                 isOpenMatch: isOpenMatch,
//                 type: PaymentDetailsRequestType.booking,
//                 locationID: widget.bookings.location!.id!,
//                 requestType: PaymentProcessRequestType.courtBooking,
//                 price: amount ?? 0,
//                 duration: widget.bookings.duration,
//                 courtId: widget.court.keys.first,
//                 startDate: date);
//           },
//         );
//         var (int? serviceID, double? amount2) = (null, null);
//         if (data is (int, double?)) {
//           (serviceID, amount2) = data;
//         }
//         ref.invalidate(getCourtBookingProvider);
//         if (serviceID != null && mounted) {
//           await showDialog(
//             context: context,
//             builder: (context) {
//               return CourtBookedDialog(
//                 courtPriceModel: courtPriceModel,
//                 amountPaid: amount2 ?? amountPaid,
//                 bookings: widget.bookings,
//                 bookingTime: widget.bookingTime,
//                 court: widget.court,
//                 isOpenMatch: isOpenMatch,
//                 serviceID: widget.bookings.id,
//                 additionalPlayers: selectedPlayers.isNotEmpty ? selectedPlayers : null,
//               );
//             },
//           );
//           id = widget.bookings.id;
//         }
//       }
//       ref.read(goRouterProvider).pop(id);
//       return;
//     }
//
//     final provider = bookCourtProvider(
//       requestType: isAddToCart
//           ? BookingRequestType.addToCart
//           : BookingRequestType.processingBooking,
//       payMyShare: payMyShare,
//       booking: widget.bookings,
//       courtID: widget.court.keys.first,
//       dateTime: widget.bookingTime,
//       isOpenMatch: isOpenMatch,
//       reservedPlayers: isOpenMatch ? reservedPlayers : 1,
//       organizerNote: isOpenMatch ? organizerNote : null,
//       isFriendlyMatch: isOpenMatch ? isFriendlyMatch : null,
//       isPrivateMatch: isPrivateMatch,
//       approvalNeeded: isOpenMatch ? isApprovalNeeded : null,
//       openMatchMinLevel: minLevel,
//       openMatchMaxLevel: maxLevel,
//       customerPlayers: isOpenMatch && selectedPlayers.isNotEmpty ? selectedPlayers : null,
//     );
//     final double? price = await Utils.showLoadingDialog(context, provider, ref);
//
//     if (!mounted) {
//       return;
//     }
//     if (price == null) {
//       return;
//     }
//
//     if (isAddToCart) {
//       ref.invalidate(getCourtBookingProvider);
//       ref.invalidate(fetchBookingCartListProvider);
//       ref.read(goRouterProvider).pop();
//       return;
//     }
//     final data = await showDialog(
//       context: context,
//       builder: (context) {
//         return PaymentInformation(
//             serviceID: widget.bookings.id,
//             isOpenMatch: isOpenMatch,
//             type: PaymentDetailsRequestType.booking,
//             locationID: widget.bookings.location!.id!,
//             requestType: PaymentProcessRequestType.courtBooking,
//             price: price,
//             duration: widget.bookings.duration,
//             courtId: widget.court.keys.first,
//             startDate: widget.bookingTime);
//       },
//     );
//     var (int? serviceID, double? amount) = (null, null);
//     if (data is (int, double?)) {
//       (serviceID, amount) = data;
//     }
//
//     ref.invalidate(getCourtBookingProvider);
//
//     if (serviceID != null && mounted) {
//       Navigator.pop(context);
//       showDialog(
//         context: context,
//         builder: (context) {
//           return CourtBookedDialog(
//             courtPriceModel: courtPriceModel,
//             // amountPaid: (amount ?? 0) > 0 ? amount : null,
//             amountPaid: amount ?? amountPaid,
//             bookings: widget.bookings,
//             bookingTime: widget.bookingTime,
//             court: widget.court,
//             isOpenMatch: isOpenMatch,
//             serviceID: serviceID,
//             additionalPlayers: selectedPlayers.isNotEmpty ? selectedPlayers : null,
//           );
//         },
//       );
//     }
//   }
// }

class BookCourtDialogLesson extends ConsumerStatefulWidget {
  const BookCourtDialogLesson(
      {super.key,
      required this.title,
      required this.bookingTime,
      required this.calendarTitle,
      required this.lessonId,
      required this.coachId,
      required this.lessonVariant,
      required this.locationId,
      required this.lessonVariants,
      required this.courts,
      required this.locationName,
      required this.lessonTime});

  final DateTime bookingTime;
  final String title;
  final String calendarTitle;
  final int lessonId;
  final int coachId;
  final int locationId;
  final String locationName;
  final int lessonTime;
  final List<LessonVariants> lessonVariants;
  final List<Courts> courts;
  final LessonVariants? lessonVariant;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookCourtDialogLessonState();
}

class _BookCourtDialogLessonState extends ConsumerState<BookCourtDialogLesson> {
  late final List<int> courtIdList;
  final _selectedLessonVariantProvider =
      StateProvider<LessonVariants?>((ref) => null);
  int? courtId;
  String? courtName;

  @override
  void initState() {
    if (widget.courts.isNotEmpty) {
      courtId = widget.courts.first.id ?? 0;
      courtName = widget.courts.first.courtName ?? "";
      courtIdList = [courtId ?? 0];
    } else {
      courtIdList = [];
    }
    Future(() {
      ref.invalidate(_isOpenMatchProvider);
      ref.invalidate(_isFriendlyMatchProvider);
      ref.invalidate(_isApprovePlayersProvider);
      ref.invalidate(_organizerNoteProvider);
      ref.invalidate(_matchLevelProvider);
      ref.invalidate(_reserveSpotsForMatchProvider);
      if (widget.lessonVariants.isNotEmpty &&
          ref.read(_selectedLessonVariantProvider) == null) {
        ref.read(_selectedLessonVariantProvider.notifier).state =
            widget.lessonVariants.first;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.courts.isNotEmpty) {
      courtName = widget.courts.first.courtName ?? "";
    }
    final selectedLessonVariant = ref.watch(_selectedLessonVariantProvider);
    if (selectedLessonVariant == null) {
      return const SizedBox(); // or loading indicator
    }
    final provider = ref.watch(fetchCourtPriceProvider(
      serviceId: widget.lessonId,
      coachId: null,
      courtId: courtIdList,
      durationInMin: widget.lessonTime,
      requestType: CourtPriceRequestType.lesson,
      dateTime: widget.bookingTime,
      lessonVariant: selectedLessonVariant,
    ));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomDialog(
        child: Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 6.5.w,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  "BOOKING_INFORMATION".trU(context),
                  style: AppTextStyles.popupHeaderTextStyle,
                ),
                SizedBox(height: 5.h),
                provider.when(
                  data: (data) {
                    double pricePaid = 0;
                    int? cancellationHour;

                    CourtPriceModel value = data;
                    final double discountedPrice = value.discountedPrice ?? 0;
                    pricePaid = discountedPrice;

                    cancellationHour =
                        value.cancellationPolicy?.cancellationTimeInHours;

                    return Column(
                      children: [
                        if (cancellationHour != null)
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: Text(
                              cancellationHour == 0
                                  ? "YOU_WILL_NOT_GET_REFUND_ON_THIS_BOOKING"
                                      .tr(context)
                                  : "CANCELLATION_POLICY_HOURS".tr(context,
                                      params: {
                                          "HOUR": cancellationHour.toString()
                                        }),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.popupBodyTextStyle,
                            ),
                          ),
                        BookCourtInfoCardLesson(
                          lessonVariant: selectedLessonVariant,
                          bookingTime: widget.bookingTime,
                          title: widget.title,
                          price: pricePaid,
                          duration: widget.lessonTime,
                          coachName: widget.title,
                          courtName: courtName,
                          locationName: widget.locationName,
                        ),
                      ],
                    );
                  },
                  loading: () => const CupertinoActivityIndicator(radius: 10),
                  error: (error, stackTrace) {
                    return SecondaryText(text: error.toString());
                  },
                ),
                5.verticalSpace,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "NUMBER_OF_PAX".trU (context),
                    style: AppTextStyles.sofiaSansMedium(
                        color: AppColors.white, fontSize: 21.sp,),
                  ),
                ),
                5.verticalSpace,
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: widget.lessonVariants.map((e) {
                    final isSelected = selectedLessonVariant.id == e.id;
                    return InkWell(
                      onTap: () {
                        ref
                            .read(_selectedLessonVariantProvider.notifier)
                            .state = e;
                      },
                      child: Container(
                        width: 60.w,
                        height: 24.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          color: isSelected
                              ? AppColors.white
                              : AppColors.white25,
                        ),
                        child: Text(
                          (e.maximumCapacity ?? 0).toString(),
                          textAlign: TextAlign.center,
                          style: isSelected
                              ? AppTextStyles.manropeSemiBold(fontSize: 13.sp,color: AppColors.brick,)
                              : AppTextStyles.manropeMedium(color: AppColors.white,fontSize: 13.sp,),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                20.verticalSpace,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "BOOKING_PAYMENT".trU(context),
                    style: AppTextStyles.sofiaSansMedium(
                        color: AppColors.white, fontSize: 23.sp),
                  ),
                ),
                SizedBox(height: 10.h),
                MainButton(
                  label: "PAY_LESSON".trU(context),
                  isForPopup: true,
                  onTap: () async {
                    await _payCourt(selectedLessonVariant);
                  },
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _payCourt(LessonVariants? selectedLessonVariant) async {
    try {
      final provider = bookLessonCourtProvider(
        lessonVariant: selectedLessonVariant,
        lessonTime: widget.lessonTime,
        coachId: widget.coachId,
        lessonId: widget.lessonId,
        courtId: courtId ?? 0,
        locationId: widget.locationId,
        dateTime: widget.bookingTime,
      );
      final price = await Utils.showLoadingDialog(context, provider, ref);
      if (price == null || price is String || !mounted) return;
      final data = await showPaymentSheet(
        context: context,
        child: PaymentInformation(
            type: PaymentDetailsRequestType.lesson,
            locationID: widget.locationId,
            requestType: PaymentProcessRequestType.courtBooking,
            price: price,
            serviceID: widget.lessonId,
            courtId: courtId,
            variantId: selectedLessonVariant?.id,
            duration: widget.lessonTime,
            startDate: widget.bookingTime),
      );
      var (int? serviceID, double? amount) = (null, null);
      if (data is (int, double?)) {
        (serviceID, amount) = data;
      } else if (data is int) {
        serviceID = data;
      }
      if (serviceID != null && mounted) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => CourtLessonBookedDialog(
            lessonVariant: selectedLessonVariant,
            courtName: courtName ?? "",
            price: price,
            locationName: widget.locationName,
            courtId: courtId ?? 0,
            calendarTitle: widget.calendarTitle,
            coachId: widget.coachId,
            lessonId: widget.lessonId,
            lessonTime: widget.lessonTime,
            locationId: widget.locationId,
            bookingTime: widget.bookingTime,
            title: widget.title,
            // isOpenMatch: true,
          ),
        );
      }
    } catch (e) {
      myPrint(e.toString());
    }
  }
}
