part of 'lessons_list.dart';

class _HideShowDatesButton extends StatelessWidget {
  final bool isDatesVisible;
  final VoidCallback onTap;

  const _HideShowDatesButton({
    required this.isDatesVisible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        // customBorder: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(10.r),
        // ),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 3.5.h, horizontal: 7.5.w),
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isDatesVisible
                    ? "HIDE_DATES".tr(context)
                    : "SEE_DATES".tr(context),
                style: AppTextStyles.manropeMedium(
                    fontSize: 13.sp,color: AppColors.white).copyWith(height: 1),
              ),
              SizedBox(width: 4.w),
              Icon(
                isDatesVisible ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16.sp,
                color: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonDatesListView extends StatelessWidget {
  final List<LessonServices>? services;
  final Function(int) onTap;

  const _LessonDatesListView({
    required this.services,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: services?.length ?? 0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: CDivider(),
        );
      },
      itemBuilder: (context, index) {
        final serviceBooking = services![index].serviceBookings?.first;
        final maximumCapacity = serviceBooking?.maximumCapacity ?? 0;
        final minimumCapacity = serviceBooking?.minimumCapacity ?? 0;
        return _LessonDateItem(
          serviceBooking: serviceBooking,
          maximumCapacity: maximumCapacity,
          minimumCapacity: minimumCapacity,
          isEnabled: isEnabled(serviceBooking?.players?.length ?? 0,
              maximumCapacity, minimumCapacity),
          onTap: () {
            onTap(index);
          },
        );
      },
    );
  }

  bool isEnabled(int playersCount, int maximumCapacity, int minimumCapacity) {
    final maxCapacity = maximumCapacity;
    final minCapacity = minimumCapacity;
    if (maxCapacity == 0) {
      return false;
    }
    if (playersCount >= maxCapacity) {
      return false;
    } else if (playersCount >= minCapacity) {
      return true;
    } else {
      return true;
    }
  }
}

class _LessonDateItem extends StatelessWidget {
  final LessonServiceBookings? serviceBooking;
  final int maximumCapacity;
  final int minimumCapacity;
  final Function() onTap;
  final bool isEnabled;

  const _LessonDateItem({
    required this.serviceBooking,
    required this.maximumCapacity,
    required this.minimumCapacity,
    required this.onTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                serviceBooking?.bookingDate.format("EEE dd MMM") ??
                    "",
                style: AppTextStyles.manropeSemiBold(
                    fontSize: 15.sp,),
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  "${serviceBooking?.bookingStartTime.format("h:mm")} - ${serviceBooking?.bookingEndTime.format("h:mm a").toLowerCase()}",
                  style: AppTextStyles.manropeMedium(fontSize: 15.sp),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Utils.eventLessonStatusText(
                  context: context,
                  playersCount: serviceBooking?.players?.length ?? 0,
                  maxCapacity: maximumCapacity,
                  minCapacity: minimumCapacity,
                ).toUpperCase(),
                style: AppTextStyles.sofiaSansMedium(fontSize: 16.sp,),
              ),
              // SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.only(top: 4.h, left: 10.w, right: 10.w,bottom: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  "${serviceBooking?.players?.length.toString() ?? "0"}/$maximumCapacity",
                  style: AppTextStyles.manropeSemiBold(fontSize: 13.sp,color: AppColors.white),
                ),
              ),
            ],
          ),
          MainButton(
            color: AppColors.white,
            showArrow: true,
            applyShadow: isEnabled,
            enabled: isEnabled,
            height: 35.h,
            arrowSize: 12.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            applySize: false,
            label: "BOOK".trU(context),
            labelStyle: AppTextStyles.sofiaSansMedium(fontSize: 19.sp,color: AppColors.black70),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "ARE_YOU_SURE_YOU_WANT_TO_JOIN".trU(context),
              style: AppTextStyles.popupHeaderTextStyle,
              textAlign: TextAlign.center,
            ),

            // Text(
            //   "ARE_YOU_SURE_YOU_WANT_TO_JOIN".trU(context),
            //   textAlign: TextAlign.center,
            //   style: AppTextStyles.gothamNarrowBold(
            //       color: AppColors.white, fontSize: 19),
            // ),
            SizedBox(height: 5.h),
            // Text(
            //   "LESSON_CANCELATION_POLICY".tr(context),
            //   textAlign: TextAlign.center,
            //   style: AppTextStyles.popupBodyTextStyle,
            // ),
            // SizedBox(height: 8.h),
            Text(
              "CANCELATION_POLICY_3".tr(context),
              textAlign: TextAlign.center,
              style: AppTextStyles.popupBodyTextStyle,
            ),
            SizedBox(height: 20.h),
            MainButton(
              // child: MultiStyleTextFirstPositionBold(
              //   text: "JOIN_AND_PAY_MY_SHARE".trU(context),
              //   fontSize: 18.sp,
              //   color: AppColors.black,
              //   textBoldPosition: 3,
              //   letterSpacing: 1,
              // ),
              isForPopup: true,
              label: "JOIN_AND_PAY_MY_SHARE".trU(context),
              // color: AppColors.rosewood,
              onTap: () {
                Navigator.pop(context, true);
              },
            )
          ],
        ),
      ),
    );
  }
}

