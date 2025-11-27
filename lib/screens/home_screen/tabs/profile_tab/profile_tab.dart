import 'dart:io';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hop/box_shadow/flutter_inset_box_shadow.dart' as inset;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/models/user_membership.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:hop/components/following_follower_component.dart';
import 'package:hop/components/image_src_sheet.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/components/multi_style_text.dart';
import 'package:hop/components/network_circle_image.dart';
import 'package:hop/components/secondary_button.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/managers/user_manager.dart';
import 'package:hop/repository/booking_repo.dart';
import 'package:hop/repository/user_repo.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:hop/routes/app_routes.dart';
import 'package:hop/screens/home_screen/tabs/play_match_tab/tabs/tab_parent.dart';
import 'package:hop/screens/home_screen/tabs/profile_tab/tabs/booking_profile_tab/booking_profile_tab.dart';
import 'package:hop/screens/home_screen/tabs/profile_tab/tabs/membership_tab/membership_tab.dart';
import 'package:hop/screens/home_screen/tabs/profile_tab/tabs/settings.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../../../../globals/current_platform.dart';
import '../../../../repository/payment_repo.dart';
import '../../../payment_information/payment_information.dart';
import '../../../ranking_profile/ranking_profile.dart';

part 'profile_tab_components.dart';

part 'profile_tab_provider.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  late List<Widget> _pages = [];

  @override
  void initState() {
    setPages(context);
    super.initState();
  }

  void setPages(BuildContext context) {
    Future(() {
      ref.read(_selectedTabIndex.notifier).state = 0;
      ref.invalidate(fetchUserProvider);
      ref.invalidate(fetchAllCustomFieldsProvider);
    });
    _pages = [const BookingProfileTab(), const Settings(), MembershipTab()];
  }

  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(_profilePageController);
    ref.listen(
      _selectedTabIndex,
      (previous, next) {
        if (next == previous) return;
        ref.read(_profilePageController.notifier).state.animateToPage(next,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);
      },
    );
    return PlayTabsParentWidget(
      onRefresh: () {
        int index = ref.read(_selectedTabIndex);
        if (index == 0) {
          return ref.refresh(fetchUserAllBookingsProvider.future);
        } else if (index == 2) {
          return ref.refresh(fetchActiveAndAllMembershipsProvider.future);
        }
        return ref.refresh(fetchUserProvider.future);
      },
      child: Column(
        children: [
          SizedBox(height: 10.h),
          const _HeaderInfo(),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 15.h),
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            decoration: inset.BoxDecoration(
              color: AppColors.black5,
              boxShadow: kInsetShadow,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _pageSelectorItem(text: 'BOOKINGS'.tr(context), index: 0),
                _pageSelectorItem(text: 'SETTINGS'.tr(context), index: 1),
                _pageSelectorItem(text: 'PACKAGES'.tr(context), index: 2),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: ExpandablePageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageSelectorItem({
    required String text,
    required int index,
  }) {
    final selectedTab = ref.watch(_selectedTabIndex);
    bool isSelected = selectedTab == index;
    return Expanded(
      // flex: index == 3 ? 20 : 15,
      child: InkWell(
          onTap: () {
            if (selectedTab != index) {
              ref.read(_selectedTabIndex.notifier).state = index;
            }
          },
          child: Container(
            height: 40.h,
            constraints: kComponentWidthConstraint,
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
            ),
            margin: EdgeInsets.symmetric(
              vertical: 4.h,
              horizontal: 4.w
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
                color: isSelected ? AppColors.blue : Colors.transparent),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: isSelected
                      ? GoogleFonts.dmSans(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        )
                      : GoogleFonts.dmSans(
                          color: AppColors.black70,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                ),
              ],
            ),
          )),
    );
  }
}
