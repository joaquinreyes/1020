import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/c_divider.dart';
import 'package:hop/components/changes_cancelled_details_card.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/components/network_circle_image.dart';
import 'package:hop/components/open_match_participant_row.dart';
import 'package:hop/components/open_match_waiting_for_approval_players.dart';
import 'package:hop/components/secondary_button.dart';
import 'package:hop/components/secondary_text.dart';
import 'package:hop/components/waiting_list_approval_status.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/managers/user_manager.dart';
import 'package:hop/models/base_classes/booking_player_base.dart';
import 'package:hop/models/service_detail_model.dart';
import 'package:hop/repository/booking_repo.dart';
import 'package:hop/repository/payment_repo.dart';
import 'package:hop/repository/play_repo.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:hop/screens/payment_information/payment_information.dart';
import 'package:hop/screens/responsive_widgets/home_responsive_widget.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/widgets/background_view.dart';

import '../../components/refund_description_component.dart';
import '../../components/secondary_textfield.dart';
import '../../managers/chat_socket_manager/chat_socket_manager.dart';
import '../../models/cancellation_policy_model.dart';
import '../../models/follow_list.dart';
import '../../models/service_waiting_players.dart';
import '../../repository/assessment_res_model.dart';
import '../../repository/user_repo.dart';
import '../../routes/app_routes.dart';
import '../../utils/dubai_date_time.dart';
import '../../utils/debouncer.dart';
import '../../models/app_user.dart';
import 'dupr_ranked_component.dart';
import 'match_result_dialog/enter_match_result.dart';
import 'package:hop/box_shadow/flutter_inset_box_shadow.dart' as inset;


part 'open_match_components.dart';

part 'open_match_dialogs.dart';

part 'open_match_provider.dart';

class OpenMatchDetail extends ConsumerStatefulWidget {
  const OpenMatchDetail({super.key, this.matchId});

  final int? matchId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OpenMatchDetailState();
}

