part of 'booking_tab.dart';

class _DateSelectorWidget extends ConsumerStatefulWidget {
  const _DateSelectorWidget({required this.futureDayLength});

  final int futureDayLength;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DateSelectorWidgetState();
}

class _DateSelectorWidgetState extends ConsumerState<_DateSelectorWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.futureDayLength < 1) {
      return SizedBox();
    }
    final selectedIndex = ref.watch(_selectedTabIndex);
    final isCourtActive = selectedIndex == 0;

    UserActiveMembership? membership;
    if (isCourtActive) {
      membership = ref.watch(fetchActiveAndAllMembershipsProvider).value;
    }

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    // final selectedDate = ref.watch(selectedDateProvider);
    final selectedDate = (selectedIndex == 0 || selectedIndex == 2)
        ? ref.watch(selectedDateProvider)
        : ref.watch(selectedDateLessonProvider);
    return Container(
      height: (width / height) > 0.6 ? 120.h : 65.h,
      margin: EdgeInsets.only(
        top: 10.h,
        bottom: 7.h,
      ),
      color: AppColors.white,
      // padding: EdgeInsets.only(left: 6.w, right: 0),
      child: _buildDateListView(context, selectedDate.dateTime, membership),
    );
  }

  Widget _buildDateListView(BuildContext context, DateTime selectedDate,
      UserActiveMembership? membership) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        scrollDirection: Axis.horizontal,
        itemCount: widget.futureDayLength,
        itemBuilder: (context, i) {
          DateTime now = DubaiDateTime.now().dateTime;
          DateTime date =
              DubaiDateTime.custom(now.year, now.month, now.day + i).dateTime;
          return _getDateContainer(date, selectedDate, i, membership);
        },
      ),
    );
  }

  Widget _getDateContainer(DateTime date, DateTime selectedDate, int index,
      UserActiveMembership? membership) {
    bool isSelected = date.isAtSameMomentAs(selectedDate);

    Color color = isSelected ? AppColors.blue : AppColors.black5;

    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => _onDateTap(date),
        child: Container(
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: _buildDateContent(date, isSelected),
        ),
      ),
    );
  }

  void _onDateTap(DateTime date) {
    (ref.read(_selectedTabIndex) == 0 || ref.read(_selectedTabIndex) == 2)
        ? ref.read(selectedDateProvider.notifier).selectedDate =
            DubaiDateTime.custom(
            date.year,
            date.month,
            date.day,
          )
        : ref.read(selectedDateLessonProvider.notifier).selectedDate =
            DubaiDateTime.custom(
            date.year,
            date.month,
            date.day,
          );

    Future(() {
      ref.read(_selectedTimeSlotAndLocationID.notifier).state = (null, null);
    });
  }

  Widget _buildDateContent(DateTime date, bool isSelected) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            date.format(DateFormat.ABBR_WEEKDAY),
            style: AppTextStyles.manropeMedium(
              // height: 0.8,
              fontSize: 15.sp,
              color: isSelected ? AppColors.white : AppColors.black70,
            ),
          ),
          Text(
            '${date.day}',
            style: AppTextStyles.manropeSemiBold(
              color: isSelected ? AppColors.white : AppColors.black70,
              fontSize: 15.sp,
            ),
          ),
          Text(
            date.format(DateFormat.ABBR_MONTH),
            style: AppTextStyles.manropeMedium(
              fontSize: 15.sp,
              color: isSelected ? AppColors.white : AppColors.black70,
              height: 1,
            ),
          ),
          // SizedBox(height: 10.h),
        ],
      ),
    );
  }
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
        text: (sportToShow.sportName ?? '').capitalizeFirst,
        onTap: () {
          onTap();
        });
  }
}

class _Duration extends ConsumerWidget {
  const _Duration({required this.duration, required this.index});

  final int index;
  final int duration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDuration = ref.watch(_selectedDuration);
    bool isServiceSelected = (selectedDuration == duration);
    return Expanded(
      child: InkWell(
        customBorder: RoundedRectangleBorder(),
        borderRadius: BorderRadius.circular(100.r),
        onTap: () {
          ref.read(_selectedDuration.notifier).state = duration;
          ref.read(_pageViewController.notifier).state.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
          padding: EdgeInsets.all(2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.r),
              color:
                  isServiceSelected ? AppColors.blue : Colors.transparent,),
          alignment: Alignment.center,
          child: Text(
            "$duration ${"MIN".tr(context)}",
            textAlign: TextAlign.center,
            style: isServiceSelected
                ? AppTextStyles.manropeSemiBold(
                color: AppColors.white, fontSize: 13.sp,)
                : AppTextStyles.manropeMedium(
              fontSize: 13.sp,
              color: AppColors.black70,
            ),
          ),
        ),
      ),
    );
  }
}

class _Court extends ConsumerWidget {
  const _Court({required this.courtId, required this.courtName});

  final int courtId;
  final String courtName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCourt = ref.watch(_selectedCourt);
    bool isCourtSelected = (selectedCourt == courtId);

    return InkWell(
      customBorder: RoundedRectangleBorder(),
      onTap: () {
        if (selectedCourt == courtId) {
          // ref.read(_selectedCourt.notifier).state = null;
        } else {
          ref.read(_selectedCourt.notifier).state = courtId;
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isCourtSelected ? AppColors.black2 : Colors.transparent,
          borderRadius: BorderRadius.circular(18.r),
        ),
        alignment: Alignment.center,
        child: Text(
          courtName.capitalizeFirst,
          textAlign: TextAlign.center,
          style: isCourtSelected
              ? AppTextStyles.manropeSemiBold(
                  color: AppColors.white, fontSize: 14.sp)
              : AppTextStyles.manropeMedium(
                  fontSize: 13.sp, color: AppColors.black70),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
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
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(
          4.h,
        ),
        padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 4.h),
        decoration: decoration.copyWith(
            color: isSelected ? AppColors.black2 : Colors.white),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: isSelected
              ? AppTextStyles.manropeSemiBold(
                  color: AppColors.white, fontSize: 14.sp)
              : AppTextStyles.manropeMedium(
                  fontSize: 13.sp, color: AppColors.black70),
        ),
      ),
    );
  }
}

class _Timeslots extends ConsumerStatefulWidget {
  const _Timeslots({required this.data, required this.locationID});

  final CourtBookingData data;
  final int locationID;

  @override
  ConsumerState<_Timeslots> createState() => __TimeslotsState();
}

