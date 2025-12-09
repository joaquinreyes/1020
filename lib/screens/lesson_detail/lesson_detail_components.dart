part of 'lesoon_detail.dart';

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.lesson});

  final ServiceDetail lesson;

  @override
  Widget build(BuildContext context) {
    String? levelRestriction = lesson.service?.event?.levelRestriction;
    final maxPaxValue = lesson.maxPaxValue;
    final bool isLessonVariant = maxPaxValue != null;

    if (isLessonVariant) {
      return _LessonVariantInfoCard(lesson: lesson);
    }

    return Container(
      padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 10.h),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  (lesson.service?.lesson?.lessonName ?? "").toUpperCase(),
                  style: AppTextStyles.sofiaSansMedium(color: AppColors.white, fontSize: 21.sp,),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  (lesson.service?.location?.locationName.trU(context) ?? ""),
                  textAlign: TextAlign.end,
                  style: AppTextStyles.sofiaSansMedium(
                    color: AppColors.white,
                    fontSize: 21.sp,
                  ),
                ),
              ),
            ],
          ),
          CDivider(color: AppColors.white25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _colInfo(
                  lesson.bookingDate.format("EEE dd MMM"),
                  "${lesson.bookingStartTime.format("h:mm")} - ${lesson.bookingEndTime.format("h:mm a")}"
                      .toLowerCase(),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'SLOTS'.trU(context),
                      style: AppTextStyles.sofiaSansMedium(
                        color: AppColors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      "${'MAX'.tr(context)} ${lesson.getMaximumCapacity.toString() ?? ""} ${'PLAYERS'.tr(context)}",
                      style: AppTextStyles.manropeMedium(
                          color: AppColors.white, fontSize: 12.sp),
                    ),
                    Text(
                      "${'MIN'.tr(context)} ${lesson.getMinimumCapacity.toString() ?? ""} ${'PLAYERS'.tr(context)}",
                      style: AppTextStyles.manropeMedium(
                          color: AppColors.white, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _colInfo(
                  levelRestriction != null
                      ? "${"LEVEL".tr(context)} $levelRestriction"
                      : "",
                  "${"PRICE".tr(context)} ${Utils.formatPriceNew(lesson.service?.price)}",
                  isEnd: true,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Column _colInfo(String text1, String text2,
      {bool isEnd = false, TextStyle? textStyle1, TextStyle? textStyle2}) {
    return Column(
      crossAxisAlignment:
          isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          style: textStyle1 ?? AppTextStyles.manropeMedium(color: AppColors.white, fontSize: 13.sp,),
        ),
        SizedBox(height: 2.h),
        Text(
          text2,
          style: textStyle2 ?? AppTextStyles.manropeMedium(color: AppColors.white, fontSize: 13.sp,),
    ),
      ],
    );
  }
}

class _LessonVariantInfoCard extends StatelessWidget {
  const _LessonVariantInfoCard({required this.lesson});

  final ServiceDetail lesson;

  @override
  Widget build(BuildContext context) {
    final coachName =
        (lesson.getCoaches.isNotEmpty ? lesson.getCoaches.first.fullName : "-")
                ?.toUpperCase() ??
            "-";
    final location =
        lesson.service?.location?.locationName.toUpperCase() ?? "-";
    final lessonType =
        lesson.service?.lesson?.lessonName?.capitalizeFirst ?? "Private Lesson";
    final court = lesson.courtName.isNotEmpty ? lesson.courtName : "Court 1";
    final paid = Utils.formatPrice(lesson.service?.price);
    final duration = lesson.duration2 > 0 ? "${lesson.duration2} min" : "-";
    final pax = lesson.getMaximumCapacity > 0
        ? "${lesson.getMaximumCapacity} pax"
        : "-";
    final time =
        "${lesson.bookingStartTime.format("H:mm")} - ${lesson.bookingEndTime.format("H:mm")}";
    final date = lesson.bookingDate.format("EEEE d MMM");

    return Container(
      padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 10.h),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  coachName,
                  style: AppTextStyles.sofiaSansMedium(
                    color: AppColors.white,
                    fontSize: 21.sp,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  location,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.sofiaSansMedium(
                    color: AppColors.white,
                    fontSize: 21.sp,
                  ),
                ),
              ),
            ],
          ),
          CDivider(color: AppColors.white25),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              15.horizontalSpace,
              // Left column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lessonType,
                      style: AppTextStyles.manropeMedium(color: AppColors.white, fontSize: 15.sp,),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      court,
                      style: AppTextStyles.manropeMedium(color: AppColors.white, fontSize: 15.sp,),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Paid $paid",
                      style: AppTextStyles.manropeMedium(color: AppColors.white, fontSize: 15.sp,),
                    ),
                  ],
                ),
              ),
              // Right column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "$duration - $pax",
                      style: AppTextStyles.manropeMedium(color: AppColors.white, fontSize: 15.sp,),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      time,
                      style: AppTextStyles.manropeMedium(color: AppColors.white, fontSize: 15.sp,),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      date,
                      style: AppTextStyles.manropeMedium(color: AppColors.white, fontSize: 15.sp,),
                    ),
                  ],
                ),
              ),
              15.horizontalSpace,
            ],
          ),
        ],
      ),
    );
  }
}

