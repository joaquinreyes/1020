import 'package:hop/components/alert_dialog_button.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/avaialble_slot_widget.dart';
import 'package:hop/components/c_divider.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/components/multi_style_text.dart';
import 'package:hop/components/service_detail_components.dart/service_coaches.dart';
import 'package:hop/components/participant_slot.dart';
import 'package:hop/components/secondary_button.dart';
import 'package:hop/components/secondary_text.dart';
import 'package:hop/components/service_detail_components.dart/service_information.dart';
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
import 'package:hop/screens/payment_information/modern_payment_sheet.dart';
import 'package:hop/screens/responsive_widgets/home_responsive_widget.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/widgets/background_view.dart';
import 'dart:math' as math;

import '../../components/refund_description_component.dart';
import '../../models/cancellation_policy_model.dart';

part 'lesson_detail_provider.dart';

part 'lesson_detail_components.dart';

class LessonDetail extends ConsumerStatefulWidget {
  const LessonDetail({super.key, this.matchId});

  final int? matchId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LessonDetailState();
}

class _LessonDetailState extends ConsumerState<LessonDetail> {
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
    var eventLessonStatusText = Utils.eventLessonStatusText(
      context: context,
      playersCount: widget.service.players?.length ?? 0,
      maxCapacity: widget.service.getMaximumCapacity,
      minCapacity: widget.service.getMinimumCapacity,
    );
    final maxPaxValue = service.maxPaxValue;

