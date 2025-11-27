import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/c_divider.dart';
import 'package:hop/components/changes_cancelled_listing_card.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/user_bookings.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/models/court_booking.dart' as bookingModel;
import '../globals/constants.dart';
import '../repository/booking_repo.dart';
import '../repository/user_repo.dart';
import '../screens/home_screen/tabs/booking_tab/book_court_dialog/book_court_dialog.dart';
import 'main_button.dart';

class UserBookingCard extends ConsumerWidget {
  const UserBookingCard({super.key, required this.booking});

  final UserBookings booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlayerPendingPayment = booking.isPlayerPendingPayment(ref);
    bool isCancelled = booking.isCancelled ?? false;
    final color = isCancelled || isPlayerPendingPayment ? AppColors.brick : AppColors.black5;
    final textColor = isCancelled || isPlayerPendingPayment ? AppColors.white : AppColors.black;
    return Container(
      padding: EdgeInsets.all(15.h),
      decoration: BoxDecoration(
          color: color,
        // border: border,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCancelled) ...[
            ChangesCancelledListingCard(
              text: "BOOKING_CANCELLED".tr(context),
            ),
            SizedBox(height: 10.h),
          ],
          if (isPlayerPendingPayment)
            Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChangesCancelledListingCard(
                    // color: AppColors.white,
                    isUpperCase: false,
                    iconColor: AppColors.brick,
                    textColor: AppColors.brick,
                    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 15.w),
                    style: AppTextStyles.manropeSemiBold(fontSize: 13.sp, color: AppColors.brick),
                    text: "BOOKING_UNPAID".tr(context),
                  ),
                  MainButton(
                    label: "PAY_NOW".tr(context),
                    onTap: () async {
                      String sportName = "";
                      if ((booking.players ?? []).isNotEmpty &&
                          booking.players!.first.customer!.sportsLevel
                              .isNotEmpty) {
                        sportName = booking.players!.first.customer!.sportsLevel
                            .first.sportName ??
                            "";
                      }

                      List<bookingModel.BookingCourts> listCourts = [];

                      (booking.courts ?? []).map((e) {
                        listCourts.add(
                            bookingModel.BookingCourts.fromJson(e.toJson()));
                      }).toList();

                      dynamic paid = await showDialog(
                        context: context,
                        builder: (context) {
                          return BookCourtDialog(
                            allowPayLater: false,
                            getPendingPayment: true,
                            showRefund: true,
                            coachId: null,
                            courtPriceRequestType: CourtPriceRequestType.join,
                            bookings: bookingModel.Bookings(
                                id: booking.id,
                                price: booking.service!.price,
                                duration: booking.duration2,
                                isOpenMatch: true,
                                sport: bookingModel.Sport(sportName: sportName),
                                location: bookingModel.Location(
                                    id: booking.service!.location!.id,
                                    courts: listCourts,
                                    locationName: booking
                                        .service!.location!.locationName)),
                            bookingTime: booking.bookingStartTime,
                            court: {
                              (booking.courts ?? []).first.id ?? 0:
                              (booking.courts ?? []).first.courtName ?? ""
                            },
                          );
                        },
                      );
                      if (paid is bool && paid) {
                        Utils.showMessageDialog(
                            context, "YOU_HAVE_PAID_SUCCESSFULLY".tr(context));
                        ref.invalidate(fetchUserAllBookingsProvider);
                        ref.invalidate(walletInfoProvider);

                      }
                    },
                    width: 85.w,
                    height: 30.h,
                    isForPopup: true,
                    labelStyle: AppTextStyles.manropeBold(
                        fontSize: 14.sp,color: AppColors.brick),
                    padding: EdgeInsets.zero,
                  )
                ],
              ),
            ),
          Row(
            children: [
              Text(
                "BOOKING".tr(context),
                style: AppTextStyles.manropeSemiBold(
                  color: textColor,
                  fontSize: 16.sp,
                ),
              ),
              const Spacer(),
              Text(
                (booking.service?.location?.locationName ?? "").toUpperCase(),
                style: AppTextStyles.sofiaSansMedium(
                    color: textColor,
                    fontSize: 19.sp,),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          CDivider(
            color: isCancelled ? AppColors.white25 : AppColors.black5,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${booking.courtName}".capitalizeFirst,
                    style: AppTextStyles.manropeMedium(
                      color: textColor,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "${"PRICE".tr(context)} ${Utils.formatPrice(booking.pricePaid(ref))}",
                    style: AppTextStyles.manropeMedium(
                      color: textColor,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // if (isCancelled) ...[
                  //   Text(
                  //     booking.formattedDateStartEndTimeAM12,
                  //     style: AppTextStyles.qanelasLight(
                  //       color: textColor,
                  //     ),
                  //   ),
                  //   SizedBox(height: 2.h),
                  //   Text(
                  //     booking.bookingLevel,
                  //     style: AppTextStyles.qanelasLight(
                  //       color: textColor,
                  //     ),
                  //   ),
                  // ] else ...[
                    Text(
                      booking.formatBookingDate,
                      style: AppTextStyles.manropeMedium(
                        color: textColor,
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      booking.formatStartEndTimeAM12.toLowerCase(),
                      style: AppTextStyles.manropeMedium(
                        color: textColor,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ]
                // ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