class _OpenMatchDetailState extends ConsumerState<OpenMatchDetail> {
  @override
  Widget build(BuildContext context) {
    return BackgroundView(
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        body: SafeArea(
          child: HomeResponsiveWidget(
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (widget.matchId == null) {
      return SecondaryText(text: "SERVICE_ID_NOT_FOUND".tr(context));
    }
    final serviceDetail =
        ref.watch(fetchServiceDetailProvider(widget.matchId!));
    return serviceDetail.when(
      data: (data) {
        final user = ref.read(userManagerProvider).user;
        if (user == null) {
          return SecondaryText(text: "USER_NOT_FOUND".tr(context));
        }
        int uid = user.user?.id ?? -1;
        final joined = data.players
                ?.indexWhere((element) => element.customer?.id == uid) !=
            -1;
        Future(() {
          if (joined) {
            ref.read(_isJoined.notifier).state = true;
          } else {
            ref.read(_isJoined.notifier).state = false;
          }
        });
        return _DataBody(
          service: data,
        );
      },
      error: (error, stackTrace) => SecondaryText(text: error.toString()),
      loading: () => const Center(
        child: CupertinoActivityIndicator(
          radius: 10,
        ),
      ),
    );
  }
}

class _DataBody extends ConsumerStatefulWidget {
  const _DataBody({
    required this.service,
  });

  final ServiceDetail service;

  @override
  ConsumerState<_DataBody> createState() => _DataBodyState();
}

class _DataBodyState extends ConsumerState<_DataBody> {
  bool isApprovalNeeded = false;
  bool isCurrentUserOrganizer = false;
  bool isRankedMatch = false;
  bool isCancelled = false;

  @override
  void initState() {
    isApprovalNeeded = (widget.service.approveBeforeJoin ?? false) ||
        (widget.service.requestWaitingList?.isNotEmpty ?? false);
    isCancelled = widget.service.isCancelled ?? false;
    final currentPlayerID = ref.read(userProvider)?.user?.id;
    final organizerID = widget.service.organizer?.customer?.id;
    isCurrentUserOrganizer = currentPlayerID == organizerID;
    isRankedMatch = !(widget.service.isFriendlyMatch ?? true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ServiceDetail service = widget.service;
    final isJoined = ref.watch(_isJoined);
    String chatCount = "";

    if (isJoined) {
      final provider = fetchChatCountProvider(matchId: service.id ?? 0);
      ref.watch(provider).whenData((data) {
        if (data != null && data > 0) {
          chatCount = "(${data.toInt()})";
        }
      });
    }
    return Container(
      constraints: kComponentWidthConstraint,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => ref.read(goRouterProvider).pop(),
                    child: Image.asset(AppImages.back_arrow_new.path,
                        height: 24.h, width: 24.h),
                  ),
                ),
                // MultiStyleTextFirstBold(text: "${"MATCH".trU(context)} \n${"INFORMATION".trU(context)}",
                //     fontSize: 26.sp,
                //     color: AppColors.black),
                Text(
                  "${"MATCH".trU(context)} \n${"INFORMATION".trU(context)}",
                  style: AppTextStyles.sofiaSansMedium(
                    fontSize: 30.sp,
                    height: 1
                  ),
                  textAlign: TextAlign.center,
                ),
                40.verticalSpace,
                if (isCancelled) ...[
                  ChangesCancelledDetailsCard(
                    heading: "BOOKING_CANCELLED".tr(context),
                    description: "CHANGES_DESC".tr(context),
                  ),
                  SizedBox(height: 10.h),
                ],
                _InfoCard(service: service),
                // SizedBox(height: 20.h),
                _OrganizerNote(note: service.organizerNote ?? ""),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      "PLAYERS".trU(context),
                      style: AppTextStyles.sofiaSansMedium(
                        fontSize: 23.sp,
                      ),
                    ),
                    const Spacer(),
                    _RankedOrFriendly(
                      isRanked: !(widget.service.isFriendlyMatch ?? true),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                OpenMatchParticipantRowWithBG(
                  textForAvailableSlot: "RESERVE".trU(context),
                  players: service.players ?? [],
                  slotIconColor: AppColors.white,
                  backgroundColor: AppColors.black5,
                  slotBackgroundColor: AppColors.blue,
                  textColor: AppColors.black,
                  imageBgColor: AppColors.blue,
                  imageLogoColor: AppColors.white,
                  onTap: (_, __) async {
                    final currentUserID =
                        ref.read(userManagerProvider).user?.user?.id;

                    if (currentUserID == null || isCancelled) return;

                    // Check if user is already in the player list
                    final isUserInPlayerList = service.players?.any(
                            (player) => player.customer?.id == currentUserID) ??
                        false;

                    // Check if user is in waiting list
                    final provider = fetchServiceWaitingPlayersProvider(
                        service.id!, RequestServiceType.booking);
                    final data =
                        await Utils.showLoadingDialog(context, provider, ref);
                    if (isCurrentUserOrganizer) {
                      await _showPlayerSelectionDialog(context);
                      return;
                    }

                    bool isUserInWaitingList = false;
                    if (data is List<ServiceWaitingPlayers>) {
                      isUserInWaitingList =
                          data.any((e) => e.customer?.id == currentUserID);
                    }
                    if (isCurrentUserOrganizer) {
                      await _showPlayerSelectionDialog(context);
                      return;
                    }
                    if (isUserInWaitingList || isUserInPlayerList) {
                      return;
                    }
                    if (!isJoined) {
                      _onJoin(false, false);
                    }
                  },
                  showReserveReleaseButton: true,
                  currentPlayerID: ref.read(userProvider)?.user?.id ?? -1,
                  onRelease: _onRelease,
                ),
                SizedBox(height: 20.h),
                _secondaryButtons(isJoined, context, service),
                if (isApprovalNeeded) ...[
                  SizedBox(height: 20.h),
                  _WaitingList(
                    id: service.id!,
                    onApprove: _onApprove,
                    isCurrentOrganizer: isCurrentUserOrganizer,
                    onJoinAfterApproval: (customerID) {
                      _joinAfterApproval(customerID);
                    },
                    refreshApis: () {
                      ref.invalidate(fetchServiceDetailProvider(service.id!));
                      ref.invalidate(fetchServiceWaitingPlayersProvider(
                          service.id!, RequestServiceType.booking));
                    },
                    onWithdraw: _withdraw,
                  ),
                ],
                if (isRankedMatch && (service.players?.length ?? 0) > 0) ...[
                  SizedBox(height: 20.h),
                  _ScoreViewComponent(service: service),
                ],
                SizedBox(height: 15.h),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: MainButton(
                      enabled: isJoined,
                      color: AppColors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      showArrow: false,
                      labelStyle: AppTextStyles.sofiaSansMedium(
                          fontSize: 23.sp, color: AppColors.white),
                      label: "${"CHAT".trU(context)} $chatCount",
                      onTap: () {
                        ref.read(goRouterProvider).push(RouteNames.chat,
                            extra: [service.id ?? 0]).then((e) {
                          ref.read(chatSocketProvider.notifier).offSocket();
                          final provider =
                              fetchChatCountProvider(matchId: service.id ?? 0);
                          ref.invalidate(provider);
                        });
                      },
                    ))
                // if(isJoined)
                //   Padding(
                //       padding: const EdgeInsets.symmetric(vertical: 15),
                //       child: MainButton(
                //         label: "CHAT".tr(context),
                //         onTap: () {
                //           ref
                //               .read(goRouterProvider)
                //               .push(RouteNames.chat, extra: [service.id ?? 0]).then((e){
                //             ref.read(chatSocketProvider.notifier).offSocket();
                //
                //           });
                //         },
                //       ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showPlayerSelectionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => _AddPlayerToWaitingListDialog(
        serviceId: widget.service.id!,
        players: widget.service.players ?? [],
      ),
    );

    // Refresh the waiting list and service details after dialog closes
    if (mounted) {
      ref.invalidate(fetchServiceWaitingPlayersProvider(
          widget.service.id!, RequestServiceType.booking));
      ref.invalidate(fetchServiceDetailProvider(widget.service.id!));
    }
  }

