import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/utils.dart';

class SecondaryImageButton extends StatelessWidget {
  SecondaryImageButton(
      {super.key,
      this.onTap,
      required this.label,
      required this.image,
      double? imageHeight,
      double? imageWidth,
      double? fontSize,
      double? spacing,
      this.color,
      this.decoration,
      this.padding,
      this.isForPopup = false,
      this.textColor,
      this.iconColor,
      this.applyShadow = false,
      this.borderRadius,
      this.labelStyle})
      : imageHeight = imageHeight ?? 15.h,
        imageWidth = imageWidth ?? 15.h,
        fontSize = fontSize ?? 13.sp,
        spacing = spacing ?? 7.w;
  final VoidCallback? onTap;
  final String label;
  final String image;
  final double imageHeight;
  final double imageWidth;
  final double fontSize;
  final Color? color;
  final EdgeInsets? padding;
  final double? spacing;
  final bool isForPopup;
  final Color? textColor;
  final Color? iconColor;
  final bool applyShadow;
  final double? borderRadius;
  final TextStyle? labelStyle;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      decoration: decoration,
      borderRadius: borderRadius != null ? borderRadius! : 12.r,
      color: color ??
          (isForPopup
              ? AppColors.white25
              : AppColors.black5),
      padding: padding,
      applyShadow: isForPopup,
      onTap: () {
        onTap?.call();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            image,
            height: imageHeight,
            width: imageWidth,
            color: isForPopup
                ? iconColor ?? AppColors.white
                : iconColor ?? AppColors.black,
          ),
          SizedBox(width: spacing),
          Text(
            label,
            style: labelStyle != null
                ? labelStyle
                : AppTextStyles.manropeMedium(
                    fontSize: fontSize,
                    color: isForPopup
                        ? textColor ?? AppColors.white
                        : textColor ?? AppColors.black),
          ),
        ],
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  SecondaryButton(
      {super.key,
      this.onTap,
      required this.child,
      this.enabled = true,
      this.color,
      this.decoration,
      this.padding,
      this.borderRadius = 12,
      this.applyShadow = true});
  final VoidCallback? onTap;
  final Widget child;
  final bool enabled;
  final Color? color;
  final EdgeInsets? padding;
  final double borderRadius;
  final bool applyShadow;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Container(
          decoration: decoration ?? BoxDecoration(
            color: color ?? AppColors.black5,
            borderRadius: BorderRadius.circular(borderRadius.r),
            boxShadow: applyShadow ? [kBoxShadow] : null,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius.r),
            onTap: enabled ? onTap : null,
            child: Padding(
              padding: padding ??
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
