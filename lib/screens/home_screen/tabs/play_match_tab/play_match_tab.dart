import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:hop/components/selected_tag.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/current_platform.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/managers/user_manager.dart';
import 'package:hop/models/app_user.dart';
import 'package:hop/models/club_locations.dart';
import 'package:hop/models/players_ranking.dart';
import 'package:hop/repository/club_repo.dart';
import 'package:hop/screens/app_provider.dart';
import 'package:hop/screens/home_screen/tabs/play_match_tab/tabs/lessons_list/lessons_list.dart';
import 'package:hop/screens/home_screen/tabs/play_match_tab/tabs/events_list.dart';
import 'package:hop/screens/home_screen/tabs/play_match_tab/tabs/open_matches_list.dart';
import 'package:hop/screens/home_screen/tabs/play_match_tab/tabs/tab_parent.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:hop/box_shadow/flutter_inset_box_shadow.dart' as inset;
import 'package:syncfusion_flutter_core/theme.dart'
    show SfDateRangePickerTheme, SfDateRangePickerThemeData;

import '../../../../components/multi_style_text.dart';
import '../../../../components/network_circle_image.dart';
import '../../../../components/secondary_text.dart';
import '../../../../managers/pagination_params.dart';
import '../../../../models/service_detail_model.dart';
import '../../../../repository/user_repo.dart';

part 'play_match_providers.dart';

part 'play_match_component.dart';

class PlayMatchTab extends ConsumerStatefulWidget {
  const PlayMatchTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayMatchTabState();
}

class _PlayMatchTabState extends ConsumerState<PlayMatchTab> {
  @override
  void initState() {
    Future(() {
      ref.read(_selectedTabIndex.notifier).state = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      _selectedTabIndex,
      (previous, next) {
        if (next == previous) return;
        Future(() {
          ref.read(_pageController.notifier).state.animateToPage(
                next,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
        });
      },
    );
    final pageController = ref.watch(_pageController);
    final dateRange = ref.watch(dateRangeProvider);
    final levelRange = ref.watch(_selectedLevelProvider);
    final locationIDs = ref.watch(selectedLocationProvider);
    final sportsIds = ref.watch(_selectedSportsProvider);
    final locationID = ref.watch(selectedLocationProvider);
    final storeLocations = ref.watch(_storeAllLocationsProvider);
    List<int> locationIdList = [...locationIDs];
    List<int> sportsIdList =
        Utils.getSportsIds(sportsIds, storeLocations, locationID);
    final selectedTabIndex = ref.watch(_selectedTabIndex);
    return Column(
      children: [
        SizedBox(height: 20.h),
        Row(
          children: [
            const Spacer(),
            // const NotificationButton(),
            SizedBox(width: 30.w),
          ],
        ),
        // SizedBox(height: 2.5.h),
        const _ViewSelector(),
        SizedBox(height: 12.h),
        FilterRow(),
        SizedBox(height: 10.h),
        if (selectedTabIndex == 0) _PlayerRankingButton(),
        10.verticalSpace,
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                OpenMatchesList(
                  start: dateRange.startDate!,
                  end: dateRange.endDate!,
                  locationIds: locationIdList,
                  sportsIds: sportsIdList,
                  minLevel: levelRange.first.toInt(),
                  maxLevel: levelRange.last.toInt(),
                  selectedSport: sportsIds,
                ),
                EventsList(
                  start: dateRange.startDate!,
                  end: dateRange.endDate!,
                  locationIds: locationIdList,
                  sportsIds: sportsIdList,
                ),
                LessonsList(
                  start: dateRange.startDate!,
                  end: dateRange.endDate!,
                  locationIds: locationIdList,
                  sportsIds: sportsIdList,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
