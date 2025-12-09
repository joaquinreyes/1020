import 'package:flutter/cupertino.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/book_court_info_card.dart';
import 'package:hop/components/multi_style_text.dart';
import 'package:hop/components/open_match_participant_row.dart';
import 'package:hop/components/secondary_button.dart';
import 'package:hop/components/secondary_text.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/court_booking.dart';
import 'package:hop/repository/booking_repo.dart';
import 'package:hop/repository/play_repo.dart';
import 'package:hop/screens/app_provider.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../../../../models/court_price_model.dart';
import '../../../../models/lesson_model_new.dart';
import '../../../../models/base_classes/booking_player_base.dart';

class CourtBookedDialog extends ConsumerStatefulWidget {
  const CourtBookedDialog(
      {super.key,
      required this.bookings,
      required this.bookingTime,
      required this.court,
      this.amountPaid,
      this.refundAmount,
      this.borderRadius,
      this.title,
      this.courtPriceModel,
      required this.isOpenMatch,
      required this.serviceID,
      this.additionalPlayers});

  final Bookings bookings;
  final DateTime bookingTime;
  final Map<int, String> court;
  final bool isOpenMatch;
  final int? serviceID;
  final double? amountPaid;
  final double? refundAmount;
  final double? borderRadius;
  final Widget? title;
  final CourtPriceModel? courtPriceModel;
  final List<BookingPlayerBase>? additionalPlayers;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourtBookedDialogState();
}

class _CourtBookedDialogState extends ConsumerState<CourtBookedDialog> {
  @override
  Widget build(BuildContext context) {
    final cancellationHour = widget.isOpenMatch
        ? widget.courtPriceModel?.cancellationPolicy?.openMatchCancellationTimeInHours
        : widget.courtPriceModel?.cancellationPolicy?.cancellationTimeInHours;
    return CustomDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 5.h,
          ),
          Center(
            child: widget.title ??
                Text(
                  "BOOKING_INFORMATION".trU(context),
                  style: AppTextStyles.popupHeaderTextStyle,
                  textAlign: TextAlign.center,
                ),
            // Text(
            //   "YOU_HAVE_BOOKED_A_COURT".trU(context),
            //   style: AppTextStyles.gothamNarrowBold().copyWith(
            //       color: AppColors.white, fontSize: 19.sp, letterSpacing: 2),
            //   textAlign: TextAlign.center,
            // ),
          ),
          SizedBox(height: cancellationHour != null ? 5.h : 20.h),

          if (cancellationHour != null)
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Text(
                cancellationHour == 0
                    ? "YOU_WILL_NOT_GET_REFUND_ON_THIS_BOOKING".tr(context)
                    : "CANCELLATION_POLICY_HOURS".tr(context, params: {"HOUR": cancellationHour.toString()}),
                textAlign: TextAlign.center,
                style: AppTextStyles.popupBodyTextStyle,
              ),
            ),

          // Text(
          //   "CANCELLATION_POLICY".tr(context),
          //   style: AppTextStyles.popupBodyTextStyle,
          //   textAlign: TextAlign.center,
          // ),
          // SizedBox(height: 20.h),
          BookCourtInfoCard(
            price: widget.amountPaid ?? widget.bookings.price,
            textPrice: widget.refundAmount != null
                ? "${"PRICE".tr(context)} ${Utils.formatPrice((widget.amountPaid ?? widget.bookings.price)?.toDouble())}\n${"REFUND".tr(context)} ${Utils.formatPrice(widget.refundAmount?.toDouble())}"
                : null,
            borderRadius: BorderRadius.circular(10.r),
            bookings: widget.bookings,
            bookingTime: widget.bookingTime,
            courtName: "${widget.court.values.first}",
            // headerTextStyle: AppTextStyles.gothicLight(
            //     fontSize: 18.sp, color: AppColors.black),
            // dataTextStyle: AppTextStyles.gothicRegular(
            //     fontSize: 14.sp, color: AppColors.black),
          ),
          if (widget.isOpenMatch) SizedBox(height: 15.h),
          if (widget.isOpenMatch) _openMatch(),
          25.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: SecondaryImageButton(
                  label: 'ADD_TO_CALENDAR'.tr(context),
                  fontSize: 13.sp,
                  // labelStyle: AppTextStyles.qanelasLight(
                  //     fontSize: 13.sp, color: AppColors.white),
                  image: AppImages.calendar.path,
                  // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  // borderRadius: widget.borderRadius ?? 0.r,
                  onTap: () {
                    final sportName = kSportName;
                    String title = widget.isOpenMatch
                        ? "$sportName Match"
                        : "Booking @ ${widget.court.values.first} - ${widget.bookings.location?.locationName?.capitalizeFirst ?? ''}";
                    DateTime startTime = widget.bookingTime;
                    DateTime endTime = widget.bookingTime.add(Duration(minutes: widget.bookings.duration!));
                    ref.watch(addToCalendarProvider(
                      title: title,
                      startDate: startTime,
                      endDate: endTime,
                    ));
                  },
                  isForPopup: true,
                ),
              ),
              4.horizontalSpace,
              Flexible(
                child: SecondaryImageButton(
                  label: "SEE_MY_MATCHES".tr(context),
                  fontSize: 13.sp,
                  // labelStyle: AppTextStyles.qanelasLight(
                  //     fontSize: 13.sp, color: AppColors.white),
                  image: AppImages.tennisBall.path,
                  imageHeight: 13.h,
                  imageWidth: 13.h,
                  isForPopup: true,
                  // padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                  // borderRadius: widget.borderRadius ?? 10.r,
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
              ),
            ],
          ),
          if (widget.isOpenMatch) ...[
            SizedBox(height: 14.h),
            Align(
              alignment: Alignment.centerLeft,
              child: SecondaryImageButton(
                isForPopup: true,
                label: 'SHARE_MATCH'.tr(context),
                imageHeight: 14.h,
                imageWidth: 14.h,
                fontSize: 13.sp,
                // labelStyle: AppTextStyles.qanelasLight(
                //     fontSize: 13.sp, color: AppColors.white),
                image: AppImages.whatsaapIcon.path,
                // padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                onTap: () {
                  final service = ref.watch(fetchServiceDetailProvider(widget.serviceID!)).asData?.value;
                  if (service == null) return;
                  Utils.shareOpenMatch(context, service, ref);
                },
              ),
            ),
          ],
          20.verticalSpace,
        ],
      ),
    );
  }

  _openMatch() {
    final service = ref.watch(fetchServiceDetailProvider(widget.serviceID!));
    return service.when(
      data: (data) {
        final String organizerNote = data.organizerNote ?? "";

        // Combine API players with additional players from booking tab
        List<BookingPlayerBase> combinedPlayers = List.from(data.players ?? []);

        if (widget.additionalPlayers != null && widget.additionalPlayers!.isNotEmpty) {
          // Get existing player IDs to avoid duplicates
          final existingPlayerIds = combinedPlayers.map((p) => p.id).toSet();

          // Add additional players that aren't already in the list
          for (var player in widget.additionalPlayers!) {
            if (!existingPlayerIds.contains(player.id)) {
              combinedPlayers.add(player);
            }
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (organizerNote.isNotEmpty) ...[
              Text(
                "NOTE_FROM_THE_ORGANIZER".trU(context),
                style: AppTextStyles.sofiaSansMedium(fontSize: 21.sp,color: AppColors.white,),
              ),
              SizedBox(height: 5.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6.h,horizontal: 12.w),
                decoration: BoxDecoration(
                  color: AppColors.white25,
                  borderRadius: BorderRadius.circular(100.r)
                ),
                width: double.infinity,
                child: Text(
                  data.organizerNote ?? "",
                  style: AppTextStyles.manropeMedium(fontSize: 13.sp,color: AppColors.white,),
                ),
              ),
              SizedBox(height: 15.h),
            ],
            // YOUR_OPEN_MATCH
            Text(
              "YOUR_OPEN_MATCH".trU(context),
              style: AppTextStyles.sofiaSansMedium(color: AppColors.white,fontSize: 21.sp),
            ),
            SizedBox(height: 5.h),
            OpenMatchParticipantRowWithBG(
              textForAvailableSlot: "RESERVE".trU(context),
              players: combinedPlayers,
              backgroundColor: AppColors.white25,
              textColor: AppColors.white,
              imageLogoColor: AppColors.brick,
              imageBgColor: AppColors.white,
              slotIconColor: AppColors.brick,
              slotBackgroundColor: AppColors.yellow,
            ),
            SizedBox(height: 15.h),
          ],
        );
      },
      error: (err, __) => SecondaryText(text: err.toString()),
      loading: () => Center(
        child: CupertinoActivityIndicator(color: AppColors.white25),
      ),
    );
  }
}