  Row _secondaryButtons(
      bool isJoined, BuildContext context, ServiceDetail service) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isJoined) ...[
                _leaveOpenMatch(context),
                SizedBox(height: 10.h),
              ],
              if (!service.isPast) _addToCalendarButton(context, service),
            ],
          ),
        ),
        4.horizontalSpace,
        Flexible(child: _shareMatchButton(context)),
      ],
    );
  }

  Widget _shareMatchButton(BuildContext context) {
    return SecondaryImageButton(
      label: "SHARE_MATCH".tr(context),
      image: AppImages.whatsaapIcon.path,
      imageHeight: 14.w,
      imageWidth: 14.w,
      // padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 5.h),
      // labelStyle: AppTextStyles.qanelasLight(
      //   fontSize: 13.sp,
      // ),
      onTap: () {
        Utils.shareOpenMatch(context, widget.service, ref);
      },
    );
  }

  SecondaryImageButton _addToCalendarButton(
      BuildContext context, ServiceDetail? service) {
    return SecondaryImageButton(
      label: "ADD_TO_CALENDAR".tr(context),
      image: AppImages.calendar.path,
      imageHeight: 15.w,
      imageWidth: 15.w,
      // padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      // labelStyle: AppTextStyles.qanelasLight(
      //   fontSize: 13.sp,
      // ),
      onTap: () {
        String title = "$kSportName Match";
        ref.watch(addToCalendarProvider(
          title: title,
          startDate: service!.bookingStartTime,
          endDate: service.bookingEndTime,
        ));
      },
    );
  }

  SecondaryImageButton _leaveOpenMatch(BuildContext context) {
    final int playerCount = widget.service.players?.length ?? 0;
    return SecondaryImageButton(
      label: playerCount == 1
          ? "CANCEL_MATCH".tr(context)
          : "LEAVE_OPEN_MATCH".tr(context),
      image: AppImages.crossIcon.path,
      imageHeight: 8.w,
      imageWidth: 8.w,
      // labelStyle: AppTextStyles.qanelasLight(
      //   fontSize: 13.sp,
      // ),
      onTap: () {
        _onLeave();
      },
    );
  }

  _onApprove(int playerID) async {
    final ServiceDetail service = widget.service;
    final bool? approve = await showDialog(
      context: context,
      builder: (context) => const ConfirmationDialog(
        type: ConfirmationDialogType.approveConfirm,
      ),
    );

    if (approve == true && mounted) {
      final provider =
          approvePlayerProvider(serviceID: service.id!, playerID: playerID);
      await Utils.showLoadingDialog(context, provider, ref);
      ref.invalidate(fetchServiceWaitingPlayersProvider(
          service.id!, RequestServiceType.booking));
      return;
    }
  }

  _onLeave() async {
    final ServiceDetail service = widget.service;
    final bool isLeave = (service.players?.length ?? 0) > 1;

    final CancellationPolicy? policy = await Utils.showLoadingDialog(
        context, cancellationPolicyProvider(service.id!), ref);

    if (policy == null) {
      return;
    }
    final bool? leave = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        policy: policy,
        type: isLeave
            ? ConfirmationDialogType.leave
            : ConfirmationDialogType.cancel,
      ),
    );

    if (leave == true && mounted) {
      final provider = cancelServiceProvider(service.id!);
      final bool? success =
          await Utils.showLoadingDialog(context, provider, ref);
      if (!mounted || success == null || !success) {
        return;
      }
      ref.invalidate(fetchServiceDetailProvider(service.id!));

      Utils.showMessageDialog(
        context,
        !isLeave
            ? "YOU_HAVE_CANCELED_THE_MATCH".tr(context)
            : "YOU_HAVE_LEFT_THE_MATCH".tr(context),
      );
    }
  }

  _joinAfterApproval(int playerID) async {
    _onJoin(false, true);
    //
    // final ServiceDetail service = widget.service;
    // final data = await showDialog(
    //   context: context,
    //   builder: (context) {
    //     return OpenMatchChooseSpotDialog(
    //       players: service.players!,
    //     );
    //   },
    // );
    // if (!mounted || data == null) {
    //   return;
    // }
    // final (int index, _) = data;
    // ConfirmationDialogType dialogType = ConfirmationDialogType.join;
    // final bool? join = await showDialog(
    //   context: context,
    //   builder: (context) => ConfirmationDialog(
    //     type: dialogType,
    //   ),
    // );
    // final playerID = ref.read(userManagerProvider).user?.user?.id;
    // if (join == true && context.mounted && mounted && playerID != null) {
    //   final provider = joinServiceProvider(service.id!,
    //       position: index + 1,
    //       isEvent: false,
    //       isOpenMatch: true,
    //       isDouble: false,
    //       isReserve: false,
    //       isLesson: false,
    //       isApprovalNeeded: isApprovalNeeded);
    //   final double? price =
    //       await Utils.showLoadingDialog(context, provider, ref);
    //
    //   if (!mounted || price == null) {
    //     return;
    //   }
    //   int? postPaymentServiceID = await showDialog(
    //     context: context,
    //     builder: (context) {
    //       return PaymentInformation(
    //         type: PaymentDetailsRequestType.join,
    //         locationID: service.service!.location!.id!,
    //         requestType: PaymentProcessRequestType.join,
    //         price: service.service!.price!,
    //         serviceID: service.id!,
    //         isJoiningApproval: true,
    //       );
    //     },
    //   );
    //
    //   if (postPaymentServiceID != null && mounted) {
    //     ref.invalidate(fetchServiceDetailProvider(service.id!));
    //     ref.invalidate(fetchServiceWaitingPlayersProvider(service.id!));
    //     Utils.showMessageDialog(
    //       context,
    //       "YOU_HAVE_JOINED_THE_MATCH".tr(context),
    //     );
    //   }
    // }
  }

  _onJoin(bool isReserve, bool isJoinApproval) async {
    final ServiceDetail service = widget.service;
    final data = await showDialog(
      context: context,
      builder: (context) {
        return OpenMatchChooseSpotDialog(
          players: service.players!,
        );
      },
    );
    if (!mounted || data == null) {
      return;
    }
    final (int index, int? otherTeamMemberPlayerID) = data;
    ConfirmationDialogType dialogType = ConfirmationDialogType.join;
    if (isReserve) {
      dialogType = ConfirmationDialogType.reserve;
      isApprovalNeeded = false;
    }
    if (isApprovalNeeded && !isJoinApproval) {
      dialogType = ConfirmationDialogType.approvalNeeded;
    }
    final bool? join = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        type: dialogType,
      ),
    );
    final playerID = ref.read(userManagerProvider).user?.user?.id;
    if (join == true && context.mounted && mounted && playerID != null) {
      final provider = fetchCourtPriceProvider(
          coachId: null,
          serviceId: service.id ?? 0,
          durationInMin: service.duration2,
          courtId: [service.courtId],
          requestType: CourtPriceRequestType.join,
          dateTime: DateTime.now());
      await Utils.showLoadingDialog(context, provider, ref);
      _callJoin(
          service: service,
          isReserve: isReserve,
          index: index,
          isJoinApproval: isJoinApproval,
          isApprovalNeeded: isApprovalNeeded && !isJoinApproval);
    }
    // if (join == true && context.mounted && mounted && playerID != null) {
    //   final provider = joinServiceProvider(
    //     service.id!,
    //     position: index + 1,
    //     isEvent: false,
    //     isOpenMatch: true,
    //     isDouble: false,
    //     isReserve: isReserve,
    //     isLesson: false,
    //     isApprovalNeeded: isApprovalNeeded,
    //   );
    //   final double? price =
    //       await Utils.showLoadingDialog(context, provider, ref);
    //
    //   if (!mounted || price == null) {
    //     return;
    //   }
    //   if (isApprovalNeeded && price < 0) {
    //     ref.invalidate(fetchServiceWaitingPlayersProvider(service.id!));
    //     showDialog(
    //       context: context,
    //       builder: (_) => _WaitingForApprovalDialog(serviceID: service.id!),
    //     );
    //     return;
    //   }
    //
    //   int? paymentDone = await showDialog(
    //     context: context,
    //     builder: (context) {
    //       return PaymentInformation(
    //         type: PaymentDetailsRequestType.join,
    //         locationID: service.service!.location!.id!,
    //         price: price,
    //         requestType: isReserve
    //             ? PaymentProcessRequestType.Reserved
    //             : PaymentProcessRequestType.Join,
    //         serviceID: service.id!,
    //       );
    //     },
    //   );
    //
    //   ref.invalidate(fetchServiceDetailProvider(service.id!));
    //   if (paymentDone != null && mounted) {
    //     Utils.showMessageDialog(
    //       context,
    //       isReserve
    //           ? "YOU_HAVE_RESERVED_A_SPOT_SUCCESSFULLY".tr(context)
    //           : "YOU_HAVE_JOINED_THE_MATCH".tr(context),
    //     );
    //   }
    // }
  }

  void _callJoin(
      {required ServiceDetail service,
      required int index,
      required bool isReserve,
      required bool isApprovalNeeded,
      bool isJoinApproval = false}) async {
    final provider = joinServiceProvider(service.id!,
        position: index + 1,
        isEvent: false,
        isOpenMatch: true,
        isDouble: false,
        isReserve: isReserve,
        isLesson: false,
        isApprovalNeeded: isApprovalNeeded);
    final double? price = await Utils.showLoadingDialog(context, provider, ref);

    if (!mounted || price == null) {
      return;
    }
    if (isApprovalNeeded && price < 0) {
      await showDialog(
        context: context,
        builder: (_) => _WaitingForApprovalDialog(serviceID: service.id!),
      );
      ref.invalidate(fetchServiceWaitingPlayersProvider(
          service.id!, RequestServiceType.booking));
      return;
    }

    final canProceed = await Utils().checkForLevelAssessment(
        ref: ref, context: context, sportsName: service.getSportsName(ref));

    if (!canProceed) {
      return;
    }

    final data = await showDialog(
      context: context,
      builder: (context) {
        return PaymentInformation(
            title: "PAY_MY_SHARE".tr(context),
            isOpenMatch: true,
            courtId: service.courtId,
            // boldPosition: 1,
            type: PaymentDetailsRequestType.join,
            locationID: service.service!.location!.id!,
            isJoiningApproval: isJoinApproval,
            price: price,
            requestType: isReserve
                ? PaymentProcessRequestType.reserved
                : PaymentProcessRequestType.join,
            serviceID: service.id!,
            duration: service.duration2,
            startDate: service.bookingStartTime);
      },
    );

    var (int? paymentDone, double? amount) = (null, null);
    if (data is (int, double?)) {
      (paymentDone, amount) = data;
    }

    ref.invalidate(fetchServiceDetailProvider(service.id!));
    ref.invalidate(fetchServiceWaitingPlayersProvider(
        service.id!, RequestServiceType.booking));
    if (paymentDone != null && mounted) {
      Utils.showMessageDialog(
        context,
        isReserve
            ? "YOU_HAVE_RESERVED_A_SPOT_SUCCESSFULLY".tr(context)
            : "YOU_HAVE_JOINED_THE_MATCH".tr(context),
      );
    }
  }

  _onRelease(int id) async {
    if (id == -1) {
      return;
    }
    final bool? goAhead = await showDialog(
      context: context,
      builder: (context) => const ConfirmationDialog(
        type: ConfirmationDialogType.releaseReserve,
      ),
    );
    if (goAhead == true && mounted) {
      final provider = deleteReservedProvider(widget.service.id!, id);
      final bool? success =
          await Utils.showLoadingDialog(context, provider, ref);
      if (!mounted || success == null || !success) {
        return;
      }

      ref.invalidate(fetchServiceDetailProvider(widget.service.id!));
      Utils.showMessageDialog(
        context,
        "YOU_HAVE_RELEASED_THIS_SPOT_SUCCESSFULLY".tr(context),
      );
    }
  }

  _withdraw(int id) {
    if (id == -1) {
      return;
    }
    showDialog(
      context: context,
      builder: (context) => const ConfirmationDialog(
        type: ConfirmationDialogType.withdraw,
        boldPosition: 1,
      ),
    ).then(
      (value) {
        if (value == true) {
          final provider = approvePlayerProvider(
              isApprove: false, serviceID: widget.service.id!, playerID: id);
          Utils.showLoadingDialog(context, provider, ref).then((value) {
            if (value == true) {
              ref.invalidate(
                fetchServiceWaitingPlayersProvider(
                    widget.service.id!, RequestServiceType.booking),
              );
              Utils.showMessageDialog(
                context,
                "YOU_HAVE_WITHDRAWN_FROM_THE_MATCH".tr(context),
              );
            }
          });
        }
      },
    );
  }
}

