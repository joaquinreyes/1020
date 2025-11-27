import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_styles/app_colors.dart';
import '../app_styles/app_text_styles.dart';
import '../globals/images.dart';

class ChatIconComponent extends StatelessWidget {
  final bool hasUnread;
  final int unreadCount;
  final double? size;

  const ChatIconComponent({
    super.key,
    this.hasUnread = false,
    this.unreadCount = 0,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? 21.w;
    final showCount = hasUnread && unreadCount > 0;
    return SizedBox(
      width: iconSize + (showCount ? 10 : 0),
      height: iconSize + (showCount ? 10 : 0),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            right: showCount ? 10 : 0,
            top: showCount ? 10 : 0,
            child: SizedBox(
              height: 20,
              width: 20,
              child: hasUnread
                  ? Image.asset(AppImages.chatIconUnRead.path)
                  : Image.asset(AppImages.chatIconRead.path),
            ),
          ),
          if (showCount)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 16.w,
                  minHeight: 16.w,
                ),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$unreadCount',
                    style: AppTextStyles.sofiaSansMedium(
                      fontSize: 9.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
