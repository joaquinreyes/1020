import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/components/network_circle_image.dart';
import 'package:hop/components/secondary_button.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/service_waiting_players.dart';
import 'package:hop/repository/play_repo.dart';
import 'package:hop/utils/custom_extensions.dart';

class WaitingListApprovalStatus extends ConsumerStatefulWidget {
  const WaitingListApprovalStatus({
    super.key,
    required this.data,
    required this.onJoin,
    required this.onWithdraw,
    required this.isForEvent,
    this.serviceBookingId,
    this.refreshApis,
  });

  final int? serviceBookingId;
  final ServiceWaitingPlayers data;
  final Function(int) onJoin;
  final Function(int) onWithdraw;
  final bool isForEvent;
  final Function? refreshApis;

  @override
  ConsumerState<WaitingListApprovalStatus> createState() =>
      _WaitingListApprovalStatusState();
}

class _WaitingListApprovalStatusState
    extends ConsumerState<WaitingListApprovalStatus> {
  String get acceptedHeader {
    return widget.isForEvent
        ? "YOU_HAVE_BEEN_ACCEPTED_INTO_THE_TEAM".tr(context)
        : ("YOU_HAVE_BEEN_ACCEPTED_INTO_THE_MATCH".trU(context));
  }

  Future<void> _showConfirmationDialog(String action) async {
    final isAccept = action == "accept";

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return CustomDialog(
          color: AppColors.brick,
          closeIconColor: AppColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isAccept
                    ? "ARE_YOU_SURE_YOU_WANT_TO_ACCEPT_THE_OPEN_MATCH".trU(context)
                    : "ARE_YOU_SURE_YOU_WANT_TO_REJECT_THE_OPEN_MATCH".trU(context),
                textAlign: TextAlign.center,
                style: AppTextStyles.popupHeaderTextStyle,
              ),
              SizedBox(height: 15.h),
              Text(
                "THIS_ACTION_CANNOT_BE_UNDONE".tr(context),
                textAlign: TextAlign.center,
                style: AppTextStyles.popupBodyTextStyle,
              ),
              SizedBox(height: 20.h),
              MainButton(
                label: isAccept ? "ACCEPT".trU(context) : "REJECT".trU(context),
                // color: isAccept ? AppColors.yellow : AppColors.darkRosewood,
                // labelStyle: AppTextStyles.sofiaSansMedium(
                //   fontSize: 18.sp,
                //   color: isAccept ? AppColors.black2 : AppColors.white,
                // ),
                isForPopup: true,
                onTap: () {
                  Navigator.pop(dialogContext, true);
                },
              ),
            ],
          ),
        );
      },
    );

    if (confirmed == true && mounted) {
      _handleWaitingListAction(action);
    }
  }

  Future<void> _handleWaitingListAction(String action) async {
    final player = widget.data;

    // Call the API
    try {
      final provider = waitingListActionProviderProvider(
        waitingListId: widget.serviceBookingId ?? 0,
        action: action,
      );
      final success = await Utils.showLoadingDialog(context, provider, ref);

      if (success && mounted) {
        if (action == "accept") {
          // If accepted, automatically call onJoin
          widget.onJoin(player.customer!.id!);
        } else {
          // If rejected, show success message
          await Utils.showMessageDialog(
            context,
            "YOU_HAVE_LEFT_SUCCESSFULLY".tr(context),
          );
        }
        if(widget.refreshApis != null){
          widget.refreshApis!();
        }
      }
    } catch (e) {
      if (mounted) {
        Utils.showMessageDialog(
          context,
          e.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          player.isApproved
              ? acceptedHeader
              : "YOU_ARE_WAITING_FOR_APPROVAL".trU(context),
          style: AppTextStyles.sofiaSansMedium(
            fontSize: 23.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.black5,
            border: border,
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
          child: Row(
            children: [
              NetworkCircleImage(
                path: player.customer?.profileUrl,
                width: 37.w,
                height: 37.h,
                logoColor: AppColors.white,
                borderRadius: BorderRadius.circular(6.r),
                bgColor: AppColors.blue,
                boxBorder: Border.all(
                  color: AppColors.white25,
                ),
              ),
              SizedBox(width: 15.w),
              Column(
                children: [
                  Text(
                    player.getCustomerName.toUpperCase(),
                    style: AppTextStyles.sofiaSansMedium(fontSize: 12.sp),
                  ),
                  if (player.customer?.level(getSportsName(ref))?.isNotEmpty ??
                      false)
                    Text(
                      "${player.customer?.level(getSportsName(ref))}",
                      //, •  Right",
                      style: AppTextStyles.manropeMedium(
                        fontSize: 12.sp,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              if (player.isOpenMatchWaitingApproval) ...[
                // Show Accept and Reject buttons
                SecondaryButton(
                  color: AppColors.darkRosewood,
                  borderRadius: 100,
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
                  onTap: () => _showConfirmationDialog("reject"),
                  child: Text(
                    "REJECT".tr(context),
                    style: AppTextStyles.sofiaSansMedium(
                      fontSize: 16.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                MainButton(
                  label: "ACCEPT".tr(context),
                  color: AppColors.blue,
                  labelStyle: AppTextStyles.sofiaSansMedium(
                    fontSize: 16.sp,
                    color: AppColors.white,
                  ),
                  applySize: false,
                  applyShadow: true,
                  borderRadius: 100.r,
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
                  onTap: () => _showConfirmationDialog("accept"),
                ),
              ] else
                MainButton(
                  label: player.isApproved || player.isAccepted
                      ? "PAY_MY_SHARE".trU(context)
                      : "WITHDRAW_FROM_THE_MATCH".trU(context),
                  color: AppColors.blue,
                  labelStyle: AppTextStyles.sofiaSansMedium(
                    fontSize: 16.sp,
                    color: AppColors.white,
                  ),
                  applySize: false,
                  applyShadow: true,
                  borderRadius: 8.r,
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
                  onTap: () {
                    if (player.isApproved || player.isAccepted) {
                      widget.onJoin(player.customer!.id!);
                    } else {
                      widget.onWithdraw(player.id!);
                    }
                  },
                )
            ],
          ),
        ),
      ],
    );
  }
}
