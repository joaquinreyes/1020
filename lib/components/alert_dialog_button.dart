import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/multi_style_text.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/images.dart';

class AlertDialogButton extends StatelessWidget {
  const AlertDialogButton({
    this.label,
    this.onTap,
    this.child,
    this.padding = EdgeInsets.zero,
    this.color,
    this.labelStyle,
    this.textBoldPosition = 1,
    this.labelColor,
    this.applySize = true,
    this.applyShadow = false,
    this.enabled = true,
    this.loading = false,
    this.borderRadius,
    this.height,
    this.width,
    this.constraints,
    this.showArrow = false,
    this.isForPopup = false,
    this.borderColor,
    Key? key,
  }) : super(key: key);

  final String? label;
  final TextStyle? labelStyle;
  final bool applySize;
  final int textBoldPosition;
  final bool applyShadow;
  final bool enabled;
  final bool loading;
  final Color? color;
  final Color? labelColor;
  final VoidCallback? onTap;
  final double? borderRadius;
  final double? height;
  final double? width;
  final BoxConstraints? constraints;
  final EdgeInsets padding;
  final Widget? child;
  final bool showArrow;
  final bool isForPopup;
  final Color? borderColor;

  Color get _defaultBackgroundColor =>
      isForPopup ? AppColors.black2 : AppColors.yellow;

  Color get _backgroundColor => color ?? _defaultBackgroundColor;

  Color get _defaultDisabledColor => AppColors.darkGray50;

  double get effectiveBorderRadius => borderRadius ?? 0.r;