    final bool isLessonVariant = maxPaxValue != null;
    return Container(
      height: double.infinity,
      constraints: kComponentWidthConstraint,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
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
                "${"LESSON".trU(context)}\n ${"INFORMATION".trU(context)}",
                style: AppTextStyles.sofiaSansMedium(
                  fontSize: 30.sp,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
              // Text(
              //   "${"LESSON".trU(context)}\n ${"INFORMATION".trU(context)}",
              //   style: AppTextStyles.gothamNarrowBold().copyWith(
              //       height: 1.3,
              //       fontSize: 22.sp,
              //       color: AppColors.black,
              //       letterSpacing: 1),
              //   textAlign: TextAlign.center,
              // ),
              40.verticalSpace,
              _InfoCard(lesson: service),
              // SizedBox(height: 10.h),

              if(!isLessonVariant)...[
                ServiceInformationText(
                  service: service,
                ),
                ServiceCoaches(coaches: service.getCoaches),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      "${"PLAYERS".trU(context)} ${service.players?.length ?? 0} / ${service.getMaximumCapacity}",
                      style: AppTextStyles.sofiaSansMedium(
                        fontSize: 23.sp,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${"STATUS".trU(context)}: ${eventLessonStatusText.trU(context)}",
                      style: AppTextStyles.sofiaSansMedium(
                        fontSize: 20.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Text(
                    //   "${"STATUS".tr(context)}: $eventLessonStatusText",
                    //   style: AppTextStyles.gothamNarrowBold().copyWith(
                    //       fontSize: 15.sp,
                    //       letterSpacing: 1,
                    //       color: AppColors.black),
                    //   textAlign: TextAlign.center,
                    // ),
                  ],
                ),
                SizedBox(height: 10.h),
                Container(
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.only(
                      left: 15.w, right: 15.w, top: 15.h, bottom: 10.h),
                  width: double.infinity,
                  constraints: kComponentWidthConstraint,
                  decoration: BoxDecoration(
                    color: AppColors.black5,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: _LessonPlayersSlots(
                    players: service.players ?? [],
                    maxPlayers: service.getMaximumCapacity,
                    onSlotTap: (index, __) async {
                      await _onJoin(index);
                    },
                  ),
                ),
              ],
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isJoined) ...[
                          _leaveLesson(context),
                          SizedBox(height: 10.h),
                        ],
                        if (!service.isPast) _addToCalendarButton(context),
                      ],
                    ),
                  ),
                  4.horizontalSpace,
                  Flexible(child: _shareMatchButton(context)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shareMatchButton(BuildContext context) {
    return SecondaryImageButton(
      label: "SHARE_MATCH".tr(context),
      // labelStyle: AppTextStyles.qanelasLight(
      //   fontSize: 13.sp,
      //   color: AppColors.black,
      // ),
      padding:
          EdgeInsets.only(right: 14.w, top: 4.h, bottom: 4.h, left: 14.w),
      image: AppImages.whatsaapIcon.path,
      imageHeight: 14.h,
      imageWidth: 14.h,
      onTap: _shareWhatsAap,
    );
  }

  void _shareWhatsAap() {
    Utils.shareEventLessonUrl(
        context: context, service: widget.service, isLesson: true);
  }

  SecondaryImageButton _addToCalendarButton(BuildContext context) {
    return SecondaryImageButton(
      label: "ADD_TO_CALENDAR".tr(context),
      // labelStyle: AppTextStyles.qanelasLight(
      //   fontSize: 13.sp,
      //   color: AppColors.black,
      // ),
      padding: EdgeInsets.only(left: 5.w, right: 22.w, top: 4.h, bottom: 4.h),
      image: AppImages.calendar.path,
      imageHeight: 15.h,
      imageWidth: 15.h,
      onTap: () {
        String title =
            "Lesson @ ${widget.service.service?.location?.locationName ?? ""}";
        ref.watch(addToCalendarProvider(
          title: title,
          startDate: widget.service.bookingStartTime,
          endDate: widget.service.bookingEndTime,
        ));
      },
    );
  }

  SecondaryImageButton _leaveLesson(BuildContext context) {
    return SecondaryImageButton(
      label: "LEAVE_LESSON".tr(context),
      // labelStyle: AppTextStyles.qanelasLight(
      //   fontSize: 13.sp,
      //   color: AppColors.black,
      // ),
      padding: EdgeInsets.only(right: 39.w, top: 4.h, bottom: 4.h, left: 10.w),
      image: AppImages.crossIcon.path,
      imageHeight: 8.h,
      imageWidth: 8.h,
      // borderRadius: 8.r,
      onTap: () {
        _onLeave();
      },
    );
  }

  _onJoin(int index) async {
    final ServiceDetail service = widget.service;
    final bool? join = await showDialog(
      context: context,
      builder: (context) => const _ConfirmationDialog(
        type: _ConfirmationDialogType.join,
      ),
    );
    final canProceed = await Utils().checkForLevelAssessment(
    ref: ref, context: context, sportsName: service.getSportsName(ref));

    if (!canProceed) {
    return;
    }
    if (join == true && context.mounted && mounted) {
      final courtPrice = fetchCourtPriceProvider(
          coachId: service.service?.coachesId,
          serviceId: service.id ?? 0,
          courtId: [service.courtId],
          durationInMin: service.duration2,
          requestType: CourtPriceRequestType.join,
          dateTime: DateTime.now());
      await Utils.showLoadingDialog(context, courtPrice, ref);
      final provider = joinServiceProvider(
        service.id!,
        position: index + 1,
        isLesson: true,
        playerId: null,
        isEvent: false,
        isOpenMatch: false,
        isDouble: false,
        isReserve: false,
        isApprovalNeeded: false,
      );
      final double? price =
          await Utils.showLoadingDialog(context, provider, ref);
      if (!mounted || price == null) {
        return;
      }

      final data = await showPaymentSheet(
        context: context,
        child: PaymentInformation(
            title: "PAY_MY_SHARE".trU(context),
            type: PaymentDetailsRequestType.join,
            locationID: service.service!.location!.id!,
            price: price,
            courtId: service.courtId,
            requestType: PaymentProcessRequestType.join,
            serviceID: service.id!,
            duration: service.duration2,
            startDate: service.bookingStartTime),
      );
      if (data != null) {
        final (int? paymentDone, double? amount) = data;
        ref.invalidate(fetchServiceDetailProvider(service.id!));
        if (paymentDone != null && mounted) {
          Utils.showMessageDialog(
            context,
            "YOU_HAVE_JOINED_SUCCESSFULLY".tr(context),
          );
        }
      }
    }
  }

  _onLeave() async {
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
      final provider = cancelServiceProvider(service.id!);
      final bool? success =
          await Utils.showLoadingDialog(context, provider, ref);
      if (!mounted || success == null || !success) {
        return;
      }
      ref.invalidate(fetchServiceDetailProvider(service.id!));

      Utils.showMessageDialog(
        context,
        "YOU_LEFT_SUCCESSFULLY".tr(context),
      );
    }
  }
}
