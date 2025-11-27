import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/components/network_circle_image.dart';
import 'package:hop/components/secondary_text.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/follow_list.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:hop/routes/app_routes.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../app_styles/app_colors.dart';
import '../app_styles/app_text_styles.dart';
import '../globals/constants.dart';
import '../repository/user_repo.dart';
import 'custom_dialog.dart';

class FollowingFollowerComponent extends ConsumerWidget {
  const FollowingFollowerComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followingList = ref.watch(getFollowingListProvider);

    return followingList.when(
      data: (data) {
        final count = data.count ?? 0;
        return GestureDetector(
          onTap: () {
            _showFollowingListDialog(context, ref, data);
          },
          child: Container(
            height: 24.h,
            width: 105.w,
            decoration: BoxDecoration(
                color: AppColors.yellow30,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.black2.withOpacity(0.05)),
                boxShadow: [kBoxShadow]),
            alignment: Alignment.center,
            child: Text(
              "FOLLOWING".tr(context) + " $count",
              style: AppTextStyles.manropeMedium(
                fontSize: 13.sp,
                color: AppColors.black2,
              ),
            ),
          ),
        );
      },
      loading: () => Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: SizedBox(
          width: 60.w,
          height: 16.h,
          child: const Center(
            child: CupertinoActivityIndicator(
              radius: 8,
            ),
          ),
        ),
      ),
      error: (error, stack) {
        myPrint("Error loading following list: $error");
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.yellow,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            "FOLLOWING".trU(context) + " 0",
            style: AppTextStyles.sofiaSansMedium(
              fontSize: 13.sp,
              color: AppColors.black2,
            ),
          ),
        );
      },
    );
  }

  void _showFollowingListDialog(
      BuildContext context, WidgetRef ref, FollowList data) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
            color: AppColors.white,
            closeIconColor: AppColors.black2,
            child: FollowingList());
      },
    );
  }
}


class FollowingList extends ConsumerStatefulWidget {
  const FollowingList({super.key});

  @override
  ConsumerState<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends ConsumerState<FollowingList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final followingList = ref.watch(getFollowingListProvider);

    return followingList.when(
      data: (data) {
        final count = data.count ?? 0;

        return Column(
          children: [
            Text(
              "FOLLOWING".trU(context) + " $count",
              style: AppTextStyles.sofiaSansMedium(
                fontSize: 19.sp,
                color: AppColors.black2,
              ),
            ),
            SizedBox(height: 15.h),
            if (data.following == null || data.following!.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Center(
                  child: Text(
                    "NO_FOLLOWING_FOUND".tr(context),
                    style: AppTextStyles.manropeMedium(
                      fontSize: 14.sp,
                      color: AppColors.black2,
                    ),
                  ),
                ),
              ),
            if (data.following != null && data.following!.isNotEmpty)
              Container(
                constraints: BoxConstraints(
                  maxHeight: 400.h,
                ),
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thumbColor: WidgetStateProperty.all(AppColors.darkGray50),
                    trackColor: WidgetStateProperty.all(AppColors.white),
                    trackBorderColor:
                        WidgetStateProperty.all(Colors.transparent),
                    thickness: WidgetStateProperty.all(10),
                    radius: Radius.circular(5.r),
                  ),
                  child: Scrollbar(
                    controller: _scrollController,
                    interactive: true,
                    trackVisibility: true,
                    thickness: 8,
                    radius: Radius.circular(4.r),
                    thumbVisibility: true,
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(right: 15),
                      controller: _scrollController,
                      itemCount: data.following!.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final user = data.following![index];
                        return _FollowingUserItem(user: user);
                      },
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: SizedBox(
          width: 60.w,
          height: 16.h,
          child: const Center(
            child: CupertinoActivityIndicator(
              radius: 8,
              color: AppColors.black2,
            ),
          ),
        ),
      ),
      error: (error, stack) {
        return SecondaryText(text: "NO_FOLLOWING_FOUND".tr(context));
      },
    );
  }
}

class _FollowingUserItem extends ConsumerWidget {
  final Following user;

  const _FollowingUserItem({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final userLevel = user.following?.level(kSportName) ?? 0;
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            ref
                .read(goRouterProvider)
                .push("${RouteNames.rankingProfile}/${user.following?.id ?? 0}");
          },
          child: Row(
            children: [
              NetworkCircleImage(
                path: user.following?.profileUrl,
                width: 40.h,
                height: 40.h,
                showBG: true,
                bgColor: AppColors.black2,
                logoColor: AppColors.white,
                borderRadius: BorderRadius.circular(8.r),
                applyShadow: false,
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.following?.fullName.toUpperCase() ?? "",
                    style: AppTextStyles.sofiaSansMedium(
                      fontSize: 12.sp,
                      color: AppColors.black2,
                    ),
                  ),
                  // Text(
                  //   "${userLevel.toStringAsFixed(2)} ${getRankLabel(userLevel ?? 0)}• ${user.following?.playingSide ?? ""}",
                  //   style: AppTextStyles.qanelasRegular(
                  //     fontSize: 12.sp,
                  //     color: AppColors.black2.withOpacity(0.7),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () async {
            await _showUnfollowConfirmation(context, ref, user);
            // Refresh the following list
            ref.invalidate(getFollowingListProvider);
          },
          child: Container(
            height: 24.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.black2.withOpacity(0.05)),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [kBoxShadow]),
            alignment: Alignment.center,
            child: Text(
              "UNFOLLOW".tr(context),
              style: AppTextStyles.manropeMedium(
                fontSize: 13.sp,
                color: AppColors.black2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showUnfollowConfirmation(
      BuildContext context, WidgetRef ref, Following user) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomDialog(
          color: AppColors.white,
          closeIconColor: AppColors.black2,
          child: Column(
            children: [
              Text(
                "ARE_YOU_SURE_UNFOLLOW_PLAYER".trU(context),
                textAlign: TextAlign.center,
                style: AppTextStyles.sofiaSansMedium(
                  fontSize: 19.sp,
                  color: AppColors.black2,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "UNFOLLOW_PLAYER_DESCRIPTION".tr(context),
                textAlign: TextAlign.center,
                style: AppTextStyles.manropeMedium(
                  fontSize: 14.sp,
                  color: AppColors.black2,
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () async {
                  await _performUnfollow(context, ref, user);
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "YES_UNFOLLOW".trU(context),
                    style: AppTextStyles.manropeBold(
                      fontSize: 18.sp,
                      color: AppColors.black2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _performUnfollow(
      BuildContext context, WidgetRef ref, Following user) async {
    try {
      final provider = unfollowFriendProvider(userId: user.following?.id ?? 0);
      await Utils.showLoadingDialog(context, provider, ref);

      if (context.mounted) {
        // Show success dialog
        await showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
              color: AppColors.white,
              closeIconColor: AppColors.black2,
              child: Column(
                children: [
                  Text(
                    "YOU_JUST_UNFOLLOWED_PLAYER".trU(context),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.sofiaSansMedium(
                      fontSize: 16.sp,
                      color: AppColors.black2,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      myPrint("Error unfollowing: $e");
    }
  }
}
