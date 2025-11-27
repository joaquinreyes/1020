import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/box_shadow/flutter_inset_box_shadow.dart' as inset;
import 'package:hop/screens/home_screen/tabs/profile_tab/tabs/booking_profile_tab/user_bookings_list.dart';
import 'package:hop/utils/custom_extensions.dart';
import '../../../../../../app_styles/app_colors.dart';
import '../../../../../../app_styles/app_text_styles.dart';
import '../../../../../../globals/constants.dart';

part 'booking_profile_tab_provider.dart';

class BookingProfileTab extends ConsumerStatefulWidget {
  const BookingProfileTab({super.key});

  @override
  ConsumerState<BookingProfileTab> createState() => _BookingProfileTabState();
}

class _BookingProfileTabState extends ConsumerState<BookingProfileTab> {
  @override
  void initState() {
    super.initState();
    Future(() {
      ref.invalidate(_selectedTabIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(_bookingPageController);
    ref.listen(
      _selectedTabIndex,
      (previous, next) {
        if (next == previous) return;
        ref.read(_bookingPageController.notifier).state.animateToPage(next,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);
      },
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            width: 180.w,
            alignment: AlignmentDirectional.centerStart,
            decoration: inset.BoxDecoration(
              color: AppColors.black5,
              boxShadow: kInsetShadow,
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _pageSelectorItem(
                    ref: ref, text: 'UPCOMING'.tr(context), index: 0),
                _pageSelectorItem(ref: ref, text: 'PAST'.tr(context), index: 1),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ExpandablePageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: _pages,
        ),
      ],
    );
  }

  Widget _pageSelectorItem({
    required WidgetRef ref,
    required String text,
    required int index,
  }) {
    final selectedTab = ref.watch(_selectedTabIndex);
    final isSelected = selectedTab == index;
    return Expanded(
      flex: 15,
      child: InkWell(
          onTap: () {
            if (selectedTab != index) {
              ref.read(_selectedTabIndex.notifier).state = index;
            }
          },
          child: Container(
            // height: 30.h,
            constraints: kComponentWidthConstraint,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 5.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
                color: isSelected ? AppColors.blue : Colors.transparent),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text,
                    textAlign: TextAlign.center,
                    style: isSelected
                        ? AppTextStyles.manropeSemiBold(
                            fontSize: 14.sp,
                            color: AppColors.white,
                          ).copyWith(height: 1.2)
                        : AppTextStyles.manropeMedium(
                            color: AppColors.black70,
                            fontSize: 13.sp,
                          ))
              ],
            ),
          )),
    );
  }
}
