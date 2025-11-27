part of 'enter_match_result.dart';

class _MatchResultForms extends ConsumerStatefulWidget {
  const _MatchResultForms({required this.service});

  final ServiceDetail service;

  @override
  ConsumerState<_MatchResultForms> createState() => _MatchResultFormsState();
}

class _MatchResultFormsState extends ConsumerState<_MatchResultForms> {
  @override
  Widget build(BuildContext context) {
    final players = ref.watch(_sortedPlayersProvider);
    if (players.isEmpty) {
      return const SizedBox();
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: AppColors.white25,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.service.formatBookingDate,
                style: AppTextStyles.manropeSemiBold(
                  fontSize: 16.sp,
                  color: AppColors.white,
                ),
              ),
              Text(
                widget.service.openMatchLevelRange ?? '',
                style: AppTextStyles.manropeMedium(
                  fontSize: 15.sp,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          // SizedBox(height: 5.h),
          CDivider(color: AppColors.white.withOpacity(0.10)),
          SizedBox(height: 5.h),
          _drawButton(),
          // SizedBox(height: 10.h),
          if (players.length > 1)
            _SingleResultForm(
              players: [players.first, players[1]],
              isTeamA: true,
            ),
          SizedBox(height: 7.h),
          const _SwapRow(),
          SizedBox(height: 7.h),
          if (players.length > 3)
            _SingleResultForm(
              players: [players[2], players[3]],
              isTeamA: false,
            ),
        ],
      ),
    );
  }

  Widget _drawButton() {
    return SizedBox();
    final isDraw = ref.watch(_isDrawProvider);
    return Align(
      alignment: Alignment.centerRight,
      child: SecondaryButton(
        borderRadius: 100.r,
        color: isDraw ? AppColors.yellow : AppColors.white,
        applyShadow: true,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
        onTap: () {
          ref.invalidate(_teamAScoreProvider);
          ref.invalidate(_teamBScoreProvider);
          ref.read(_isDrawProvider.notifier).state = !isDraw;
        },
        child: Text(
          "DRAW".tr(context),
          style: isDraw
              ? AppTextStyles.manropeSemiBold(
                  fontSize: 13.sp,
                  color: AppColors.brick,
                ).copyWith(height: 1)
              : AppTextStyles.manropeMedium(
                  fontSize: 13.sp,
                  color: AppColors.brick,
                  height: 1,
                ),
        ),
      ),
    );
  }
}

class _SingleResultForm extends ConsumerWidget {
  const _SingleResultForm({required this.players, required this.isTeamA});

