part of 'event_detail.dart';

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.event,
  });

  final ServiceDetail event;

  @override
  Widget build(BuildContext context) {
    String? levelRestriction = event.service?.event?.levelRestriction;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 15.h,
      ),
      decoration: BoxDecoration(
          border: border,
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
                  (event.service?.event?.eventName ?? "").capitalizeFirst,
                  style: AppTextStyles.manropeSemiBold(
                    color: AppColors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  // (event.courtName).toUpperCase(),
                  (event.service?.location?.locationName ?? "").toUpperCase(),
                  textAlign: TextAlign.end,
                  style: AppTextStyles.sofiaSansMedium(
                    color: AppColors.white,
                    fontSize: 19.sp,
                  ),
                ),
              ),
            ],
          ),
          CDivider(color: AppColors.white25),
          // SizedBox(
          //   height: 5.h,
          // ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _colInfo(
                  event.bookingDate.format("EEE dd MMM"),
                  "${event.bookingStartTime.format("HH:mm")} - ${event.bookingEndTime.format("HH:mm a")}"
                      .toLowerCase(),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'SLOTS'.trU(context),
                      style: AppTextStyles.sofiaSansMedium(
                        color: AppColors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      "${'MAX'.tr(context)} ${event.getMaximumCapacity.toString()} ${(event.isWellnessSport ? 'PARTICIPANTS' : 'PLAYERS').tr(context)}",
                      style: AppTextStyles.manropeMedium(
                          color: AppColors.white, fontSize: 12.sp),
                    ),
                    Text(
                        "${'MIN'.tr(context)} ${event.getMinimumCapacity.toString()} ${(event.isWellnessSport ? 'PARTICIPANTS' : 'PLAYERS').tr(context)}",
                        style: AppTextStyles.manropeMedium(
                            color: AppColors.white, fontSize: 12.sp),),
                  ],
                ),
              ),
              Expanded(
                child: _colInfo(
                  levelRestriction != null
                      ? "${"LEVEL".tr(context)} $levelRestriction"
                      : "",
                  "${"PRICE".tr(context)} ${Utils.formatPrice(event.service?.price)}",
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
          style: textStyle1 ??
              AppTextStyles.manropeMedium(
                  color: AppColors.white, fontSize: 13.sp),
        ),
        SizedBox(height: 2.h),
        Text(
          text2,
          style: textStyle2 ??
              AppTextStyles.manropeMedium(
                  color: AppColors.white, fontSize: 13.sp),
        ),
      ],
    );
  }
}

enum _ConfirmationDialogType {
  join,
  leave,
  joinWaitingLit,
  approvePlayer,
  applyForApproval,
  withdraw,
  reserve,
  releaseReserve,
}

class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog({required this.type, this.policy});

  final _ConfirmationDialogType type;
  final CancellationPolicy? policy;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      // contentPadding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
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
          if (type != _ConfirmationDialogType.withdraw) ...[
            SizedBox(height: 5.h),
            Text(
              _descText(context),
              textAlign: TextAlign.center,
              style: AppTextStyles.popupBodyTextStyle,
            ),
          ],
          if (type == _ConfirmationDialogType.leave)
            RefundDescriptionComponent(
                policy: policy,
                text: policy == null ? "LEAVE_POLICY_EVENT".tr(context) : null,
                style: AppTextStyles.popupBodyTextStyle),
          SizedBox(height: 20.h),
          MainButton(
            label: _buttonText(context),
            isForPopup: true,
            // color: AppColors.rosewood,
            onTap: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    );
  }

  _headingText(BuildContext context) {
    switch (type) {
      case _ConfirmationDialogType.join:
        return "ARE_YOU_SURE_YOU_WANT_TO_JOIN".trU(context);
      case _ConfirmationDialogType.leave:
        return "ARE_YOU_SURE_YOU_WANT_TO_LEAVE".trU(context);
      case _ConfirmationDialogType.joinWaitingLit:
        return "ARE_YOU_SURE_YOU_WANT_TO_JOIN_THE_WAITING_LIST".trU(context);
      case _ConfirmationDialogType.approvePlayer:
        return "ARE_YOU_SURE_YOU_WANT_TO_APPROVE_THIS_PLAYER".trU(context);
      case _ConfirmationDialogType.applyForApproval:
        return "WILL_REQUIRE_APPROVAL".trU(context);
      case _ConfirmationDialogType.reserve:
        return "ARE_YOU_SURE_YOU_WANT_TO_RESERVE_THIS_SPOT".trU(context);
      case _ConfirmationDialogType.releaseReserve:
        return "ARE_YOU_SURE_YOU_WANT_TO_RELEASE_THIS_RESERVED_SPOT"
            .trU(context);
      case _ConfirmationDialogType.withdraw:
        return "ARE_YOU_SURE_YOU_WANT_TO_WITHDRAW_FROM_THE_MATCH".trU(context);
    }
  }

  _descText(BuildContext context) {
    switch (type) {
      case _ConfirmationDialogType.join:
        return "IF_YOU_JOIN_DESC_EVENT".tr(context);
      case _ConfirmationDialogType.leave:
        return "IF_YOU_LEAVE_DESC_EVENT".tr(context);
      case _ConfirmationDialogType.joinWaitingLit:
        return "IF_YOU_JOIN_DESC_WAITING_LIST".tr(context);
      case _ConfirmationDialogType.releaseReserve:
      case _ConfirmationDialogType.approvePlayer:
        return "THIS_ACTION_CANNOT_BE_UNDONE".tr(context);
      case _ConfirmationDialogType.applyForApproval:
        return "WILL_REQUIRE_APPROVAL_DESC".tr(context);
      case _ConfirmationDialogType.reserve:
        return "YOU_WONT_BE_ABLE_TO_EDIT_THIS_LATER".tr(context);
      case _ConfirmationDialogType.withdraw:
        return "";
    }
  }

  _buttonText(BuildContext context) {
    switch (type) {
      case _ConfirmationDialogType.join:
        return "JOIN_PAY_MY_SHARE".trU(context);

      case _ConfirmationDialogType.leave:
        return "LEAVE".trU(context);
      case _ConfirmationDialogType.joinWaitingLit:
        return "JOIN_WAITING_LIST".trU(context);
      case _ConfirmationDialogType.approvePlayer:
        return "APPROVE_PLAYER".trU(context);
      case _ConfirmationDialogType.applyForApproval:
        return "APPLY_TO_TEAM".trU(context);
      case _ConfirmationDialogType.withdraw:
        return "YES_WITHDRAW".trU(context);
      case _ConfirmationDialogType.releaseReserve:
        return "RELEASE_THIS_SPOT".trU(context);
      case _ConfirmationDialogType.reserve:
        return "RESERVE_PAY_SLOT".trU(context);
    }
  }
}

