import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/c_divider.dart';
import 'package:hop/components/service_detail_components.dart/event_lesson_card_coach.dart';
import 'package:hop/components/service_detail_components.dart/level_restriction_container.dart';
import 'package:hop/components/secondary_text.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/events_model.dart';
import 'package:hop/repository/play_repo.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:hop/routes/app_routes.dart';
import 'package:hop/screens/home_screen/tabs/play_match_tab/tabs/tab_parent.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../../../../../components/ranked_component.dart';
import '../../../../../globals/constants.dart';

class EventsList extends ConsumerStatefulWidget {
  const EventsList({
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
  ConsumerState<ConsumerStatefulWidget> createState() => _EventListState();
}

class _EventListState extends ConsumerState<EventsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventsListProvider(
      startDate: widget.start,
      endDate: widget.end,
      locationIDs: widget.locationIds,
      sportsIds: widget.sportsIds,
    ));
    return PlayTabsParentWidget(
      onRefresh: () => ref.refresh(eventsListProvider(
        startDate: widget.start,
        endDate: widget.end,
        locationIDs: widget.locationIds,
        sportsIds: widget.sportsIds,
      ).future),
      child: events.when(
        data: (data) {
          if (data.isEmpty) {
            return SecondaryText(text: "NO_EVENTS_FOUND".tr(context));
          }
          final dateList = data.dateList;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildBookingWidgets(dateList, data),
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, _) => SecondaryText(text: error.toString()),
      ),
    );
  }

  List<Widget> buildBookingWidgets(
      List<DateTime> dateList, List<EventsModel> matches) {
    final widgets = <Widget>[];
    for (var date in dateList) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: 15.h,
          ),
          child: Text(
            Utils.formatBookingDate(date, context).toUpperCase(),
            style: AppTextStyles.sofiaSansMedium(
              fontSize: 25.sp,
            ),
          ),
        ),
      );

      final dataMatches = matches.where((e) => e.bookingDate == date).toList();

      widgets.addAll(
        dataMatches.map(
          (event) => Padding(
            padding: EdgeInsets.only(bottom: 15.h),
            child: InkWell(
              onTap: () async {
                await ref
                    .read(goRouterProvider)
                    .push("${RouteNames.event_info}/${event.id}");
                ref.invalidate(
                  eventsListProvider(
                    startDate: widget.start,
                    endDate: widget.end,
                    locationIDs: widget.locationIds,
                    sportsIds: widget.sportsIds,
                  ),
                );
              },
              child: EventsCard(event: event),
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}

class EventsCard extends ConsumerWidget {
  const EventsCard({required this.event});

  final EventsModel event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: border,
        color: AppColors.black5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (event.service?.event?.eventName ?? "").capitalizeFirst,
                      style: AppTextStyles.manropeSemiBold(fontSize: 16.sp),
                    ),
                    SizedBox(height: 2.h),
                    LevelRestrictionContainer(
                      levelRestriction: event.service?.event?.levelRestriction,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: EventLessonCardCoach(
                  coaches: event.getCoaches,
                ),
              ),
            ],
          ),
          CDivider(),
          if (event.rankedEvent ?? false)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Align(
                alignment: Alignment.centerRight,
                child: RankedComponent(),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: _colInfo(
                  // event.courtName,
                  event.service?.location?.locationName ?? "",
                  "${"PRICE".tr(context)} ${Utils.formatPrice(event.service?.price)}",
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Utils.eventLessonStatusText(
                        context: context,
                        playersCount: event.players?.length ?? 0,
                        maxCapacity: event.getMaximumCapacity,
                        minCapacity: event.getMinimumCapacity,
                      ).trU(context),
                      style: AppTextStyles.sofiaSansMedium(
                        fontSize: 16.sp,
                      ),
                    ),
                    // SizedBox(height: 4.h),
                    Container(
                      padding:
                          EdgeInsets.only(top: 2.h, left: 10.w, right: 10.w),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Text(
                        "${event.players?.length.toString() ?? "0"}/${event.getMaximumCapacity.toString()}",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.manropeSemiBold(
                          color: AppColors.white,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _colInfo(
                  event.bookingDate.format("EEE dd MMM"),
                  "${event.bookingStartTime.format("HH:mm")} - ${event.bookingEndTime.format("HH:mm a").toLowerCase()}",
                  isEnd: true,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Column _colInfo(String text1, String text2, {bool isEnd = false}) {
    return Column(
      crossAxisAlignment:
          isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          style: AppTextStyles.manropeMedium(fontSize: 13.sp),
        ),
        SizedBox(height: 2.h),
        Text(
          text2,
          style: AppTextStyles.manropeMedium(fontSize: 13.sp),
        ),
      ],
    );
  }
}
