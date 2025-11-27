part of 'class_detail.dart';

class _EventPlayersSlots extends ConsumerStatefulWidget {
  const _EventPlayersSlots({
    required this.players,
    required this.maxPlayers,
    required this.onSlotTap,
    required this.service,
    required this.id,
    this.isDoubleEvents = false,
    this.onRelease,
  });

  final List<BookingPlayerBase> players;
  final int maxPlayers;
  final Function(int, int?) onSlotTap;
  final bool isDoubleEvents;
  final ServiceDetail service;
  final int id;
  final Function(int)? onRelease;

  @override
  ConsumerState<_EventPlayersSlots> createState() => _EventPlayersSlotsState();
}

class _EventPlayersSlotsState extends ConsumerState<_EventPlayersSlots> {
  late int maxPlayers;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isWellnessSports = widget.service.isWellnessSport;

    if (widget.isDoubleEvents) {
      maxPlayers =
          widget.maxPlayers.isEven ? widget.maxPlayers : widget.maxPlayers - 1;
      return _DoubleEventPlayers(
        id: widget.id,
        service: widget.service,
        players: widget.players,
        onSlotTap: widget.onSlotTap,
        maxPlayers: maxPlayers,
        isWellnessSports: isWellnessSports,
        isWaitingList: false,
        onRelease: widget.onRelease,
        showRelease: widget.onRelease != null,
      );
    }
    maxPlayers = widget.maxPlayers;
    return _SingleEventPlayers(
        maxPlayers: maxPlayers,
        players: widget.players,
        onSlotTap: widget.onSlotTap,
        isWellnessSports: isWellnessSports);
  }
}

class _DoubleEventPlayers extends ConsumerStatefulWidget {
  const _DoubleEventPlayers(
      {required this.service,
      required this.id,
      required this.players,
      required this.isWaitingList,
      required this.onRelease,
      required this.showRelease,
      required this.onSlotTap,
      required this.isWellnessSports,
      required this.maxPlayers});

  final ServiceDetail service;
  final int id;
  final List<BookingPlayerBase> players;
  final Function(int, int?) onSlotTap;
  final int maxPlayers;
  final bool isWellnessSports;

  final bool isWaitingList;
  final bool showRelease;
  final Function(int)? onRelease;

  @override
  ConsumerState<_DoubleEventPlayers> createState() =>
      _DoubleEventPlayersState();
}

class _DoubleEventPlayersState extends ConsumerState<_DoubleEventPlayers> {
  int totalTeams = 0;
  List<BookingPlayerBase?> players = [];

  @override
  Widget build(BuildContext context) {
    final waitingList = ref.watch(fetchServiceWaitingPlayersProvider(
        widget.id, RequestServiceType.event));
    return waitingList.when(
      data: (data) {
        setPlayers();
        return _doubleEvents(data);
      },
      loading: () => const CupertinoActivityIndicator(radius: 10),
      error: (error, stackTrace) => SecondaryText(text: error.toString()),
    );
  }

  setPlayers() {
    players.clear();
    totalTeams = widget.maxPlayers ~/ 2;

    int playersCount = math.min(widget.maxPlayers, widget.players.length);
    players = List.generate(
      widget.maxPlayers,
      (_) => null,
    );
    for (int i = 0; i < playersCount; i++) {
      final player = widget.players[i];
      int? pos = (player.position);
      myPrint("pos $pos");
      int posIndex = (pos ?? (i + 1)) - 1;
      if (posIndex < players.length) {
        players[(pos ?? (i + 1)) - 1] = player;
      }
    }
  }

