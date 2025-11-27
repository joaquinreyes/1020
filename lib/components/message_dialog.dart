import 'package:hop/components/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';

class MessageDialog extends StatelessWidget {
  const MessageDialog({super.key, required this.message, this.backgroundColor});
  final String message;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      color: backgroundColor ?? AppColors.brick,
      contentPadding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 45.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.toUpperCase(),
            style: AppTextStyles.popupHeaderTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class MessageDialog2 extends StatelessWidget {
  const MessageDialog2({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      contentPadding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 45.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // MultiStyleTextFirstLight(text: message, fontSize: 19.sp, color: AppColors.white,),
          Text(
            message,
            style: AppTextStyles.popupHeaderTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
