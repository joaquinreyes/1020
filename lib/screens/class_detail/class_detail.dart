import 'package:hop/components/custom_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/approved_applicant_dialogs/events/events_applicant_dialog.dart';
import 'package:hop/components/avaialble_slot_widget.dart';
import 'package:hop/components/c_divider.dart';

import 'package:hop/components/service_detail_components.dart/service_coaches.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/components/participant_slot.dart';
import 'package:hop/components/secondary_button.dart';
import 'package:hop/components/secondary_text.dart';
import 'package:hop/components/service_detail_components.dart/service_information.dart';
import 'package:hop/components/waiting_list_approval_status.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/managers/user_manager.dart';
import 'package:hop/models/applicat_socket_response.dart';
import 'package:hop/models/base_classes/booking_player_base.dart';
import 'package:hop/models/service_detail_model.dart';
import 'package:hop/models/service_waiting_players.dart';
import 'package:hop/repository/booking_repo.dart';
import 'package:hop/repository/payment_repo.dart';
import 'package:hop/repository/play_repo.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:hop/screens/payment_information/payment_information.dart';
import 'package:hop/screens/payment_information/modern_payment_sheet.dart';
import 'package:hop/screens/responsive_widgets/home_responsive_widget.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/widgets/background_view.dart';
import 'dart:math' as math;

import '../../components/refund_description_component.dart';
import '../../models/cancellation_policy_model.dart';
import '../../models/court_price_model.dart';

part 'class_detail_provider.dart';

part 'class_detail_components.dart';

part 'class_players_slots.dart';

class ClassDetail extends ConsumerStatefulWidget {
  const ClassDetail({super.key, this.matchId});

  final int? matchId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClassDetailState();
}

