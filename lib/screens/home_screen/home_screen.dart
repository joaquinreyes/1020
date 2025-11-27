import 'dart:io';
import 'package:hop/components/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/CustomDatePicker/flutter_datetime_picker.dart';
import 'package:hop/CustomDatePicker/src/date_model.dart';
import 'package:hop/CustomDatePicker/src/i18n_model.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/image_src_sheet.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/components/network_circle_image.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/current_platform.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/managers/api_manager.dart';
import 'package:hop/managers/dynamic_link_handler.dart';
import 'package:hop/managers/fcm_manager.dart';
import 'package:hop/managers/shared_pref_manager.dart';
import 'package:hop/managers/socket_manager/socket_manager.dart';
import 'package:hop/managers/user_manager.dart';
import 'package:hop/repository/location_repo.dart';
import 'package:hop/repository/user_repo.dart';
import 'package:hop/screens/app_provider.dart';
import 'package:hop/screens/home_screen/nav_bar.dart';
import 'package:hop/screens/home_screen/tabs/booking_tab/booking_tab.dart';
import 'package:hop/screens/home_screen/tabs/play_match_tab/play_match_tab.dart';
import 'package:hop/screens/home_screen/tabs/profile_tab/profile_tab.dart';
import 'package:hop/screens/home_screen/tabs/wellness_tab/wellness_tab.dart';
import 'package:hop/screens/responsive_widgets/home_responsive_widget.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/utils/dubai_date_time.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hop/widgets/background_view.dart';

import '../../main.dart';
import 'booking_cart/booking_cart.dart';

part 'home_screen_components.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {



  List<int> sportsIdList = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      globalRef = ref;
      FcmManager().initialize(isInitialize: true);

      DynamicLinkHandler.instance.initialize(ref);
      final userID = ref.read(userManagerProvider).user?.user?.id;
      final token = ref.read(userManagerProvider).user?.accessToken;
      if (userID != null && token != null) {
        ref.read(socketProvider.notifier).connect(
              kClubID,
              userID,
              token,
            );
      }
      // final user = ref.read(userManagerProvider).user;
      // final image = user?.user?.profileUrl;
      // final startedPlaying = user?.user?.startedPlaying;
      // final bool selectImage = image?.isEmpty ?? true;
      // final bool selectDate = (startedPlaying?.isEmpty ?? true) && (user?.user?.preferredSport ?? "").toLowerCase() != "wellness";
      // final bool hasDialogShown = ref.read(sharedPrefManagerProvider).hasProfilePictureDialogShown();

      // if ((selectImage || selectDate) && Utils.checkUserLogin(ref) && !hasDialogShown) {
      //   showDialog(
      //     context: context,
      //     builder: (context) {
      //       return _AddProfilePicture(
      //         selectDate: selectDate,
      //         selectImage: selectImage,
      //       );
      //     },
      //   );
      //   // Mark dialog as shown
      //   ref.read(sharedPrefManagerProvider).setProfilePictureDialogShown(true);
      // }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final dateRange = ref.watch(dateRangeProvider);

    final locationIDs = ref.watch(selectedLocationProvider);
    List<int> locationIdList = [...locationIDs];




    ref.watch(fetchLocationProvider);
    ref.listen(
      pageIndexProvider,
      (previous, next) {
        if (previous != next) {
          ref.read(pageControllerProvider).animateToPage(
                next,
                duration: kAnimationDuration,
                curve: Curves.linear,
              );
        }
      },
    );
    final pageController = ref.watch(pageControllerProvider);
    return BackgroundView(
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(allowAddToCart)
              BookingCart(),
              if (!(PlatformC().isCurrentDesignPlatformDesktop)) NavBar(),
            ],
          ),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowIndicator();
            return true;
          },
          child: SafeArea(
            child: HomeResponsiveWidget(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                children: [
                  const PlayMatchTab(),
                  const BookingTab(),
                  // WellnessTab(
                  //   start: dateRange.startDate!,
                  //   end: dateRange.endDate!,
                  //   locationIds: locationIdList,
                  //   sportsIds: sportsIdList
                  // ),
                  const ProfileTab(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