class __TimeslotsState extends ConsumerState<_Timeslots> {
  @override
  Widget build(BuildContext context) {
    final selectedDuration = ref.watch(_selectedDuration);
    final selectedDate = ref.watch(selectedDateProvider);

    if (selectedDuration == null) {
      return Container();
    }
    int? currentCourt = ref.watch(_selectedCourt);
    final sauna = ref.watch(_selectedTabIndex) == 2;

    final timeSlots = widget.data.getTimeSlots(sauna ? currentCourt : null,
        selectedDuration, widget.locationID, selectedDate.dateTime);

    if (timeSlots.isEmpty) {
      return _buildNoAvailableSlotsMessage(context);
    }

    List<List<DateTime>> timeSlotChunked = Utils.getChunks(timeSlots, 4);

    return _buildTimeSlots(timeSlotChunked);
  }

  Widget _buildNoAvailableSlotsMessage(BuildContext context) {
    return Container(
      height: 100.h,
      alignment: Alignment.center,
      child: SecondaryText(
        text: "NO_AVAILABLE_SLOTS".trU(context),
      ),
    );
  }

  Widget _buildTimeSlots(List<List<DateTime>> timeSlotChunked) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < timeSlotChunked.length; i++)
          _buildTimeSlotRow(timeSlotChunked, i),
      ],
    );
  }

  Widget _buildTimeSlotRow(List<List<DateTime>> timeSlotChunked, int rowIndex) {
    bool addExtra = rowIndex == timeSlotChunked.length - 1 &&
        timeSlotChunked[rowIndex].length < 4;
    List<Widget> extraSlots = addExtra
        ? List.generate(4 - timeSlotChunked[rowIndex].length,
            (_) => Expanded(child: Container()))
        : [];

    return Row(
      children: [
        Expanded(
          flex: 8,
          child: Container(
            height: 40.h,
            margin: EdgeInsets.symmetric(vertical: 1.5.h),
            child: Row(
              children: [
                for (int colIndex = 0;
                    colIndex < timeSlotChunked[rowIndex].length;
                    colIndex++)
                  _buildTimeSlot(timeSlotChunked, rowIndex, colIndex),
                ...extraSlots,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlot(
      List<List<DateTime>> timeSlotChunked, int rowIndex, int colIndex) {
    final (selectedTime, selectedLocationID) =
        ref.watch(_selectedTimeSlotAndLocationID);
    bool selected = selectedTime == timeSlotChunked[rowIndex][colIndex] &&
        selectedLocationID == widget.locationID;
    BorderRadius? borderRadius =
        _getBorderRadius(rowIndex, colIndex, timeSlotChunked);

    return Expanded(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
        onTap: () => _onTap(timeSlotChunked, rowIndex, colIndex),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          // padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.blue : AppColors.white,
            boxShadow: [kBoxShadow],
            borderRadius: borderRadius,
          ),
          child: Text(
            timeSlotChunked[rowIndex][colIndex].format("HH:mm"),
            style: selected
                ? AppTextStyles.manropeSemiBold(
                    fontSize: 15.sp,
                    color: AppColors.white,
                  )
                : AppTextStyles.manropeMedium(
                    fontSize: 15.sp,
                  ),
          ),
        ),
      ),
    );
  }

  BorderRadius? _getBorderRadius(
      int rowIndex, int colIndex, List<List<DateTime>> timeSlotChunked) {
    return BorderRadius.all(Radius.circular(12.r));
  }

  void _onTap(
      List<List<DateTime>> timeSlotChunked, int rowIndex, int colIndex) {
    final selectedSlot = ref.read(_selectedTimeSlotAndLocationID);
    if (selectedSlot.$1 == timeSlotChunked[rowIndex][colIndex] &&
        selectedSlot.$2 == widget.locationID) {
      ref.read(_selectedTimeSlotAndLocationID.notifier).state = (null, null);
      return;
    }
    ref.read(_selectedTimeSlotAndLocationID.notifier).state =
        (timeSlotChunked[rowIndex][colIndex], widget.locationID);
  }
}

class _AvailableTimeslot extends ConsumerStatefulWidget {
  const _AvailableTimeslot({required this.data, required this.locationID});

  final CourtBookingData data;
  final int locationID;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __AvailableTimeslotState();
}

class __AvailableTimeslotState extends ConsumerState<_AvailableTimeslot> {
  @override
  Widget build(BuildContext context) {
    final selectedDuration = ref.watch(_selectedDuration);
    final (timeslot, locationID) = ref.watch(_selectedTimeSlotAndLocationID);
    final selectedDate = ref.watch(selectedDateProvider);
    if (selectedDuration == null || timeslot == null || locationID == null) {
      return Container();
    }
    if (widget.locationID != locationID) {
      return Container();
    }
    int? currentCourt = ref.watch(_selectedCourt);
    final sauna = ref.watch(_selectedTabIndex) == 2;

    final courts = widget.data.getCourt(sauna ? currentCourt : null,
        selectedDuration, locationID, timeslot, selectedDate.dateTime);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courts.length,
      itemBuilder: (context, index) {
        final startTime = timeslot;
        final endTime = startTime.add(Duration(minutes: selectedDuration));
        final String formattedTime =
            "${startTime.format("EEE d MMM")} | ${startTime.format("HH:mm")} - ${endTime.format("HH:mm")}";
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.h, left: 10.w),
              child: Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          courts.values.toList()[index],
                          style: AppTextStyles.manropeSemiBold(
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              formattedTime,
                              style:
                                  AppTextStyles.manropeMedium(fontSize: 15.sp),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  // const Spacer(),
                  MainButton(
                      color: AppColors.white,
                      showArrow: true,
                      applyShadow: true,
                      applySize: false,
                      // height: 30.h,
                      width: 90.w,
                      arrowSize: 15.h,
                      padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 7.h),
                      label: "BOOK".trU(context),
                      labelStyle: AppTextStyles.sofiaSansMedium(fontSize: 19.sp,height: 1),
                      // onTap: () async {
                      //   if (!Utils.checkUserLogin(ref)) {
                      //     ref.read(goRouterProvider).push(RouteNames.auth);
                      //     return;
                      //   }
                      //   if (selectedDate.dateTime
                      //           .difference(DateTime.now())
                      //           .inDays >
                      //       5) {
                      //     final membership = ref
                      //         .read(fetchActiveAndAllMembershipsProvider)
                      //         .value;
                      //     if (membership?.haveActiveHOPMembership == null) {
                      //       showDialog(
                      //         context: context,
                      //         builder: (context) {
                      //           return _NonMembershipUser();
                      //         },
                      //       );
                      //       return;
                      //     }
                      //   }
                      //
                      //   final booking = widget.data.getBooking(
                      //       selectedDate.dateTime,
                      //       timeslot,
                      //       locationID,
                      //       selectedDuration,
                      //       courts.keys.toList()[index]);
                      //   if (booking == null) {
                      //     return;
                      //   }
                      //   final sportsName =
                      //       (booking.sport?.sportName ?? "").toLowerCase();
                      //
                      //   bool canProceed = true;
                      //
                      //   if (sportsName != "recovery") {
                      //     canProceed = await Utils().checkForLevelAssessment(
                      //         ref: ref,
                      //         context: context,
                      //         sportsName: sportsName);
                      //   }
                      //
                      //   if (canProceed) {
                      //     await Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         fullscreenDialog: true,
                      //         builder: (context) {
                      //           return BookCourtDialog(
                      //             coachId: null,
                      //             bookings: booking,
                      //             bookingTime: DubaiDateTime.custom(
                      //               selectedDate.dateTime.year,
                      //               selectedDate.dateTime.month,
                      //               selectedDate.dateTime.day,
                      //               startTime.hour,
                      //               startTime.minute,
                      //             ).dateTime,
                      //             court: {
                      //               courts.keys.toList()[index]:
                      //                   courts.values.toList()[index]
                      //             },
                      //           );
                      //         },
                      //       ),
                      //     );
                      //     ref.invalidate(getCourtBookingProvider);
                      //   }
                      // }

                    onTap: () async {
                      final booking = widget.data.getBooking(
                          selectedDate.dateTime,
                          timeslot,
                          locationID,
                          selectedDuration,
                          courts.keys.toList()[index]);
                      if (booking == null) {
                        return;
                      }
                      showDialog(
                        useSafeArea: false,
                        context: context,
                        builder: (context) {
                          return BookCourtDialog(
                            coachId: null,
                            bookings: booking,
                            bookingTime: DubaiDateTime.custom(
                              selectedDate.dateTime.year,
                              selectedDate.dateTime.month,
                              selectedDate.dateTime.day,
                              startTime.hour,
                              startTime.minute,
                            ).dateTime,
                            court: {
                              courts.keys.toList()[index]:
                              courts.values.toList()[index]
                            },
                          );
                        },
                      );
                    },


                      // onTap: () async {
                      //   final booking = widget.data.getBooking(
                      //       selectedDate.dateTime,
                      //       timeslot,
                      //       locationID,
                      //       selectedDuration,
                      //       courts.keys.toList()[index]);
                      //   if (booking == null) {
                      //     return;
                      //   }
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return BookCourtDialog(
                      //         coachId: null,
                      //         bookings: booking,
                      //         bookingTime: DubaiDateTime.custom(
                      //           selectedDate.dateTime.year,
                      //           selectedDate.dateTime.month,
                      //           selectedDate.dateTime.day,
                      //           startTime.hour,
                      //           startTime.minute,
                      //         ).dateTime,
                      //         court: {
                      //           courts.keys.toList()[index]:
                      //               courts.values.toList()[index]
                      //         },
                      //       );
                      //     },
                      //   );
                      // },
                      ),
                ],
              ),
            ),
            if (courts.length - 1 != index) ...[
              const SizedBox(height: 10),
              Container(
                height: 0.7.h,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                color: AppColors.black5,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _Selector extends ConsumerWidget {
  const _Selector({required this.title, required this.index});

  final int index;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(_selectedTabIndex);
    bool isServiceSelected = (selectedIndex == index);
    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(_selectedTabIndex.notifier).state = index;
          ref.read(_pageControllerFor.notifier).state.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
          clipBehavior: Clip.none,
          padding: EdgeInsets.symmetric(vertical: 13.5.h, horizontal: 4.w),
          decoration: BoxDecoration(
              color:
                  isServiceSelected ? AppColors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(15.r),
          ),
          alignment: Alignment.center,
          child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.sofiaSansMedium(
                fontSize: isServiceSelected ? 23.sp : 20.sp,
                color: isServiceSelected ? AppColors.white : AppColors.black70,
              ),
          ),
        ),
      ),
    );
  }
}