enum _ConfirmationDialogType { join, leave }

class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog({required this.type, this.policy});

  final _ConfirmationDialogType type;
  final CancellationPolicy? policy;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      // closeIconPadding: EdgeInsets.only(right: 6.5.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            type == _ConfirmationDialogType.leave
                ? Text(
                    _headingText(context),
                    style: AppTextStyles.popupHeaderTextStyle,
                    textAlign: TextAlign.center,
                  )
                : Text(
                    _headingText(context),
                    style: AppTextStyles.popupHeaderTextStyle,
                    textAlign: TextAlign.center,
                  ),
            SizedBox(height: 20.h),
            Text(
              type == _ConfirmationDialogType.join
                  ? "LESSON_CANCELATION_POLICY".tr(context)
                  : "IF_YOU_LEAVE_DESC_EVENT".tr(context),
              textAlign: TextAlign.center,
              style: AppTextStyles.popupBodyTextStyle,
            ),
            if (type == _ConfirmationDialogType.leave)
              RefundDescriptionComponent(
                policy: policy,
                text: policy == null ? "LEAVE_POLICY_LESSON".tr(context) : null,
                style: AppTextStyles.popupBodyTextStyle,
              ),
            SizedBox(height: 20.h),
            Flexible(
              child: MainButton(
                isForPopup: true,
                enabled: true,
                label: _buttonText(context),
                applySize: false,
                // padding: EdgeInsets.zero,
                padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 12.h),
                // labelStyle: AppTextStyles.gothicLight().copyWith(fontSize: 18.sp, color: AppColors.mediumGreen),
                // borderRadius: 12.r,
                onTap: () {
                  Navigator.pop(context, true);
                },
                child: Text(_buttonText(context),textAlign: TextAlign.start,style: AppTextStyles.sofiaSansMedium(fontSize: 25.sp,color: AppColors.brick,height: 1),),
              ),
            ),
            // MainButton(
            //   isForPopup: true,
            //   enabled: true,
            //   label: _buttonText(context),
            //   labelStyle: AppTextStyles.gothamNarrowLight()
            //       .copyWith(fontSize: 18.sp, color: AppColors.darkGreen),
            //   // borderRadius: 12.r,
            //   onTap: () {
            //     Navigator.pop(context, true);
            //   },
            // )
          ],
        ),
      ),
    );
  }

  _headingText(BuildContext context) {
    switch (type) {
      case _ConfirmationDialogType.join:
        return "ARE_YOU_SURE_YOU_WANT_TO_JOIN".trU(context);
      case _ConfirmationDialogType.leave:
        return "ARE_YOU_SURE_YOU_WANT_TO_LEAVE".trU(context);
    }
  }

  _buttonText(BuildContext context) {
    switch (type) {
      case _ConfirmationDialogType.join:
        return "JOIN_AND_PAY_MY_SHARE".trU(context);

      case _ConfirmationDialogType.leave:
        return "LEAVE".trU(context);
    }
  }
}

class _LessonPlayersSlots extends StatelessWidget {
  const _LessonPlayersSlots({
    required this.players,
    required this.maxPlayers,
    required this.onSlotTap,
  });

  final List<BookingPlayerBase> players;
  final int maxPlayers;
  final Function(int, int?) onSlotTap;

  @override
  Widget build(BuildContext context) {
    final int totalParticipants = players.length;
    final int totalRows = (maxPlayers / 4).ceil();
    int playerIndex = 0;

    List<Widget> rows = List.generate(totalRows, (rowIndex) {
      List<Widget> participantsRow = List.generate(
        math.min(4, maxPlayers - 4 * rowIndex),
        (colIndex) {
          return playerIndex < totalParticipants
              ? ParticipantSlot(
                  player: players[playerIndex++],
                  imageBgColor: AppColors.blue,
                  logoColor: AppColors.white,
                  showLevel: false,
                )
              : AvailableSlotWidget(
                  text: "AVAILABLE".trU(context),
                  index: colIndex,
                  onTap: (index, __) => onSlotTap(index, null),
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.black,
                  iconColor: AppColors.black,
                  borderColor: AppColors.black,
                );
        },
      );

      while (participantsRow.length < 4) {
        participantsRow.add(
          Opacity(
            opacity: 0,
            child: AvailableSlotWidget(
              text: "AVAILABLE".tr(context),
              index: -1,
            ),
          ),
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: participantsRow,
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int j = 0; j < rows.length; j++) ...[
          rows[j],
          if (j < rows.length - 1) SizedBox(height: 10.h),
        ],
      ],
    );
  }
}
