import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/avaialble_slot_widget.dart';
import 'package:hop/components/participant_slot.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/models/base_classes/booking_player_base.dart';

class OpenMatchParticipantRowWithBG extends StatelessWidget {
  OpenMatchParticipantRowWithBG(
      {super.key,
      required this.textForAvailableSlot,
      this.backgroundColor = AppColors.brick,
      this.players = const [],
      this.onTap,
      this.showReserveReleaseButton = false,
      this.alreadyReserved = false,
      this.allowTap = true,
      this.currentPlayerID = -1,
      this.onRelease,
      this.maxPlayers = 4,
      this.textColor = AppColors.blue,
      Color? slotBackgroundColor,
      this.slotIconColor = AppColors.white,
      this.imageBgColor = AppColors.black2,
      this.imageLogoColor = AppColors.white,
      this.borderRadius})
      : slotBackgroundColor = slotBackgroundColor ?? AppColors.yellow;
  final Color slotBackgroundColor;
  final Color? backgroundColor;
  final Color textColor;
  final List<BookingPlayerBase> players;
  final String textForAvailableSlot;
  final Function(int, int?)? onTap;
  final bool showReserveReleaseButton;
  final bool alreadyReserved;
  final bool allowTap;
  final int currentPlayerID;
  final Function(int)? onRelease;
  final int maxPlayers;
  final Color slotIconColor;
  final Color imageBgColor;
  final Color imageLogoColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        borderRadius:
            borderRadius != null ? borderRadius : BorderRadius.circular(12.r),
        border: border,
        color: backgroundColor,
      ),
      child: OpenMatchParticipantRow(
        textForAvailableSlot: textForAvailableSlot,
        backGroundColor: slotBackgroundColor,
        players: players,
        onTap: onTap,
        allowTap: allowTap,
        showReserveReleaseButton: showReserveReleaseButton,
        alreadyReserved: alreadyReserved,
        currentCustomerID: currentPlayerID,
        onRelease: onRelease,
        maxPlayers: maxPlayers,
        textColor: textColor,
        slotIconColor: slotIconColor,
        imageBgColor: imageBgColor,
        imageLogoColor: imageLogoColor,
      ),
    );
  }
}

class OpenMatchParticipantRow extends StatefulWidget {
  OpenMatchParticipantRow({
    super.key,
    required this.textForAvailableSlot,
    this.players = const [],
    this.onTap,
    this.alreadyReserved = false,
    this.showReserveReleaseButton = false,
    this.currentCustomerID = -1,
    this.onRelease,
    this.allowTap = true,
    this.maxPlayers = 4,
    this.textColor = AppColors.black,
    this.slotIconColor = AppColors.white,
    this.imageBgColor = AppColors.blue2,
    this.imageLogoColor = AppColors.white,
    this.borderColor = AppColors.white,
    Color? backGroundColor,
  }) : slotBackgroundColor = backGroundColor ?? AppColors.yellow;

  final Color slotBackgroundColor;
  final List<BookingPlayerBase> players;
  final String textForAvailableSlot;
  final Function(int, int?)? onTap;
  final bool showReserveReleaseButton;
  final bool alreadyReserved;
  final int currentCustomerID;
  final Function(int)? onRelease;
  final bool allowTap;
  final int maxPlayers;
  final Color textColor;
  final Color slotIconColor;
  final Color imageBgColor;
  final Color imageLogoColor;
  final Color borderColor;

  @override
  State<OpenMatchParticipantRow> createState() =>
      _OpenMatchParticipantRowState();
}

class _OpenMatchParticipantRowState extends State<OpenMatchParticipantRow> {
  List<BookingPlayerBase> teamA = [];
  List<BookingPlayerBase> teamB = [];
  List<Widget> playerWidgets = [];

  int currentPlayerID = -1;