  _doubleEvents(List<ServiceWaitingPlayers> waitingList) {
    List<Widget> playersW =
        List.generate(widget.maxPlayers, (_) => Container());

    List<int> storeWaitingListIndex = [];

    for (int i = 0; i < waitingList.length; i++) {
      final player = waitingList[i];
      bool showWaitingList = checkShowWaitingList(widget.service);
      bool checkIfPlayerFilledValue = checkIfPlayerFilled(widget.service);
      final pos = (player.position ?? 1) - 1;
      final isCurrentPlayer =
          (player.customer?.id == ref.read(userProvider)?.user?.id);

      bool check = !(checkIfPlayerFilledValue &&
          widget.isWaitingList &&
          (player.status == "waiting_approval" || player.status != "waiting"));
      bool check2 = !(!checkIfPlayerFilledValue &&
          !widget.isWaitingList &&
          (player.status == "pending" || (player.status == "approved")));

      if (check2 && check) {
        continue;
      }
      if (pos >= players.length ||
          (showWaitingList &&
              checkIfPlayerFilledValue &&
              !widget.isWaitingList)) {
        continue;
      }

      bool checkForShowApplicants = true;

      if (widget.isWaitingList && showWaitingList && checkIfPlayerFilledValue) {
        int? playerPosition = waitingList
            .firstWhere(
                (e) => e.customer?.id == ref.read(userProvider)?.user?.id,
                orElse: () => ServiceWaitingPlayers())
            .position;

        if (!isCurrentPlayer) {
          if (playerPosition != null) {
            checkForShowApplicants = pos == playerPosition;
          } else {
            checkForShowApplicants = false;
          }
        }
      }

      if (!checkForShowApplicants) {
        continue;
      }

      storeWaitingListIndex.add(pos);
      playersW[pos] = Expanded(
          flex: 10,
          child: _ApplicantSlotWidget(
            text: "AVAILABLE".trU(context),
            index: pos,
            otherTeamMemberID: player.otherPlayer,
            applicantsCount: getApplicants(waitingList).length,
            currentInWaitingList: isCurrentPlayer,
            backGroundColor:
                !isCurrentPlayer ? AppColors.darkRosewood : Colors.transparent,
            borderColor: !isCurrentPlayer ? AppColors.white : Colors.black,
            iconColor: !isCurrentPlayer ? AppColors.white : Colors.black,
            seeApplicants: () {
              seeApplicants(waitingList);
            },
          ));
    }

    for (int i = 0; i < players.length; i += 2) {
      final firstPlayer = players[i];
      final secondPlayer = players[i + 1];
      Widget? playerLeft = _processTeamsSlot(
        i,
        firstPlayer,
        storeWaitingListIndex,
        otherTeamMemberID: secondPlayer?.id,
      );
      Widget? playerRight = _processTeamsSlot(
        i + 1,
        secondPlayer,
        storeWaitingListIndex,
        otherTeamMemberID: firstPlayer?.id,
      );
      if (playerLeft != null) {
        playersW[i] = playerLeft;
      }
      if (playerRight != null) {
        playersW[i + 1] = playerRight;
      }
    }

    List<List<Widget>> teamRows = List.generate(
      totalTeams,
      (index) {
        return playersW.sublist(index * 2, index * 2 + 2);
      },
    );
    _addNumberToTeams(teamRows);
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: teamRows.length,
      separatorBuilder: (context, index) => SizedBox(height: 15.h),
      itemBuilder: (context, index) {
        return Row(children: teamRows[index]);
      },
    );
  }

  List<ServiceWaitingPlayers> getApplicants(
      List<ServiceWaitingPlayers> waitingList) {
    List<ServiceWaitingPlayers> tempWaitingList = [...waitingList];
    if (widget.isWaitingList) {
      ServiceWaitingPlayers playerPresent = tempWaitingList.firstWhere(
          (e) => e.customer?.id == ref.read(userProvider)?.user?.id,
          orElse: () => ServiceWaitingPlayers());

      if (playerPresent.id == null) {
        return [];
      }

      tempWaitingList.removeWhere(
          (e) => e.position != ((playerPresent.position ?? -2) + 1));

      tempWaitingList.removeWhere((e) =>
          (e.customer?.id == ref.read(userProvider)?.user?.id) ||
          (e.isApproved == true) ||
          (e.isWaiting == true));
    } else {
      tempWaitingList.removeWhere(
          (e) => e.status == "waiting" || e.status == "waiting_approval");
    }
    return tempWaitingList;
  }

  ServiceDetail getTempService(List<ServiceWaitingPlayers> waitingList) {
    ServiceDetail tempService = ServiceDetail.fromJson(widget.service.toJson());
    List<ServiceWaitingPlayers> tempWaitingList = [...waitingList];

    if (widget.isWaitingList) {
      tempWaitingList.removeWhere(
          (e) => e.customer?.id != ref.read(userProvider)?.user?.id);
      tempService.players = tempWaitingList
          .map((e) => ServiceDetail_Players.fromJson(e.toJson()))
          .toList();
    } else {
      (tempService.players ?? []).removeWhere(
          (e) => e.customer?.id != ref.read(userProvider)?.user?.id);
    }

    return tempService;
  }

  Future<void> seeApplicants(List<ServiceWaitingPlayers> waitingList) async {
    ServiceDetail tempService = getTempService(waitingList);
    List<ServiceWaitingPlayers> tempWaitingList = getApplicants(waitingList);

    await showDialog(
      context: context,
      builder: (context) {
        return EventApplicantDialog(
          data: ApplicantSocketResponse(
            serviceBooking: tempService,
            waitingList: tempWaitingList,
          ),
        );
      },
    );
    ref.invalidate(
      fetchServiceWaitingPlayersProvider(widget.id, RequestServiceType.event),
    );
  }

  void _addNumberToTeams(List<List<Widget>> teamRows) {
    for (int i = 0; i < teamRows.length; i++) {
      teamRows[i].insert(0, _count(i));
      teamRows[i].insert(1, const Spacer());
      teamRows[i].insert(0, const Spacer());
    }
  }

  Widget _count(int i) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(100.r)),
        boxShadow: [
          kBoxShadow,
        ],
      ),
      width: 25.h,
      height: 25.h,
      child: Center(
        child: Text(
          "${i + 1}",
          style: AppTextStyles.manropeSemiBold(
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget? _processTeamsSlot(
      int index, BookingPlayerBase? player, List<int> playersW,
      {int? otherTeamMemberID}) {
    if (player != null) {
      return _addParticipantSlotDouble(
        index,
        player,
      );
    } else {
      if (playersW.contains(index)) {
        return null;
      }
      return _addAvailableSlotDouble(
        index,
        otherTeamMemberID: otherTeamMemberID,
      );
    }
  }

  Widget _addAvailableSlotDouble(int index, {int? otherTeamMemberID}) {
    return Expanded(
      flex: 10,
      child: AvailableSlotWidget(
        text: "AVAILABLE".trU(context),
        index: index,
        onTap: widget.onSlotTap,
        isHorizontal: true,
        otherTeamMemberID: otherTeamMemberID,
        borderColor: AppColors.black,
        backgroundColor: Colors.transparent,
        iconColor: AppColors.black,
      ),
    );
  }

  Widget _addParticipantSlotDouble(int index, BookingPlayerBase player) {
    bool showReleaseReserveButton = ((player.reserved ?? false) &&
        widget.showRelease &&
        player.customer?.id == (ref.read(userProvider)?.user?.id ?? -1));

    return Expanded(
      flex: 10,
      child: ParticipantSlot(
        player: player,
        showReleaseReserveButton: showReleaseReserveButton,
        onRelease: widget.onRelease,
        isHorizontal: true,
        isWellnessSports: widget.isWellnessSports,
        imageBgColor: AppColors.black2,
        logoColor: AppColors.white,
      ),
    );
  }
}

class _SingleEventPlayers extends StatelessWidget {
  const _SingleEventPlayers({
    required this.maxPlayers,
    required this.players,
    required this.onSlotTap,
    required this.isWellnessSports,
  });

  final List<BookingPlayerBase> players;
  final Function(int, int?) onSlotTap;
  final int maxPlayers;
  final bool isWellnessSports;

  @override
  Widget build(BuildContext context) {
    final int totalParticipants = players.length;
    final int totalRows = (maxPlayers / 4).ceil();
    int playerIndex = 0;

    List<Widget> rows = [];

    for (int rowIndex = 0; rowIndex < totalRows; rowIndex++) {
      List<Widget> participantsRow = [];

      int limit = math.min(4, maxPlayers - 4 * rowIndex);
      for (int colIndex = 0; colIndex < limit; colIndex++) {
        if (playerIndex < totalParticipants) {
          participantsRow.add(
            ParticipantSlot(
              isWellnessSports: isWellnessSports,
              player: players[playerIndex++],
              imageBgColor: AppColors.blue2,
              logoColor: AppColors.white,
            ),
          );
        } else {
          participantsRow.add(
            AvailableSlotWidget(
              text: "AVAILABLE".trU(context),
              index: colIndex,
              onTap: (index, _) => onSlotTap(index, null),
              backgroundColor: Colors.transparent,
              iconColor: AppColors.black,
              borderColor: AppColors.black,
            ),
          );
        }
      }

      while (participantsRow.length < 4) {
        participantsRow.add(
          Opacity(
            opacity: 0,
            child: AvailableSlotWidget(
              text: "AVAILABLE".tr(context),
              index: -1,
              backgroundColor: AppColors.white,
              iconColor: AppColors.blue,
            ),
          ),
        );
      }

      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: participantsRow,
        ),
      );

      if (rowIndex < totalRows - 1) {
        rows.add(SizedBox(height: 10.h));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}

class _ApplicantSlotWidget extends StatelessWidget {
  const _ApplicantSlotWidget({
    required this.text,
    required this.index,
    this.backGroundColor = AppColors.white,
    this.iconColor = AppColors.blue,
    this.seeApplicants,
    this.borderColor,
    this.otherTeamMemberID,
    required this.applicantsCount,
    required this.currentInWaitingList,
  });

  final String text;
  final Color backGroundColor;
  final Color iconColor;
  final Function()? seeApplicants;
  final int index;
  final int? otherTeamMemberID;
  final int applicantsCount;
  final bool currentInWaitingList;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return _horizontal(context);
  }

  _horizontal(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _circle(),
          SizedBox(width: 15.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _text(),
              SizedBox(height: 2.h),
              if (!currentInWaitingList) ...[
                SecondaryButton(
                  color: AppColors.white,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  onTap: seeApplicants,
                  child: AutoSizeText(
                    "${applicantsCount > 1 ? "SEE_APPLICANTS".tr(context) : "SEE_APPLICANT".tr(context)} ($applicantsCount)",
                    maxFontSize: 10.sp,
                    minFontSize: 2.sp,
                    maxLines: 1,
                    stepGranularity: 1.sp,
                    style: AppTextStyles.manropeMedium(
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ] else ...[
                SecondaryButton(
                  color: AppColors.white,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  borderRadius: 0,
                  child: Text(
                    "YOU_APPLIED".tr(context),
                    style: AppTextStyles.manropeMedium(
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  AutoSizeText _text() {
    return AutoSizeText(
      text,
      textAlign: TextAlign.center,
      maxFontSize: 13.sp,
      minFontSize: 9.sp,
      maxLines: 1,
      stepGranularity: 1.sp,
      style: AppTextStyles.manropeSemiBold(letterSpacing: 14.sp * 0.05),
    );
  }

  Container _circle() {
    return Container(
      height: 37.h,
      width: 37.w,
      decoration: BoxDecoration(
          color: backGroundColor, borderRadius: BorderRadius.circular(10.r)),
      padding: EdgeInsets.all(1.5.w),
      child: DottedBorder(
        borderType: BorderType.RRect,
        dashPattern: const [5, 4],
        radius: Radius.circular(8.r),
        color: borderColor != null ? borderColor! : Colors.black,
        borderPadding: EdgeInsets.all(1.w),
        strokeWidth: 1.5.h,
        child: Container(
          // height: 48.h,
          // width: 37.w,
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            color: iconColor,
            size: 14.h,
          ),
        ),
      ),
    );
  }
}