class _WaitingPlayersSlots extends ConsumerStatefulWidget {
  const _WaitingPlayersSlots({
    required this.players,
    required this.maxPlayers,
    required this.onSlotTap,
    required this.service,
    required this.isDoubleEvents,
    required this.isInWaitingList,
    required this.id,
    required this.onWithdraw,
  });

  final List<BookingPlayerBase> players;
  final int maxPlayers;
  final Function(int, int?) onSlotTap;
  final Function onWithdraw;

  final bool isDoubleEvents;
  final ServiceDetail service;
  final int id;
  final bool isInWaitingList;

  @override
  ConsumerState<_WaitingPlayersSlots> createState() =>
      _WaitingPlayersSlotsState();
}

class _WaitingPlayersSlotsState extends ConsumerState<_WaitingPlayersSlots> {
  @override
  Widget build(BuildContext context) {
    int maxPlayers = widget.isDoubleEvents
        ? (widget.maxPlayers.isEven ? widget.maxPlayers : widget.maxPlayers - 1)
        : widget.maxPlayers;
    bool showWaitingList = checkShowWaitingList(widget.service);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // const Icon(Icons.info_outline, color: AppColors.black, size: 22),
            Image.asset(
              AppImages.infoIcon.path,
              width: 12.h,
              height: 12.h,
              color: AppColors.black,
            ),
            SizedBox(width: 10.w),
            Text(
              "WAITING_LIST".trU(context),
              style: AppTextStyles.sofiaSansMedium(
                fontSize: 23.sp,
              ),
            )
          ],
        ),
        SizedBox(height: 6.h),
        showWaitingList
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    // border: border,
                    color: AppColors.black5,
                ),
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, (widget.isDoubleEvents ?? false) ? 15.h : 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    widget.isDoubleEvents
                        ? _DoubleEventPlayers(
                            id: widget.id,
                            service: widget.service,
                            players: widget.players,
                            onSlotTap: widget.onSlotTap,
                            maxPlayers: maxPlayers,
                            isWellnessSports: widget.service.isWellnessSport,
                            isWaitingList: true,
                            onRelease: null,
                            showRelease: false,
                          )
                        : _SingleEventPlayers(
                            service: widget.service,
                            maxPlayers: maxPlayers - 2,
                            players: widget.players,
                            onSlotTap: widget.onSlotTap,
                            isWellnessSports: widget.service.isWellnessSport,
                          )
                  ],
                ))
            : Padding(
                padding: EdgeInsets.only(top: 0, left: 12.w),
                child: Text("THERE_IS_NO_WAITING_LIST".tr(context),
                    style: AppTextStyles.manropeMedium(
                      color: AppColors.black2,
                      fontSize: 13.sp,
                    )),
              ),
        SizedBox(height: 10.h),
        if (showWaitingList)
          Align(
            alignment: Alignment.centerRight,
            child:
                Text("${"WAITING_LIST".tr(context)} ${widget.players.length}",
                    style: AppTextStyles.manropeMedium(
                      color: AppColors.black2,
                    )),
          ),
        SizedBox(height: 10.h),
        if (showWaitingList && widget.isInWaitingList)
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: SecondaryImageButton(
              label: "LEAVE_WAITING_LIST".tr(context),
              image: AppImages.crossIcon.path,
              imageHeight: 10.w,
              imageWidth: 10.w,
              onTap: () {
                widget.onWithdraw();
              },
            ),
          )
      ],
    );
  }
}

bool checkIfPlayerFilled(ServiceDetail service) {
  var servicePlayers = [...(service.players ?? [])];
  servicePlayers
      .removeWhere((e) => (e.isCanceled ?? false) || (e.isWaiting ?? false));

  int maxCount = service.getMaximumCapacity;

  return (service.service?.isDoubleEvent ?? false)
      ? (servicePlayers.length >= (maxCount))
      : (servicePlayers.length == maxCount);
}

bool checkShowWaitingList(ServiceDetail service) {
  return service.service?.event?.waitingList ?? true;
}
