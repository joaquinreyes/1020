import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/c_divider.dart';
import 'package:hop/components/open_match_participant_row.dart';
import 'package:hop/components/secondary_text.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/open_match_model.dart';
import 'package:hop/repository/play_repo.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:hop/routes/app_routes.dart';
import 'package:hop/screens/home_screen/tabs/play_match_tab/tabs/tab_parent.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../../../../../globals/constants.dart';

class OpenMatchesList extends ConsumerStatefulWidget {
  const OpenMatchesList({
    super.key,
    required this.start,
    required this.end,
    required this.locationIds,
    required this.sportsIds,
    required this.minLevel,
    required this.maxLevel,
    required this.selectedSport,
  });

  final DateTime start;
  final DateTime end;
  final List<int> locationIds;
  final List<int> sportsIds;
  final int minLevel;
  final int maxLevel;
  final String selectedSport;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OpenMatchesState();
}

class _OpenMatchesState extends ConsumerState<OpenMatchesList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final openMatches = ref.watch(openMatchesListProvider(
      startDate: widget.start,
      endDate: widget.end,
      locationIDs: widget.locationIds,
      sportsIds: widget.sportsIds,
      minLevel: widget.minLevel,
      maxLevel: widget.maxLevel,
    ));
    return PlayTabsParentWidget(
      onRefresh: () => ref.refresh(openMatchesListProvider(
        startDate: widget.start,
        endDate: widget.end,
        locationIDs: widget.locationIds,
        sportsIds: widget.sportsIds,
        minLevel: widget.minLevel,
        maxLevel: widget.maxLevel,
      ).future),
      child: openMatches.when(
        data: (data) {
          if (data.isEmpty) {
            return SecondaryText(
              text: "NO_OPEN_MATCHES_FOUND".tr(context),
              subtitle: "NO_OPEN_MATCHES_FOUND_SUBTITLE".tr(context),
              imagePath: 'assets/images/illustrations/shared/crossed_rackets.png',
              imageSize: 130,
            );
          }
          // final dateList = _getDateList(data);
          final dateList = data.dateList;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildBookingWidgets(dateList, data),
          );
        },
        loading: () {
          return const Center(child: CupertinoActivityIndicator());
        },
        error: (error, stackTrace) {
          log("PlayTabsParentWidget :: ${error} :: $stackTrace");
          return SecondaryText(
            text: "NO_OPEN_MATCHES_FOUND".tr(context),
            subtitle: "NO_OPEN_MATCHES_FOUND_SUBTITLE".tr(context),
            imagePath: 'assets/images/illustrations/shared/crossed_rackets.png',
            imageSize: 130,
          );
        },
      ),
    );
  }

  List<Widget> buildBookingWidgets(
      List<DateTime> dateList, List<OpenMatchModel> matches) {
    final widgets = <Widget>[];
    for (var date in dateList) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 15.h),
          child: Text(
            Utils.formatBookingDate(date, context).toUpperCase(),
            style: AppTextStyles.sofiaSansMedium(
                fontSize: 23.sp,),
          ),
        ),
      );

      final dataMatches = matches.where((e) => e.bookingDate == date).toList();

      widgets.addAll(
        dataMatches.map(
          (match) => Padding(
            padding: EdgeInsets.only(bottom: 15.h),
            child: InkWell(
              onTap: () async {
                await ref
                    .read(goRouterProvider)
                    .push("${RouteNames.match_info}/${match.id}");
                ref.invalidate(openMatchesListProvider(
                  startDate: widget.start,
                  endDate: widget.end,
                  locationIDs: widget.locationIds,
                  sportsIds: widget.sportsIds,
                  minLevel: widget.minLevel,
                  maxLevel: widget.maxLevel,
                ));
              },
              child: _OpenMatchCard(
                match: match,
                selectedSport: widget.selectedSport,
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}

class _OpenMatchCard extends ConsumerWidget {
  const _OpenMatchCard({required this.match, required this.selectedSport});

  final OpenMatchModel match;
  final String selectedSport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String level = match.openMatchLevelRange;
    if (level.isNotEmpty) {
      level = "${"LEVEL".tr(context)} $level";
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 15.h),
      decoration: BoxDecoration(
        color: AppColors.black5,
        border: border,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 10,
                child: Text(
                  '${match.bookingDate.format("EEE dd MMM")} | ${match.bookingStartTime.format("h:mm")} - ${match.bookingEndTime.format("h:mm a").toLowerCase()}',
                  style: AppTextStyles.manropeSemiBold(
                    fontSize: 13.sp,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  (match.service?.location?.locationName ?? "").toUpperCase(),
                  textAlign: TextAlign.end,
                  style: AppTextStyles.sofiaSansMedium(
                      fontSize: 19.sp,),
                ),
              ),
            ],
          ),
          // SizedBox(height: 2.h),
          CDivider(color: AppColors.black5,),
          5.verticalSpace,
          OpenMatchParticipantRow(
            textForAvailableSlot: "AVAILABLE".trU(context),
            backGroundColor: Colors.transparent,
            slotIconColor: AppColors.black,
            players: match.players ?? [],
            imageBgColor: AppColors.blue,
            borderColor: AppColors.black,
            imageLogoColor: AppColors.white,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(
                "${match.court}".capitalizeFirst,
                style: AppTextStyles.manropeMedium(fontSize: 13.sp),
              ),
              const Spacer(),
              Text(
                level,
                style: AppTextStyles.manropeMedium(fontSize: 13.sp),
              ),
            ],
          )
        ],
      ),
    );
  }
}