class _LessonBookingType extends ConsumerWidget {
  const _LessonBookingType({required this.lessonType, required this.index});

  final int index;
  final Lessons lessonType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLessonType = ref.watch(_selectedLessonBookingType);
    bool isServiceSelected = (selectedLessonType == lessonType.duration);
    return Expanded(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
        ),
        onTap: () {
          ref.read(_selectedLessonBookingType.notifier).state =
              lessonType.duration;
          ref.read(_pageViewController.notifier).state.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
          padding: EdgeInsets.all(5.h),
          decoration: BoxDecoration(
            color: isServiceSelected ? AppColors.black2 : Colors.transparent,
            borderRadius: BorderRadius.circular(100.r),
          ),
          alignment: Alignment.center,
          child: Text(
            lessonType.lessons ?? "",
            textAlign: TextAlign.center,
            style: isServiceSelected
                ? AppTextStyles.manropeSemiBold(
                    color: AppColors.white,
                    fontSize: 13.sp,
                    letterSpacing: 13.sp * 0.05)
                : AppTextStyles.manropeLight(
                    color: AppColors.black70,
                    fontSize: 13.sp,
                  ),
          ),
        ),
      ),
    );
  }
}

class _TimeslotsLesson extends ConsumerStatefulWidget {
  const _TimeslotsLesson({
    required this.data,
    required this.coachId,
    required this.lessonLocation,
    required this.selectedDate,
  });

  final LessonDataNew0? data;
  final DateTime? selectedDate;
  final int coachId;
  final LocationLesson lessonLocation;

  @override
  ConsumerState<_TimeslotsLesson> createState() => __TimeslotsLessonState();
}