class _ScoreViewComponent extends ConsumerStatefulWidget {
  const _ScoreViewComponent({required this.service});

  final ServiceDetail service;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __ScoreComponentState();
}

class __ScoreComponentState extends ConsumerState<_ScoreViewComponent> {
  @override
  Widget build(BuildContext context) {
    final players = widget.service.players?.map((e) => e).toList();
    final assessment = ref.watch(fetchAssessmentProvider(widget.service.id!));
    //SORT BY POSITION
    final Map<int, ServiceDetail_Players?> positions = {
      1: null,
      2: null,
      3: null,
      4: null
    };

    for (var position in positions.keys) {
      final index =
          players?.indexWhere((element) => element.position == position) ?? -1;
      positions[position] = index != -1 ? (players?[index]) : null;
    }

    final playerA = positions[1];
    final playerB = positions[2];
    final playerC = positions[3];
    final playerD = positions[4];

    return assessment.when(
      data: (data) {
        return _body(data, playerA, playerB, playerC, playerD);
      },
      error: (error, stackTrace) {
        return _body(null, playerA, playerB, playerC, playerD);
      },
      loading: () {
        return const Center(
          child: CupertinoActivityIndicator(radius: 5),
        );
      },
    );
  }

  Column _body(
      AssessmentResModel? data,
      ServiceDetail_Players? playerA,
      ServiceDetail_Players? playerB,
      ServiceDetail_Players? playerC,
      ServiceDetail_Players? playerD) {
    List<int?> teamAScores = [
      data?.teamA?.score1,
      data?.teamA?.score2,
      data?.teamA?.score3
    ];
    List<int?> teamBScores = [
      data?.teamB?.score1,
      data?.teamB?.score2,
      data?.teamB?.score3
    ];
    Map<String, bool> result = determineWinner(teamAScores, teamBScores);
    bool isDraw = result['isDraw']!;
    bool isAWin = result['isAWin']!;
    final isMatchScoreFilled =
        teamAScores.every((element) => element != null) &&
            teamBScores.every((element) => element != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "SCORE",
          style: AppTextStyles.sofiaSansMedium(fontSize: 23.sp),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(15.h),
          decoration: BoxDecoration(
            color: AppColors.black5,
            border: border,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.service.formatBookingDate,
                    style: AppTextStyles.manropeSemiBold(
                      fontSize: 13.sp,
                    ),
                  ),
                  _enterButton(teamAScores, teamBScores),
                  Text(
                    widget.service.openMatchLevelRange,
                    style: AppTextStyles.manropeMedium(
                      fontSize: 15.sp,
                    ),
                  )
                ],
              ),
              // SizedBox(height: 5.h),
              CDivider(
                color: AppColors.black5,
              ),
              PrivateRankedComponent(
                  isRanked: !(widget.service.isFriendlyMatch ?? true),
                  isPrivate: widget.service.isPrivateMatch ?? false),
              SizedBox(height: 10.h),
              _TeamScore(
                playerA: playerA,
                playerB: playerB,
                scores: teamAScores,
                isWinner: !isDraw && isAWin && isMatchScoreFilled,
                isDraw: isDraw && isMatchScoreFilled,
              ),
              SizedBox(height: 10.h),
              CDivider(),
              _TeamScore(
                playerA: playerC,
                playerB: playerD,
                scores: teamBScores,
                isWinner: !isAWin && !isDraw && isMatchScoreFilled,
                isDraw: isDraw && isMatchScoreFilled,
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _enterButton(List<int?>? teamAScores, List<int?>? teamBScores) {
    bool isEnabled = false;

    DateTime endTime = widget.service.bookingEndTime;
    DateTime now = DubaiDateTime.now().dateTime;
    // Check if all other 3 users are reserved
    int reserveCount = 0;
    widget.service.players?.forEach((element) {
      if (element.reserved == true) {
        reserveCount++;
      }
    });
    if (now.isAfter(endTime) &&
        now.difference(endTime).inHours < 24 &&
        widget.service.players?.length == 4 &&
        reserveCount < 3) {
      isEnabled = true;
    }

    return InkWell(
      onTap: isEnabled
          ? () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return EnterMatchResults(
                    service: widget.service,
                    teamAScore: teamAScores,
                    teamBScore: teamBScores,
                  );
                },
              );
              if (mounted) {
                ref.invalidate(fetchServiceDetailProvider(widget.service.id!));
                ref.invalidate(fetchAssessmentProvider(widget.service.id!));
              }
            }
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 15.w),
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Text(
          "ENTER_MATCH_RESULTS".tr(context),
          style: AppTextStyles.manropeSemiBold(
            fontSize: 13.sp,
            color: isEnabled ? AppColors.white : AppColors.black25,
          ),
        ),
      ),
    );
  }
}