  BoxDecoration get buttonDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        color: enabled ? _backgroundColor : _defaultDisabledColor,
        boxShadow: applyShadow
            ? [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.10),
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                )
              ]
            : null,
      );

  BoxDecoration get containerDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        color: Colors.transparent,
        border: Border.all(
          color: enabled
              ? (borderColor ?? Colors.transparent)
              : _defaultDisabledColor,
          width: 1,
        ),
      );

  double? get effectiveHeight => height ?? (applySize ? 40.h : null);

  double? get effectiveWidth => width ?? (applySize ? 294.w : null);

  BoxConstraints? get effectiveConstraints =>
      constraints ?? (applySize ? kComponentWidthConstraint : null);

  Widget _buildContent() {
    if (loading) {
      return _buildLoadingIndicator();
    }
    if (child != null) {
      return child!;
    }
    return _buildLabel();
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 25.h,
      width: 25.h,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(labelColor),
      ),
    );
  }

  Widget _buildLabel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: (showArrow && !isForPopup)
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isForPopup) ...[
            _popupLabel,
          ] else ...[
            Text(
              label ?? '',
              textAlign: TextAlign.center,
              style: _labelTextStyle,
            ),
          ],
          if (showArrow && !isForPopup) _buildArrowIcon(),
        ],
      ),
    );
  }

  Widget get _popupLabel {
    if (enabled) {
      return MultiStyleTextFirstPositionBold(
        text: label ?? "",
        fontSize: 18.sp,
        color: AppColors.black,
        textBoldPosition: textBoldPosition,
      );
    } else {
      return Text(
        label ?? '',
        textAlign: TextAlign.center,
        style: _labelTextStyleForPopup,
      );
    }
  }

  TextStyle get _labelTextStyle {
    if (enabled) {
      return labelStyle ??
          AppTextStyles.manropeLight(
            color: AppColors.white,
            fontSize: 18.sp,
          );
    } else {
      return labelStyle ??
          AppTextStyles.manropeLight(
            color: AppColors.white,
            fontSize: 18.sp,
          );
    }
  }

  TextStyle get _labelTextStyleForPopup {
    if (enabled) {
      return labelStyle ??
          AppTextStyles.manropeBold(
              color: AppColors.yellow, fontSize: 18.sp);
    } else {
      return labelStyle ??
          AppTextStyles.manropeLight(color: AppColors.white, fontSize: 18.sp);
    }
  }

  Widget _buildArrowIcon() {
    return Image.asset(
      AppImages.rightArrow.path,
      height: 18.h,
      width: 18.h,
      color: labelStyle?.color ??
          labelColor ??
          (enabled ? AppColors.white : AppColors.white),
    );
  }

  void _handleTap() {
    if (!loading && enabled && onTap != null) {
      onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      decoration: containerDecoration,
      child: InkWell(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        onTap: _handleTap,
        child: Container(
          height: effectiveHeight,
          width: effectiveWidth,
          decoration: buttonDecoration,
          padding: padding,
          constraints: effectiveConstraints,
          child: Center(
            child: AnimatedSwitcher(
              duration: kAnimationDuration,
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }
}

// class MainButton extends StatelessWidget {
//   const MainButton({
//     this.label,
//     this.onTap,
//     this.child,
//     this.padding = EdgeInsets.zero,
//     this.color,
//     this.labelStyle,
//     this.labelColor,
//     this.applySize = true,
//     this.applyShadow = false,
//     this.enabled = true,
//     this.loading = false,
//     this.borderRadius,
//     this.height,
//     this.width,
//     this.constraints,
//     this.showArrow = false,
//     this.isForPopup = false,
//     this.borderColor,
//     Key? key,
//   }) : super(key: key);

//   final String? label;
//   final TextStyle? labelStyle;
//   final bool applySize;
//   final bool applyShadow;
//   final bool enabled;
//   final bool loading;
//   final Color? color;
//   final Color? labelColor;
//   final VoidCallback? onTap;
//   final double? borderRadius;
//   final double? height;
//   final double? width;
//   final BoxConstraints? constraints;
//   final EdgeInsets padding;
//   final Widget? child;
//   final bool showArrow;
//   final bool isForPopup;
//   final Color? borderColor;

//   Color get _defaultBackgroundColor =>
//       isForPopup ? AppColors.brightGold : AppColors.brightGold;

//   Color get _backgroundColor => color ?? _defaultBackgroundColor;

//   Color get _defaultDisabledColor => AppColors.black25;

//   double get effectiveBorderRadius => borderRadius ?? 12.r;

//   BoxDecoration get buttonDecoration => BoxDecoration(
//         borderRadius: BorderRadius.circular(effectiveBorderRadius),
//         color: enabled ? _backgroundColor : _defaultDisabledColor,
//         boxShadow: applyShadow
//             ? [
//                 BoxShadow(
//                   color: const Color(0xFF000000).withOpacity(0.10),
//                   offset: const Offset(0, 4),
//                   blurRadius: 4,
//                 )
//               ]
//             : null,
//       );

//   BoxDecoration get containerDecoration => BoxDecoration(
//         borderRadius: BorderRadius.circular(effectiveBorderRadius),
//         color: Colors.transparent,
//         border: Border.all(
//           color: enabled
//               ? (borderColor ?? Colors.transparent)
//               : AppColors.darkGreen,
//           width: 1,
//         ),
//       );

//   double? get effectiveHeight => height ?? (applySize ? 40.h : null);

//   double? get effectiveWidth => width ?? (applySize ? 294.w : null);

//   BoxConstraints? get effectiveConstraints =>
//       constraints ?? (applySize ? kComponentWidthConstraint : null);

//   Widget _buildContent() {
//     if (loading) {
//       return _buildLoadingIndicator();
//     }
//     if (child != null) {
//       return child!;
//     }
//     return _buildLabel();
//   }

//   Widget _buildLoadingIndicator() {
//     return SizedBox(
//       height: 25.h,
//       width: 25.h,
//       child: CircularProgressIndicator(
//         strokeWidth: 2,
//         valueColor: AlwaysStoppedAnimation(labelColor),
//       ),
//     );
//   }

//   Widget _buildLabel() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 15.w),
//       child: Row(
//         mainAxisAlignment: (showArrow && !isForPopup)
//             ? MainAxisAlignment.spaceBetween
//             : MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
// if (isForPopup) ...[
//   MultiStyleTextFirstLight(
//     text: label ?? "",
//     fontSize: 18.sp,
//     color: AppColors.black,
//   )
// ] else ...[
//   Text(
//     label ?? '',
//     textAlign: TextAlign.center,
//     style: _labelTextStyle,
//   ),
// ],
//           if (showArrow && !isForPopup) _buildArrowIcon(),
//         ],
//       ),
//     );
//   }

//   TextStyle get _labelTextStyle {
//     if (enabled) {
//       return labelStyle ??
//           AppTextStyles.aeonikRegular18.copyWith(
//             height: 1.2,
//             color: AppColors.blue,
//           );
//     } else {
//       return labelStyle ??
//           AppTextStyles.aeonikRegular18.copyWith(
//             height: 1.2,
//             color: AppColors.blue25,
//           );
//     }
//   }

//   TextStyle get _labelTextStyleForPopup {
//     if (enabled) {
//       return labelStyle ??
//           AppTextStyles.gothamNarrowLight().copyWith(
//             height: 1.2,
//             color: AppColors.darkGreen,
//             fontSize: 18.sp,
//           );
//     } else {
//       return labelStyle ??
//           AppTextStyles.aeonikRegular18.copyWith(
//             height: 1.2,
//             color: AppColors.blue25,
//           );
//     }
//   }

//   Widget _buildArrowIcon() {
//     return Image.asset(
//       AppImages.rightArrow.path,
//       height: 18.h,
//       width: 18.w,
//       color: labelStyle?.color ??
//           labelColor ??
//           (enabled ? AppColors.lightOrange : AppColors.orange),
//     );
//   }

//   void _handleTap() {
//     if (!loading && enabled && onTap != null) {
//       onTap!();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: kAnimationDuration,
//       decoration: containerDecoration,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(effectiveBorderRadius),
//         onTap: _handleTap,
//         child: Container(
//           height: effectiveHeight,
//           width: effectiveWidth,
//           decoration: buttonDecoration,
//           padding: padding,
//           constraints: effectiveConstraints,
//           child: Center(
//             child: AnimatedSwitcher(
//               duration: kAnimationDuration,
//               child: _buildContent(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