class _ClassDetailState extends ConsumerState<ClassDetail> {
  @override
  Widget build(BuildContext context) {
    return BackgroundView(
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        body: SafeArea(
          child: HomeResponsiveWidget(child: _buildBody()),
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
  @override
  Widget build(BuildContext context) {
    final ServiceDetail service = widget.service;
    final isJoined = ref.watch(_isJoined);
    final playerWaitingListId = ref.watch(_playerWaitingListId);

    return Container(
      constraints: kComponentWidthConstraint,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: RefreshIndicator(
          color: AppColors.brick,
          backgroundColor: AppColors.white,
          onRefresh: () {
            ref.invalidate(fetchServiceWaitingPlayersProvider(
                service.id!, RequestServiceType.event));
            return ref.refresh(fetchServiceDetailProvider(service.id!).future);
          },
          child: ListView(
            children: [
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.only(left: 3.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => ref.read(goRouterProvider).pop(),
                    child: Image.asset(
                      AppImages.back_arrow_new.path,
                      height: 24.h,
                      width: 24.h,
                    ),
                  ),
                ),
              ),
              Text(
                "${"CLASS".trU(context)}\n ${"INFORMATION".trU(context)}",
                style: AppTextStyles.sofiaSansMedium(
                    fontSize: 22.sp,),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              _InfoCard(
                event: service,
              ),
              // SizedBox(height: 10.h),
              ServiceInformationText(
                service: service,
                // titleStyle: AppTextStyles.qanelasBold().copyWith(
                //     fontSize: 19.sp,
                //     color: AppColors.black,
                //     letterSpacing: 19.sp * 0.10),
                // desStyle: AppTextStyles.qanelasRegular()
                //     .copyWith(color: AppColors.black, fontSize: 13.sp),
              ),
              ServiceCoaches(coaches: service.getCoaches),
              SizedBox(height: 30.h),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 33.w),
              //   child: MainButton(
              //     // onSlotTap: (int index, int? otherPlayerID) async {
              //     //   if (_canJoin(
              //     //       isJoined: isJoined,
              //     //       otherPlayerID: otherPlayerID,
              //     //       service: service)) {
              //     //     await _onJoin(index, otherPlayerID, isJoined);
              //     //   }
              //     // },
              //     // onTap: ()
              //     //   async {
              //     //     if (_canJoin(
              //     //         isJoined: isJoined,
              //     //         otherPlayerID: 0,
              //     //         service: service)) {
              //     //       await _onJoin(0, 0, isJoined);
              //     //     }
              //     // },
              //     color: AppColors.darkYellow,
              //     label: 'JOIN'.trU(context),
              //     labelStyle: AppTextStyles.qanelasMedium(fontSize: 18.sp,),
              //   ),
              // ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${"PLAYERS".trU(context)} ${service.players?.length ?? 0} / ${service.getMaximumCapacity}",
                  style: AppTextStyles.sofiaSansMedium(
                      fontSize: 17.sp,),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                clipBehavior: Clip.antiAlias,
                padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, (service.service?.isDoubleEvent ?? false) ? 15.h : 0),
                width: double.infinity,
                constraints: kComponentWidthConstraint,
                decoration: BoxDecoration(
                  color: AppColors.tileBgColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: _EventPlayersSlots(
                  players: service.players ?? [],
                  maxPlayers: service.getMaximumCapacity,
                  service: service,
                  id: service.id!,
                  onSlotTap: (int index, int? otherPlayerID) async {
                    if (_canJoin(
                        isJoined: isJoined,
                        otherPlayerID: otherPlayerID,
                        service: service)) {
                      await _onJoin(index, otherPlayerID, isJoined);
                    }
                  },
                  isDoubleEvents: service.service?.isDoubleEvent ?? false,
                  onRelease: _onRelease,
                ),
              ),
              SizedBox(height: 30.h),
              _secondaryBtns(isJoined, playerWaitingListId, context, service),
              SizedBox(height: 30.h),

              // _ApprovalStatus(
              //   service: service,
              //   onJoin: _joinAfterApprovel,
              //   onWithdraw: _withdraw,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canJoin({
    required bool isJoined,
    required int? otherPlayerID,
    required ServiceDetail service,
  }) {
    final currentCustomerID = ref.read(userProvider)?.user?.id ?? -1;

    if (isJoined && !(service.service?.isDoubleEvent ?? true)) {
      return false;
    }

    if (otherPlayerID != null) {
      final otherPlayerCustomerID = service.players
              ?.firstWhere(
                (element) => element.id == otherPlayerID,
              )
              .customer
              ?.id ??
          -1;

      if (isJoined && currentCustomerID != otherPlayerCustomerID) {
        return false;
      }
    } else if (isJoined) {
      return false;
    }
    return true;
  }

  Row _secondaryBtns(bool isJoined, int? playerWaitingListId,
      BuildContext context, ServiceDetail service) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isJoined || (playerWaitingListId != null)) ...[
              _leave(context, playerWaitingListId),
              SizedBox(height: 10.h),
            ],
            if (!service.isPast) _addToCalendarButton(context),
          ],
        ),
        const Spacer(),
        _shareMatchButton(context),
      ],
    );
  }

  Widget _shareMatchButton(BuildContext context) {
    return SecondaryImageButton(
      label: "SHARE_EVENT".tr(context),
      // labelStyle: AppTextStyles.qanelasLight(
      //   fontSize: 13.sp,
      // ),
      // padding: EdgeInsets.only(right: 3.w, top: 4.h, bottom: 4.h, left: 3.w),
      image: AppImages.whatsaapIcon.path,
      imageHeight: 14.h,
      imageWidth: 14.h,
      // borderRadius: 8.r,
      color: AppColors.tileBgColor,
      onTap: _shareWhatsAap,
    );
  }

  void _shareWhatsAap() {
    Utils.shareEventLessonUrl(
        context: context, service: widget.service, isLesson: false);
  }

  SecondaryImageButton _addToCalendarButton(BuildContext context) {
    return SecondaryImageButton(
      label: "ADD_TO_CALENDAR".tr(context),
      // labelStyle: AppTextStyles.qanelasLight(
      //   fontSize: 13.sp,
      // ),
      image: AppImages.calendar.path,
      imageHeight: 15.h,
      imageWidth: 15.h,
      // padding: EdgeInsets.only(right: 11.w, top: 4.h, bottom: 4.h, left: 5.w),

      // borderRadius: 8.r,
      color: AppColors.tileBgColor,
      textColor: AppColors.black,
      onTap: () {
        String title =
            "Event @ ${widget.service.service?.location?.locationName ?? ""}";
        ref.watch(addToCalendarProvider(
          title: title,
          startDate: widget.service.bookingStartTime,
          endDate: widget.service.bookingEndTime,
        ));
      },
    );
  }

  SecondaryImageButton _leave(BuildContext context, int? playerWaitingListId) {
    return SecondaryImageButton(
      label: ((playerWaitingListId != null)
              ? "LEAVE_WAITING_EVENT"
              : "CANCEL_SLOT")
          .tr(context),
      // labelStyle: AppTextStyles.qanelasLight(
      //   fontSize: 13.sp,
      // ),
      // padding: EdgeInsets.only(right: 10.w, top: 4.h, bottom: 4.h, left: 10.w),
      image: AppImages.crossIcon.path,
      imageHeight: 8.h,
      imageWidth: 8.h,
      // borderRadius: 8.r,
      color: AppColors.tileBgColor,
      textColor: AppColors.black,
      onTap: () {
        _onLeave(playerWaitingListId);
      },
    );
  }

  _onJoin(int index, int? otherTeamPlayerId, bool isReserve) async {
    final ServiceDetail service = widget.service;
    bool isSecondPlayer = otherTeamPlayerId != null;
    _ConfirmationDialogType dialogType = _ConfirmationDialogType.join;
    if (isSecondPlayer) {
      dialogType = _ConfirmationDialogType.applyForApproval;
    }
    if (isReserve) {
      dialogType = _ConfirmationDialogType.reserve;
    }

    final bool? join = await showDialog(
      context: context,
      builder: (context) => _ConfirmationDialog(
        type: dialogType,
      ),
    );
    if (join == true && context.mounted && mounted) {
      final courtPrice = fetchCourtPriceProvider(
          coachId: null,
          serviceId: service.id ?? 0,
          durationInMin: service.duration2,
          courtId: [service.courtId],
          requestType: CourtPriceRequestType.join,
          dateTime: DateTime.now());
      final value = await Utils.showLoadingDialog(context, courtPrice, ref);
      if (value == null || !mounted) {
        return;
      }

      CourtPriceModel? courtPriceModel;

      if (value is CourtPriceModel) {
        courtPriceModel = value;
      }

      final provider = joinServiceProvider(
        service.id!,
        position: index + 1,
        playerId: otherTeamPlayerId,
        isEvent: true,
        isOpenMatch: false,
        isDouble: service.service?.isDoubleEvent ?? false,
        isReserve: isReserve,
        isApprovalNeeded: otherTeamPlayerId != null && !isReserve,
        isLesson: false,
      );
      final double? price =
          await Utils.showLoadingDialog(context, provider, ref);
      if (!mounted || price == null) {
        return;
      }
      if (isSecondPlayer && price < 0) {
        ref.invalidate(fetchServiceWaitingPlayersProvider(
            service.id!, RequestServiceType.event));
        Utils.showMessageDialog(
          context,
          "YOU_ARE_NOW_WAITING_FOR_APPROVAL".trU(context),
        );
        return;
      }
      final canProceed = await Utils().checkForLevelAssessment(
          ref: ref, context: context, sportsName: service.getSportsName(ref));

      if (!canProceed) {
        return;
      }

      final data = await showPaymentSheet(
        context: context,
        child: PaymentInformation(
            courtPriceModel: courtPriceModel,
            courtId: service.courtId,

            type: PaymentDetailsRequestType.join,
            locationID: service.service?.location?.id ?? 0,
            price: price,
            requestType: isReserve
                ? PaymentProcessRequestType.reserved
                : PaymentProcessRequestType.join,
            serviceID: service.id!,
            duration: service.duration2,
            startDate: service.bookingStartTime),
      );
      var (int? paymentDone, double? amount) = (null, null);
      if (data is (int, double?)) {
        (paymentDone, amount) = data;
      }

      ref.invalidate(fetchServiceDetailProvider(service.id!));
      if (paymentDone != null && mounted) {
        Utils.showMessageDialog(
          context,
          "YOU_HAVE_JOINED_SUCCESSFULLY".tr(context),
        );
      }
    }
  }

  _onRelease(int id) async {
    if (id == -1) {
      return;
    }
    final bool? goAhead = await showDialog(
      context: context,
      builder: (context) => const _ConfirmationDialog(
        type: _ConfirmationDialogType.releaseReserve,
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
          context, "YOU_HAVE_RELEASED_THIS_SPOT_SUCCESSFULLY".tr(context));
    }
  }

  _joinAfterApprovel(int playerID) async {
    final ServiceDetail service = widget.service;
    final canProceed = await Utils().checkForLevelAssessment(
        ref: ref, context: context, sportsName: service.getSportsName(ref));

    if (!canProceed) {
      return;
    }
    final data = await showPaymentSheet(
      context: context,
      child: PaymentInformation(
          courtId: service.courtId,
          type: PaymentDetailsRequestType.join,
          locationID: service.service!.location!.id!,
          requestType: PaymentProcessRequestType.join,
          price: service.service!.price!,
          serviceID: service.id!,
          isJoiningApproval: true,
          duration: service.duration2,
          startDate: service.bookingStartTime),
    );
    final (int? postPaymentServiceID, double? amount) = data;
    if (postPaymentServiceID != null && mounted) {
      ref.invalidate(fetchServiceDetailProvider(service.id!));
      ref.invalidate(fetchServiceWaitingPlayersProvider(
          service.id!, RequestServiceType.event));
      Utils.showMessageDialog(
        context,
        "YOU_HAVE_JOINED_THE_MATCH".tr(context),
      );
    }
  }

  _withdraw(int id) {
    if (id == -1) {
      return;
    }
    showDialog(
      context: context,
      builder: (context) => const _ConfirmationDialog(
        type: _ConfirmationDialogType.withdraw,
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
                    widget.service.id!, RequestServiceType.event),
              );
              Utils.showMessageDialog(
                  context, "YOU_HAVE_WITHDRAWN_FROM_THE_MATCH".tr(context));
            }
          });
        }
      },
    );
  }

  _onLeave(int? playerWaitingListId) async {
    if (playerWaitingListId != null) {
      _withdraw(playerWaitingListId);
      return;
    }
    final ServiceDetail service = widget.service;
    final CancellationPolicy? policy = await Utils.showLoadingDialog(
        context, cancellationPolicyProvider(service.id!), ref);

    if (policy == null) {
      return;
    }
    final bool? leave = await showDialog(
      context: context,
      builder: (context) => _ConfirmationDialog(
        policy: policy,
        type: _ConfirmationDialogType.leave,
      ),
    );
    if (leave == true && mounted) {
      final bool? left = await Utils.showLoadingDialog(
        context,
        cancelServiceProvider(service.id!),
        ref,
      );
      if (left == true && mounted) {
        ref.invalidate(fetchServiceDetailProvider(service.id!));
        Utils.showMessageDialog(
          context,
          "YOU_HAVE_LEFT_SUCCESSFULLY".tr(context),
        );
      }
    }
  }
}

