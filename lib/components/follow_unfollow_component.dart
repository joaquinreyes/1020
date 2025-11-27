import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../app_styles/app_colors.dart';
import '../app_styles/app_text_styles.dart';
import '../globals/constants.dart';
import '../repository/user_repo.dart';
import 'custom_dialog.dart';

class FollowUnfollowComponent extends ConsumerStatefulWidget {
  final int customerID;

  const FollowUnfollowComponent({super.key, required this.customerID});

  @override
  ConsumerState<FollowUnfollowComponent> createState() =>
      _FollowUnfollowComponentState();
}

class _FollowUnfollowComponentState
    extends ConsumerState<FollowUnfollowComponent> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final provider =
        ref.watch(checkFollowStatusProvider(userId: widget.customerID));

    return provider.when(
      data: (data) {
        final isFollowing = data;

        if (isFollowing) {
          // Show expandable button for "Following"
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Container(
                  height: 24.h,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    // border: Border.all(color: AppColors.black2.withOpacity(0.05)),
                    borderRadius: isExpanded
                        ? BorderRadius.only(
                            topLeft: Radius.circular(12.r),
                            topRight: Radius.circular(12.r),
                          )
                        : BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "FOLLOWING".tr(context),
                        style: AppTextStyles.sofiaSansMedium(
                          fontSize: 13.sp,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 18.sp,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isExpanded = false;
                    });
                    await _showUnfollowConfirmationDialog(context, ref);
                    ref.invalidate(checkFollowStatusProvider);
                  },
                  child: Container(
                    height: 24.h,
                    padding: EdgeInsets.symmetric(horizontal: 28.w),

                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.r),
                        bottomRight: Radius.circular(12.r),
                      ),
                      border: Border.all(
                        color: AppColors.black2.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "UNFOLLOW".tr(context),
                      style: AppTextStyles.sofiaSansMedium(
                        fontSize: 13.sp,
                        color: AppColors.black2,
                      ),
                    ),
                  ),
                ),
            ],
          );
        } else {
          // Show regular button for "Follow"
          return GestureDetector(
            onTap: () async {
              await _showFollowConfirmationDialog(context, ref);
              ref.invalidate(checkFollowStatusProvider);
            },
            child: Container(
              height: 24.h,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(100.r),
              ),
              alignment: Alignment.center,
              child: Text(
                "FOLLOW".tr(context),
                style: AppTextStyles.sofiaSansMedium(
                  fontSize: 13.sp,
                  color: AppColors.brick,
                ),
              ),
            ),
          );
        }
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (error, stack) {
        myPrint("stack: $stack");
        return Center(child: Text(error.toString()));
      },
    );
  }

  Future<void> _showFollowConfirmationDialog(BuildContext context, WidgetRef ref) {
   return  showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          color: AppColors.brick,
          closeIconColor: AppColors.white,
          child: Column(
            children: [
              Text(
                "ARE_YOU_SURE_FOLLOW_PLAYER".trU(context),
                textAlign: TextAlign.center,
                style: AppTextStyles.popupHeaderTextStyle,
              ),
              SizedBox(height: 10.h),
              Text(
                "FOLLOW_PLAYER_DESCRIPTION".tr(context),
                textAlign: TextAlign.center,
                style: AppTextStyles.popupBodyTextStyle,
              ),
              SizedBox(height: 20.h),
              MainButton(
                isForPopup: true,
                onTap: () async {
                  await _performFollow(context, ref);
                  Navigator.of(context).pop();
                },
                label: "YES_FOLLOW".trU(context),
              ),
              // GestureDetector(
              //   onTap: () async {
              //     await _performFollow(context, ref);
              //     Navigator.of(context).pop();
              //   },
              //   child: Container(
              //     width: double.infinity,
              //     padding: EdgeInsets.symmetric(vertical: 12.h),
              //     decoration: BoxDecoration(
              //       color: AppColors.yellow,
              //       borderRadius: BorderRadius.circular(12.r),
              //     ),
              //     alignment: Alignment.center,
              //     child: Text(
              //       "YES_FOLLOW".trU(context),
              //       style: AppTextStyles.manropeBold(
              //         fontSize: 18.sp,
              //         color: AppColors.black2,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showUnfollowConfirmationDialog(BuildContext context, WidgetRef ref) {
   return showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          color: AppColors.brick,
          closeIconColor: AppColors.white,
          child: Column(
            children: [
              Text(
                "ARE_YOU_SURE_UNFOLLOW_PLAYER".trU(context),
                textAlign: TextAlign.center,
                style: AppTextStyles.popupHeaderTextStyle,
              ),
              SizedBox(height: 10.h),
              Text(
                "UNFOLLOW_PLAYER_DESCRIPTION".tr(context),
                textAlign: TextAlign.center,
                style: AppTextStyles.popupBodyTextStyle,
              ),
              SizedBox(height: 20.h),
              MainButton(
                isForPopup: true,
                label: "YES_UNFOLLOW".trU(context),
                onTap: () async {
                  await _performUnfollow(context, ref);
                  Navigator.of(context).pop();
                },
              ),
              // GestureDetector(
              //   onTap: () async {
              //     await _performUnfollow(context, ref);
              //     Navigator.of(context).pop();
              //   },
              //   child: Container(
              //     width: double.infinity,
              //     padding: EdgeInsets.symmetric(vertical: 12.h),
              //     decoration: BoxDecoration(
              //       color: AppColors.yellow,
              //       borderRadius: BorderRadius.circular(12.r),
              //     ),
              //     alignment: Alignment.center,
              //     child: Text(
              //       "YES_UNFOLLOW".trU(context),
              //       style: AppTextStyles.manropeBold(
              //         fontSize: 18.sp,
              //         color: AppColors.black2,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _performFollow(BuildContext context, WidgetRef ref) async {
    try {
      final provider = followFriendProvider(userId: widget.customerID);
      await Utils.showLoadingDialog(context, provider, ref);
      if (context.mounted) {
        await _showSuccessDialog(
            context, "YOU_ARE_NOW_FOLLOWING_PLAYER".trU(context));
      }
    } catch (e) {
      myPrint("Error following: $e");
    }
  }

  Future<void> _performUnfollow(BuildContext context, WidgetRef ref) async {
    try {
      final provider = unfollowFriendProvider(userId: widget.customerID);
     await Utils.showLoadingDialog(context, provider, ref);
      if (context.mounted) {
        await _showSuccessDialog(context, "YOU_HAVE_UNFOLLOWED_PLAYER".trU(context));
      }
    } catch (e) {
      myPrint("Error unfollowing: $e");
    }
  }

  Future<void> _showSuccessDialog(BuildContext context, String message) async {
   return showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          color: AppColors.brick,
          closeIconColor: AppColors.white,
          child: Column(
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.popupHeaderTextStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}
