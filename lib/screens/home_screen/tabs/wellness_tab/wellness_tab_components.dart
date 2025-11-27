part of 'wellness_tab.dart';

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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final selectedIndex = ref.watch(_selectedTabIndex);
    // final selectedDate = ref.watch(selectedDateProvider);
    final selectedDate = selectedIndex == 0
        ? ref.watch(selectedDateProvider)
        : ref.watch(selectedDateLessonProvider);
    return Container(
      height: (width / height) > 0.6 ? 120.h : 65.h,
      margin: EdgeInsets.only(
        top: 10.h,
        bottom: 7.h,
      ),
      // padding: EdgeInsets.only(left: 6.w, right: 0),
      child: _buildDateListView(context, selectedDate.dateTime),
    );
  }

  Widget _buildDateListView(BuildContext context, DateTime selectedDate) {
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
          return _getDateContainer(date, selectedDate);
        },
      ),
    );
  }

  Widget _getDateContainer(DateTime date, DateTime selectedDate) {
    bool isSelected = date.isAtSameMomentAs(selectedDate);

    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => _onDateTap(date),
        child: Container(
          // height: 70.w,
          // width: 55.w,
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.black2 : AppColors.black5,
            borderRadius: BorderRadius.circular(15.r),
            // border: Border.all(
            //   color: isSelected ? AppColors.blue : AppColors.blue25,
            //   width: 1.w,
            // ),
          ),
          child: _buildDateContent(date, isSelected),
        ),
      ),
    );
  }

  void _onDateTap(DateTime date) {
    ref.read(_selectedTabIndex) == 0
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
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            date.format(DateFormat.ABBR_WEEKDAY),
            style: AppTextStyles.manropeLight(
              height: 0.8,
              // color: AppColors.white,
              color: isSelected ? AppColors.white : AppColors.black70,
            ),
          ),
          Text(
            '${date.day}',
            style: AppTextStyles.manropeMedium(
              color: isSelected ? AppColors.white : AppColors.black70,
              fontSize: 18.sp,
              letterSpacing: 18.sp * 0.12,
            ),
          ),
          Text(
            date.format(DateFormat.ABBR_MONTH),
            style: AppTextStyles.manropeLight(
              color: isSelected ? AppColors.white : AppColors.darkGray,
              height: 0.8,
            ),
          ),
          // SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