class _LessonCoachesListView extends StatelessWidget {
  final LessonsModel lesson;
  final int? maximumCapacity;
  final int? minimumCapacity;
  final Function(int?) onChangeSelectedCoach;

  const _LessonCoachesListView({
    required this.lesson,
    required this.maximumCapacity,
    required this.onChangeSelectedCoach,
    required this.minimumCapacity,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Utils.fetchLessonCoaches(lesson).length > 0
              ? Container(
                  margin: EdgeInsets.only(
                    top: 10.h,
                    left: 15.w,
                    right: 15.w,
                  ),
                  // height: 110.h,
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.05),
                    boxShadow: [kBoxShadow],
                    borderRadius: BorderRadius.circular(10.r),

                    // borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(5.r),bottomStart: Radius.circular(5.r)),
                  ),
                  child: Row(
                    children: List.generate(
                      Utils.fetchLessonCoaches(lesson).length,
                      (index) {
                        final coaches = Utils.fetchLessonCoaches(lesson)[index];
                        final isSelected = lesson.selectedCoach == coaches.id;
                        final profileUrl = coaches.profileUrl ?? '';
                        final fullName =
                            (coaches.fullName ?? '').split(" ").first;
                        return InkWell(
                            onTap: () {
                              onChangeSelectedCoach(coaches.id);
                            },
                            child: Container(
                              // width: 65.w,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.black2
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 5.h),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 8.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  NetworkCircleImage(
                                    path: profileUrl,
                                    width: 40.w,
                                    height: 40.h,
                                    applyShadow: false,
                                    boxBorder: Border.all(
                                        width: 1, color: AppColors.white25),
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                  Text(
                                    "COACH"
                                        .tr(context)
                                        .toLowerCase()
                                        .capitalizeFirst,
                                    style: AppTextStyles.manropeLight(
                                        color: isSelected
                                            ? AppColors.white
                                            : AppColors.black70),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    fullName.toUpperCase(),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.manropeMedium(
                                        fontSize: 13.sp,
                                        color: isSelected
                                            ? AppColors.white
                                            : AppColors.black70,
                                        height: 1),
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
                  ))
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  bool isEnabled(int playersCount) {
    final maxCapacity = maximumCapacity ?? 0;
    final minCapacity = minimumCapacity ?? 0;
    if (maxCapacity == 0) {
      return false;
    }
    if (playersCount >= maxCapacity) {
      return false;
    } else if (playersCount >= minCapacity) {
      return true;
    } else {
      return true;
    }
  }
}