  final List<ServiceDetail_Players> players;
  final bool isTeamA;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDraw = ref.watch(_isDrawProvider.notifier).state;
    final isAWinner = ref.watch(isTeamAWinner);
    final isBWinner = ref.watch(isTeamBWinner);

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              ParticipantSlot(
                textColor: AppColors.white,
                player: players[0],
                showLevel: false,
                logoColor: AppColors.brick,
                imageBgColor: AppColors.white,
              ),
              ParticipantSlot(
                textColor: AppColors.white,
                player: players[1],
                imageBgColor: AppColors.white,
                logoColor: AppColors.brick,
                showLevel: false,
              ),
            ],
          ),
        ),
        Expanded(
          child: _ScoreInput(
            scores: isTeamA ? ref.read(_teamAScoreProvider) : ref.read(_teamBScoreProvider),
            index: isTeamA ? 0 : 1,
            isDraw: isDraw,
            onChanged: (value) {
              int? a = int.tryParse(value[0]);
              int? b = int.tryParse(value[1]);
              int? c = int.tryParse(value[2]);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (isTeamA) {
                  ref.read(_teamAScoreProvider.notifier).state = [a, b, c];
                } else {
                  ref.read(_teamBScoreProvider.notifier).state = [a, b, c];
                }
                _setIfDraw(ref);
              });
            },
            isWinner: isTeamA ? isAWinner : isBWinner,
          ),
        ),
      ],
    );
  }

  _drawWidget(BuildContext context) {
    return SizedBox();
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Center(
        child: Text(
          "DRAW".trU(context),
          style: AppTextStyles.sofiaSansMedium(
            color: AppColors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}

class _RankOtherPlayers extends ConsumerWidget {
  const _RankOtherPlayers();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(_otherNonReservedPlayersProvider);
    final assessmentModel = ref.watch(_assesmentReqModelProvider);
    if (players.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Text(
          "RANK_THE_OTHER_PLAYERS".trU(context),
          style: AppTextStyles.sofiaSansMedium(fontSize: 21.sp,color: AppColors.white),
        ),
        SizedBox(height: 10.h),
        for (var i = 0; i < players.length; i++) ...[
          Row(
            children: [
              ParticipantSlot(
                player: players[i],
                textColor: AppColors.white,
                imageBgColor: AppColors.white,
                logoColor: AppColors.brick,
              ),
              SizedBox(width: 20.w),
              _RankingLevelSelector(
                player: players[i],
                selectedLevel: assessmentModel.assessments[players[i].id.toString()] ?? 0,
                onChanged: (value) {
                  final model = ref.read(_assesmentReqModelProvider);
                  model.assessments[players[i].id.toString()] = value;
                  ref.invalidate(_assesmentReqModelProvider);
                  ref.read(_assesmentReqModelProvider.notifier).state = model;
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _RankingLevelSelector extends StatefulWidget {
  const _RankingLevelSelector({
    required this.player,
    required this.selectedLevel,
    required this.onChanged,
  });

  final ServiceDetail_Players player;
  final double selectedLevel;
  final Function(double) onChanged;

  @override
  State<_RankingLevelSelector> createState() => _RankingLevelSelectorState();
}

class _RankingLevelSelectorState extends State<_RankingLevelSelector> {
  // bool _isOpen = false;
  List<double> levelList = [];

  @override
  void initState() {
    final playerLevel = widget.player.customer?.levelD("padel") ?? 0;

    if (playerLevel - 0.5 >= 0) {
      levelList.add(playerLevel - 0.5);
    }
    levelList.add(playerLevel);
    if (playerLevel + 0.5 <= 7.0) {
      levelList.add(playerLevel + 0.5);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "SELECT_PLAYER_LEVEL".tr(context),
          style: AppTextStyles.manropeMedium(fontSize: 15.sp,color: AppColors.white,),
        ),
        SizedBox(height: 5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: BoxDecoration(
            color: AppColors.white25,
            borderRadius: BorderRadius.circular(100.r),
            // boxShadow: const [
            //   BoxShadow(
            //     color: Color(0x11000000),
            //     blurRadius: 4,
            //     offset: Offset(0, 4),
            //     spreadRadius: 0,
            //   ),
            // ],
          ),
          child: Row(
            children: levelList.map((e) {
              bool isSelected = widget.selectedLevel == e;
              return Expanded(
                child: InkWell(
                  onTap: () {
                    widget.onChanged(e);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 7.5.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                      // boxShadow: isSelected
                      //     ? const [
                      //         BoxShadow(
                      //           color: Color(0x11000000),
                      //           blurRadius: 4,
                      //           offset: Offset(0, 4),
                      //           spreadRadius: 0,
                      //         ),
                      //       ]
                      //     : null,
                    ),
                    child: Center(
                      child: Text(
                        e.toStringAsFixed(2),
                        style: isSelected
                            ? AppTextStyles.manropeSemiBold(
                                fontSize: 13.sp,
                          color: AppColors.brick,
                              ).copyWith(height: 1)
                            : AppTextStyles.manropeMedium(
                                fontSize: 13.sp,
                                color: AppColors.white,
                          height: 1,
                              ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    ));
  }
}

class _ScoreInput extends StatelessWidget {
  const _ScoreInput({
    required this.isWinner,
    required this.onChanged,
    required this.index,
    required this.isDraw,
    this.scores,
  });

  final bool isWinner;
  final bool isDraw;
  final Function(List<String>) onChanged;
  final int index;
  final List<int?>? scores;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.only(bottom: 10, top: 4),
      decoration: BoxDecoration(
        color: isDraw
            ? AppColors.yellow
            : isWinner
                ? AppColors.yellow
                : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          if (isWinner || isDraw)
            Text(
              (isDraw ? "DRAW" : "WINNERS").trU(context),
              style: AppTextStyles.sofiaSansMedium(
                fontSize: 18.sp,
                color: AppColors.brick,
              ),
            ),
          CustomNumberInput(
            onChanged: onChanged,
            color: isDraw || isWinner ? AppColors.brick : AppColors.white,
            index: index,
            initialScore: scores,
          ),
        ],
      ),
    );
  }
}

class _SwapRow extends StatelessWidget {
  const _SwapRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(flex: 3),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const _SwapDialog(),
            );
          },
          child: Container(
            padding: EdgeInsets.all(4.5.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Center(
              child: Image.asset(
                AppImages.refresh.path,
                width: 13.w,
                height: 13.w,
                color: AppColors.brick,
              ),
            ),
          ),
        ),
        const Spacer(flex: 7),
        Text(
          "V/S",
          style: AppTextStyles.sofiaSansMedium(
            fontSize: 16.sp,
            color: AppColors.white,
          ),
        ),
        const Spacer(flex: 3),
      ],
    );
  }
}

class _SwapDialog extends ConsumerStatefulWidget {
  const _SwapDialog();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __SwapDialogState();
}

class __SwapDialogState extends ConsumerState<_SwapDialog> {
  @override
  Widget build(BuildContext context) {
    final players = ref.watch(_otherPlayersProvider);
    return CustomDialog(
        child: Column(
      children: [
        Text(
          "WHO_DID_YOU_PLAY_WITH".trU(context),
          style: AppTextStyles.popupHeaderTextStyle,
        ),
        SizedBox(height: 5.h),
        Text(
          "CLICK_ON_THE_PLAYER_THAT_WAS_ON_YOUR_TEAM".tr(context),
          style: AppTextStyles.popupBodyTextStyle,
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            for (var i = 0; i < players.length; i++)
              Expanded(
                child: InkWell(
                  onTap: () {
                    onTap(players[i].id!);
                  },
                  child: ParticipantSlot(
                    logoColor: AppColors.brick,
                    imageBgColor: AppColors.white,
                    player: players[i],
                    showLevel: false,
                    allowTap: false,
                    textColor: AppColors.white,
                  ),
                ),
              ),
          ],
        )
      ],
    ));
  }

  onTap(int playerId) {
    final players = ref.read(_sortedPlayersProvider);
    final assesmentModel = ref.read(_assesmentReqModelProvider);
    final myPlayerID = ref.read(currentPlayerID);
    final positions = assesmentModel.positions;
    final oldPOS = positions[playerId.toString()]!;
    final myPOS = positions[myPlayerID.toString()]!;
    int newPOS;
    if (myPOS.isEven) {
      newPOS = myPOS - 1;
    } else {
      newPOS = myPOS + 1;
    }
    final personAtNewPos = positions.entries.firstWhere((element) => element.value == newPOS).key;

    positions[playerId.toString()] = newPOS;
    positions[personAtNewPos.toString()] = oldPOS;
    assesmentModel.positions = positions;
    ref.invalidate(_assesmentReqModelProvider);
    ref.read(_assesmentReqModelProvider.notifier).state = assesmentModel;
    // sort the players according to the new positions
    final sortedPlayers = players.toList()..sort((a, b) => positions[a.id.toString()]!.compareTo(positions[b.id.toString()]!));
    ref.invalidate(_sortedPlayersProvider);
    ref.read(_sortedPlayersProvider.notifier).state = sortedPlayers;

    Navigator.of(context).pop();
  }
}
