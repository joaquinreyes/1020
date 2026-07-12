import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:hop/components/language_selector_auth.dart';
import 'package:hop/components/main_button.dart';
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

enum _SignInStep { email, password, setupPassword }

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends ConsumerState<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passNode = FocusNode();
  final FocusNode _confirmPassNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _SignInStep _step = _SignInStep.email;

  bool get _canProceedEmail => _emailController.text.isNotEmpty;

  bool get _canProceedPassword =>
      _passwordController.text.isNotEmpty &&
      _passwordController.text.length >= 6;

  bool get _canProceedSetup =>
      _passwordController.text.length >= 6 &&
      _confirmPasswordController.text.isNotEmpty;

  void _onBack() {
    if (_step == _SignInStep.email) {
      Navigator.pop(context);
    } else {
      setState(() {
        _step = _SignInStep.email;
        _passwordController.clear();
        _confirmPasswordController.clear();
      });
    }
  }

  Future<void> _onCheckEmail() async {
    if (!(_formKey.currentState?.validate() ?? true)) return;

    final provider =
        checkEmailStatusProvider(_emailController.text.trim());
    final result = await Utils.showLoadingDialog<Map<String, dynamic>>(
      context,
      provider,
      ref,
    );

    if (result != null && context.mounted) {
      final exists = result['exists'] == true;
      final hasPassword = result['hasPassword'] == true;

      if (!exists) {
        Utils.showMessageDialog(
          context,
          "EMAIL_NOT_REGISTERED".tr(context),
        );
        return;
      }

      setState(() {
        if (hasPassword) {
          _step = _SignInStep.password;
        } else {
          _step = _SignInStep.setupPassword;
        }
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _passNode.requestFocus();
      });
    }
  }

  Future<void> _onSignIn() async {
    if (!(_formKey.currentState?.validate() ?? true)) return;

    final provider = loginUserProvider(
        _emailController.text.trim(), _passwordController.text);
    final AppUser? data = await Utils.showLoadingDialog<AppUser>(
      context,
      provider,
      ref,
    );

    if (data != null && context.mounted) {
      _navigateToHome();
    }
  }

  Future<void> _onSetupPassword() async {
    if (!(_formKey.currentState?.validate() ?? true)) return;

    final provider = setupPasswordAndLoginProvider(
      _emailController.text.trim(),
      _passwordController.text,
    );
    final AppUser? user = await Utils.showLoadingDialog<AppUser>(
      context,
      provider,
      ref,
    );

    if (user != null && context.mounted) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    if (FcmManager().token.isNotEmpty) {
      ref.watch(saveFCMTokenProvider(FcmManager().token));
    }
    ref.watch(getCourtBookingProvider);
    ref.read(pageIndexProvider.notifier).index = 1;
    ref.invalidate(pageControllerProvider);
    ref.read(goRouterProvider).go(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return true;
      },
      child: Container(
        decoration: const BoxDecoration(),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: BackgroundView(
            child: Scaffold(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: _onBack,
                                  child: Image.asset(
                                    AppImages.arrowBack.path,
                                    height: 18.h,
                                    color: AppColors.black,
                                  ),
                                ),
                                const LanguageSelectorAuth(),
                              ],
                            ),
                            10.verticalSpace,
                            Text(
                              "SIGN_IN".trU(context),
                              style: AppTextStyles.sofiaSansMedium(
                                color: AppColors.black,
                                fontSize: 40.sp,
                              ),
                            ),
                            5.verticalSpace,
                            Text(
                              'WELCOME_BACK'.tr(context),
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
                                      color: AppColors.black,
                                    ),
                                  ),
                                  CustomTextField(
                                    controller: _emailController,
                                    node: _emailNode,
                                    keyboardType: TextInputType.emailAddress,
                                    readOnly: _step != _SignInStep.email,
                                    validator: _step == _SignInStep.email
                                        ? (value) {
                                            if (!(value?.isValidEmail ??
                                                true)) {
                                              return "PLEASE_ENTER_VALID_".tr(
                                                context,
                                                params: {'FIELD': "EMAIL"},
                                              );
                                            }
                                            return null;
                                          }
                                        : null,
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                  ),
                                  if (_step == _SignInStep.password) ...[
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
                                          return "PASSWORD_MUST_BE_"
                                              .tr(context);
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
                                  if (_step == _SignInStep.setupPassword) ...[
                                    SizedBox(height: 25.h),
                                    Text(
                                      'ACCOUNT_EXISTS_NO_PASSWORD'.tr(context),
                                      style: AppTextStyles.manropeMedium(
                                        fontSize: 14.sp,
                                        color: AppColors.black70,
                                      ),
                                    ),
                                    SizedBox(height: 25.h),
                                    Text(
                                      "NEW_PASSWORD".trU(context),
                                      style: AppTextStyles.sofiaSansMedium(
                                        fontSize: 25.sp,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    CustomTextField(
                                      controller: _passwordController,
                                      node: _passNode,
                                      obscureText: true,
                                      validator: (val) {
                                        if ((val?.isEmpty ?? true) ||
                                            (val?.length ?? 0) < 6) {
                                          return "PASSWORD_MUST_BE_"
                                              .tr(context);
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
                                    ),
                                    SizedBox(height: 30.h),
                                    Text(
                                      "CONFIRM_PASSWORD".trU(context),
                                      style: AppTextStyles.sofiaSansMedium(
                                        fontSize: 25.sp,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    CustomTextField(
                                      controller: _confirmPasswordController,
                                      node: _confirmPassNode,
                                      obscureText: true,
                                      validator: (val) {
                                        if (val != _passwordController.text) {
                                          return "PASSWORDS_DO_NOT_MATCH"
                                              .tr(context);
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
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const Spacer(),
                            if (_step == _SignInStep.email)
                              MainButton(
                                enabled: _canProceedEmail,
                                label: "CONTINUE".trU(context),
                                showArrow: true,
                                onTap: _onCheckEmail,
                              ),
                            if (_step == _SignInStep.password)
                              MainButton(
                                enabled: _canProceedPassword,
                                label: "SIGN_IN".trU(context),
                                showArrow: true,
                                onTap: _onSignIn,
                              ),
                            if (_step == _SignInStep.setupPassword)
                              MainButton(
                                enabled: _canProceedSetup,
                                label: "SETUP_PASSWORD".trU(context),
                                showArrow: true,
                                onTap: _onSetupPassword,
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
