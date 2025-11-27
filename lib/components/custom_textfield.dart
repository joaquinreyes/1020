import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText, helperText, hintText, initialValue;
  final TextStyle? style, hintTextStyle;
  final int? maxLines, minLines;
  final double? height, width;
  final bool? obscureText, isDense, readOnly, autofocus;
  final bool hasBorders, isForPopup, isRequired;
  final Function(String)? onChanged, onFieldSubmitted;
  final Function()? onEditingComplete;
  final EdgeInsets? contentPadding;
  final FocusNode node;
  final TextEditingController controller;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix, suffixIcon, prefix, prefixIcon;
  final Color? fillColor, borderColor;
  final String? Function(String?)? validator;
  final InputBorder? border;
  final BorderRadius? borderRadius;

  const CustomTextField({
    this.width,
    this.height,
    this.border,
    this.textInputAction,
    this.keyboardType,
    this.textCapitalization,
    required this.controller,
    required this.node,
    this.contentPadding,
    this.obscureText,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.suffix,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.style,
    this.labelText,
    this.helperText,
    this.hintText,
    this.hintTextStyle,
    this.isDense = true,
    this.hasBorders = true,
    this.readOnly,
    this.maxLines,
    this.minLines,
    this.autofocus,
    this.fillColor,
    this.initialValue,
    this.borderColor,
    this.isForPopup = false,
    this.validator,
    this.borderRadius,
    this.isRequired = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => node.hasFocus ? null : node.requestFocus(),
      child: TextFormField(
        initialValue: initialValue,
        controller: controller,
        focusNode: node,
        textAlign: textAlign,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        inputFormatters: inputFormatters,
        readOnly: readOnly ?? false,
        obscureText: obscureText ?? false,
        autofocus: autofocus ?? false,
        maxLines: maxLines ?? 1,
        minLines: minLines ?? 1,
        validator: validator,
        cursorRadius: Radius.circular(15.r),
        cursorWidth: 1.5,
        cursorHeight: 20.h,
        cursorColor: AppColors.brick,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onFieldSubmitted,
        style: style ?? _defaultTextStyle(),
        decoration: _buildInputDecoration(),
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      filled: isForPopup ? true : fillColor != null,
      fillColor: isForPopup ? AppColors.white25 : fillColor,
      contentPadding: contentPadding ??
          EdgeInsets.symmetric(
              vertical: 8.h, horizontal: isForPopup ? 12.w : 0.w),
      alignLabelWithHint: true,
      labelText: labelText,
      labelStyle: isForPopup
          ? AppTextStyles.manropeBold()
          : AppTextStyles.manropeBold(),
      helperText: helperText,
      hintText: hintText,
      hintStyle: hintTextStyle ?? _defaultHintTextStyle(),
      prefix: prefix,
      prefixIcon: prefixIcon,
      prefixIconConstraints: BoxConstraints.tightFor(width: 50.h, height: 45.h),
      suffix: suffix,
      suffixIcon: suffixIcon,
      suffixIconConstraints: BoxConstraints(maxHeight: 16.sp),
      isDense: isDense,
      border: border ?? _getBorder(),
      errorBorder: border ?? _getBorder(color: AppColors.errorColor),
      focusedBorder: border ?? _getBorder(),
      enabledBorder: border ?? _getBorder(),
      disabledBorder: border ?? _getBorder(),
    );
  }

  TextStyle _defaultTextStyle() {
    return isForPopup
        ? AppTextStyles.manropeMedium(
            color: AppColors.white,
            fontSize: 13.sp,
          )
        : AppTextStyles.manropeMedium(
            color: AppColors.black,
            fontSize: 18.sp,
          );
  }

  TextStyle _defaultHintTextStyle() {
    return isForPopup
        ? AppTextStyles.manropeMedium(
           fontSize: 13.sp,
           color: AppColors.white55,
          )
        : AppTextStyles.manropeMedium(
            color: AppColors.black..withOpacity(0.5),
            fontSize: 19.sp,
          );
  }

  UnderlineInputBorder _getBorder({Color color = AppColors.black}) {
    return UnderlineInputBorder(
      borderRadius: borderRadius ?? BorderRadius.zero,
      borderSide: BorderSide(color: borderColor ?? color),
    );
  }
}