  @override
  void initState() {
    int index = widget.players.indexWhere(
        (element) => element.customer?.id == widget.currentCustomerID);

    if (index != -1) {
      currentPlayerID = widget.players[index].id ?? -1;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showReserveReleaseButton && widget.currentCustomerID == -1) {
      return Container();
    }
    setWidget();
    // for (int i = 0; i < playerWidgets.length; i++) {
    //   final player = playerWidgets[i];
    //   int flex = 1;
    //   if (player is ParticipantSlot) {
    //     if (player.showReleaseReserveButton == true) {
    //       flex = 2;
    //     }
    //   }
    //   playerWidgets[i] = Expanded(
    //     flex: flex,
    //     child: playerWidgets[i],
    //   );
    // }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: playerWidgets,
    );
  }

  SizedBox _buildVsWidget() {
    return SizedBox(
      height: 81.h,
      child: Column(
        children: [
          const Spacer(),
          AutoSizeText(
            'V/S',
            maxFontSize: 16.sp,
            minFontSize: 8.sp,
            maxLines: 1,
            stepGranularity: 1.sp,
            textAlign: TextAlign.center,
            style: AppTextStyles.sofiaSansMedium(
              color: widget.textColor,
              fontSize: 16.sp,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  setWidget() {
    playerWidgets = [];
    for (int i = 0; i < widget.maxPlayers; i++) {
      playerWidgets.add(
        AvailableSlotWidget(
          index: i,
          otherTeamMemberID: null,
          text: widget.textForAvailableSlot,
          backgroundColor: widget.slotBackgroundColor,
          onTap: widget.onTap,
          textColor: widget.textColor,
          iconColor: widget.slotIconColor,
          borderColor: widget.borderColor,
        ),
      );
    }

    List<BookingPlayerBase> playersWithoutPosition = [];
    _setPlayers(playersWithoutPosition);

    _setPlayersWithoutPos(playersWithoutPosition);

    if (widget.maxPlayers > 2) {
      playerWidgets.insert(2, _buildVsWidget());
    }
  }

  void _setPlayersWithoutPos(List<BookingPlayerBase> playersWithoutPosition) {
    for (final player in playersWithoutPosition) {
      final nextAvailablePosition = findNextAvailablePosition();
      if (nextAvailablePosition != -1) {
        bool showReleaseReserveButton = ((((player.reserved ?? false) &&
                        player.customer?.id == widget.currentCustomerID)) ||
                    widget.alreadyReserved
                ? player.customer?.id != widget.currentCustomerID
                : false) &&
            widget.showReserveReleaseButton;
        playerWidgets[nextAvailablePosition] = ParticipantSlot(
          player: player,
          onRelease: widget.onRelease,
          allowTap: widget.allowTap,
          showReleaseReserveButton: showReleaseReserveButton,
          textColor: widget.textColor,
          imageBgColor: widget.imageBgColor,
          logoColor: widget.imageLogoColor,
        );
      }
    }
  }

  void _setPlayers(List<BookingPlayerBase> playersWithoutPosition) {
    for (int i = 0;
        i < math.min(widget.players.length, widget.maxPlayers);
        i++) {
      final player = widget.players[i];
      final position = widget.players[i].position;
      if (position == null || position > widget.maxPlayers) {
        player.position = null;
        playersWithoutPosition.add(player);
      } else {
        bool showReleaseReserveButton = ((((player.reserved ?? false) &&
                        player.customer?.id == widget.currentCustomerID)) ||
                    widget.alreadyReserved
                ? player.customer?.id != widget.currentCustomerID
                : false) &&
            widget.showReserveReleaseButton;
        if (!(player.isCanceled ?? false)) {
          playerWidgets[position - 1] = ParticipantSlot(
            player: player,
            onRelease: widget.onRelease,
            allowTap: widget.allowTap,
            showReleaseReserveButton: showReleaseReserveButton,
            textColor: widget.textColor,
            imageBgColor: widget.imageBgColor,
            logoColor: widget.imageLogoColor,
          );
        }
      }
    }
  }

  findNextAvailablePosition() {
    for (int i = 0; i < widget.maxPlayers; i++) {
      if (playerWidgets[i] is AvailableSlotWidget) {
        return i;
      }
    }
    return -1;
  }

  setTeamA() {
    teamA = [];
    if (widget.players.isEmpty) return;
    final player = widget.players.first;
    teamA.add(player);
    final otherPlayerID = player.otherPlayer;
    if (otherPlayerID == null) return;
    final otherPlayerIndex =
        widget.players.indexWhere((element) => element.id == otherPlayerID);
    if (otherPlayerIndex == -1) return;
    teamA.add(widget.players[otherPlayerIndex]);
  }

  setTeamB() {
    teamB = [];
    final playersWithoutTeamA =
        widget.players.where((element) => !teamA.contains(element)).toList();
    if (playersWithoutTeamA.isEmpty) return;
    final player = playersWithoutTeamA.first;
    teamB.add(player);
    final otherPlayerID = player.otherPlayer;
    if (otherPlayerID == null) return;
    final otherPlayerIndex = playersWithoutTeamA
        .indexWhere((element) => element.id == otherPlayerID);
    if (otherPlayerIndex == -1) return;
    teamB.add(player);
    teamB.add(playersWithoutTeamA[otherPlayerIndex]);
  }
}
