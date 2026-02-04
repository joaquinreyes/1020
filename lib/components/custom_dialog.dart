import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/globals/images.dart';

class CustomDialog extends StatelessWidget {
  CustomDialog(
      {super.key,
      required this.child,
      this.height,
      this.color = AppColors.brick,
      this.borderRadius,
      EdgeInsets? contentPadding,
      this.showCloseIcon = true,
      this.closeIconColor,
      this.physics,
      this.closeIconPadding,
      this.onTapCloseIcon,
      this.maxHeight})
      : _contentPadding = contentPadding ??
            // EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h);
            EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h, bottom: 30.h);

  final Widget child;
  final double? height;
  final Color color;
  final BorderRadius? borderRadius;
  final EdgeInsets _contentPadding;
  final EdgeInsets? closeIconPadding;
  final bool showCloseIcon;
  final Color? closeIconColor;
  final double? maxHeight;
  final ScrollPhysics? physics;
  final Function? onTapCloseIcon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            width: 344.w,
            height: height,
            constraints: maxHeight != null
                ? BoxConstraints(maxHeight: maxHeight!)
                : null,
            padding: _contentPadding,
            decoration: BoxDecoration(
              color: color,
              borderRadius: borderRadius ?? BorderRadius.circular(5.r),
            ),
            child: SingleChildScrollView(
              physics: physics ?? BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showCloseIcon) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: (){
                          if(onTapCloseIcon != null) {
                            onTapCloseIcon!();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Padding(
                          padding: closeIconPadding ??
                              EdgeInsets.only(
                                right: 6.5.w,
                              ),
                          child: Image.asset(
                            AppImages.closeIcon.path,
                            width: 12.h,
                            height: 12.h,
                            color: closeIconColor ?? AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
