import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/c_divider.dart';
import 'package:hop/components/changes_cancelled_details_card.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/components/multi_style_text.dart';
import 'package:hop/components/network_circle_image.dart';
import 'package:hop/components/secondary_button.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/service_detail_model.dart';
import 'package:hop/repository/booking_repo.dart';
import 'package:hop/repository/play_repo.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:hop/screens/responsive_widgets/home_responsive_widget.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/widgets/background_view.dart';
import '../../components/refund_description_component.dart';
import '../../components/secondary_text.dart';
import '../../models/cancellation_policy_model.dart';
import '../../models/court_booking.dart' as booking;
import '../../routes/app_routes.dart';
import '../home_screen/tabs/booking_tab/book_court_dialog/book_court_dialog.dart';

class BookingDetail extends ConsumerStatefulWidget {
  const BookingDetail({super.key, required this.bookingId});

  final int? bookingId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookingDetailState();
}

class _BookingDetailState extends ConsumerState<BookingDetail> {
  @override
  Widget build(BuildContext context) {
    return BackgroundView(
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        body: SafeArea(
            child: HomeResponsiveWidget(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 18.w),
                  child: InkWell(
                    onTap: () => ref.read(goRouterProvider).pop(),
                    child: Image.asset(
                      AppImages.back_arrow_new.path,
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                ),
              ),
              Text(
                "${"BOOKING".trU(context)} \n${"INFORMATION".trU(context)}",
                style: AppTextStyles.sofiaSansMedium(
                  fontSize: 30.sp,
                ).copyWith(height: 1),
                textAlign: TextAlign.center,
              ),
              _body()
            ],
          ),
        )),
      ),
    );
  }

  Widget _body() {
    if (widget.bookingId == null) {
      return SecondaryText(text: "BOOKING_ID_NOT_FOUND".tr(context));
    }
    final serviceDetail = ref.watch(fetchServiceDetailProvider(widget.bookingId!));
    return serviceDetail.when(
      data: (data) {
        return _DataBody(
          userBooking: data,
        );
      },
      error: (error, stackTrace) => SecondaryText(text: error.toString()),
      loading: () => const Center(
        child: CupertinoActivityIndicator(
          radius: 10,
        ),
      ),
    );
  }
}

class _CancelConfirmDialog extends StatelessWidget {
  final CancellationPolicy policy;

  const _CancelConfirmDialog({required this.policy});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "ARE_YOU_SURE_YOU_WANT_TO_CANCEL_THE_BOOKING".trU(context),
            textAlign: TextAlign.center,
            style: AppTextStyles.popupHeaderTextStyle,
          ),
          SizedBox(height: 5.h),
          RefundDescriptionComponent(policy: policy),
          SizedBox(height: 20.h),
          MainButton(
            label: "CANCEL_BOOKING".trU(context),
            isForPopup: true,
            onTap: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    );
  }
}

class _DataBody extends ConsumerWidget {
  final ServiceDetail userBooking;

