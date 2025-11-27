import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';

class SelectedTag extends StatelessWidget {
  SelectedTag(
      {super.key,
      required this.isSelected,
      double? width,
      double? height,
      this.unSelectedColor = AppColors.alysumWhite,
      this.unSelectedBorderColor = AppColors.black,
      this.shape,
      this.selectedColor,
      this.selectedBorderColor})
      : width = width ?? 15.w,
        height = height ?? 18.w;
  final bool isSelected;
  final double width;
  final double height;
  final Color unSelectedBorderColor;
  final Color unSelectedColor;
  final Color? selectedColor;
  final BoxShape? shape;
  final Color? selectedBorderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18.h,
      width: 18.w,
      decoration: BoxDecoration(
          color: !isSelected
              ? unSelectedColor
              : selectedColor ?? AppColors.black,
          border: Border.all(
            color: isSelected
                ? selectedBorderColor != null
                    ? selectedBorderColor!
                    : AppColors.white
                : unSelectedBorderColor,
            width: 1.w,
          ),
          shape: shape != null ? shape! : BoxShape.circle),
    );
  }
}
