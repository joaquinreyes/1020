import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/c_divider.dart';
import 'package:hop/components/changes_cancelled_listing_card.dart';
import 'package:hop/components/open_match_participant_row.dart';
import 'package:hop/components/waiting_for_approval.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/user_bookings.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/models/court_booking.dart' as bookingModel;
import '../repository/booking_repo.dart';
import '../repository/user_repo.dart';
import '../screens/home_screen/tabs/booking_tab/book_court_dialog/book_court_dialog.dart';
import '../screens/open_match_detail/dupr_ranked_component.dart';
import 'main_button.dart';

class UserOpenMatchCard extends ConsumerWidget {
  const UserOpenMatchCard({super.key, required this.booking});

  final UserBookings booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlayerPendingPayment = booking.isPlayerPendingPayment(ref);

    bool isCancelled = booking.isCancelled ?? false;
    final color = isCancelled || isPlayerPendingPayment ? AppColors.brick : AppColors.black5;
    final textColor = isCancelled || isPlayerPendingPayment ? AppColors.white : AppColors.black;
    bool isWaiting = booking.requestWaitingList?.isNotEmpty ?? false;
    final price = booking.service?.price != null
        ? Utils.formatPriceNew(booking.service?.price?.toDouble())
        : "-";
    return Container(
      padding: EdgeInsets.all(15.h),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: color,
        // border: border,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isWaiting && !isCancelled) ...[
            WaitingForApproval(
              title: "IN_WAITING_LIST".tr(context),
              // backgroundColor: AppColors.black2,
              // titleStyle: AppTextStyles.manropeSemiBold(
              //   fontSize: 13.sp,
              //   color: AppColors.white,
              // ),
            )
          ],
          if (isWaiting && !isCancelled) ...[
            10.verticalSpace,
          ],
          if (isCancelled) ...[
            ChangesCancelledListingCard(
              text: "OPEN_MATCH_CANCELLED".tr(context),
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
                    label: "PAY_NOW".trU(context),
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
                            getPendingPayment: true,
                            allowPayLater: false,
                            showRefund: true,
                            coachId: null,
                            defaultOpenMatch: true,
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
                "OPEN_MATCHH".tr(context),
                style: AppTextStyles.manropeSemiBold(
                    color: textColor, fontSize: 16.sp,),
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
            color: (isCancelled || isPlayerPendingPayment) ? AppColors.white25 : AppColors.black5,
          ),
          if (!isCancelled)
            PrivateRankedComponent(
                isPrivate: booking.isPrivateMatch ?? false,
                isRanked: !(booking.isFriendlyMatch ?? true)),
          // if (isCancelled || isPlayerPendingPayment)
            SizedBox(height: 5.h),
          OpenMatchParticipantRow(
            textForAvailableSlot: "RESERVE".trU(context),
            players: booking.players ?? [],
            textColor: textColor,
            imageBgColor: isCancelled || isPlayerPendingPayment ? AppColors.white : AppColors.blue,
            imageLogoColor: isCancelled || isPlayerPendingPayment ? AppColors.brick : AppColors.white,
            backGroundColor: isCancelled || isPlayerPendingPayment ? AppColors.yellow : AppColors.blue,
            slotIconColor: isCancelled || isPlayerPendingPayment ? AppColors.brick : AppColors.white,
          ),
          if (!isCancelled) SizedBox(height: 15.h),
          Row(
            children: [
              Text(
                "${booking.courtName.capitalizeFirst}",
                style: AppTextStyles.manropeMedium(
                  color: textColor,
                  fontSize: 13.sp,
                ),
              ),
              const Spacer(),
              Text(
                booking.formattedDateStartEndTimeAMH,
                style: AppTextStyles.manropeMedium(
                  color: textColor,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Text(
                "${"PRICE".tr(context)} $price",
                style: AppTextStyles.manropeMedium(
                  color: textColor,
                  fontSize: 13.sp,
                ),
              ),
              const Spacer(),
              Text(
                "${"LEVEL".tr(context)} ${booking.bookingLevel}",
                style: AppTextStyles.manropeMedium(
                  color: textColor,
                  fontSize: 13.sp,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
