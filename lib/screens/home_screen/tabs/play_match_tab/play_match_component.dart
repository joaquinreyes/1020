part of 'play_match_tab.dart';

class _ViewSelector extends ConsumerWidget {
  const _ViewSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(_selectedTabIndex);
    return Container(
      height: 54.h,
      decoration: inset.BoxDecoration(
        color: AppColors.black5,
       boxShadow: kInsetShadow
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTab(
                title:
                    '${'OPEN'.trU(context)}${kIsWeb ? " " : "\n"}${'MATCHES'.trU(context)}',
                index: 0,
                selectedIndex: selectedIndex,
                onTap: () => ref.read(_selectedTabIndex.notifier).state = 0,
              ),
              SizedBox(width: 15.w),
              CustomTab(
                title: "ACTIVITIES".trU(context),
                index: 1,
                selectedIndex: selectedIndex,
                onTap: () => ref.read(_selectedTabIndex.notifier).state = 1,
              ),
              SizedBox(width: 15.w),
              CustomTab(
                title: "COACHING".trU(context),
                index: 2,
                selectedIndex: selectedIndex,
                onTap: () => ref.read(_selectedTabIndex.notifier).state = 2,
              ),
            ],
          )
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         if (selectedIndex != 0) {
          //           ref.read(_selectedTabIndex.notifier).state = 0;
          //         }
          //       },
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: selectedIndex == 0 ? AppColors.black2 : Colors.transparent,
          //           borderRadius: BorderRadius.circular(15.r),
          //         ),
          //         child: Padding(
          //           padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
          //           child: Text(
          //             '${'OPEN'.trU(context)}\n${'MATCHES'.trU(context)}',
          //             textAlign: TextAlign.center,
          //             style: AppTextStyles.qanelasRegular(
          //               height: 0.95,
          //               fontSize: 16.sp,
          //               letterSpacing: 16.sp * 0.12,
          //               color: selectedIndex == 0 ? AppColors.white : AppColors.black70,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     SizedBox(width: 15.w),
          //     GestureDetector(
          //       onTap: () {
          //         if (selectedIndex != 1) {
          //           ref.read(_selectedTabIndex.notifier).state = 1;
          //         }
          //       },
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: selectedIndex == 1 ? AppColors.black2 : Colors.transparent,
          //           borderRadius: BorderRadius.circular(15.r),
          //         ),
          //         child: Padding(
          //           padding: EdgeInsets.only(right: 15.w, left: 15.w, top: 14.h, bottom: 8.h),
          //           child: Text(
          //             "ACTIVITIES".trU(context),
          //             style: AppTextStyles.qanelasRegular(
          //               height: 0.95,
          //               fontSize: 16.sp,
          //               letterSpacing: 16.sp * 0.12,
          //               color: selectedIndex == 1 ? AppColors.white : AppColors.black70,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     SizedBox(width: 15.w),
          //     GestureDetector(
          //       onTap: () {
          //         if (selectedIndex != 2) {
          //           ref.read(_selectedTabIndex.notifier).state = 2;
          //         }
          //       },
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: selectedIndex == 2 ? AppColors.black2 : Colors.transparent,
          //           borderRadius: BorderRadius.circular(15.r),
          //         ),
          //         child: Padding(
          //           padding: EdgeInsets.only(right: 15.w, left: 15.w, top: 14.h, bottom: 8.h),
          //           child: Text(
          //             "COACHING".trU(context),
          //             style: AppTextStyles.qanelasRegular(
          //               height: 0.95,
          //               fontSize: 16.sp,
          //               letterSpacing: 16.sp * 0.12,
          //               color: selectedIndex == 2 ? AppColors.white : AppColors.black70,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          ),
    );
  }
}


class CustomTab extends StatelessWidget {
  final String title;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const CustomTab({
    Key? key,
    required this.title,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == selectedIndex;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
              color: isSelected ? AppColors.blue : Colors.transparent),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.sofiaSansMedium(
                fontSize: isSelected ? 21.sp : 20.sp,
                color: isSelected ? AppColors.white : AppColors.black70,
              ).copyWith(height: selectedIndex == 0 ? 1 : null),
            ),
          ),
        ),
      ),
    );
  }
}

class FilterRow extends ConsumerWidget {
  FilterRow(
      {this.allowLevelFilter = true,
      this.allowLocationFilter = true,
      super.key});