  const _DataBody({required this.userBooking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),
          if (userBooking.isCancelled ?? false) ...[
            ChangesCancelledDetailsCard(
              heading: "BOOKING_CANCELLED".tr(context),
              description: "CANCEL_DESC".tr(context),
              contactPhone: ref.read(clubLocationsProvider).value
                  ?.where((l) => l.id == userBooking.service?.location?.id)
                  .firstOrNull
                  ?.locationNumber,
            ),
            SizedBox(height: 10.h),
          ],
          _buildCard(context, ref),
          SizedBox(height: 20.h),
          if (!userBooking.isPast) ...[
            Row(
              children: [
                SecondaryImageButton(
                  label: "CANCEL_OR_RESCHEDULE".tr(context),
                  image: AppImages.crossIcon.path,
                  imageHeight: 10.w,
                  imageWidth: 10.w,
                  fontSize: 13.sp,
                  // labelStyle: AppTextStyles.qanelasLight(fontSize: 13.sp),
                  onTap: () {
                    _cancel(ref, context, userBooking);
                  },
                ),
                const Spacer(),
                SecondaryImageButton(
                  label: "SHARE_MATCH".tr(context),
                  image: AppImages.whatsaapIcon.path,
                  imageHeight: 14.w,
                  imageWidth: 14.w,
                  // labelStyle: AppTextStyles.qanelasLight(fontSize: 13.sp),
                  fontSize: 13.sp,
                  onTap: () {
                    _shareWhatsAap(context, ref);
                  },
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
          Row(
            children: [
              if (!userBooking.isPast)
                SecondaryImageButton(
                  label: "ADD_TO_CALENDAR".tr(context),
                  image: AppImages.calendar.path,
                  imageHeight: 15.w,
                  imageWidth: 15.w,
                  fontSize: 13.sp,
                  // labelStyle: AppTextStyles.qanelasLight(fontSize: 13.sp),
                  // borderRadius: 8.r,
                  onTap: () {
                    String title = "Booking @ ${userBooking.courtName} - ${userBooking.service?.location?.locationName}";
                    ref.watch(addToCalendarProvider(
                      title: title,
                      startDate: userBooking.bookingStartTime,
                      endDate: userBooking.bookingEndTime,
                    ));
                  },
                ),
              const Spacer(),
              if (allowOpenMatch)
                SecondaryImageButton(
                  label: "OPEN_MATCH_TO_FIND_PLAYERS".tr(context),
                  image: AppImages.tennisBall.path,
                  imageHeight: 13.w,
                  imageWidth: 13.w,
                  fontSize: 13.sp,
                  // labelStyle: AppTextStyles.qanelasLight(fontSize: 13.sp),
                  // borderRadius: 8.r,
                  onTap: () {
                    _changeToOpen(ref, context);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _shareWhatsAap(context, WidgetRef ref) {
    Utils.shareBookingWhatsapp(context, userBooking, ref);
  }

  Container _buildCard(BuildContext context, WidgetRef ref) {
    String level = "";
    String profileUrl = "";
    String firstName = "-";
    if ((userBooking.players ?? []).isNotEmpty) {
      level = userBooking.players?.first.customer?.level(getSportsName(ref)) ?? "";
      profileUrl = userBooking.players?.first.customer?.profileUrl ?? "";
      firstName = userBooking.players?.first.getCustomerName ?? "";
    }
    // if (userBooking.courtName == 'Sauna') {
    //   return Container(
    //     padding: EdgeInsets.all(15.w),
    //     decoration: BoxDecoration(
    //       color: AppColors.blue,
    //       borderRadius: BorderRadius.circular(12.r),
    //     ),
    //     child: Column(
    //       children: [
    //         Row(
    //           children: [
    //             Text(
    //               firstName,
    //               style: AppTextStyles.sofiaSansMedium(
    //                 color: AppColors.white,
    //                 fontSize: 16.sp,
    //               ),
    //             ),
    //             const Spacer(),
    //             Text(
    //               '${userBooking.service?.location?.locationName}',
    //               style: AppTextStyles.sofiaSansMedium(
    //                 color: AppColors.white,
    //                 fontSize: 16.sp,
    //               ),
    //             ),
    //           ],
    //         ),
    //         CDivider(
    //           color: AppColors.white25,
    //         ),
    //         SizedBox(height: 5.h),
    //         Row(
    //           children: [
    //             15.horizontalSpace,
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   '${userBooking.courtName}',
    //                   style: AppTextStyles.manropeMedium(
    //                     color: AppColors.white,
    //                     fontSize: 15.sp,
    //                   ),
    //                 ),
    //                 SizedBox(height: 2.h),
    //                 Text(
    //                   "${'PRICE'.tr(context)} ${Utils.formatPriceNew(userBooking.pricePaid(ref))}",
    //                   style: AppTextStyles.manropeMedium(
    //                     color: AppColors.white,
    //                     fontSize: 15.sp,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             15.horizontalSpace,
    //             Spacer(),
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.end,
    //               children: [
    //                 Text(
    //                   "${userBooking.bookingStartTime.format("h:mm")} - ${userBooking.bookingEndTime.format("h:mm a").toLowerCase()}",
    //                   style: AppTextStyles.manropeMedium(
    //                     color: AppColors.white,
    //                     fontSize: 15.sp,
    //                   ),
    //                 ),
    //                 SizedBox(height: 2.h),
    //                 Text(
    //                   "${userBooking.bookingDate.format("EEE dd MMM")}",
    //                   style: AppTextStyles.manropeMedium(
    //                     color: AppColors.white,
    //                     fontSize: 15.sp,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         )
    //       ],
    //     ),
    //   );
    // }
    return Container(
      padding: EdgeInsets.fromLTRB(15.w,15.h,15.w,10.h),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "ORGANIZER".trU(context),
                style: AppTextStyles.sofiaSansMedium(
                  color: AppColors.white,
                  fontSize: 21.sp,
                ),
              ),
              const Spacer(),
              Text(
                "BOOKING".trU(context),
                style: AppTextStyles.sofiaSansMedium(
                  color: AppColors.white,
                  fontSize: 21.sp,
                ),
              ),
            ],
          ),
          CDivider(
            color: AppColors.white25,
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  NetworkCircleImage(
                    path: profileUrl,
                    width: 37.h,
                    height: 37.h,
                    borderRadius: BorderRadius.circular(4.r),
                    boxBorder: Border.all(
                      color: AppColors.white25,
                      width: 1,
                    ),
                    showBG: true,
                    bgColor: AppColors.white,
                  ),
                  2.verticalSpace,
                  Text(
                    firstName.toUpperCase(),
                    style: AppTextStyles.sofiaSansMedium(
                      color: AppColors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    "${level} ${getRankLabel(double.tryParse(level) ?? 0)}", //•  Right",
                    style: AppTextStyles.manropeMedium(
                      fontSize: 12.sp,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${userBooking.bookingDate.format("EEE dd MMM")} | ${userBooking.bookingStartTime.format("HH:mm")} - ${userBooking.bookingEndTime.format("HH:mm")}",
                    style: AppTextStyles.manropeMedium(
                      color: AppColors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    "${userBooking.courtName.capitalizeFirst} | ${userBooking.service?.location?.locationName}",
                    style: AppTextStyles.manropeMedium(
                      color: AppColors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                  // SizedBox(height: 2.h),
                  // Text(
                  //   "${"PRICE".tr(context)} ${Utils.formatPrice(userBooking.pricePaid(ref))} ",
                  //   style: AppTextStyles.gothicRegular().copyWith(color: AppColors.white, fontSize: 14.sp),
                  // ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _cancel(WidgetRef ref, BuildContext context, ServiceDetail data) async {
    final CancellationPolicy? policy = await Utils.showLoadingDialog(context, cancellationPolicyProvider(data.id!), ref);

    if (policy == null || !context.mounted) {
      return;
    }

    final check = await showDialog(
      context: context,
      builder: (context) => _CancelConfirmDialog(policy: policy),
    );

    if (check is bool && check && context.mounted) {
      final bool? left = await Utils.showLoadingDialog(context, cancelServiceProvider(data.id!), ref);
      if (left == true && context.mounted) {
        Utils.showMessageDialog(
          context,
          "YOU_HAVE_CANCELED_THE_BOOKING".trU(context),
        ).then((value) {
          ref.read(goRouterProvider).pop();
        });
      }
    }
  }

  Future<void> _changeToOpen(WidgetRef ref, BuildContext context) async {
    if ((userBooking.courts ?? []).isNotEmpty && userBooking.service != null && userBooking.service!.location != null) {
      List<booking.BookingCourts> listCourts = [];

      (userBooking.courts ?? []).map((e) {
        listCourts.add(booking.BookingCourts.fromJson(e.toJson()));
      }).toList();

      String sportName = "";
      if ((userBooking.players ?? []).isNotEmpty && userBooking.players!.first.customer!.sportsLevel.isNotEmpty) {
        sportName = userBooking.players!.first.customer!.sportsLevel.first.sportName ?? "";
      }
      int? serviceId = await showDialog(
        useSafeArea: false,
        context: context,
        builder: (context) {
          return BookCourtDialog(
            isOnlyOpenMatch: true,
            showRefund: true,
            coachId: null,
            courtPriceRequestType: CourtPriceRequestType.join,
            bookings: booking.Bookings(
                id: userBooking.id,
                price: userBooking.service!.price,
                duration: userBooking.duration2,
                isOpenMatch: true,
                sport: booking.Sport(sportName: sportName),
                location: booking.Location(
                    id: userBooking.service!.location!.id, courts: listCourts, locationName: userBooking.service!.location!.locationName)),
            bookingTime: userBooking.bookingDate,
            court: {(userBooking.courts ?? []).first.id ?? 0: (userBooking.courts ?? []).first.courtName ?? ""},
          );
        },
      );

      if (serviceId != null) {
        ref.read(goRouterProvider).push("${RouteNames.match_info}/$serviceId").then((e) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
      }
    }
  }
}
