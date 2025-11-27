part of 'open_match_detail.dart';

class _RankedOrFriendly extends StatelessWidget {
  const _RankedOrFriendly({
    this.isRanked = true,
  });

  final bool isRanked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: inset.BoxDecoration(
        boxShadow: kInsetShadow,
        color: AppColors.black5,
        borderRadius: BorderRadius.circular(100.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
      child: Row(
        children: [
          _buildWidget("FRIENDLY".tr(context), !isRanked),
          2.horizontalSpace,
          _buildWidget("RANKED".tr(context), isRanked),
        ],
      ),
    );
  }

  _buildWidget(String text, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(100.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
      child: Text(
        text,
        style: isSelected
            ? AppTextStyles.manropeSemiBold(
                fontSize: 13.sp,
                color: AppColors.white,
              )
            : AppTextStyles.manropeMedium(
                color: AppColors.black70,
                fontSize: 13.sp,
              ),
      ),
    );
  }
}

class _OrganizerNote extends StatelessWidget {
  const _OrganizerNote({
    required this.note,
  });

  final String note;

  @override
  Widget build(BuildContext context) {
    if (note.isEmpty) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          "NOTE_FROM_ORGANIZER".trU(context),
          style: AppTextStyles.sofiaSansMedium(
              fontSize: 23.sp,),
        ),
        SizedBox(height: 10.h),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: border,
            color: AppColors.black5,
            borderRadius: BorderRadius.circular(100.r)
          ),
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
          child: Text(
            note,
            style: AppTextStyles.manropeMedium(
                fontSize: 13.sp,),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends ConsumerWidget {
  const _InfoCard({required this.service});

  final ServiceDetail service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String level = service.openMatchLevelRange;
    if (level.isNotEmpty) {
      level = "${"LEVEL".tr(context)} $level |";
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        vertical: 15.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.blue,
        border: border,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ORGANIZER'.trU(context),
                style: AppTextStyles.sofiaSansMedium(
                    color: AppColors.white, fontSize: 21.sp),
              ),
              const Spacer(),
              Text(
                'BOOKING'.trU(context),
                style: AppTextStyles.sofiaSansMedium(
                    color: AppColors.white, fontSize: 21.sp),
              ),
              if (service.isPrivate)
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: AppColors.yellow),
                  padding: EdgeInsets.all(2.h),
                  margin: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.lock,
                    size: 16,
                    color: AppColors.brick,
                  ),
                )
            ],
          ),
          CDivider(color: AppColors.white25),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: _organizer(context, service.organizer, ref),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    // "${DateFormat("EEE dd MMM").format(booking.startingTime ?? (DubaiDateTime.now().dateTime))} • ${DateFormat(DateFormat.HOUR_MINUTE).format(booking.startingTime ?? (DubaiDateTime.now().dateTime))} - ${DateFormat(DateFormat.HOUR_MINUTE).format((booking.endingTime ?? (DubaiDateTime.now().dateTime)))}",
                    service.formattedDateStartEndTimeAM12,
                    style: AppTextStyles.manropeMedium(
                      color: AppColors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "${service.courts?.first.courtName ?? ""} | ${service.service?.location?.locationName ?? ""}"
                        .capitalizeFirst,
                    style: AppTextStyles.manropeMedium(
                      color: AppColors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "$level Price ${Utils.formatPrice(service.pricePaid(ref))}",
                    style: AppTextStyles.manropeMedium(
                      color: AppColors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
              // SizedBox(width: 15.h),
            ],
          ),
        ],
      ),
    );
  }

  Widget _organizer(
      BuildContext context, ServiceDetail_Players? organizer, WidgetRef ref) {
    if (organizer == null) {
      return SizedBox(
        child: Text(
          "NO_ORGANIZER".tr(context),
          textAlign: TextAlign.center,
          style: AppTextStyles.manropeMedium(
              color: AppColors.white, fontSize: 15.sp),
        ),
      );
    }
    String level =
        organizer.customer?.level(getSportsName(ref)).toString() ?? "N/A";
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: NetworkCircleImage(
            // path: participant?.imgUrl,
            path: organizer.customer?.profileUrl,
            width: 37.h,
            height: 37.h,
            bgColor: AppColors.white,
            logoColor: AppColors.brick,
            boxBorder: Border.all(color: AppColors.white25),
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          organizer.getCustomerName.toUpperCase(),
          textAlign: TextAlign.center,
          style: AppTextStyles.sofiaSansMedium(
            color: AppColors.white,
            fontSize: 15.sp,
          ),
        ),
        Text(
          "$level ${getRankLabel(double.tryParse(level) ?? 0)}", // • SIDE",
          textAlign: TextAlign.center,
          style: AppTextStyles.manropeMedium(
            color: AppColors.white,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}

class _WaitingList extends ConsumerStatefulWidget {
  const _WaitingList(
      {required this.id,
      required this.onApprove,
      required this.onJoinAfterApproval,
      required this.onWithdraw,
      required this.isCurrentOrganizer,this.refreshApis});

  final int id;
  final Function(int) onApprove;
  final Function? refreshApis;
  final Function(int) onJoinAfterApproval;
  final Function(int) onWithdraw;
  final bool isCurrentOrganizer;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __WaitingListState();
}

class __WaitingListState extends ConsumerState<_WaitingList> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(fetchServiceWaitingPlayersProvider(
        widget.id, RequestServiceType.booking));
    return provider.when(
      skipLoadingOnRefresh: false,
      data: (list) {
        final data = list.map((e) => e).toList();
        if (widget.isCurrentOrganizer) {
          // data.removeWhere((element) => element.isApproved);
        } else {
          final currentID = ref.read(userProvider)?.user?.id;
          data.removeWhere((element) => element.customer?.id != currentID);
        }
        if (data.isEmpty) {
          return SizedBox();
        }
        if (!widget.isCurrentOrganizer) {
          return WaitingListApprovalStatus(
            serviceBookingId: widget.id,
            data: data.first,
            onJoin: widget.onJoinAfterApproval,
            onWithdraw: widget.onWithdraw,
            refreshApis: widget.refreshApis,
            isForEvent: false,
          );
        }
        return OpenMatchWaitingForApprovalPlayers(
          data: data,
          onApprove: widget.onApprove,
        );
      },
      error: (error, stackTrace) {
        return SecondaryText(text: error.toString());
      },
      loading: () => const Center(
        child: CupertinoActivityIndicator(radius: 5),
      ),
    );
  }
}
