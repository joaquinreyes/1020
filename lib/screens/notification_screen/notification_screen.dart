import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/secondary_button.dart';
import 'package:hop/globals/current_platform.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/widgets/background_view.dart';

part 'notification_components.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return BackgroundView(
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.5.w),
            child: Column(
              children: [
                SizedBox(height: 24.h),
                if (!PlatformC().isCurrentDesignPlatformDesktop)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => ref.read(goRouterProvider).pop(),
                      child: Image.asset(
                        AppImages.back_arrow_new.path,
                        height: 24.h,
                        width: 24.h,
                      ),
                    ),
                  ),
                Text(
                  "NOTIFICATIONS".trU(context),
                  style: AppTextStyles.sofiaSansMedium(
                    fontSize: 30.sp,
                  ),
                ),
                40.verticalSpace,
                // const _ClearAllBtn(),
                // 10.verticalSpace,
                // Expanded(
                //     child: ListView.separated(
                //   itemCount: 10,
                //   padding: EdgeInsets.only(bottom: 15.h),
                //   separatorBuilder: (_, __) => 10.verticalSpace,
                //   itemBuilder: (context, index) {
                //     return const NotificationTile();
                //   },
                // ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