class CourtLessonBookedDialog extends ConsumerStatefulWidget {
  const CourtLessonBookedDialog(
      {super.key,
        required this.title,
        required this.bookingTime,
        required this.courtId,
        required this.calendarTitle,
        required this.lessonId,
        required this.coachId,
        required this.courtName,
        required this.locationId,
        required this.locationName,
        required this.lessonVariant,
        required this.lessonTime,
        required this.price});

  final DateTime bookingTime;
  final String title;
  final String calendarTitle;
  final double price;
  final String courtName;
  final int courtId;
  final int lessonId;
  final int coachId;
  final int locationId;
  final String locationName;
  final int lessonTime;
  final LessonVariants? lessonVariant;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourtLessonBookedDialogState();
}

class _CourtLessonBookedDialogState extends ConsumerState<CourtLessonBookedDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              "YOU_HAVE_BOOKED_A_LESSON".trU(context),
              style: AppTextStyles.popupHeaderTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "CANCELLATION_POLICY_LESSON".tr(context),
            textAlign: TextAlign.center,
            style: AppTextStyles.popupBodyTextStyle,
          ),
          SizedBox(height: 20.h),
          BookCourtInfoCardLesson(
            lessonVariant: widget.lessonVariant,
            bookingTime: widget.bookingTime,
            coachName: widget.title,
            duration: widget.lessonTime,
            locationName: widget.locationName,
            title: widget.title,
            courtName: '${widget.courtName}',
            price: widget.price,
            isBooked: true,
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: SecondaryImageButton(
                  label: 'ADD_TO_CALENDAR'.tr(context),
                  isForPopup: true,
                  image: AppImages.calendar.path,
                  labelStyle: AppTextStyles.manropeLight(fontSize: 13.sp, color: AppColors.white),
                  borderRadius: 100.r,
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                  onTap: () {
                    String title = "Booking @ ${widget.title} - ${widget.locationName.capitalizeFirst}";
                    DateTime startTime = widget.bookingTime;
                    DateTime endTime = widget.bookingTime.add(Duration(minutes: widget.lessonTime));
                    ref.watch(addToCalendarProvider(
                      title: title,
                      startDate: startTime,
                      endDate: endTime,
                    ));
                  },
                ),
              ),
              4.horizontalSpace,
              Flexible(
                child: SecondaryImageButton(
                  label: "SEE_MY_BOOKINGS".tr(context),
                  isForPopup: true,
                  image: AppImages.tennisBall.path,
                  imageHeight: 13.h,
                  imageWidth: 13.h,
                  labelStyle: AppTextStyles.manropeLight(fontSize: 13.sp, color: AppColors.white),
                  borderRadius: 100.r,
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