  final bool allowLevelFilter;
  final bool allowLocationFilter;
  final DateRangePickerController dateController = DateRangePickerController();
  List<ClubLocationSports> sports = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelRange = ref.watch(_selectedLevelProvider);
    final dateRange = ref.watch(dateRangeProvider);
    final selectedLocation = ref.watch(selectedLocationProvider);
    final allLocations = ref.watch(clubLocationsProvider);
    final selectedIndex = ref.watch(_selectedTabIndex);
    // final selectedSports = ref.watch(_selectedSportsProvider);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            children: [
              Image.asset(
                AppImages.filterIcon.path,
                height: 15.h,
                width: 15.w,
                color: AppColors.black,
              ),
              SizedBox(width: 6.w),
              if (selectedIndex == 0 && allowLevelFilter) ...[
                Expanded(
                  flex: 2,
                  child: _buildFilterItem(
                    label:
                        "${levelRange.first.toStringAsFixed(1)} - ${levelRange.last.toStringAsFixed(1)}",
                    onTap: () {
                      final Widget widget =
                          _buildLevelSelector(context, levelRange);
                      if (PlatformC().isCurrentDesignPlatformDesktop) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return widget;
                          },
                        );
                        return;
                      }
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return widget;
                        },
                      );
                    },
                  ),
                ),
                // const Spacer(),
                SizedBox(width: 8.w),
              ],
              Expanded(
                flex: 2,
                child: _buildFilterItem(
                  label:
                      "${dateRange.startDate!.format('dd')}-${dateRange.endDate!.format('dd MMM')}",
                  onTap: () {
                    final Widget widget =
                        _buildDateRangeSelector(ref, context, dateRange);
                    if (PlatformC().isCurrentDesignPlatformDesktop) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return widget;
                        },
                      );
                      return;
                    }
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: AppColors.standardGold50Popup,
                      builder: (context) {
                        return widget;
                      },
                    );
                  },
                ),
              ),
              // const Spacer(),
              // if (selectedIndex == 0 && allowLocationFilter)
              ...[
                SizedBox(width: 8.w),
                Expanded(
                  flex: 2,
                  child: allLocations.when(
                    data: (data) {
                      if (data == null) {
                        return Container();
                      }
                      final list = data;
                      Future(() {
                        ref.read(_storeAllLocationsProvider.notifier).state =
                            data;
                      });
                      if (list.first.id != kAllLocation.id) {
                        list.insert(0, kAllLocation);
                      }
                      sports = [...Utils.fetchSportsList(data)];
                      if (ref.read(selectedSportProvider.notifier).sport ==
                          null) {
                        Future(() {
                          ref.read(selectedSportProvider.notifier).sport =
                              sports.first;
                        });
                      }
                      return _buildFilterItem(
                        label: _buildLocationLabel(
                            selectedLocation, allLocations.value ?? []),
                        onTap: () {
                          final Widget widget =
                              _buildLocationSelector(ref, context, list);
                          if (PlatformC().isCurrentDesignPlatformDesktop) {
                            showDialog(
                                context: context, builder: (context) => widget);
                            return;
                          }
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: AppColors.standardGold50Popup,
                              builder: (context) => widget);
                        },
                      );
                    },
                    error: (_, __) => Container(),
                    loading: () => Container(),
                  ),
                ),
              ],
            ],
          ),
        ),
        // SizedBox(
        //   height: 10.h,
        // ),
        // _sportsRow(
        //   ref,
        //   sports,
        //   selectedSports,
        // ),
      ],
    );
  }

  Widget _sportsRow(
    WidgetRef ref,
    List<ClubLocationSports> sports,
    String? selectedSport,
  ) {
    if (sports.length > 4) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 1.h),
          decoration: inset.BoxDecoration(
            color: AppColors.black5,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: kInsetShadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              for (int i = 0; i < sports.length; i++)
                _Sport(
                    sportToShow: sports[i],
                    index: i,
                    isServiceSelected: selectedSport?.toLowerCase() ==
                        sports[i].sportName?.toLowerCase(),
                    onTap: () {
                      String? updatedSelectedSport = sports[i].sportName;
                      ref.read(_selectedSportsProvider.notifier).state =
                          updatedSelectedSport ?? '';
                    }),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Container(
          decoration: inset.BoxDecoration(
            color: AppColors.black5,
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: kInsetShadow,
          ),
          padding: EdgeInsets.all(2.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              for (int i = 0; i < sports.length; i++)
                Expanded(
                  child: _Sport(
                      sportToShow: sports[i],
                      index: i,
                      isServiceSelected: selectedSport?.toLowerCase() ==
                          sports[i].sportName?.toLowerCase(),
                      onTap: () {
                        String? updatedSelectedSport = sports[i].sportName;
                        ref.read(_selectedSportsProvider.notifier).state =
                            updatedSelectedSport ?? '';
                      }),
                ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildFilterItem({
    required String label,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: inset.BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          color: AppColors.black5,
          boxShadow: kInsetShadow
        ),
        padding: EdgeInsets.only(left: 10.w, right: 5.w, top: 8.h, bottom: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.manropeSemiBold(
                  fontSize: 13.sp,
                  color: AppColors.black,
                ),
              ),
            ),
            // SizedBox(width: 4.w),
            Image.asset(
              AppImages.dropdownIcon.path,
              height: 16.h,
              width: 15.h,
              color: AppColors.black,
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomSheet({required Widget child}) {
    bool isDesktop = PlatformC().isCurrentDesignPlatformDesktop;
    if (isDesktop) {
      return CustomDialog(height: 550.h, child: child);
    }
    return Material(
      color: AppColors.white,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: 440.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            kBoxShadow,
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(child: child),
      ),
    );
  }

  Widget _buildDateRangeSelector(
      WidgetRef ref, BuildContext context, PickerDateRange range) {
    return _bottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 22.h),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close,
                color: AppColors.black,
                size: 20.h,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'DATE'.trU(context),
            style: AppTextStyles.sofiaSansMedium(
              fontSize: 26.sp,
            ),
          ),
          SizedBox(height: 20.h),
          SfDateRangePickerTheme(
            data: SfDateRangePickerThemeData().copyWith(
              headerBackgroundColor: Colors.transparent,
              headerTextStyle: AppTextStyles.sofiaSansMedium(
                fontSize: 25.sp,
              ),
              viewHeaderTextStyle: AppTextStyles.manropeSemiBold(
                  fontSize: 17.sp,
                  color: AppColors.black70
              ),
              disabledDatesTextStyle: AppTextStyles.sofiaSansMedium(
                fontSize: 28.sp,
              ),
              todayTextStyle: AppTextStyles.sofiaSansMedium(
                fontSize: 28.sp,
              ),
              todayHighlightColor: AppColors.black,
            ),
            child: SfDateRangePicker(
              controller: dateController,
              selectionMode: DateRangePickerSelectionMode.range,
              selectionShape: DateRangePickerSelectionShape.circle,
              initialSelectedRange: range,
              enablePastDates: false,
              endRangeSelectionColor: AppColors.blue,
              startRangeSelectionColor: AppColors.blue,
              rangeSelectionColor: AppColors.blue50,
              monthCellStyle: DateRangePickerMonthCellStyle(
                textStyle: AppTextStyles.sofiaSansMedium(
                  fontSize: 28.sp,
                ),
              ),
              selectionTextStyle: AppTextStyles.sofiaSansMedium(
                fontSize: 28.sp,
                color: AppColors.white,
              ),
              rangeTextStyle: AppTextStyles.sofiaSansMedium(
                fontSize: 28.sp, color: AppColors.white,
              ),
              monthViewSettings: DateRangePickerMonthViewSettings(
                dayFormat: "E",
                viewHeaderHeight: 52.h,
                firstDayOfWeek: 1,
              ),
              headerHeight: 52.h,
              yearCellStyle: DateRangePickerYearCellStyle(
                todayTextStyle: AppTextStyles.sofiaSansMedium(
                  fontSize: 28.sp,
                ),
                disabledDatesTextStyle: AppTextStyles.sofiaSansMedium(
                  fontSize: 28.sp,
                ),
                textStyle: AppTextStyles.sofiaSansMedium(
                  fontSize: 28.sp,
                ),
                leadingDatesTextStyle: AppTextStyles.sofiaSansMedium(
                  fontSize: 28.sp,
                ),
              ),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                final range = args.value as PickerDateRange;
                if (range.startDate != null && range.endDate != null) {
                  ref.read(dateRangeProvider.notifier).state = range;
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelSelector(BuildContext context, List<double> levelRange) {
    return _bottomSheet(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 22.h),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close,
                  color: AppColors.black,
                  size: 20.h,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              'LEVEL'.trU(context),
              style: AppTextStyles.sofiaSansMedium(
                fontSize: 26.sp,
              ),
            ),
            SizedBox(height: 20.h),
            const _LevelListForSelection()
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSelector(
      WidgetRef ref, BuildContext context, List<ClubLocationData> locations) {
    final isDesktop = PlatformC().isCurrentDesignPlatformDesktop;
    return _bottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 22.h),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close,
                color: AppColors.black,
                size: 20.h,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'LOCATION'.trU(context),
            style: AppTextStyles.sofiaSansMedium(
              fontSize: 26.sp,
            ),
          ),
          // SizedBox(height: 20.h),
          Flexible(
            child: Consumer(
              builder: (context, ref, child) {
                final selectedLocations = ref.watch(selectedLocationProvider);
                return Scrollbar(
                  thumbVisibility: isDesktop,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: ListView.builder(
                      itemCount: locations.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final location = locations[index];
                        final isSelected =
                            selectedLocations.contains(location.id);
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: OptionTile(
                            option: (location.locationName?.tr(context) ?? ""),
                            enabled: true,
                            selected: isSelected,
                            // onTap: () {
                            //   ref.read(_selectedLocationProvider.notifier).state =
                            //       location;
                            //   Navigator.pop(context);
                            // },
                            // onTap: () {},
                            onTap: () {
                              List<int> updatedSelectedLocations =
                                  List<int>.from(selectedLocations);

                              if (isSelected) {
                                updatedSelectedLocations.remove(location.id);
                              } else {
                                if (location.id == kAllLocation.id) {
                                  updatedSelectedLocations.clear();
                                } else {
                                  updatedSelectedLocations
                                      .remove(kAllLocation.id);
                                }
                                updatedSelectedLocations.add(location.id!);
                              }
                              if (updatedSelectedLocations.isEmpty &&
                                  kAllLocation.id != null) {
                                updatedSelectedLocations.add(kAllLocation.id!);
                              }
                              if (!(updatedSelectedLocations.length == 1 &&
                                  updatedSelectedLocations.first ==
                                      kAllLocation.id)) {
                                ref
                                    .read(_selectedSportsProvider.notifier)
                                    .state = kSportName;
                              }
                              // Update provider state with new selection list
                              ref
                                  .read(selectedLocationProvider.notifier)
                                  .state = updatedSelectedLocations;
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  String _buildLocationLabel(
      List<int> selectedIds, List<ClubLocationData> allLocations) {
    if (selectedIds.isEmpty || selectedIds.contains(kAllLocation.id)) {
      return 'All locations';
    } else if (selectedIds.length == 1) {
      final selectedLocation =
          allLocations.firstWhere((loc) => loc.id == selectedIds.first);
      return selectedLocation.locationName?.capitalizeFirst ?? 'Location';
    } else {
      return 'Multiple Locations';
    }
  }
}

class _LevelListForSelection extends ConsumerStatefulWidget {
  const _LevelListForSelection();

  @override
  ConsumerState<_LevelListForSelection> createState() =>
      _LevelListForSelectionState();
}

class _LevelListForSelectionState
    extends ConsumerState<_LevelListForSelection> {
  List<double> currentLevel = [];

  List<double> newLevel = [];

  @override
  Widget build(BuildContext context) {
    final currentLevel = ref.watch(_selectedLevelProvider);
    final isDesktop = PlatformC().isCurrentDesignPlatformDesktop;
    return Flexible(
      child: Scrollbar(
        thumbVisibility: isDesktop,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 15.h),
          itemCount: levelsList.length,
          itemBuilder: (context, index) {
            final level = levelsList[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: OptionTile(
                option: "LEVEL".tr(context) + " " + level.toString(),
                enabled: true,
                selected: newLevel.isEmpty
                    ? level >= currentLevel.first && level <= currentLevel.last
                    : newLevel.contains(level),
                onTap: () {
                  if (newLevel.isEmpty) {
                    newLevel = [level];
                  } else if (newLevel.length == 1) {
                    newLevel.add(level);
                    newLevel.sort();
                    ref.read(_selectedLevelProvider.notifier).state = newLevel;
                    Navigator.pop(context);
                  }
                  setState(() {});
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  const OptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
    required this.enabled,
  });

  final String option;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.r),
            color: selected ? AppColors.blue : AppColors.black5,
            // border: Border.all(
            //   color: selected ? Colors.transparent : AppColors.orange,
            //   width: 1.w,
            // ),
          ),
          padding: EdgeInsets.all(10.h),
          child: Row(
            children: [
              SelectedTag(
                isSelected: selected,
                shape: BoxShape.circle,
                selectedColor: AppColors.circleBgColor,
                unSelectedColor: AppColors.white,
                unSelectedBorderColor: AppColors.black2,
                selectedBorderColor: AppColors.white,
              ),
              SizedBox(width: 20.w),
              Expanded(
                flex: 10,
                child: Text(
                  (option),
                  style: selected
                      ? AppTextStyles.manropeSemiBold(
                          fontSize: 16.sp,
                          color: AppColors.white,
                        )
                      : AppTextStyles.manropeMedium(
                          fontSize: 16.sp,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerRankingButton extends StatelessWidget {
  const _PlayerRankingButton();

  @override
  Widget build(BuildContext context) {
    if (!kAllowPlayerRanking) {
      return SizedBox();
    }
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        customBorder: RoundedRectangleBorder(),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return _PlayersRanking();
            },
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
          margin: EdgeInsets.only(right: 15.w),
          decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(100.r)),
          child: Text(
            "PLAYERS_RANKING".tr(context),
            style: AppTextStyles.manropeSemiBold(
                fontSize: 13.sp, color: AppColors.white),
          ),
        ),
      ),
    );
  }
}

class _PlayersRanking extends ConsumerStatefulWidget {
  _PlayersRanking();

  @override
  ConsumerState<_PlayersRanking> createState() => _PlayersRankingState();
}

class _PlayersRankingState extends ConsumerState<_PlayersRanking> {
  final _selectedTabIndexRanking = StateProvider<int>((ref) => 0);
  final _pageController =
      StateProvider((ref) => PageController(initialPage: 0));

  @override
  Widget build(BuildContext context) {
    ref.listen(
      _selectedTabIndexRanking,
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

    return CustomDialog(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "PLAYERS_RANKING".trU(context),
            style: AppTextStyles.popupHeaderTextStyle,
          ),
          SizedBox(height: 10.h),
          _PlayerRankingSelector(selectedTabIndex: _selectedTabIndexRanking),
          SizedBox(height: 15.h),
          Container(
            constraints: BoxConstraints(
              maxHeight: 400.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.white25,
              borderRadius: BorderRadius.circular(12.r),
            ),
            width: double.infinity,
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _PlayersRankingList(
                  currentPage: 0,
                ),
                _PlayersRankingList(
                  currentPage: 1,
                ),
                _PlayersRankingList(
                  currentPage: 2,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _PlayerRankingSelector extends ConsumerWidget {
  final StateProvider<int> selectedTabIndex;

  const _PlayerRankingSelector({required this.selectedTabIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabIndex);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white25,
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: [
          BoxShadow(
              color: AppColors.black5,
              blurRadius: 4,
              offset: Offset(0, 4),
              blurStyle: BlurStyle.outer),
        ],
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTabButton(
                title: "TOP_TEN",
                isSelected: selectedIndex == 0,
                onTap: () {
                  if (selectedIndex != 0) {
                    ref.read(selectedTabIndex.notifier).state = 0;
                  }
                },
              ),
              CustomTabButton(
                title: "TOP_FIFTY",
                isSelected: selectedIndex == 1,
                onTap: () {
                  if (selectedIndex != 1) {
                    ref.read(selectedTabIndex.notifier).state = 1;
                  }
                },
              ),
              CustomTabButton(
                title: "ALL",
                isSelected: selectedIndex == 2,
                onTap: () {
                  if (selectedIndex != 2) {
                    ref.read(selectedTabIndex.notifier).state = 2;
                  }
                },
              ),
            ],
          )
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Expanded(
          //       child: GestureDetector(
          //         onTap: () {
          //           if (selectedIndex != 0) {
          //             ref.read(selectedTabIndex.notifier).state = 0;
          //           }
          //         },
          //         child: Container(
          //           height: 40.h,
          //           decoration: BoxDecoration(
          //             color: selectedIndex == 0
          //                 ? AppColors.black2
          //                 : Colors.transparent,
          //             // borderRadius: BorderRadius.circular(15.r),
          //           ),
          //           alignment: Alignment.center,
          //           child: Padding(
          //             padding: EdgeInsets.only(left: 11.w, right: 11.w),
          //             child: Text(
          //               'TOP_TEN'.trU(context),
          //               textAlign: TextAlign.center,
          //               style: AppTextStyles.qanelasMedium(
          //                 // height: 0.95,
          //                 fontSize: 16.sp,
          //                 color: AppColors.white,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: GestureDetector(
          //         onTap: () {
          //           if (selectedIndex != 1) {
          //             ref.read(selectedTabIndex.notifier).state = 1;
          //           }
          //         },
          //         child: Container(
          //           height: 40.h,
          //           decoration: BoxDecoration(
          //             color: selectedIndex == 1
          //                 ? AppColors.black2
          //                 : Colors.transparent,
          //             borderRadius: BorderRadius.circular(15.r),
          //           ),
          //           alignment: Alignment.center,
          //           child: Padding(
          //             padding: EdgeInsets.only(right: 15.w, left: 15.w),
          //             child: Text(
          //               "TOP_FIFTY".trU(context),
          //               style: AppTextStyles.qanelasRegular(
          //                 height: 0.95,
          //                 fontSize: 19.sp,
          //                 color: AppColors.white,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: GestureDetector(
          //         onTap: () {
          //           if (selectedIndex != 2) {
          //             ref.read(selectedTabIndex.notifier).state = 2;
          //           }
          //         },
          //         child: Container(
          //           height: 40.h,
          //           decoration: BoxDecoration(
          //             color: selectedIndex == 2
          //                 ? AppColors.black2
          //                 : Colors.transparent,
          //             borderRadius: BorderRadius.circular(15.r),
          //           ),
          //           alignment: Alignment.center,
          //           child: Padding(
          //             padding: EdgeInsets.only(right: 15.w, left: 15.w),
          //             child: Text(
          //               "ALL".trU(context),
          //               style: AppTextStyles.qanelasRegular(
          //                 height: 0.95,
          //                 fontSize: 19.sp,
          //                 color: AppColors.white,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          ),
    );
  }
}

class CustomTabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomTabButton({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(100.r),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              title.trU(context),
              textAlign: TextAlign.center,
              style: isSelected ? AppTextStyles.manropeSemiBold(fontSize: 16.sp,color: AppColors.brick) : AppTextStyles.manropeMedium(
                fontSize: 16.sp,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayersRankingList extends ConsumerStatefulWidget {
  final int currentPage;

  const _PlayersRankingList({required this.currentPage});

  @override
  ConsumerState<_PlayersRankingList> createState() =>
      _PlayersRankingListState();
}

class _PlayersRankingListState extends ConsumerState<_PlayersRankingList> {
  final ScrollController _scrollController = ScrollController();

  late PlayerRankingParams _params;

  @override
  void initState() {
    _params = PlayerRankingParams(
        limit: kPageLimit,
        currentPage: widget.currentPage,
        sportName: getSportsName(ref));

    // Trigger initial fetch.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(playersRankingPaginationProvider(_params).notifier).refresh();
    });

    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    // When scrolling near the bottom, fetch next page.
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(playersRankingPaginationProvider(_params).notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paginationStateAsync =
        ref.watch(playersRankingPaginationProvider(_params));
    final currentUserID = ref.read(userManagerProvider).user?.user;

    return paginationStateAsync.when(
      data: (paginationState) {
        if (paginationState.mainLoading) {
          return const Center(
            child: CupertinoActivityIndicator(radius: 10),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ScrollbarTheme(
                data: ScrollbarThemeData(
                  thumbColor: WidgetStateProperty.all(AppColors.darkGray50),
                  // Light gray
                  trackColor: WidgetStateProperty.all(AppColors.white),
                  // Light beige
                  trackBorderColor: WidgetStateProperty.all(Colors.transparent),
                  thickness: WidgetStateProperty.all(10),
                  radius: Radius.circular(5.r),
                ),
                child: Scrollbar(
                  controller: _scrollController,
                  interactive: true,
                  trackVisibility: true,
                  thickness: 8,
                  radius: Radius.circular(0.r),
                  thumbVisibility: true,
                  child: PlayTabsParentWidget(
                    scrollController: _scrollController,
                    onRefresh: () {
                      return ref
                          .read(playersRankingPaginationProvider(_params)
                              .notifier)
                          .refresh();
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.black5,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black5,
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: paginationState.items.length + 1,
                        shrinkWrap: true,
                        cacheExtent: double.infinity,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < paginationState.items.length) {
                            final user = paginationState.items[index];
                            return _RankingPlayerView(user: user, index: index);
                          }
                          // Show loading indicator at the bottom.
                          if (paginationState.hasMore) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                  child: CupertinoActivityIndicator(
                                color: AppColors.white,
                              )),
                            );
                          }
                          if (paginationState.items.isEmpty) {
                            return SecondaryText(
                                text: "NO_USER_FOUND".tr(context));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            if (paginationState.extraData is Result)
              _RankingPlayerView(
                  user: Levels(
                      level: (currentUserID?.level(getSportsName(ref)) ?? 0)
                          .toString(),
                      customer: User(
                          id: currentUserID?.id,
                          firstName: currentUserID?.firstName,
                          lastName: currentUserID?.lastName,
                          profileUrl: currentUserID?.profileUrl),
                      index: int.tryParse(
                              paginationState.extraData?.position ?? "") ??
                          0),
                  index: 0)
          ],
        );
      },
      error: (e, _) => SecondaryText(text: e.toString()),
      loading: () => const Center(child: CupertinoActivityIndicator()),
    );
  }
}

class _RankingPlayerView extends ConsumerWidget {
  final Levels user;
  final int index;

  const _RankingPlayerView({required this.user, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserID = ref.read(userManagerProvider).user?.user?.id;

    final ranking = user.index ?? (index + 1);
    final profileUrl = user.customer?.profileUrl;
    final userName =
        "${user.customer?.firstName ?? ""} ${user.customer?.lastName ?? ""}"
            .capitalizeFirst;
    final userLevel = user.level ?? "0.0";

    bool isCurrentUser = currentUserID == user.customer?.id;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      margin: EdgeInsets.only(bottom: 0.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(12.r),bottomLeft: Radius.circular(12.r)),
          color: isCurrentUser ? AppColors.yellow : Colors.transparent),
      child: Row(
        children: [
          Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: AppColors.brick,
                borderRadius: BorderRadius.circular(12.r),
                // shape: BoxShape.circle
              ),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  ranking.toString(),
                  style: AppTextStyles.sofiaSansMedium(
                    fontSize: 13.sp,
                    color: AppColors.white,
                  ),
                ),
              )),
          SizedBox(width: 15.w),
          NetworkCircleImage(
            path: profileUrl,
            width: 37.h,
            height: 37.h,
            boxBorder: Border.all(
                width: 1,
                color: (profileUrl?.isNotEmpty ?? false)
                    ? AppColors.white25
                    : AppColors.black25),
            bgColor: AppColors.white,
            borderRadius: BorderRadius.circular(6.r),
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Text(
              userName.toUpperCase(),
              style: AppTextStyles.sofiaSansMedium(
                color: isCurrentUser ? AppColors.brick : AppColors.white,
                fontSize: 15.sp,
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Text(
            userLevel.toString(),
            style: AppTextStyles.manropeMedium(
              color: isCurrentUser ? AppColors.brick : AppColors.white,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }
}

class SportFilterModel {
  final String sportName;
  final List<int> id;

  SportFilterModel({required this.sportName, required this.id});
}

class _Sport extends ConsumerWidget {
  const _Sport(
      {required this.sportToShow,
      required this.index,
      required this.onTap,
      required this.isServiceSelected});

  final int index;
  final ClubLocationSports sportToShow;
  final Function onTap;
  final bool isServiceSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DurationAndSportContainer(
      isSelected: isServiceSelected,
      text: sportToShow.sportName ?? '',
      onTap: () {
        onTap();
      },
      // onTap: () {
      //   ref.read(_selectedTimeSlotAndLocationID.notifier).state = (null, null);
      //   ref.read(selectedSportProvider.notifier).sport = sportToShow;
      // },
    );
  }
}

class _DurationAndSportContainer extends StatelessWidget {
  const _DurationAndSportContainer(
      {required this.isSelected, required this.text, required this.onTap});

  final bool isSelected;
  final Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.r),
      ),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 6.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black2 : Colors.transparent,
          borderRadius: BorderRadius.circular(100.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: isSelected
              ? AppTextStyles.manropeSemiBold(
                  fontSize: 13.sp, color: AppColors.white)
              : AppTextStyles.manropeLight(
                  fontSize: 13.sp, color: AppColors.black70),
        ),
      ),
    );
  }
}
