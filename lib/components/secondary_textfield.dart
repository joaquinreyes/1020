import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';

class SecondaryTextField extends StatelessWidget {
  final String? labelText;
  final String? errorText;
  final String? helperText;
  final String? hintText;
  final String? initialValue;
  final TextStyle? style;
  final TextStyle? hintTextStyle;
  final int? maxLines;
  final int? minLines;
  final double? height;
  final double? width;
  final bool? obscureText;
  final bool? isDense;
  final bool? readOnly;
  final bool? isError;
  final bool? autofocus;
  final bool hasBorders;
  final bool hasShadow;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final Function(String)? onFieldSubmitted;
  final EdgeInsets? contentPadding;
  final FocusNode? node;
  final TextEditingController? controller;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final InputBorder? border;

  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final Color? fillColor;
  final bool isEnabled;
  final Color? borderColor;
  final Color? cursorColor;
  final double? borderRadius;
  SecondaryTextField({
    this.width,
    this.height,
    this.textInputAction,
    this.prefixIconConstraints,
    this.keyboardType,
    this.validator,
    this.controller,
    this.border,
    this.node,
    this.contentPadding,
    this.obscureText,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.errorText,
    this.suffix,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.textAlign = TextAlign.start,
    this.style,
    this.labelText,
    this.helperText,
    this.hintText,
    this.hintTextStyle,
    this.isDense,
    this.inputFormatters,
    this.hasBorders = true,
    this.hasShadow = false,
    this.readOnly,
    this.maxLines,
    this.minLines,
    this.autofocus,
    this.fillColor,
    this.initialValue,
    this.isError = false,
    this.isEnabled = true,
    this.borderColor,
    this.cursorColor,
    this.borderRadius,
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1 : 0.8,
      child: SizedBox(
        width: width,
        // height: height ?? .h,
        child: TextFormField(
          validator: validator,
          initialValue: initialValue,
          onChanged: onChanged,
          textAlign: textAlign,
          enabled: isEnabled,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onFieldSubmitted,
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          focusNode: node,
          obscureText: obscureText ?? false,
          cursorRadius: Radius.circular(15.r),
          cursorWidth: 1,
          autofocus: autofocus ?? false,
          maxLines: maxLines ?? 1,
          minLines: minLines ?? 1,
          cursorColor: errorText == null
              ? cursorColor ?? AppColors.orange50Popup
              : AppColors.errorColor,
          style: style ??
              AppTextStyles.manropeMedium(
                height: 1,
                color: AppColors.white,
                ////fontFamily: kPirulen,
                fontSize: 13.sp,
              ),
          decoration: InputDecoration(
            fillColor: fillColor ?? AppColors.white25,
            filled: fillColor != null,
            contentPadding: contentPadding ??
                EdgeInsets.symmetric(
                  vertical: 6.h,
                ),
            alignLabelWithHint: true,
            labelText: labelText,
            labelStyle: AppTextStyles.manropeBold(),
            helperText: helperText,
            hintText: hintText,
            hintStyle: hintTextStyle ??
                AppTextStyles.manropeMedium(
                  height: 1,
                  color: AppColors.white55,
                  fontSize: 13.sp,
                ),
            prefixIcon: prefixIcon,
            prefixIconConstraints:
            prefixIconConstraints ??
                BoxConstraints.tightFor(width: 50.h, height: 45.h),
            suffixIconConstraints:
                BoxConstraints.tightFor(width: 22.w, height: 30.w),
            errorText: errorText,
            suffix: suffix,
            suffixIcon: suffixIcon,
            prefix: prefix,
            isDense: true,
            border: border ??
                UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 0.r),
                  borderSide:
                      BorderSide(color: borderColor ?? AppColors.transparentColor),
                ),
            disabledBorder: border ??
                UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 0.r),
                  borderSide:
                      BorderSide(color: borderColor ?? AppColors.transparentColor),
                ),
            enabledBorder: border ??
                UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 0.r),
                  borderSide:
                      BorderSide(color: borderColor ?? AppColors.transparentColor),
                ),
            focusedBorder: border ??
                UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 0.r),
                  borderSide:
                      BorderSide(color: borderColor ?? AppColors.transparentColor),
                ),
          ),
        ),
      ),
    );
  }
}
