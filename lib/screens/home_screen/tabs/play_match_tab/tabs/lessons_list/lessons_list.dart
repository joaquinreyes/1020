import 'package:hop/components/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/c_divider.dart';
import 'package:hop/components/multi_style_text.dart';
import 'package:hop/components/network_circle_image.dart';
import 'package:hop/components/service_detail_components.dart/event_lesson_card_coach.dart';
import 'package:hop/components/service_detail_components.dart/level_restriction_container.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/components/secondary_text.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/lesson_models.dart';
import 'package:hop/repository/payment_repo.dart';
import 'package:hop/repository/play_repo.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:hop/routes/app_routes.dart';
import 'package:hop/screens/home_screen/tabs/play_match_tab/tabs/tab_parent.dart';
import 'package:hop/screens/payment_information/payment_information.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../../../../../../repository/booking_repo.dart';

part 'lessons_list_components.dart';

class LessonsList extends ConsumerStatefulWidget {
  const LessonsList({
    super.key,
    required this.start,
    required this.end,
    required this.locationIds,
    required this.sportsIds,
  });

  final DateTime start;
  final DateTime end;
  final List<int> locationIds;
  final List<int> sportsIds;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LessonState();
}

class _LessonState extends ConsumerState<LessonsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lessons = ref.watch(lessonsListProvider(
      startDate: widget.start,
      endDate: widget.end,
      locationIDs: widget.locationIds,
      sportsIds: widget.sportsIds,
    ));
    return PlayTabsParentWidget(
      onRefresh: () => ref.refresh(lessonsListProvider(
        startDate: widget.start,
        endDate: widget.end,
        sportsIds: widget.sportsIds,
      ).future),
      child: lessons.when(
        data: (data) {
          if (data.isEmpty) {
            return SecondaryText(text: "NO_LESSONS_FOUND".tr(context));
          }
          return ListView.builder(
            itemCount: data.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _Lessons(
                lesson: data[index],
                start: widget.start,
                end: widget.end,
                locationIds: widget.locationIds,
              );
            },
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, _) => SecondaryText(text: error.toString()),
      ),
    );
  }
}

class _Lessons extends ConsumerStatefulWidget {
  const _Lessons({
    required this.lesson,
    required this.start,
    required this.end,
    required this.locationIds,
  });

  final LessonsModel lesson;
  final DateTime start;
  final DateTime end;
  final List<int> locationIds;

  @override
  ConsumerState<_Lessons> createState() => _LessonsState();
}

class _LessonsState extends ConsumerState<_Lessons> {
  bool isDatesVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      decoration: BoxDecoration(
        color: AppColors.black5,
        // border: border,
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (widget.lesson.lessonName ?? "").capitalizeFirst,
                        style: AppTextStyles.manropeSemiBold(
                            fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      LevelRestrictionContainer(
                        levelRestriction: widget.lesson.levelRestriction,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: EventLessonCardCoach(
                    coaches: widget.lesson.coaches,
                    borderRadius: 100.r,
                  ),
                ),
              ],
            ),
          ),
          CDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    widget.lesson.description,
                    style: AppTextStyles.manropeMedium(
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.lesson.location?.locationName ?? '',
                      style: AppTextStyles.manropeMedium(
                        fontSize: 13.sp,
                      ),
                    ),
                    2.verticalSpace,
                    Text(
                      Utils.formatPrice(widget.lesson.price),
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.manropeMedium(
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: _HideShowDatesButton(
              isDatesVisible: isDatesVisible,
              onTap: () {
                setState(() {
                  isDatesVisible = !isDatesVisible;
                });
              },
            ),
          ),
          if (isDatesVisible) ...[
            // _LessonCoachesListView(
            //   lesson: widget.lesson,
            //   maximumCapacity: widget.lesson.maximumCapacity ?? 0,
            //   minimumCapacity: widget.lesson.minimumCapacity ?? 0,
            //   onChangeSelectedCoach: (int? id) {
            //     widget.lesson.selectedCoach = id;
            //     setState(() {});
            //   },
            // ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: _LessonDatesListView(
                services: widget.lesson.services,
                onTap: (index) {
                  final serviceBooking =
                      widget.lesson.services![index].serviceBookings?.first;
                  _onJoinTap(serviceBooking);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _onJoinTap(LessonServiceBookings? serviceBooking) async {
    final maxCapacity = widget.lesson.maximumCapacity ?? 0;
    if (maxCapacity == 1) {
      await _joinSingle(serviceBooking);
    } else {
      await ref
          .read(goRouterProvider)
          .push("${RouteNames.lesson_info}/${serviceBooking?.id}");
    }
    ref.read(
      lessonsListProvider(
        startDate: widget.start,
        endDate: widget.end,
        locationIDs: widget.locationIds,
      ),
    );
  }

  Future<void> _joinSingle(LessonServiceBookings? serviceBooking) async {
    final confirmed = await showDialog(
        context: context, builder: (_) => const _ConfirmationDialog());
    if (confirmed == true && context.mounted) {
      final canProceed = await Utils().checkForLevelAssessment(
          ref: ref,
          context: context,
          sportsName: serviceBooking?.getSportsName(ref));

      if (!canProceed) {
        return;
      }
      final courtPrice = fetchCourtPriceProvider(
          coachId: serviceBooking?.coachesId,
          serviceId: serviceBooking!.id ?? 0,
          courtId: [serviceBooking.courtId],
          durationInMin: serviceBooking.duration2,
          requestType: CourtPriceRequestType.join,
          dateTime: DateTime.now());
      await Utils.showLoadingDialog(context, courtPrice, ref);
      final provider = joinServiceProvider(
        serviceBooking.id!,
        position: 0,
        isLesson: true,
        playerId: null,
        isEvent: false,
        isOpenMatch: false,
        isDouble: false,
        isReserve: false,
        isApprovalNeeded: false,
      );
      if (!mounted) {
        return;
      }
      final double? price =
          await Utils.showLoadingDialog(context, provider, ref);
      if (price != null && context.mounted && mounted) {
        final data = await showDialog(
          context: context,
          builder: (context) {
            return PaymentInformation(
                title: "PAY_MY_SHARE".trU(context),
                // boldPosition: 1,
                type: PaymentDetailsRequestType.join,
                locationID: widget.lesson.location!.id!,
                price: price,
                requestType: PaymentProcessRequestType.join,
                serviceID: serviceBooking.id!,
                duration: serviceBooking.duration2,
                startDate: serviceBooking.bookingStartTime);
          },
        );

        var (int? paymentDone, double? amount) = (null, null);
        if (data is (int, double?)) {
          (paymentDone, amount) = data;
        }

        if (paymentDone != null && context.mounted && mounted) {
          Utils.showMessageDialog(
            context,
            "YOU_HAVE_JOINED_SUCCESSFULLY".tr(context),
          );
        }
      }
    }
  }
}
