part of 'signin_screen.dart';

// _forgotPasswordDialog(BuildContext context, WidgetRef ref) {
//   final emailController = TextEditingController();
//   final emailNode = FocusNode();

//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   showDialog(
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           bool canProceed = emailController.text.isNotEmpty;

//           return KeyboardVisibilityBuilder(
//             builder: (context, child, insets, isVisible) {
//               return Padding(
//                 padding: EdgeInsets.only(bottom: insets),
//                 child: child,
//               );
//             },
//             child: CustomDialog(
//               closeIconColor: AppColors.orange,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'RECOVER_PASSWORD'.tr(context),
//                     style: AppTextStyles.popupHeaderTextStyle,
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 25.h),
//                   Align(
//                     alignment: AlignmentDirectional.centerStart,
//                     child: Text(
//                       'ENTER_EMAIL_ADDRESS'.tr(context),
//                       style: AppTextStyles.aeonikRegular17.copyWith(
//                         color: AppColors.orange,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 5.h),
//                   Form(
//                     key: formKey,
//                     child: CustomTextField(
//                       controller: emailController,
//                       node: emailNode,
//                       validator: (val) {
//                         if (val?.isEmpty ?? true) {
//                           return "PLEASE_ENTER_"
//                               .tr(context, params: {'FIELD': "EMAIL"});
//                         }
//                         if (!(val?.isValidEmail ?? true)) {
//                           return "PLEASE_ENTER_VALID_".tr(
//                             context,
//                             params: {'FIELD': "EMAIL"},
//                           );
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.emailAddress,
//                       isForPopup: true,
//                       onChanged: (_) {
//                         setState(() {});
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 25.h),
//                   MainButton(
//                     enabled: canProceed,
//                     isForPopup: true,
//                     label: 'SEND_RECOVER_EMAIL'.tr(context),
//                     showArrow: false,
//                     onTap: () async {
//                       if (!(formKey.currentState?.validate() ?? true)) {
//                         return;
//                       }

//                       // String? value = await Utils.showLoadingDialog<String>(
//                       //   context,
//                       //   test2Provider,
//                       //   ref,
//                       // );
//                       // myPrint(value.toString());
//                       if (canProceed) {
//                         // await _sendResetPasswordEmail();
//                       }
//                     },
//                   ),
//                   SizedBox(height: 30.h),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }

class SetupPasswordDialog extends ConsumerStatefulWidget {
  const SetupPasswordDialog({super.key, required this.email});
  final String email;

  @override
  ConsumerState<SetupPasswordDialog> createState() =>
      _SetupPasswordDialogState();
}

