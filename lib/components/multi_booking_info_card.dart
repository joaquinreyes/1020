import 'package:hop/components/secondary_button.dart';
import 'package:hop/models/multi_booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:intl/intl.dart';

import '../models/court_booking.dart';
import 'book_court_info_card.dart';

class MultiBookingCourtInfoCard extends ConsumerStatefulWidget {
  const MultiBookingCourtInfoCard(
      {super.key,
      required this.bookings,
      this.color = AppColors.white,
      this.textColor,
      this.dividerColor,
      this.showDelete = true,
      this.onTapDeleteBooking});

  final List<MultipleBookings> bookings;
  final bool showDelete;
  final Color color;
  final Color? textColor;
  final Color? dividerColor;
  final Function(MultipleBookings)? onTapDeleteBooking;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MultiBookingCourtInfoCardState();
}

class _MultiBookingCourtInfoCardState extends ConsumerState<MultiBookingCourtInfoCard> {
  String? storeId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.bookings.map((e) => _body(e)).toList(),
    );
  }

  Widget _body(MultipleBookings data) {
    DateTime? date = DateTime.parse(data.date ?? "");

    String startTime = data.startTime ?? "";
    DateTime bookingTime = DateTime.parse("${DateFormat('yyyy-MM-dd').format(date)}T$startTime");

    // Calculate duration in minutes
    String endTime = data.endTime ?? "";

    DateTime endDateTime = DateTime.parse(
        "${DateFormat('yyyy-MM-dd').format(date.add(Duration(hours: (endTime.replaceAll("00", "").replaceAll(":", "").trim().isEmpty) ? 24 : 0)))}T$endTime");

    int duration = endDateTime.difference(bookingTime).inMinutes;
    // Format the date and time
    String dayAndDate = DateFormat('EEE d MMM').format(bookingTime);
    String startTimeFormatted = DateFormat('h:mm').format(bookingTime);
    String endTimeFormatted = DateFormat('h:mm a').format(endDateTime).toLowerCase();

    // Combine into the desired format
    String formattedDate = '$dayAndDate, $startTimeFormatted - $endTimeFormatted';

    bool checkOpen = storeId == data.sId;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              if (checkOpen) {
                storeId = null;
              } else {
                storeId = data.sId;
              }
              setState(() {});
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Text.rich(
                  TextSpan(
                    children: [
                      // TextSpan(
                      //   text: '${'BOOKING'.tr(context)} ',
                      //   style: AppTextStyles.qanelasMedium(
                      //     fontSize: 16.sp,
                      //     color: AppColors.white,
                      //   ).copyWith(
                      //     decoration: TextDecoration.underline,
                      //   ),
                      // ),
                      WidgetSpan(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: Text(
                            '${'BOOKING'.trU(context)} ',
                            style: AppTextStyles.sofiaSansMedium(
                              fontSize: 21.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      WidgetSpan(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: Text(
                            formattedDate.toUpperCase(),
                            style: AppTextStyles.sofiaSansMedium(
                              fontSize: 18.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      // TextSpan(
                      //   text: formattedDate,
                      //   style: AppTextStyles.qanelasMedium(
                      //     fontSize: 14.sp,
                      //     color: AppColors.white,
                      //   ).copyWith(
                      //     decoration: TextDecoration.underline,
                      //   ),
                      // ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                )),
                SizedBox(width: 10.w),
                Icon(
                  checkOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.white,
                  size: 16.h,
                )
              ],
            ),
          ),
          if (checkOpen)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                BookCourtInfoCard(
                  dividerColor: widget.dividerColor,
                  color: widget.color,
                  textColor: widget.textColor,
                  bookings: Bookings(
                    duration: duration < 0 ? 0 : duration,
                    location: Location(locationName: data.locationName),
                  ),
                  bookingTime: bookingTime,
                  courtName: "${data.courtName}",
                  price: data.totalPrice,
                  // headerTextStyle: AppTextStyles.gothicLight().copyWith(
                  //   fontSize: 17.sp,
                  //   color: AppColors.black90,
                  // ),
                  // dataTextStyle: AppTextStyles.gothicRegular().copyWith(fontSize: 14.sp, color: AppColors.black),
                ),
                if (widget.showDelete) SizedBox(height: 10.h),
                if (widget.showDelete)
                  SecondaryButton(
                    onTap: () {
                      if (widget.onTapDeleteBooking != null) {
                        widget.onTapDeleteBooking!(data);
                      }
                    },
                    color: AppColors.white25,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.close, color: AppColors.white, size: 18),
                        SizedBox(width: 7.w),
                        Text(
                          "DELETE_BOOKING".tr(context),
                          style: AppTextStyles.manropeMedium(fontSize: 13.sp, color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