class __TimeslotsLessonState extends ConsumerState<_TimeslotsLesson> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateLessonProvider);
    final selectedDuration = ref.watch(_selectedCoachLessonDuration);
    final List<DateTime> timeSlots = widget.data?.getTimeSlots(
            widget.coachId,
            widget.selectedDate ?? selectedDate.dateTime,
            selectedDuration,
            widget.lessonLocation) ??
        [];

    if (timeSlots.isEmpty) {
      return _buildNoAvailableSlotsMessage(context);
    }

    List<List<DateTime>> timeSlotChunked = Utils.getChunks(timeSlots, 4);

    return _buildTimeSlots(timeSlotChunked);
  }

  Widget _buildNoAvailableSlotsMessage(BuildContext context) {
    return Container(
      height: 100.h,
      alignment: Alignment.center,
      child: SecondaryText(text: "NO_AVAILABLE_SLOTS".trU(context)),
    );
  }

  Widget _buildTimeSlots(List<List<DateTime>> timeSlotChunked) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < timeSlotChunked.length; i++)
          _buildTimeSlotRow(timeSlotChunked, i),
      ],
    );
  }

  Widget _buildTimeSlotRow(List<List<DateTime>> timeSlotChunked, int rowIndex) {
    bool addExtra = rowIndex == timeSlotChunked.length - 1 &&
        timeSlotChunked[rowIndex].length < 4;
    List<Widget> extraSlots = addExtra
        ? List.generate(4 - timeSlotChunked[rowIndex].length,
            (_) => Expanded(child: Container()))
        : [];

    return Row(
      children: [
        Expanded(
          flex: 8,
          child: Container(
            height: 40.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              children: [
                for (int colIndex = 0;
                    colIndex < timeSlotChunked[rowIndex].length;
                    colIndex++)
                  _buildTimeSlot(timeSlotChunked, rowIndex, colIndex,
                      widget.lessonLocation),
                ...extraSlots,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlot(List<List<DateTime>> timeSlotChunked, int rowIndex,
      int colIndex, LocationLesson lessonLocation) {
    final (selectedTime, selectedCoachID, selectedLocationId) =
        ref.watch(_selectedTimeSlotAndLocationIDLesson);
    bool selected = selectedTime == timeSlotChunked[rowIndex][colIndex] &&
        selectedCoachID == widget.coachId &&
        lessonLocation.id == selectedLocationId;
    BorderRadius? borderRadius =
        _getBorderRadius(rowIndex, colIndex, timeSlotChunked);

    return Expanded(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
        onTap: () => _onTap(timeSlotChunked, rowIndex, colIndex),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.h),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: selected ? AppColors.blue : AppColors.white,
              boxShadow: [kBoxShadow],
              borderRadius: BorderRadius.circular(12.r)),
          child: Text(
            timeSlotChunked[rowIndex][colIndex].format("HH:mm"),
            style: selected
                ? AppTextStyles.manropeSemiBold(color: AppColors.white,fontSize: 15.sp,).copyWith(height: 1)
                : AppTextStyles.manropeMedium(
                    color: AppColors.black, fontSize: 15.sp,).copyWith(height: 1),
          ),
        ),
      ),
    );
    /*return Expanded(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
        onTap: () => _onTap(timeSlotChunked, rowIndex, colIndex),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 0.5.w),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.richGreen60 : AppColors.white,
            boxShadow: const [kBoxShadow],
            borderRadius: borderRadius,
          ),
          child: Text(
            timeSlotChunked[rowIndex][colIndex].format(DateFormat.HOUR_MINUTE),
            style: selected
          ? AppTextStyles.poppinsSemiBold13.copyWith(color: Colors.white)
                : AppTextStyles.poppinsRegular14,
          ),
        ),
      ),
    );*/
  }

  BorderRadius? _getBorderRadius(
      int rowIndex, int colIndex, List<List<DateTime>> timeSlotChunked) {
    return BorderRadius.circular(7.r);
    // BorderRadius? borderRadius;
    // if (rowIndex == 0 && colIndex == 0) {
    //   borderRadius = BorderRadius.only(topLeft: Radius.circular(15.r));
    // }
    // if (rowIndex == 0 && colIndex == 3) {
    //   borderRadius = BorderRadius.only(topRight: Radius.circular(15.r));
    // }
    // if (rowIndex == timeSlotChunked.length - 1 && colIndex == 0) {
    //   borderRadius = BorderRadius.only(bottomLeft: Radius.circular(15.r));
    // }
    // if (rowIndex == timeSlotChunked.length - 1 && colIndex == 3) {
    //   borderRadius = BorderRadius.only(bottomRight: Radius.circular(15.r));
    // }
    // return borderRadius;
  }

  void _onTap(
      List<List<DateTime>> timeSlotChunked, int rowIndex, int colIndex) {
    final selectedSlot = ref.read(_selectedTimeSlotAndLocationIDLesson);

    if (selectedSlot.$1 == timeSlotChunked[rowIndex][colIndex] &&
        selectedSlot.$2 == widget.coachId &&
        selectedSlot.$3 == widget.lessonLocation.id) {
      ref.read(_selectedTimeSlotAndLocationIDLesson.notifier).state =
          (null, null, null);
      return;
    }
    ref.read(_selectedTimeSlotAndLocationIDLesson.notifier).state = (
      timeSlotChunked[rowIndex][colIndex],
      widget.coachId,
      widget.lessonLocation.id
    );
  }
}

class _AvailableTimeslotLesson extends ConsumerStatefulWidget {
  const _AvailableTimeslotLesson({
    this.title,
    required this.calenderTitle,
    required this.coachId,
    required this.lessonLocation,
    required this.selectedDate,
    required this.data,
  });

  final LessonDataNew0? data;
  final String? title;
  final String calenderTitle;
  final int coachId;
  final DateTime? selectedDate;
  final LocationLesson lessonLocation;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __AvailableTimeslotLessonState();
}

class __AvailableTimeslotLessonState
    extends ConsumerState<_AvailableTimeslotLesson> {
  @override
  Widget build(BuildContext context) {
    final selectedLessonVariant = ref.watch(_selectedCoachLessonDuration);
    final (timeslot, coachId, coachLocationId) =
        ref.watch(_selectedTimeSlotAndLocationIDLesson);
    final selectedDate = ref.watch(selectedDateLessonProvider);
    if (selectedLessonVariant == null || timeslot == null || coachId == null) {
      return Container();
    }
    if (widget.selectedDate != null) {
      if (widget.selectedDate!.day != timeslot.day ||
          widget.selectedDate!.month != timeslot.month) {
        return const SizedBox();
      }
    }
    if (widget.coachId != coachId) {
      return const SizedBox();
    }
    if (widget.lessonLocation.id != coachLocationId) {
      return const SizedBox();
    }
    final selectedLessonType = ref.watch(_selectedCoachLessonDuration);

    final Map<int, String> lessons = widget.data?.getLessons(
            selectedLessonVariant,
            coachId,
            timeslot,
            widget.selectedDate ?? selectedDate.dateTime,
            widget.lessonLocation) ??
        {};

    return Column(
      children: List.generate(
        lessons.length,
        (index) {
          final startTime = timeslot;
          final endTime = startTime
              .add(Duration(minutes: selectedLessonType?.duration ?? 30));
          final String formattedTime =
              "${startTime.format("EEE d MMM")} | ${startTime.format("HH:mm")} - ${endTime.format("HH:mm")}";
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.h, left: 10.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lessons.values.toList()[index],
                            style: AppTextStyles.manropeSemiBold(
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Text(
                              formattedTime,
                              style: AppTextStyles.manropeMedium(
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    MainButton(
                      color: AppColors.white,
                      showArrow: true,
                      applyShadow: true,
                      // height: 30.h,
                      width: 90.w,
                      arrowSize: 15.h,
                      applySize: false,
                      padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 7.h),
                      label: "BOOK".trU(context),
                      labelStyle: AppTextStyles.sofiaSansMedium(fontSize: 19.sp,color: AppColors.black70,height: 1),
                      onTap: () async {
                        if (!Utils.checkUserLogin(ref)) {
                          ref.read(goRouterProvider).push(RouteNames.auth);
                          return;
                        }
                        final AvailableSlots? booking = widget.data?.getBooking(
                          coachId,
                        );
                        if (booking == null) {
                          return;
                        }

                        final lessonVariants =
                            booking.getLessonVariantsByMaxCapacity(
                                selectedLessonVariant,
                                lessons.keys.toList()[index]);

                        if (lessonVariants.isEmpty) {
                          return;
                        }
                        final bookingTime = DubaiDateTime.custom(
                          (widget.selectedDate ?? selectedDate.dateTime).year,
                          (widget.selectedDate ?? selectedDate.dateTime).month,
                          (widget.selectedDate ?? selectedDate.dateTime).day,
                          startTime.hour,
                          startTime.minute,
                        ).dateTime;

                        final courts = booking.getCourts(
                            lessons.keys.toList()[index],
                            bookingTime,
                            selectedLessonVariant,
                            widget.lessonLocation);

                        myPrint("COURTS: ${courts.length}");

                        showDialog(
                          context: context,
                          builder: (context) {
                            return BookCourtDialogLesson(
                              lessonVariant: selectedLessonVariant,
                              courts: courts,
                              lessonVariants: lessonVariants,
                              title: widget.title ?? "",
                              calendarTitle: widget.calenderTitle,
                              lessonId: lessons.keys.toList()[index],
                              coachId: widget.coachId,
                              locationId: widget.lessonLocation.id ?? 0,
                              locationName:
                                  widget.lessonLocation.locationName ?? "",
                              lessonTime: selectedLessonType?.duration ?? 30,
                              bookingTime: bookingTime,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (lessons.length - 1 != index) ...[
                SizedBox(height: 3.h),
                Divider(height: 2, color: Colors.grey.shade400),
              ]
            ],
          );
        },
      ),
    );
  }
}

class QuizQuestions extends ConsumerStatefulWidget {
  final String sportsName;
  final bool isOpenMatchFlow;

  const QuizQuestions({
    required this.sportsName,
    this.isOpenMatchFlow = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __QuizQuestionsState();
}

class __QuizQuestionsState extends ConsumerState<QuizQuestions> {
  int pageIndex = 0;
  PageController pageController = PageController();
  int totalPages = 1;
  RegisterModel registerModel = RegisterModel();

  @override
  Widget build(BuildContext context) {
    // final sport = ref.read(selectedSportProvider)?.sportName ?? kSportName;

    final provider =
        ref.watch(levelQuestionsProvider(sport: widget.sportsName));
    final showIntro = widget.isOpenMatchFlow;

    return Scaffold(
      backgroundColor: AppColors.alysumWhite,
      body: SafeArea(
        child: provider.when(
          data: (data) {
            totalPages = data.length + (showIntro ? 2 : 1);
            if (registerModel.levelAnswers.length != data.length) {
              registerModel.levelAnswers = List.filled(data.length, null);
            }
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  child: Row(
                    children: [
                      if (pageIndex > 0)
                        InkWell(
                          onTap: _onBack,
                          borderRadius: BorderRadius.circular(100.r),
                          child: Padding(
                            padding: EdgeInsets.all(6.w),
                            child: Image.asset(
                              AppImages.arrowBack.path,
                              height: 18.h,
                              color: AppColors.black,
                            ),
                          ),
                        )
                      else
                        SizedBox(width: 30.w),
                      const Spacer(),
                      InkWell(
                        onTap: () => Navigator.pop(context, false),
                        borderRadius: BorderRadius.circular(100.r),
                        child: Padding(
                          padding: EdgeInsets.all(6.w),
                          child: Icon(
                            Icons.close,
                            size: 20.h,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: pageController,
                      onPageChanged: (i) {
                        pageIndex = i;
                        setState(() {});
                      },
                      children: [
                        if (showIntro)
                          _OpenMatchAssessmentIntro(
                            onStart: () {
                              pageController.animateToPage(
                                1,
                                duration: kAnimationDuration,
                                curve: Curves.linear,
                              );
                            },
                          ),
                        for (int i = 0; i < data.length; i++)
                          LevelAssessmentTab(
                            index: i,
                            isLastQuestion: i == data.length - 1,
                            levelQuesiton: data[i],
                            registerModel: registerModel,
                            isForPopup: true,
                            isOpenMatchFlow: widget.isOpenMatchFlow,
                            totalQuestions: data.length,
                            onProceed: () {
                              pageController.animateToPage(
                                pageIndex + 1,
                                duration: kAnimationDuration,
                                curve: Curves.linear,
                              );
                            },
                          ),
                        LevelScoreTab(
                          registerModel: registerModel,
                          isForPopUp: true,
                          isOpenMatchFlow: widget.isOpenMatchFlow,
                          onProceed: () async {
                            final provider = calculateLevelProvider(
                                answers: registerModel.levelAnswers,
                                allowClub: true,
                                sportsName: widget.sportsName);
                            final CalculatedLevelData? check =
                                await Utils.showLoadingDialog(
                                    context, provider, ref);
                            if (check != null) {
                              if (context.mounted) {
                                ref.refresh(fetchUserProvider);
                                Navigator.pop(context, true);
                              }
                            }
                          },
                          sportsName: widget.sportsName,
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
          loading: () => const Center(
              child: CupertinoActivityIndicator(color: AppColors.brick)),
          error: (e, _) => Center(
            child: Text(
              e.toString(),
              style: AppTextStyles.manropeLight(
                fontSize: 16.sp,
                color: AppColors.errorColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onBack() {
    if (pageIndex > 0) {
      pageController.animateToPage(pageIndex - 1,
          duration: kAnimationDuration, curve: Curves.linear);
    }
  }
}

class _OpenMatchAssessmentIntro extends StatelessWidget {
  const _OpenMatchAssessmentIntro({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          6.verticalSpace,
          Center(
            child: Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: AppColors.black5,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Center(
                child: Image.asset(
                  AppImages.levelAssessment.path,
                  width: 42.w,
                  height: 42.w,
                  color: AppColors.brick,
                ),
              ),
            ),
          ),
          18.verticalSpace,
          Text(
            'OPEN_MATCH_ASSESSMENT_TITLE'.trU(context),
            style: AppTextStyles.sofiaSansMedium(
              fontSize: 24.sp,
              color: AppColors.black,
            ),
          ),
          8.verticalSpace,
          Text(
            'OPEN_MATCH_ASSESSMENT_SUBTITLE'.tr(context),
            style: AppTextStyles.manropeMedium(
              fontSize: 15.sp,
              color: AppColors.black70,
            ),
          ),
          14.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColors.black5,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'OPEN_MATCH_ASSESSMENT_TIME'.tr(context),
              style: AppTextStyles.manropeMedium(
                fontSize: 14.sp,
                color: AppColors.black70,
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: MainButton(
              isForPopup: true,
              applySize: false,
              height: 56.h,
              label: 'OPEN_MATCH_ASSESSMENT_START'.trU(context),
              onTap: onStart,
            ),
          ),
        ],
      ),
    );
  }
}

class _MembershipComponent extends ConsumerWidget {
  const _MembershipComponent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(fetchActiveAndAllMembershipsProvider);

    return membership.when(
        data: (data) {
          if (data.membershipModel.isEmpty) {
            return SizedBox();
          }

          if (data.showMembershipCategories.isNotEmpty) {
            final padelCategory = data.showMembershipCategories.firstWhere(
                (element) =>
                    (element.categoryName ?? "")
                        .toString()
                        .trim()
                        .toLowerCase() ==
                    "padel",
                orElse: () => data.showMembershipCategories.first);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(selectedMembershipCatIndex.notifier).state =
                  padelCategory.id;
            });
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 15.h, left: 15.w),
                child: Text(
                  'PACKAGES'.trU(context),
                  style: AppTextStyles.sofiaSansMedium(
                    fontSize: 17.sp,
                  ),
                ),
              ),
              MembershipListComponent(
                  data: data, scrollDirection: Axis.horizontal),
            ],
          );
        },
        error: (e, _) => SizedBox(),
        loading: () => Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: const Center(child: CupertinoActivityIndicator()),
            ));
  }
}

class _CoachSelection extends ConsumerWidget {
  const _CoachSelection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final selectedLessonCoachId = ref.watch(_selectedLessonCoachId);
    final fetchAllCoaches = ref.watch(fetchAllCoachesProvider);

    return fetchAllCoaches.when(
      data: (data) {
        if (data.isEmpty) {
          return Container(
            height: 60.h,
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.black5,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.black70.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                "NO_COACH_FOUND".tr(context),
                style: AppTextStyles.manropeMedium(
                  fontSize: 14.sp,
                  color: AppColors.black70,
                ),
              ),
            ),
          );
        }
        return Container(
          height: (width / height) > 0.6 ? 110.h : 71.h,
          margin:
              EdgeInsets.only(left: 6.w, top: 15.h, bottom: 7.h, right: 6.w),
          child:
              _buildCoachesListView(ref, context, selectedLessonCoachId, data),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (error, _) => SecondaryText(text: error.toString()),
    );
  }

  Widget _buildCoachesListView(WidgetRef ref, BuildContext context,
      List<int> selectedCoach, List<CoachListModel> coachList) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: coachList.length,
        itemBuilder: (context, i) {
          final slot = coachList[i];
          return _getDateContainer(ref, slot, selectedCoach);
        },
      ),
    );
  }

  Widget _getDateContainer(
      WidgetRef ref, CoachListModel slots, List<int> selectedCoach) {
    bool isSelected = selectedCoach.contains(slots.id ?? 0);

    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => _onDateTap(ref, slots),
        child: Container(
          height: 60.h,
          width: 64.w,
          clipBehavior: Clip.none,
          decoration: decoration.copyWith(
            color: isSelected ? AppColors.blue : AppColors.black5,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: _buildCoachContent(slots, isSelected),
        ),
      ),
    );
  }

  void _onDateTap(WidgetRef ref, CoachListModel coach) {
    ref.read(_selectedLessonCoachId.notifier).state = [coach.id ?? 0];
  }

  Widget _buildCoachContent(CoachListModel coach, bool isSelected) {
    final coachName = coach.fullName ?? "";
    final coachProfile = coach.profileUrl ?? "";
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 5.h),
        NetworkCircleImage(
          path: coachProfile,
          width: 37.w,
          height: 37.w,
          bgColor: AppColors.white,
        ),
        SizedBox(width: 5.w),
        Flexible(
          child: Text(
            coachName.capitalizeFirst,
            style: AppTextStyles.manropeMedium(fontSize: 15.sp,
                color: isSelected ? AppColors.white : AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}

class _FilterRow extends ConsumerWidget {
  const _FilterRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDateLessonSelected = ref.watch(_dateBookableLesson);
    final fetchAllCoaches = ref.watch(fetchAllCoachesProvider);
    final dateRangeLesson = ref.watch(_dateLessonsRangeProvider);
    final selectedLessonCoachId = ref.watch(_selectedLessonCoachId);
    final allLocations = ref.watch(clubLocationsProvider);
    final selectedLocation = ref.watch(_selectedLessonsLocationProvider);
    final getCoachName = () {
      if (selectedLessonCoachId.length > 1) {
        return "MULTIPLE_COACHES".tr(context);
      }

      if (selectedLessonCoachId.isEmpty) {
        return "ALL_COACHES".tr(context);
      }

      final coachId = selectedLessonCoachId.first;
      final coach = fetchAllCoaches.value?.firstWhere(
        (c) => c.id == coachId,
        orElse: () => CoachListModel(fullName: ""),
      );

      return coach?.fullName?.isNotEmpty == true
          ? coach!.fullName ?? "ALL_COACHES".tr(context)
          : "ALL_COACHES".tr(context);
    }();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(children: [
        // Image.asset(
        //   AppImages.filterIcon.path,
        //   height: 15.h,
        //   width: 15.w,
        // ),
        // SizedBox(width: 8.w),
        Expanded(
          child: allLocations.when(
            data: (data) {
              if (data == null) {
                return const SizedBox();
              }
              final list = data;
              if (list.first.id != kAllLocation.id) {
                list.insert(0, kAllLocation);
              }
              final coachesList = Utils.fetchLocationCoaches(data);
              if (coachesList.isNotEmpty &&
                  coachesList.first.id != kAllCoaches.id) {
                coachesList.insert(0, kAllCoaches);
              }
              return Row(
                children: [
                  Expanded(
                      child: _buildFilterItem(
                    label: selectedLocation.locationName == 'All Locations'
                        ? 'ALL_LOCATIONS'.tr(context)
                        : (selectedLocation.locationName ?? 'ALL_LOCATIONS'.tr(context))
                            .capitalizeFirst,
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
                          backgroundColor: Colors.transparent,
                          builder: (context) => widget);
                    },
                  )),
                ],
              );
            },
            error: (_, __) => Container(),
            loading: () => Container(),
          ),
        ),
        SizedBox(width: 8.w),
        if (isDateLessonSelected) ...[
          Expanded(
              child: _buildFilterItem(
            label: getCoachName.capitalizeFirst,
            onTap: () {
              final Widget widget = Consumer(
                builder: (context, ref, _) {
                  return _buildCoachSelector(
                      ref, context, fetchAllCoaches.value ?? []);
                },
              );
              if (PlatformC().isCurrentDesignPlatformDesktop) {
                showDialog(context: context, builder: (context) => widget);
                return;
              }
              showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => widget);
            },
          )),
          SizedBox(width: 4.w)
        ],
        if (!isDateLessonSelected) ...[
          Expanded(
            child: _buildFilterItem(
              label:
                  "${dateRangeLesson.startDate!.format('dd')} - ${dateRangeLesson.endDate!.format('dd MMM')}",
              onTap: () {
                final Widget widget =
                    _buildDateRangeSelector(ref, context, dateRangeLesson);
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
          SizedBox(width: 4.w),
        ],
      ]),
    );
  }

  Widget _buildLocationSelector(
      WidgetRef ref, BuildContext context, List<ClubLocationData> locations) {
    final isDesktop = PlatformC().isCurrentDesignPlatformDesktop;
    return _bottomSheet(
      context: context,
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
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: OptionTile(
                            option: location.locationName == 'All Locations'
                                ? 'ALL_LOCATIONS'.tr(context)
                                : (location.locationName ?? "").capitalizeFirst,
                            enabled: true,
                            selected: location.id ==
                                ref.read(_selectedLessonsLocationProvider).id,
                            onTap: () {
                              ref
                                  .read(
                                      _selectedLessonsLocationProvider.notifier)
                                  .state = location;
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

  Widget _buildDateRangeSelector(
      WidgetRef ref, BuildContext context, PickerDateRange range) {
    DateRangePickerController dateController = DateRangePickerController();

    return _bottomSheet(
      context: context,
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
                  ref.read(_dateLessonsRangeProvider.notifier).state = range;
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomSheet({required Widget child, required BuildContext context}) {
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
        child: child,
      ),
    );
  }

  Widget _buildCoachSelector(
      WidgetRef ref, BuildContext context, List<CoachListModel> coaches) {
    final isDesktop = PlatformC().isCurrentDesignPlatformDesktop;
    final selectedLessonCoachId = ref.watch(_selectedLessonCoachId);
    return _bottomSheet(
      context: context,
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
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'COACHES'.trU(context),
            style: AppTextStyles.sofiaSansMedium(
              fontSize: 26.sp,
            ),
          ),
          SizedBox(height: 20.h),
          Flexible(
            child: Scrollbar(
              thumbVisibility: isDesktop,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: OptionTile(
                        option: (kLessonsAllCoaches.locationName ?? "")
                            .toUpperCase()
                            .tr(context),
                        enabled: true,
                        selected: selectedLessonCoachId.isEmpty,
                        onTap: () {
                          ref.read(_selectedLessonCoachId.notifier).state = [];
                        },
                      ),
                    ),
                    ListView.builder(
                      itemCount: coaches.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final coach = coaches[index];
                        final isSelected =
                            selectedLessonCoachId.contains(coach.id ?? 0);
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: OptionTile(
                            option: (coach.fullName ?? "").capitalizeFirst,
                            enabled: true,
                            selected: isSelected,
                            onTap: () {
                              final value = [...selectedLessonCoachId];

                              if (isSelected) {
                                value.remove(coach.id ?? 0);
                              } else {
                                value.add(coach.id ?? 0);
                              }
                              ref.read(_selectedLessonCoachId.notifier).state =
                                  value;
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterItem({required String label, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: inset.BoxDecoration(
          boxShadow: kInsetShadow,
          color: AppColors.black5,
          borderRadius: BorderRadius.circular(100.r),
        ),
        padding: EdgeInsets.only(left: 10.w, right: 5.w, top: 8.h, bottom: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.manropeMedium(
                  fontSize: 13.sp,
                  color: AppColors.black70,
                ),
              ),
            ),
            Image.asset(
              AppImages.dropdownIcon.path,
              height: 16.h,
              width: 16.h,
              color: AppColors.black70,
            )
          ],
        ),
      ),
    );
  }
}

class _CoachDurationList extends ConsumerWidget {
  const _CoachDurationList({required this.lessonVariants, required this.index});

  final int index;
  final LessonVariants lessonVariants;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = lessonVariants.duration;
    if (duration == null) {
      return const SizedBox();
    }

    final selectedLessonType = ref.watch(_selectedCoachLessonDuration);
    bool isServiceSelected =
        (selectedLessonType?.duration == lessonVariants.duration);
    return Expanded(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
        ),
        onTap: () {
          ref.read(_selectedCoachLessonDuration.notifier).state =
              lessonVariants;
        },
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
            padding: EdgeInsets.all(4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
                color: isServiceSelected
                    ? AppColors.blue
                    : Colors.transparent),
            alignment: Alignment.center,
            child: Text(
              "${lessonVariants.duration ?? 0} ${"MINS".tr(context)}",
              textAlign: TextAlign.center,
              style: isServiceSelected
                  ? AppTextStyles.manropeSemiBold(
                      color: AppColors.white, fontSize: 13.sp)
                  : AppTextStyles.manropeMedium(
                      fontSize: 13.sp, color: AppColors.black70),
            )),
      ),
    );
  }
}

class _NonMembershipUser extends ConsumerWidget {
  const _NonMembershipUser();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImages.trophy.path, height: 90.h, width: 90.w),
          SizedBox(height: 20.h),
          Text(
            "CAN_NOT_BOOK_DESCRIPTION".tr(context),
            style: AppTextStyles.sofiaSansMedium(
                fontSize: 19.sp, color: AppColors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          MainButton(
            isForPopup: true,
            label: "SEE_MEMBERSHIP".trU(context),
            onTap: () async {
              final membershipData =
                  ref.read(fetchActiveAndAllMembershipsProvider).value;
              if (membershipData == null) return;
              final value = await showDialog(
                context: context,
                builder: (context) => _MembershipDialog(data: membershipData),
              );
              if (value is bool && value && context.mounted) {
                await _onPurchaseMembership(ref, context, membershipData);
              }
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

Future<void> _onPurchaseMembership(
    WidgetRef ref, BuildContext context, UserActiveMembership value) async {
  final selectedMembership = value.haveHOPMembership;
  if (selectedMembership == null) {
    return;
  }
  final data = await showPaymentSheet(
    context: context,
    child: PaymentInformation(
        allowWallet: false,
        type: PaymentDetailsRequestType.join,
        locationID: selectedMembership.locationId,
        requestType: PaymentProcessRequestType.membership,
        price: selectedMembership.price ?? 0,
        serviceID: selectedMembership.id,
        startDate: null,
        duration: null,
        allowCoupon: false,
        purchaseMembership: true),
  );
  var (int? success, double? amount) = (null, null);
  if (data is (int, double?)) {
    (success, amount) = data;
  }

  if (success != null && context.mounted) {
    await Utils.showMessageDialog(
      context,
      ("YOU_HAVE_PURCHASED_MEMBERSHIP").tr(context),
    );
    ref.invalidate(fetchActiveAndAllMembershipsProvider);
  }
}

class _MembershipDialog extends ConsumerWidget {
  final UserActiveMembership data;

  const _MembershipDialog({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final price = data.haveHOPMembership?.price ?? 0;

    final haveMembership = data.haveActiveHOPMembership;

    final isActive = haveMembership != null;

    return CustomDialog(
      color: isActive ? AppColors.white : AppColors.black2,
      closeIconColor: isActive ? AppColors.black : AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              isActive
                  ? "HOUSE_OF_PADEL_MEMBERSHIP".trU(context)
                  : "BECOME_A_MEMBER".trU(context),
              style: AppTextStyles.sofiaSansMedium(
                  fontSize: 19.sp,
                  color: isActive ? AppColors.black : AppColors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (isActive) _membershipCard(ref, context, data),
            if (isActive) const SizedBox(height: 16),
            _benefits(color: isActive ? AppColors.black : AppColors.white),
            if (!isActive) const SizedBox(height: 10),
            // Price
            if (!isActive)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Price: ${price.toStringAsFixed(0)} $currency/month",
                  style: AppTextStyles.manropeLight(
                      fontSize: 15.sp, color: AppColors.white),
                ),
              ),
            if (!isActive) const SizedBox(height: 20),
            // Purchase Button
            if (!isActive)
              MainButton(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  isForPopup: true,
                  label: "PURCHASE_MEMBERSHIP".trU(context))
          ],
        ),
      ),
    );
  }

  Widget _benefits({Color? color}) {
    final temp = [
      "25% Off individual booking.",
      "14 Day advance on bookings (7 day advance on general public)."
    ];

    return Column(
      children: [
        // Membership Benefits
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Membership Benefits:",
            style: AppTextStyles.manropeLight(
                fontSize: 15.sp, color: color ?? AppColors.white),
          ),
        ),
        const SizedBox(height: 12),

        // Benefits List
        ...temp.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check, color: AppColors.yellow, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    e,
                    style: AppTextStyles.manropeLight(
                        fontSize: 15.sp, color: color ?? AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _membershipCard(
      WidgetRef ref, BuildContext context, UserActiveMembership data) {
    final haveMembership = data.haveActiveHOPMembership;
    final user = ref.read(userManagerProvider).user?.user;
    final profilePicture = user?.profileUrl ?? "";
    final fullName = (user?.fullName ?? "").toUpperCase();

    final userLeft = haveMembership?.usesLeft ?? 0;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r), color: AppColors.black),
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Avatar + Member Info
          Row(
            children: [
              NetworkCircleImage(
                path: profilePicture,
                width: 50.w,
                height: 50.w,
                borderRadius: BorderRadius.circular(12.r),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MEMBER".tr(context),
                    style: AppTextStyles.manropeMedium(
                        fontSize: 13.sp, color: AppColors.white),
                  ),
                  SizedBox(height: 2),
                  Text(
                    fullName,
                    style: AppTextStyles.sofiaSansMedium(
                        fontSize: 13.sp, color: AppColors.white),
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 20),

          Center(
              child: Image.asset(AppImages.splashLogo.path,
                  width: 140.w, height: 77.h)),

          const SizedBox(height: 24),

          // Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Off-Peak Coaching
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${"OFF_PEAK_COACHING".tr(context)}:",
                    style: AppTextStyles.manropeMedium(
                        fontSize: 13.sp, color: AppColors.white),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "$userLeft",
                          style: AppTextStyles.sofiaSansMedium(
                              fontSize: 11.sp, color: AppColors.black),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        "${"REMAINING".tr(context)}",
                        style: AppTextStyles.manropeMedium(
                            fontSize: 13.sp, color: AppColors.white),
                      )
                    ],
                  )
                ],
              ),

              // Valid Until
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    haveMembership?.finishDateString(context) ?? "",
                    style: AppTextStyles.manropeMedium(
                        fontSize: 13.sp, color: AppColors.white),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
