import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/network_circle_image.dart';
import 'package:hop/components/secondary_button.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/models/base_classes/booking_player_base.dart';
import 'package:hop/utils/custom_extensions.dart';
import '../globals/constants.dart';
import '../routes/app_pages.dart';
import '../routes/app_routes.dart';

class ParticipantSlot extends ConsumerWidget {
  const ParticipantSlot({
    super.key,
    required this.player,
    this.isHorizontal = false,
    this.allowTap = true,
    this.onRelease,
    this.showReleaseReserveButton = false,
    this.isWellnessSports = false,
    this.textColor = AppColors.black,
    this.imageBgColor = AppColors.black2,
    this.showLevel = true,
    this.logoColor = AppColors.white,
  });
  final bool allowTap;

  final BookingPlayerBase player;
  final Color textColor;
  final Color imageBgColor;
  final Color logoColor;
  final bool isHorizontal;
  final bool isWellnessSports;
  final Function(int)? onRelease;
  final bool showReleaseReserveButton;
  final bool showLevel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = player.customer?.level(kSportName) ?? "";
    // final level = player.customer?.level(getSportsName(ref)) ?? "";
    final side = player.customer?.playingSide ?? "SIDE";

    if (allowTap) {
      return GestureDetector(
        onTap: () {
          final id = player.customer?.id ?? -1;
          if (player.reserved ?? false) {
            return;
          }
          if (id != -1) {
            ref.read(goRouterProvider).push(
                  "${RouteNames.rankingProfile}/$id",
                );
          }
        },
        child: isHorizontal
            ? _horizontal(context, level, side)
            : _vertical(context, level, side),
      );
    }

    return isHorizontal
        ? _horizontal(context, level, side)
        : _vertical(context, level, side);
  }

  _horizontal(BuildContext context, String level, String side) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _image(),
          SizedBox(width: 15.h),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _text(context),
              if (showLevel &&
                  level.isNotEmpty &&
                  (!(player.reserved ?? true)) && !isWellnessSports) ...[
                SizedBox(height: 2.h),
                _levelSideText(level, side),

              ],
              if (showReleaseReserveButton) ...[
                SecondaryImageButton(
                  image: AppImages.crossIcon.path,
                  color: AppColors.white,
                  applyShadow: false,
                  imageHeight: 8.w,
                  imageWidth: 7.w,
                  spacing: 2.w,
                  fontSize: 10.sp,
                  label: "RELEASE".trU(context),
                  labelStyle: AppTextStyles.manropeMedium(fontSize: 10.sp),
                  onTap: () {
                    onRelease?.call(player.id ?? -1);
                  },
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                )
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _vertical(BuildContext context, String level, String side) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      alignment: Alignment.center,
      width: showReleaseReserveButton ? 68.w : 61.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _image(),
          SizedBox(height: 5.h),
          _text(context),
          if (showLevel && level.isNotEmpty && (!(player.reserved ?? true))  && !isWellnessSports) ...[
            _levelSideText(level, side),
          ] else ...[
            if (!showReleaseReserveButton  && !isWellnessSports) _levelSideText("", ""),
          ],
          if (showReleaseReserveButton) ...[
            SecondaryImageButton(
              image: AppImages.crossIcon.path,
              color: AppColors.white,
              applyShadow: true,
              imageHeight: 8.w,
              imageWidth: 7.w,
              spacing: 2.w,
              fontSize: 10.sp,
              label: "RELEASE".trU(context),
              labelStyle: AppTextStyles.manropeMedium(fontSize: 10.sp),
              onTap: () {
                onRelease?.call(player.id ?? -1);
              },
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            )
          ]
        ],
      ),
    );
  }

  AutoSizeText _levelSideText(String level, String side) {
    // if (level.isEmpty && side.isEmpty) {
    //   return AutoSizeText("");
    // }
    return AutoSizeText(
      // "$level ${(side != "SIDE" && side.isNotEmpty) ? "• $side" : ""} ${getRankLabel(double.tryParse(level) ?? 0)}", //• $side",
      "$level ${(side != "SIDE" && side.isNotEmpty) ? "• $side" : ""}", //• $side",
      textAlign: TextAlign.center,
      maxFontSize: 12.sp,
      minFontSize: 6.sp,
      maxLines: 2,
      stepGranularity: 1.sp,
      style: AppTextStyles.manropeMedium(color: textColor, fontSize: 12.sp),
    );
  }

  AutoSizeText _text(BuildContext context) {
    return AutoSizeText(
      (player.reserved == false)
          ? (player.getCustomerName).toUpperCase()
          : "RESERVED".trU(context),
      textAlign: TextAlign.center,
      maxFontSize: 15.sp,
      minFontSize: 9.sp,
      maxLines: 1,
      stepGranularity: 1.sp,
      style: AppTextStyles.sofiaSansMedium(
        fontSize: 15.sp,
          color: textColor,),
    );
  }

  Widget _image() {
    return NetworkCircleImage(
      path: (player.reserved == false) ? player.customer?.profileUrl : null,
      width: isHorizontal ? 37.w : 37.w,
      height: isHorizontal ? 37.w : 37.w,
      bgColor: imageBgColor,
      logoColor: logoColor,
      showBG: true,
      borderRadius: BorderRadius.circular(6.r),
      boxBorder: Border.all(color: AppColors.white25),
      // applyShadow: false,
    );
  }
}