class _SetupPasswordDialogState extends ConsumerState<SetupPasswordDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final passwordNode = FocusNode();
  final confirmPasswordController = TextEditingController();
  final confirmPasswordNode = FocusNode();

  bool get canProceed =>
      passwordController.text.length >= 6 &&
      confirmPasswordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomDialog(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SETUP_PASSWORD'.trU(context),
                style: AppTextStyles.popupHeaderTextStyle,
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Text(
                  'ACCOUNT_EXISTS_NO_PASSWORD'.tr(context),
                  style: AppTextStyles.popupBodyTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'NEW_PASSWORD'.tr(context),
                    style: AppTextStyles.manropeMedium(
                      fontSize: 16.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: CustomTextField(
                  controller: passwordController,
                  node: passwordNode,
                  borderRadius: BorderRadius.circular(100.r),
                  hintText: "TYPE_HERE".tr(context),
                  obscureText: true,
                  validator: (val) {
                    if ((val?.isEmpty ?? true) || (val?.length ?? 0) < 6) {
                      return "PASSWORD_MUST_BE_".tr(context);
                    }
                    return null;
                  },
                  isForPopup: true,
                  fillColor: AppColors.white25,
                  borderColor: Colors.transparent,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'CONFIRM_PASSWORD'.tr(context),
                    style: AppTextStyles.manropeMedium(
                      fontSize: 16.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: CustomTextField(
                  controller: confirmPasswordController,
                  node: confirmPasswordNode,
                  borderRadius: BorderRadius.circular(100.r),
                  hintText: "TYPE_HERE".tr(context),
                  obscureText: true,
                  validator: (val) {
                    if (val != passwordController.text) {
                      return "PASSWORDS_DO_NOT_MATCH".tr(context);
                    }
                    return null;
                  },
                  isForPopup: true,
                  fillColor: AppColors.white25,
                  borderColor: Colors.transparent,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(height: 25.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: MainButton(
                  enabled: canProceed,
                  label: 'SETUP_PASSWORD'.trU(context),
                  showArrow: false,
                  isForPopup: true,
                  onTap: () async {
                    if (!(formKey.currentState?.validate() ?? true)) return;
                    final provider = setupPasswordAndLoginProvider(
                      widget.email,
                      passwordController.text,
                    );
                    final user = await Utils.showLoadingDialog<AppUser>(
                      context,
                      provider,
                      ref,
                    );
                    if (user != null && context.mounted) {
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecoverPassword1 extends ConsumerStatefulWidget {
  RecoverPassword1();

  @override
  _RecoverPassword1State createState() => _RecoverPassword1State();
}

class _RecoverPassword1State extends ConsumerState<RecoverPassword1> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final emailNode = FocusNode();

  bool get canProceed => emailController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'RECOVER_PASSWORD'.trU(context),
              style: AppTextStyles.popupHeaderTextStyle,
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'ENTER_EMAIL_ADDRESS'.tr(context),
                  style: AppTextStyles.manropeMedium(
                   fontSize: 16.sp,color: AppColors.white,),
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Form(
                key: formKey,
                child: CustomTextField(
                  controller: emailController,
                  borderRadius: BorderRadius.circular(100.r),
                  node: emailNode,
                  hintText: "TYPE_HERE".tr(context),
                  validator: (val) {
                    if (val?.isEmpty ?? true) {
                      return "PLEASE_ENTER_"
                          .tr(context, params: {'FIELD': "EMAIL"});
                    }
                    if (!(val?.isValidEmail ?? true)) {
                      return "PLEASE_ENTER_VALID_".tr(
                        context,
                        params: {'FIELD': "EMAIL"},
                      );
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  fillColor: AppColors.white25,
                  borderColor: Colors.transparent,
                  isForPopup: true,
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
              ),
            ),
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: MainButton(
                enabled: canProceed,
                label: 'SEND_RECOVER_EMAIL'.trU(context),
                isForPopup: true,
                showArrow: false,
                onTap: () async {
                  if (!(formKey.currentState?.validate() ?? true)) {
                    return;
                  }
                  if (canProceed) {
                    final provider =
                        recoverPasswordProvider(emailController.text.trim());
                    final sent =
                        await Utils.showLoadingDialog(context, provider, ref);
                    if (sent && context.mounted) {
                      Navigator.pop(context);
                      showDialog(
                        // barrierColor: Colors.transparent,
                        context: context,
                        builder: (context) => _RecoverPassword2(
                          email: emailController.text.trim(),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecoverPassword2 extends ConsumerStatefulWidget {
  _RecoverPassword2({
    required this.email,
  });
  final String email;

  @override
  _RecoverPassword2State createState() => _RecoverPassword2State();
}

class _RecoverPassword2State extends ConsumerState<_RecoverPassword2> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final tokenController = TextEditingController();
  final tokenNode = FocusNode();

  final newPasswordController = TextEditingController();
  final newPasswordNode = FocusNode();

  bool get canProceed =>
      (tokenController.text.isNotEmpty) &&
      (newPasswordController.text.isNotEmpty) &&
      (newPasswordController.text.length >= 6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomDialog(
        // color: AppColors.rosewood,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'RECOVER_PASSWORD'.trU(context),
                style: AppTextStyles.popupHeaderTextStyle,
              ),
              // Text(
              //   'RECOVER_PASSWORD'.tr(context).toUpperCase(),
              //   style: AppTextStyles.gothamNarrowBold(
              //       color: AppColors.white, fontSize: 19.sp),
              //   textAlign: TextAlign.center,
              // ),
              SizedBox(height: 20.h),
              // IF_YOU_HAVE_AN_ACCOUNT_YOU_WILL_RECEIVE_AN_EMAIL
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Text(
                  'IF_YOU_HAVE_AN_ACCOUNT_YOU_WILL_RECEIVE_AN_EMAIL'
                      .tr(context),
                  style: AppTextStyles.popupBodyTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Text(
                  'EMAIL_MAY_IN_JUNK'.tr(context),
                  style: AppTextStyles.popupBodyTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 25.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'ENTER_TOKEN'.tr(context),
                    style: AppTextStyles.manropeMedium(
                      fontSize: 16.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: CustomTextField(
                  controller: tokenController,
                  borderRadius: BorderRadius.circular(100.r),
                  node: tokenNode,
                  hintText: "TYPE_HERE".tr(context),
                  validator: (val) {
                    if (val?.isEmpty ?? true) {
                      return "PLEASE_ENTER_"
                          .tr(context, params: {'FIELD': "TOKEN"});
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  isForPopup: true,
                  borderColor: Colors.transparent,
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'ENTER_NEW_PASSWORD'.tr(context),
                    style: AppTextStyles.manropeMedium(
                      fontSize: 16.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: CustomTextField(
                  controller: newPasswordController,
                  node: newPasswordNode,
                  borderRadius: BorderRadius.circular(100.r),
                  hintText: "TYPE_HERE".tr(context),
                  validator: (val) {
                    if ((val?.isEmpty ?? true) || (val?.length ?? 0) < 6) {
                      return "PASSWORD_MUST_BE_".tr(context);
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  isForPopup: true,
                  fillColor: AppColors.white25,
                  borderColor: Colors.transparent,
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(height: 25.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: MainButton(
                  enabled: canProceed,
                  label: 'UPDATE_PASSWORD'.trU(context),
                  showArrow: false,
                  isForPopup: true,
                  onTap: () async {
                    if (!(formKey.currentState?.validate() ?? true)) {
                      return;
                    }
                    if (canProceed) {
                      final provider = updateRecoveryPasswordProvider(
                          email: widget.email,
                          token: tokenController.text.trim(),
                          password: newPasswordController.text.trim());
                      final sent = await Utils.showLoadingDialog(
                          context, provider, ref,
                          isUpperCase: true);
                      if (sent && context.mounted) {
                        Navigator.pop(context);
                        Utils.showMessageDialog(
                            backgroundColor: AppColors.black2,
                            context,
                            "PASSWORD_UPDATED_SUCCESS".trU(context));
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
