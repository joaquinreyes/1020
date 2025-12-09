import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/network_circle_image.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/managers/user_manager.dart';
import 'package:hop/screens/app_provider.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/box_shadow/flutter_inset_box_shadow.dart' as inset;

class NavBar extends ConsumerStatefulWidget {
  const NavBar({Key? key}) : super(key: key);
  static const id = "NavBar";

  @override
  ConsumerState<NavBar> createState() => NavBarState();
}

class NavBarState extends ConsumerState<NavBar> {
  reload() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = ref.watch(pageIndexProvider);
    return Container(
      height: 80.h,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.r),
          topRight: Radius.circular(5.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: _insetContainer(
        child: Row(
          children: [
            _item(
              text: 'PLAY_N_MATCH'.trU(context),
              index: 0,
              textHeight: 0.99,
              isSelected: pageIndex == 0,
              onTap: () async {
                if (pageIndex != 0) {
                  ref.read(pageIndexProvider.notifier).index = 0;
                }
              },
            ),
            _item(
              text: '${'RESERVE'.trU(context)}',
              index: 1,
              textHeight: 0.90,
              isSelected: pageIndex == 1,
              onTap: () async {
                if (pageIndex != 1) {
                  ref.read(pageIndexProvider.notifier).index = 1;
                }
              },
            ),
            // _item(
            //   text: '${'FITNESS'.trU(context)}',
            //   index: 2,
            //   textHeight: 0.90,
            //   isSelected: pageIndex == 2,
            //   onTap: () async {
            //     if (pageIndex != 2) {
            //       ref.read(pageIndexProvider.notifier).index = 2;
            //     }
            //   },
            // ),
            _item(
              text: 'PROFILE'.trU(context),
              index: 2,
              textHeight: 0.90,
              isSelected: pageIndex == 2,
              onTap: () async {
                if (pageIndex != 2) {
                  ref.read(pageIndexProvider.notifier).index = 2;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _item(
      {required String text,
      required int index,
      required bool isSelected,
      required Function() onTap,
      double textHeight = 1}) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          onTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          // height: 40.h,
          // width: 82.w,
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: isSelected ? [kBoxShadow] : null,
            color: isSelected ? AppColors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // if (index == 3) ...[
              //   const _Profile(),
              //   SizedBox(height: 2.h),
              // ],
              Text(
                text,
                style: isSelected
                    ? AppTextStyles.sofiaSansMedium(
                        color: AppColors.white,
                        fontSize: 20.sp,
                        height: textHeight,
                      )
                    : AppTextStyles.sofiaSansMedium(
                        color: AppColors.black70,
                        fontSize: 16.sp,
                        height: textHeight,
                      ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Profile extends ConsumerWidget {
  const _Profile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return NetworkCircleImage(
      path: user?.user?.profileUrl,
      showBG: true,
      borderRadius: BorderRadius.circular(8.r),
      width: 23.w,
      height: 23.h,
      bgColor: AppColors.darkRosewood,
    );
  }
}

Widget _insetContainer({required Widget child}) {
  return Container(
    margin: EdgeInsets.fromLTRB(14.5.w,11.5.h,14.5.w,10.h),
    decoration: inset.BoxDecoration(
      color: AppColors.black5,
      borderRadius: BorderRadius.circular(15.r),
      boxShadow: kInsetShadow,
    ),
    // padding: EdgeInsets.all(4.h),
    child: child,
  );
}
