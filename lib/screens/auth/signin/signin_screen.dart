import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/components/multi_style_text.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/managers/fcm_manager.dart';
import 'package:hop/models/app_user.dart';
import 'package:hop/repository/user_repo.dart';
import 'package:hop/repository/club_repo.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:hop/routes/app_routes.dart';
import 'package:hop/screens/app_provider.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/custom_textfield.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/current_platform.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/widgets/background_view.dart';
part 'signin_components.dart';

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends ConsumerState<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  bool get canProceed =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _passwordController.text.length >= 6;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
          onTap: () => FocusScope.of(context).unfocus(),
          child: BackgroundView(
            child: Scaffold(
              // backgroundColor: PlatformC().isCurrentDesignPlatformDesktop
              //     ? Colors.transparent
              //     : AppColors.backgroundColor,
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Center(
                  child: Container(
                    height: height,
                    margin: EdgeInsets.symmetric(
                        vertical:
                            PlatformC().isCurrentDesignPlatformDesktop ? 30 : 0),
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    constraints: kComponentWidthConstraint,
                    child: Form(
                      key: _formKey,
                      child: SafeArea(
                        child: Column(
                          children: [
                            SizedBox(height: 19.h),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Image.asset(
                                  AppImages.arrowBack.path,
                                  height: 18.h,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                            10.verticalSpace,
                            Text(
                              "SIGN_IN".trU(context),
                              style: AppTextStyles.sofiaSansMedium(
                                  color: AppColors.black,
                                  fontSize: 40.sp,),
                            ),
                            5.verticalSpace,
                            Text(
                              '${"WELCOME_BACK".tr(context)}',
                              style: AppTextStyles.manropeMedium(
                                color: AppColors.black,
                                fontSize: 18.sp,
                              ),
                            ),
                            SizedBox(height: 45.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "EMAIL".trU(context),
                                    style: AppTextStyles.sofiaSansMedium(
                                      fontSize: 25.sp,
                                      color: AppColors.black
                                    ),
                                  ),
                                  CustomTextField(
                                    controller: _emailController,
                                    node: _emailNode,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (!(value?.isValidEmail ?? true)) {
                                        return "PLEASE_ENTER_VALID_".tr(
                                          context,
                                          params: {'FIELD': "EMAIL"},
                                        );
                                      }
                                      return null;
                                    },
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                  ),
                                  SizedBox(height: 50.h),
                                  Text(
                                    "PASSWORD".trU(context),
                                    style: AppTextStyles.sofiaSansMedium(
                                      fontSize: 25.sp,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  CustomTextField(
                                    controller: _passwordController,
                                    node: _passNode,
                                    validator: (val) {
                                      if ((val?.isEmpty ?? true) ||
                                          (val?.length ?? 0) < 6) {
                                        return "PASSWORD_MUST_BE_".tr(context);
                                      }
                                      return null;
                                    },
                                    style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: -0.5),
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                    obscureText: true,
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        showDialog(
                                          // barrierColor: Colors.transparent,
                                          context: context,
                                          builder: (context) {
                                            return RecoverPassword1();
                                          },
                                        );
                                      },
                                      child: Text(
                                        "FORGOT_MY_PASSWORD".tr(context),
                                        style: AppTextStyles.manropeMedium(
                                          fontSize: 15.sp,
                                          color: AppColors.black70,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            MainButton(
                              enabled: canProceed,
                              label:  "SIGN_IN".trU(context),
                              showArrow: true,
                              // color: canProceed
                              //     ? AppColors.rosewood
                              //     : AppColors.rosewood.withOpacity(0.25),
                              // labelStyle: AppTextStyles.qanelasLight(
                              //   fontSize: 18.sp,
                              //   color: AppColors.white,
                              // ),
                              // height: 40.h,
                              onTap: () async {
                                if (!(_formKey.currentState?.validate() ??
                                    true)) {
                                  return;
                                }
                                final provider = loginUserProvider(
                                    _emailController.text.trim(),
                                    _passwordController.text);
                                final AppUser? data =
                                    await Utils.showLoadingDialog<AppUser>(
                                  context,
                                  provider,
                                  ref,
                                );
            
                                if (data != null && context.mounted) {
                                  if (FcmManager().token.isNotEmpty) {
                                    ref.watch(
                                        saveFCMTokenProvider(FcmManager().token));
                                  }
                                  ref.watch(getCourtBookingProvider);
                                  ref.read(pageIndexProvider.notifier).index = 1;
                                  ref.invalidate(pageControllerProvider);
                                  ref.read(goRouterProvider).go(RouteNames.home);
                                }
                              },
                            ),
                            SizedBox(height: 82.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