// class _Sport extends ConsumerWidget {
//   const _Sport({required this.sportToShow, required this.index, required this.onTap, required this.isServiceSelected});
//
//   final int index;
//   final List sportToShow;
//   final Function onTap;
//   final bool isServiceSelected;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return _DurationAndSportContainer(
//       isSelected: isServiceSelected,
//       text: sportToShow[index] ?? '',
//       onTap: () {
//         onTap();
//       },
//     );
//   }
// }
//
// class _Duration extends ConsumerWidget {
//   const _Duration({required this.duration, required this.index});
//
//   final int index;
//   final int duration;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedDuration = ref.watch(_selectedDuration);
//     bool isServiceSelected = (selectedDuration == duration);
//     return Expanded(
//       child: InkWell(
//         customBorder: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(100.r),
//         ),
//         onTap: () {
//           ref.read(_selectedDuration.notifier).state = duration;
//           ref.read(_pageViewController.notifier).state.animateToPage(
//             index,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//           );
//         },
//         child: Container(
//           margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
//           padding: EdgeInsets.all(2.h),
//           decoration: BoxDecoration(
//             color: isServiceSelected ? AppColors.rosewood : Colors.transparent,
//             borderRadius: BorderRadius.circular(100.r),
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             "$duration min",
//             textAlign: TextAlign.center,
//             // style: isServiceSelected ? AppTextStyles.gothicBold(fontSize: 13.sp, color: AppColors.white) : AppTextStyles.gothicRegular(),
//             style: isServiceSelected
//                 ? AppTextStyles.gothicSemiBold(color: Colors.white, fontSize: 13.sp)
//                 : AppTextStyles.gothicLight(fontSize: 13.sp, color: AppColors.black70),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _DurationAndSportContainer extends StatelessWidget {
//   const _DurationAndSportContainer({required this.isSelected, required this.text, required this.onTap});
//
//   final bool isSelected;
//   final Function() onTap;
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.all(
//           4.h,
//         ),
//         padding: EdgeInsets.fromLTRB(24.w, 6.h, 24.w, 4.h),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.rosewood : Colors.transparent,
//           borderRadius: BorderRadius.circular(100.r),
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           text.toUpperCase(),
//           textAlign: TextAlign.center,
//           style: isSelected
//               ? AppTextStyles.gothicSemiBold(color: Colors.white, fontSize: 13.sp)
//               : AppTextStyles.gothicLight(fontSize: 13.sp, color: AppColors.black70),
//         ),
//       ),
//     );
//   }
// }
//
// class _Timeslots extends ConsumerStatefulWidget {
//   const _Timeslots({required this.data, required this.locationID});
//
//   final CourtBookingData data;
//   final int locationID;
//
//   @override
//   ConsumerState<_Timeslots> createState() => __TimeslotsState();
// }
//
// class __TimeslotsState extends ConsumerState<_Timeslots> {
//   @override
//   Widget build(BuildContext context) {
//     final selectedDuration = ref.watch(_selectedDuration);
//     final selectedDate = ref.watch(selectedDateProvider);
//
//     if (selectedDuration == null) {
//       return Container();
//     }
//
//     final timeSlots = widget.data.getTimeSlots(selectedDuration, widget.locationID, selectedDate.dateTime);
//
//     if (timeSlots.isEmpty) {
//       return _buildNoAvailableSlotsMessage(context);
//     }
//
//     List<List<DateTime>> timeSlotChunked = Utils.getChunks(timeSlots, 4);
//
//     return _buildTimeSlots(timeSlotChunked);
//   }
//
//   Widget _buildNoAvailableSlotsMessage(BuildContext context) {
//     return Container(
//       height: 100.h,
//       alignment: Alignment.center,
//       child: SecondaryText(
//         text: "NO_AVAILABLE_SLOTS".trU(context),
//       ),
//     );
//   }
//
//   Widget _buildTimeSlots(List<List<DateTime>> timeSlotChunked) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         for (int i = 0; i < timeSlotChunked.length; i++) _buildTimeSlotRow(timeSlotChunked, i),
//       ],
//     );
//   }
//
//   Widget _buildTimeSlotRow(List<List<DateTime>> timeSlotChunked, int rowIndex) {
//     bool addExtra = rowIndex == timeSlotChunked.length - 1 && timeSlotChunked[rowIndex].length < 4;
//     List<Widget> extraSlots = addExtra ? List.generate(4 - timeSlotChunked[rowIndex].length, (_) => Expanded(child: Container())) : [];
//
//     return Row(
//       children: [
//         Expanded(
//           flex: 8,
//           child: Container(
//             height: 40.w,
//             margin: EdgeInsets.symmetric(vertical: 1.5.h),
//             child: Row(
//               children: [
//                 for (int colIndex = 0; colIndex < timeSlotChunked[rowIndex].length; colIndex++) _buildTimeSlot(timeSlotChunked, rowIndex, colIndex),
//                 ...extraSlots,
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTimeSlot(List<List<DateTime>> timeSlotChunked, int rowIndex, int colIndex) {
//     final (selectedTime, selectedLocationID) = ref.watch(_selectedTimeSlotAndLocationID);
//     bool selected = selectedTime == timeSlotChunked[rowIndex][colIndex] && selectedLocationID == widget.locationID;
//     BorderRadius? borderRadius = _getBorderRadius(rowIndex, colIndex, timeSlotChunked);
//
//     return Expanded(
//       child: InkWell(
//         customBorder: RoundedRectangleBorder(
//           borderRadius: borderRadius ?? BorderRadius.zero,
//         ),
//         onTap: () => _onTap(timeSlotChunked, rowIndex, colIndex),
//         child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 1.w),
//           // padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: selected ? AppColors.darkRosewood : AppColors.white,
//             boxShadow: const [kBoxShadow],
//             borderRadius: borderRadius,
//           ),
//           child: Text(
//             timeSlotChunked[rowIndex][colIndex].format("h:mm a").toLowerCase(),
//             style: AppTextStyles.gothicLight(
//               color: selected ? AppColors.white : AppColors.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   BorderRadius? _getBorderRadius(int rowIndex, int colIndex, List<List<DateTime>> timeSlotChunked) {
//     return BorderRadius.all(Radius.circular(15.r));
//   }
//
//   void _onTap(List<List<DateTime>> timeSlotChunked, int rowIndex, int colIndex) {
//     final selectedSlot = ref.read(_selectedTimeSlotAndLocationID);
//     if (selectedSlot.$1 == timeSlotChunked[rowIndex][colIndex] && selectedSlot.$2 == widget.locationID) {
//       ref.read(_selectedTimeSlotAndLocationID.notifier).state = (null, null);
//       return;
//     }
//     ref.read(_selectedTimeSlotAndLocationID.notifier).state = (timeSlotChunked[rowIndex][colIndex], widget.locationID);
//   }
// }
//
// class _AvailableTimeslot extends ConsumerStatefulWidget {
//   const _AvailableTimeslot({required this.data, required this.locationID});
//
//   final CourtBookingData data;
//   final int locationID;
//
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => __AvailableTimeslotState();
// }
//
// class __AvailableTimeslotState extends ConsumerState<_AvailableTimeslot> {
//   @override
//   Widget build(BuildContext context) {
//     final selectedDuration = ref.watch(_selectedDuration);
//     final (timeslot, locationID) = ref.watch(_selectedTimeSlotAndLocationID);
//     final selectedDate = ref.watch(selectedDateProvider);
//     if (selectedDuration == null || timeslot == null || locationID == null) {
//       return Container();
//     }
//     if (widget.locationID != locationID) {
//       return Container();
//     }
//     final courts = widget.data.getCourt(selectedDuration, locationID, timeslot, selectedDate.dateTime);
//
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: courts.length,
//       itemBuilder: (context, index) {
//         final startTime = timeslot;
//         final endTime = startTime.add(Duration(minutes: selectedDuration));
//         final String formattedTime = "${startTime.format("EEE d MMM")} | ${startTime.format("h:mm")} - ${endTime.format("h:mm a").toLowerCase()}";
//         return Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(top: 10.h, left: 10.w),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 10,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           courts.values.toList()[index].toUpperCase(),
//                           style: AppTextStyles.gothicSemiBold(
//                             fontSize: 15.sp,
//                           ),
//                         ),
//                         SizedBox(height: 2.h),
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: 10.w,
//                             ),
//                             Text(
//                               formattedTime,
//                               style: AppTextStyles.gothicLight(),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   const Spacer(),
//                   MainButton(
//                     color: AppColors.white,
//                     showArrow: false,
//                     applyShadow: true,
//                     height: 30.h,
//                     width: 83.w,
//                     padding: EdgeInsets.symmetric(horizontal: 15.w),
//                     label: "BOOK".trU(context),
//                     labelStyle: AppTextStyles.gothicLight(fontSize: 15.sp),
//                     onTap: () async {
//                       final booking =
//                       widget.data.getBooking(selectedDate.dateTime, timeslot, locationID, selectedDuration, courts.keys.toList()[index]);
//                       if (booking == null) {
//                         return;
//                       }
//                       showDialog(
//                         context: context,
//                         builder: (context) {
//                           return BookCourtDialog(
//                             coachId: null,
//                             bookings: booking,
//                             bookingTime: DubaiDateTime.custom(
//                               selectedDate.dateTime.year,
//                               selectedDate.dateTime.month,
//                               selectedDate.dateTime.day,
//                               startTime.hour,
//                               startTime.minute,
//                             ).dateTime,
//                             court: {courts.keys.toList()[index]: courts.values.toList()[index]},
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             if (courts.length - 1 != index) ...[
//               const SizedBox(height: 10),
//               Container(
//                 height: 0.7.h,
//                 margin: EdgeInsets.symmetric(horizontal: 10.w),
//                 color: AppColors.black5,
//               ),
//             ],
//           ],
//         );
//       },
//     );
//   }
// }
//
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
          margin: EdgeInsets.all(5.h),
          clipBehavior: Clip.none,
          padding:
              EdgeInsets.only(top: 13.h, left: 14.w, bottom: 10.h, right: 14.w),
          decoration: BoxDecoration(
            color: isServiceSelected ? AppColors.black2 : Colors.transparent,
            borderRadius: BorderRadius.circular(15.r),
          ),
          alignment: Alignment.center,
          child: Text(title,
              textAlign: TextAlign.center,
              style: AppTextStyles.manropeMedium(
                  fontSize: 16.sp,
                  color:
                      isServiceSelected ? AppColors.white : AppColors.black70,
                  letterSpacing: 16.sp * 0.12)),
        ),
      ),
    );
  }
}