class _TeamScore extends ConsumerWidget {
  const _TeamScore(
      {required this.playerA,
      required this.playerB,
      required this.scores,
      required this.isWinner,
      this.isDraw = false});

  final ServiceDetail_Players? playerA;
  final ServiceDetail_Players? playerB;
  final List<int?>? scores;
  final bool isWinner;
  final bool isDraw;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _customerName(playerA, context),
              _customerName(playerB, context),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              3,
              (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 6, left: 4, right: 4),
                    child: _scoreItem(index),
                  ),
                );
              },
            ),
          ),
        ),
        // Expanded(child: Container())
        if (isWinner && !isDraw) Expanded(child: _winnerContainer()),
        if (isDraw) Expanded(child: _drawContainer()),
        if (!isWinner && !isDraw) Expanded(child: Container())
      ],
    );
  }

  _scoreItem(int index) {
    final score =
        scores != null && index < scores!.length ? scores![index] : null;
    if (score != null) {
      return Text(
        score.toString(),
        style: isWinner
            ? AppTextStyles.sofiaSansMedium(fontSize: 23.sp)
            : AppTextStyles.manropeMedium(fontSize: 16.sp),
      );
    }
    return Container(height: 1, color: AppColors.black);
  }

  _winnerContainer() {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      padding: EdgeInsets.symmetric(vertical: 6.4.h, horizontal: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        color: AppColors.blue,
      ),
      child: Center(
        child: Text(
          'Winners',
          style: AppTextStyles.manropeSemiBold(
            fontSize: 16.sp,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  _drawContainer() {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      padding: EdgeInsets.symmetric(vertical: 6.5.h, horizontal: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        color: AppColors.blue,
      ),
      child: Center(
        child: Text(
          'Draw',
          style: AppTextStyles.manropeSemiBold(
            fontSize: 16.sp,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Text _customerName(ServiceDetail_Players? player, BuildContext context) {
    if (player == null) {
      return const Text("-");
    }
    bool isReserved = player.reserved ?? false;
    return Text(
      (isReserved)
          ? "RESERVED".tr(context)
          : (player.getCustomerName).capitalizeFirst,
      style: isWinner
          ? AppTextStyles.manropeSemiBold(
              fontSize: 15.sp,
            )
          : AppTextStyles.manropeMedium(
              fontSize: 15.sp,
            ),
    );
  }
}