class _ApprovalStatus extends ConsumerStatefulWidget {
  const _ApprovalStatus(
      {required this.service, required this.onJoin, required this.onWithdraw});

  final Function(int) onJoin;
  final Function(int) onWithdraw;
  final ServiceDetail service;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __ApprovalStatusState();
}

class __ApprovalStatusState extends ConsumerState<_ApprovalStatus> {
  @override
  Widget build(BuildContext context) {
    final waitingList = ref.watch(fetchServiceWaitingPlayersProvider(
        widget.service.id ?? 0, RequestServiceType.event));
    return waitingList.when(
      data: (list) {
        final data = list.map((e) => e).toList();
        final currentID = ref.read(userProvider)?.user?.id;
        final index =
            data.indexWhere((element) => element.customer?.id == currentID);
        Future(() {
          if (index != -1 && index < data.length) {
            final item = data[index];
            ref.read(_playerWaitingListId.notifier).state = item.id;
          } else {
            ref.read(_playerWaitingListId.notifier).state = null;
          }
        });

        final waitingFinalList = [...data];
        waitingFinalList.removeWhere((element) => element.status != "waiting");
        data.removeWhere((element) => !(element.customer?.id == currentID &&
            (element.status == "pending" || element.status == "approved")));

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            if (data.isNotEmpty) ...[
              WaitingListApprovalStatus(
                data: data.first,
                onJoin: widget.onJoin,
                onWithdraw: widget.onWithdraw,
                isForEvent: true,
              ),
              SizedBox(height: 20.h),
            ],
            _WaitingPlayersSlots(
              onWithdraw: () {
                widget.onWithdraw(getInWaitingListId(list, currentID ?? -1));
              },
              isInWaitingList: checkInWaitingList(list, currentID ?? -1),
              players: waitingFinalList,
              maxPlayers: waitingFinalList.length + 3,
              service: widget.service,
              id: widget.service.id!,
              onSlotTap: (int index, int? otherPlayerID) async {
                final provider = fetchServiceWaitingPlayersProvider(
                    widget.service.id ?? 0, RequestServiceType.event);
                final currentUserID =
                    ref.read(userManagerProvider).user?.user?.id;
                final data =
                    await Utils.showLoadingDialog(context, provider, ref);
                bool userPresent = false;
                if (data is List<ServiceWaitingPlayers>) {
                  userPresent =
                      data.any((e) => e.customer?.id == currentUserID);
                }
                if (!userPresent && !(widget.service.isCancelled ?? false)) {
                  await _onJoinWaitingList(index, otherPlayerID);
                }
              },
              isDoubleEvents: widget.service.service?.isDoubleEvent ?? false,
            ),
          ],
        );
      },
      loading: () => Container(),
      error: (error, stackTrace) {
        return const SizedBox();
      },
    );
  }

  int getInWaitingListId(List<ServiceWaitingPlayers> list, int currentID) {
    final index =
        list.indexWhere((element) => element.customer?.id == currentID);
    if (index != -1) {
      return list[index].id ?? -1;
    }
    return -1;
  }

  bool checkInWaitingList(List<ServiceWaitingPlayers> list, int currentID) {
    return list.any((element) => element.customer?.id == currentID);
  }

  _onJoinWaitingList(int index, int? otherPlayerID) async {
    final ServiceDetail service = widget.service;
    _ConfirmationDialogType dialogType = _ConfirmationDialogType.joinWaitingLit;

    final bool? join = await showDialog(
      context: context,
      builder: (context) => _ConfirmationDialog(
        type: dialogType,
      ),
    );

    if (join == true && context.mounted && mounted) {
      final provider =
          joinWaitingListProvider(serviceId: service.id!, position: index + 1);
      await Utils.showLoadingDialog(context, provider, ref);
      ref.invalidate(fetchServiceWaitingPlayersProvider(
          widget.service.id ?? 0, RequestServiceType.event));
    }
  }
}