class MembershipInformation extends ConsumerStatefulWidget {
  final MembershipModel membershipModel;
  final ActiveMemberships? activeMembership;
  const MembershipInformation(
      {super.key,
      required this.membershipModel,
      required this.activeMembership});

  @override
  ConsumerState<MembershipInformation> createState() =>
      _MembershipInformationState();
}

class _MembershipInformationState extends ConsumerState<MembershipInformation> {
  DateTime? selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 5.h,
        ),
        Center(
          child: Text(
            '${"MEMBERSHIP".trU(context)}\n ${"INFORMATION".trU(context)}',
            style: AppTextStyles.popupHeaderTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          "MEMBERSHIP_DESC".tr(context),
          style: AppTextStyles.popupBodyTextStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        WellnessMembershipCourtInfoCard(
            membershipModel: widget.membershipModel,
            activeMembership: widget.activeMembership),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Text(
            "STARTING_DATE".tr(context),
            style: AppTextStyles.manropeLight(
              color: AppColors.white,
              fontSize: 17.sp,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: 5.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: InkWell(
            onTap: () async {
              await DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                minTime:
                    DateTime.now().subtract(const Duration(days: 365 * 60)),
                maxTime: DateTime.now(),
                currentTime: selectedDate ?? DateTime.now(),
                onConfirm: (date) {
                  selectedDate = date;
                  setState(() {});
                },
                locale: LocaleType.en,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white25,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? "dd-MM-yyyy"
                          : DateFormat("dd-MM-yyyy").format(selectedDate!),
                      style: AppTextStyles.manropeLight(
                        color: AppColors.white95,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 17.h,
                    color: AppColors.white95,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "BOOKING_PAYMENT".trU(context),
            style: AppTextStyles.manropeLight(
                color: AppColors.white, fontSize: 20.sp),
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.h),
          child: MainButton(
            isForPopup: true,
            enabled: selectedDate != null,
            padding: EdgeInsets.only(top: 9.h, bottom: 5.h),
            label: "PROCEED_WITH_PAYMENT".trU(context),
            onTap: () {
              Navigator.pop(context, selectedDate);
            },
          ),
        ),
        // 20.verticalSpace,
      ],
    ));
  }
}
