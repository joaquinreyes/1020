import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/current_platform.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:hop/routes/app_routes.dart';
import 'package:hop/screens/auth/auth_responseive.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../../managers/shared_pref_manager.dart';
import '../../repository/club_repo.dart';
import '../app_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return AuthResponsive(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.authBackground.path),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: PlatformC().isCurrentDesignPlatformDesktop ? 30 : 0,
              ),
              child: ConstrainedBox(
                constraints: kComponentWidthConstraint,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(height: 70.h),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(right: 20.0),
                    //     child: GestureDetector(
                    //       onTap: () async {
                    //         await ref.read(sharedPrefManagerProvider).setSkip(true);
                    //         ref.watch(getCourtBookingProvider);
                    //         ref.read(pageIndexProvider.notifier).index = 1;
                    //         ref.invalidate(pageControllerProvider);
                    //         ref.read(goRouterProvider).go(RouteNames.home);
                    //       },
                    //       child: Container(
                    //         height: 24.h,
                    //         width: 120.w,
                    //         decoration: BoxDecoration(
                    //           color: AppColors.yellow
                    //         ),
                    //         alignment: Alignment.center,
                    //         child: Text(
                    //           "SKIP".tr(context),
                    //           style: AppTextStyles.sofiaSansMedium(
                    //             fontSize: 13.sp,
                    //             color: AppColors.black2,
                    //           ),
                    //           textAlign: TextAlign.center,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //
                    // ),
                    const Spacer(),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 50.w),
                    //   child: Image.asset(
                    //     AppImages.splashLogo.path,
                    //     width: double.infinity,
                    //     alignment: Alignment.center,
                    //     // height: 92.h,
                    //   ),
                    // ),
                    // const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 87.w),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                ref.read(goRouterProvider).push(RouteNames.sign_in);
                              },
                              child: Container(
                                height: 40.h,
                                padding: EdgeInsets.symmetric(horizontal: 38.w,vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  border: Border.all(color: AppColors.white,width: 3.w),
                                  borderRadius: BorderRadius.circular(100.r),
                                ),
                                child: Text("SIGN_IN".trU(context),
                                  style: AppTextStyles.sofiaSansMedium(
                                    fontSize: 25.sp,
                                    color: AppColors.brick,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                ref.read(goRouterProvider).push(RouteNames.sign_up);
                              },
                              child: Container(
                                height: 40.h,
                                padding: EdgeInsets.symmetric(horizontal: 33.w,vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: AppColors.white25,
                                  border: Border.all(color: AppColors.white,width: 1.5.w),
                                  borderRadius: BorderRadius.circular(100.r),
                                ),
                                child: Text("REGISTER".trU(context),
                                  style: AppTextStyles.sofiaSansMedium(
                                    fontSize: 23.sp,
                                    color: AppColors.white,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // MainButton(
                    //   label: "SIGN_IN".trU(context),
                    //   borderRadius: 0.r,
                    //   showArrow: true,
                    //   labelStyle: AppTextStyles.sofiaSansMedium(
                    //       color: AppColors.black,
                    //       fontSize: 18.sp,),
                    //   color: AppColors.yellow,
                    //   onTap: () {
                    //     ref.read(goRouterProvider).push(RouteNames.sign_in);
                    //   },
                    // ),
                    // SizedBox(height: 20.h),
                    // MainButton(
                    //   color: AppColors.yellow30,
                    //   borderRadius: 0.r,
                    //   label: "REGISTER".tr(context),
                    //   labelStyle: AppTextStyles.manropeMedium(
                    //     color: AppColors.yellow,
                    //     fontSize: 18.sp,
                    //   ),
                    //   showArrow: true,
                    //   onTap: () {
                    //     ref.read(goRouterProvider).push(RouteNames.sign_up);
                    //   },
                    // ),
                    SizedBox(height: 87.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
