import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/custom_textfield.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/components/multi_style_text.dart';
import 'package:hop/components/selected_tag.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/current_platform.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/globals/playing_side.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/managers/fcm_manager.dart';
import 'package:hop/models/app_user.dart';
import 'package:hop/models/level_questions.dart';
import 'package:hop/models/register_model.dart';
import 'package:hop/repository/level_repo.dart';
import 'package:hop/repository/user_repo.dart';
import 'package:hop/repository/club_repo.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:hop/routes/app_routes.dart';
import 'package:hop/screens/app_provider.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/widgets/background_view.dart';
import 'package:image_picker/image_picker.dart';
import '../../../components/secondary_text.dart';
import '../../../components/secondary_textfield.dart';
import '../../../models/club_locations.dart';

part 'signup_form_tab.dart';

part 'select_your_position_tab.dart';

part 'level_assessment_tab.dart';

part 'level_score_tab.dart';
part 'profile_picture_tab.dart';
part 'game_preference_tab.dart';
part 'preview_tab.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final sport = ref.watch(settingSportsValueProvider);
    final provider = ref.watch(levelQuestionsProvider(sport: null));
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return true;
      },
      child: Container(
        decoration: BoxDecoration(
            // image: PlatformC().isCurrentDesignPlatformDesktop
            //     ? DecorationImage(
            //         image: AssetImage(AppImages.webStaticPage.path),
            //         fit: BoxFit.fitWidth,
            //       )
            //     : null,
            ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: BackgroundView(
            child: Scaffold(
              // backgroundColor: PlatformC().isCurrentDesignPlatformDesktop
              //     ? Colors.transparent
              //     : AppColors.backgroundColor,
              backgroundColor: AppColors.transparentColor,
              body: provider.when(
                data: (data) {
                  return _SignupFlow(levelQuestions: data);
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (e, _) => Center(child: Text(e.toString())),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignupFlow extends ConsumerStatefulWidget {
  const _SignupFlow({required this.levelQuestions});

  final List<LevelQuestion> levelQuestions;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __SignupFlowState();
}

class __SignupFlowState extends ConsumerState<_SignupFlow> {
  int pageIndex = 0;
  PageController pageController = PageController();
  RegisterModel registerModel = RegisterModel();
  int totalPages = 3;

  @override
  void initState() {
    totalPages = widget.levelQuestions.length + 3;
    registerModel.levelAnswers =
        List.filled(widget.levelQuestions.length, null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final sportsName = ref.read(settingSportsValueProvider);

    return SingleChildScrollView(
      child: Center(
        child: Container(
          height: height,
          margin: EdgeInsets.symmetric(
              vertical: PlatformC().isCurrentDesignPlatformDesktop ? 30 : 0),
          constraints: kComponentWidthConstraint,
          child: SafeArea(
            child: Column(
              children: [
                19.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  alignment: AlignmentDirectional.centerStart,
                  child: InkWell(
                    onTap: _onBack,
                    child: Image.asset(
                      AppImages.arrowBack.path,
                      height: 18.h,
                      color: AppColors.black,
                    ),
                  ),
                ),
                10.verticalSpace,
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    onPageChanged: (i) => pageIndex = i,
                    children: [
                      _SignUpFormTab(
                        registerModel: registerModel,
                        onProceed: () {
                          pageController.animateToPage(
                            1,
                            duration: kAnimationDuration,
                            curve: Curves.linear,
                          );
                        },
                      ),
                      _ProfilePictureTab(
                        registerModel: registerModel,
                        onProceed: () {
                          pageController.animateToPage(
                            2,
                            duration: kAnimationDuration,
                            curve: Curves.linear,
                          );
                        },
                      ),
                      // _SelectSports(onProceed: () {
                      //   registerModel.levelAnswers =
                      //       List.filled(widget.levelQuestions.length, null);
                      //   if (checkPickleBall()) {
                      //     registerModel.level = 0;
                      //     callRegisterUser();
                      //     return;
                      //   }
                      //   pageController.animateToPage(
                      //     2,
                      //     duration: kAnimationDuration,
                      //     curve: Curves.linear,
                      //   );
                      // }),
                      if (allowPadelQuestionInRegistration)
                        for (int i = 0; i < widget.levelQuestions.length; i++)
                          LevelAssessmentTab(
                            index: i,
                            isLastQuestion:
                                i == widget.levelQuestions.length - 1,
                            levelQuesiton: widget.levelQuestions[i],
                            registerModel: registerModel,
                            onProceed: () {
                              pageController.animateToPage(
                                pageIndex + 1,
                                duration: kAnimationDuration,
                                curve: Curves.linear,
                              );
                            },
                          ),
                      if (allowPadelQuestionInRegistration)
                        LevelScoreTab(
                          registerModel: registerModel,
                          onProceed: () {
                            pageController.animateToPage(
                              pageIndex + 1,
                              duration: kAnimationDuration,
                              curve: Curves.linear,
                            );
                          },
                          sportsName: sportsName,
                        ),
                      _SelectYourPosition(
                        registerModel: registerModel,
                        onProceed: () {
                          pageController.animateToPage(
                            pageIndex + 1,
                            duration: kAnimationDuration,
                            curve: Curves.linear,
                          );
                        },
                      ),
                      _GamePreferenceTab(
                        isPage: true,
                        registerModel: registerModel,
                        onProceed: () {
                          pageController.animateToPage(
                            pageIndex + 1,
                            duration: kAnimationDuration,
                            curve: Curves.linear,
                          );
                        },
                      ),
                      _PreviewTab(
                        registerModel: registerModel,
                        onProceed: () {
                          callRegisterUser();
                        },
                      ),
                      // _SelectYourPosition(
                      //   registerModel: registerModel,
                      //   onProceed: () async {
                      //     callRegisterUser();
                      //   },
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkWellness() {
    return ref.read(settingSportsValueProvider).toLowerCase() == "wellness";
  }
  bool checkPickleBall() {
    return ref.read(settingSportsValueProvider).toLowerCase() == "pickleball";
  }

  // void callRegisterUser() async {
  //   try {
  //     final signupProvider = registerUserProvider(registerModel);
  //     final AppUser? user =
  //         await Utils.showLoadingDialog(context, signupProvider, ref);
  //     if (user != null && context.mounted) {
  //       if (FcmManager().token.isNotEmpty) {
  //         ref.watch(saveFCMTokenProvider(FcmManager().token));
  //       }
  //       ref.watch(getCourtBookingProvider);
  //       ref.read(pageIndexProvider.notifier).index = 1;
  //       ref.read(goRouterProvider).go(RouteNames.home);
  //     }
  //   } catch (e, st) {
  //     myPrint("_SelectYourPosition Error : $e -- $st");
  //   }
  // }

  void callRegisterUser() async {
    try {
      final signupProvider = registerUserProvider(registerModel);
      final AppUser? user =
      await Utils.showLoadingDialog(context, signupProvider, ref);
      if (user != null && context.mounted) {
        // Upload profile picture if provided
        if (registerModel.profileImagePath != null) {
          try {
            final imageFile = File(registerModel.profileImagePath!);
            final profileProvider = updateProfileProvider(imageFile);
            await Utils.showLoadingDialog(context, profileProvider, ref);
          } catch (e) {
            myPrint("Error uploading profile picture: $e");
          }
        }

        if (FcmManager().token.isNotEmpty) {
          ref.watch(saveFCMTokenProvider(FcmManager().token));
        }
        ref.watch(getCourtBookingProvider);
        ref.read(pageIndexProvider.notifier).index = 1;
        ref.read(goRouterProvider).go(RouteNames.home);
      }
    } catch (e, st) {
      myPrint("Registration Error : $e -- $st");
    }
  }


  _onBack() {
    if (pageIndex == 0) {
      Navigator.pop(context);
    } else if (pageIndex == 1) {
      pageController.animateToPage(0,
          duration: kAnimationDuration, curve: Curves.linear);
    } else {
      pageController.animateToPage(pageIndex - 1,
          duration: kAnimationDuration, curve: Curves.linear);
    }
  }
}
