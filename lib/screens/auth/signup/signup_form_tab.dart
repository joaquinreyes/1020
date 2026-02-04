part of 'signup_screen.dart';

class _SignUpFormTab extends ConsumerStatefulWidget {
  const _SignUpFormTab({required this.onProceed, required this.registerModel});

  final Function() onProceed;
  final RegisterModel registerModel;

  @override
  ConsumerState<_SignUpFormTab> createState() => _SignUpFormTabState();
}

class _SignUpFormTabState extends ConsumerState<_SignUpFormTab> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _firstNameNode = FocusNode();
  final _lastNameNode = FocusNode();
  final _emailNode = FocusNode();

  final _phoneNode = FocusNode();
  final _passNode = FocusNode();
  bool _showPassword = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isTermsChecked = false;

  // bool isCommunicationChecked = false;

  String dialCode = '+7';

  bool get _canProceed =>
      _firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _phoneController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      isTermsChecked;

  // && isCommunicationChecked;

  @override
  void initState() {
    _emailController.text = widget.registerModel.email ?? '';
    _phoneController.text = widget.registerModel.phoneNumber ?? '';
    _passwordController.text = widget.registerModel.password ?? '';
    _firstNameController.text = widget.registerModel.firstName ?? '';
    _lastNameController.text = widget.registerModel.lastName ?? '';
    dialCode = widget.registerModel.phoneCode ?? dialCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 39.w),
      child: Column(children: [
        Text(
          'REGISTER'.trU(context),
          style: AppTextStyles.sofiaSansMedium(
            color: AppColors.black,
            fontSize: 40.sp,
          ),
        ),
        5.verticalSpace,
        InkWell(
          onTap: () {
            ref.read(goRouterProvider).push(RouteNames.sign_in);
          },
          child: RichText(
            text: TextSpan(
              text: '${'ALREADY_HAVE_AN_ACCOUNT'.tr(context)} ',
              style: AppTextStyles.manropeMedium(
                fontSize: 18.sp,
              ),
              children: [
                TextSpan(
                  text: 'SIGN_IN'.tr(context),
                  style: AppTextStyles.manropeSemiBold(
                    fontSize: 17.sp,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        45.verticalSpace,
        Expanded(
          child: SingleChildScrollView(
            primary: false,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Form(
                    key: formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Text(
                            'FIRST_NAME'.trU(context),
                            style: AppTextStyles.sofiaSansMedium(fontSize: 25.sp,),
                          ),
                          CustomTextField(
                            controller: _firstNameController,
                            node: _firstNameNode,
                            isRequired: true,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "PLEASE_ENTER_VALID_".tr(
                                  context,
                                  params: {'FIELD': "FIRST_NAME"},
                                );
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 50.h),
                          Text(
                            'LAST_NAME'.trU(context),
                              style: AppTextStyles.sofiaSansMedium(fontSize: 25.sp,),
                          ),
                          CustomTextField(
                            controller: _lastNameController,
                            node: _lastNameNode,
                            isRequired: true,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "PLEASE_ENTER_VALID_".tr(
                                  context,
                                  params: {'FIELD': "LAST_NAME"},
                                );
                              }
                              return null;
                            },
                            // style: AppTextStyles.qanelasLight(
                            //     fontSize: 17.sp, color: AppColors.black),
                          ),
                          SizedBox(height: 50.h),
                          Text(
                            'EMAIL'.trU(context),
                            style: AppTextStyles.sofiaSansMedium(fontSize: 25.sp,),
                          ),
                          CustomTextField(
                            controller: _emailController,
                            node: _emailNode,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "PLEASE_ENTER_VALID_".tr(
                                  context,
                                  params: {'FIELD': "EMAIL"},
                                );
                              }
                              // Allow letters, numbers, dots, hyphens, and underscores in email
                              final emailRegex = RegExp(
                                  r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                              if (!emailRegex.hasMatch(value)) {
                                return "PLEASE_ENTER_VALID_".tr(
                                  context,
                                  params: {'FIELD': "EMAIL"},
                                );
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 50.h),
                          Text(
                            'PHONE_NUMBER'.trU(context),
                            style: AppTextStyles.sofiaSansMedium(fontSize: 25.sp,),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CountryCodePicker(
                                onChanged: (value) {
                                  dialCode = value.dialCode ?? dialCode;
                                },
                                initialSelection: 'RU',
                                favorite: const ['RU'],
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                                padding: EdgeInsets.zero,
                                boxDecoration:BoxDecoration(color: AppColors.white),
                                textStyle: AppTextStyles.manropeMedium(
                                    fontSize: 18.sp, color: AppColors.black2),
                                searchStyle: AppTextStyles.manropeMedium(
                                    fontSize: 18.sp, color: AppColors.black2),
                                dialogTextStyle: AppTextStyles.manropeMedium()
                                    .copyWith(
                                        fontSize: 18.sp,
                                        color: AppColors.black2),
                                flagWidth: 25.w,
                                backgroundColor: AppColors.white,
                              ),
                              Expanded(
                                child: CustomTextField(
                                  controller: _phoneController,
                                  node: _phoneNode,
                                  isRequired: true,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "PLEASE_ENTER_VALID_".tr(
                                        context,
                                        params: {'FIELD': "PHONE_NUMBER"},
                                      );
                                    }
                                    return null;
                                  },
                                  // style: AppTextStyles.qanelasLight(
                                  //     fontSize: 17.sp, color: AppColors.black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40.h),
                          Text(
                            'PASSWORD'.trU(context),
                            style: AppTextStyles.sofiaSansMedium(fontSize: 25.sp,),
                          ),
                          CustomTextField(
                            controller: _passwordController,
                            node: _passNode,
                            isRequired: true,
                            obscureText: _showPassword,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if ((value?.length ?? 0) < 6) {
                                return "PASSWORD_MUST_BE_".tr(context);
                              }
                              return null;
                            },
                            style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: AppColors.black,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.5),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              child: Icon(
                                _showPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 25.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _CustomCheckBox(
                                  isChecked: isTermsChecked,
                                  onChanged: (v) {
                                    setState(() {
                                      isTermsChecked = v;
                                    });
                                  },
                                ),
                                SizedBox(width: 10.w),
                                RichText(
                                  textAlign: TextAlign.end,
                                  text: TextSpan(
                                    text: 'I_ACCEPT_THE'.tr(context),
                                    style: AppTextStyles.manropeMedium(
                                      fontSize: 15.sp,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${'TERMS_AND_CONDITIONS'.tr(context)}.',
                                        style: AppTextStyles.manropeExtraLight(fontSize: 15.sp).copyWith(
                                          decoration: TextDecoration.underline,
                                          decorationStyle: TextDecorationStyle.solid,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () =>
                                              Utils.termsAndCommunicationDialog(
                                                  context: context),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(height: 20.h),
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       _CustomCheckBox(
                          //         isChecked: isCommunicationChecked,
                          //         onChanged: (v) {
                          //           setState(() {
                          //             isCommunicationChecked = v;
                          //           });
                          //         },
                          //       ),
                          //       SizedBox(width: 10.w),
                          //       RichText(
                          //         text: TextSpan(
                          //           text: 'OPT_IN_FOR'.tr(context),
                          //           style: AppTextStyles.outfitLight(
                          //             fontSize: 15.sp,
                          //           ),
                          //           children: [
                          //             TextSpan(
                          //               text: '${'COMMUNICATIONS'.tr(context)}.',
                          //               style: AppTextStyles.outfitLightItalic(fontSize: 15.sp, textDecoration: TextDecoration.underline),
                          //               recognizer: TapGestureRecognizer()..onTap = () => _termsAndCommunicationDialog(false),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          33.verticalSpace,
                          MainButton(
                            enabled: _canProceed,
                            label: 'REGISTER'.trU(context),
                            showArrow: true,
                            onTap: () {
                              if (formKey.currentState?.validate() ?? false) {
                                widget.registerModel.firstName =
                                    _firstNameController.text;
                                widget.registerModel.lastName =
                                    _lastNameController.text;
                                widget.registerModel.email =
                                    _emailController.text.trim();
                                widget.registerModel.phoneNumber =
                                    _phoneController.text;
                                widget.registerModel.phoneCode = dialCode;
                                widget.registerModel.password =
                                    _passwordController.text;
                                widget.registerModel.acceptTermsAndConditions =
                                    isTermsChecked;
                                widget.onProceed();
                              }
                            },
                          ),
                          SizedBox(height: 65.h),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class _CustomCheckBox extends StatelessWidget {
  const _CustomCheckBox({required this.isChecked, required this.onChanged});

  final bool isChecked;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // radius: BorderRadius.all(Radius.elliptical(x, y)),
      onTap: () {
        onChanged(!isChecked);
      },
      child: Container(
        width: 15.w,
        height: 15.h,
        decoration: BoxDecoration(
          // color: Colors.white,
          border: Border.all(
            color: AppColors.black,
          ),
        ),
        child: isChecked
            ? Padding(
                padding: EdgeInsets.all(2.h),
                child: Image.asset(
                  AppImages.checkIcon.path,
                  width: 11.w,
                  height: 11.w,
                  color: AppColors.black,
                ),
              )
            : null,
      ),
    );
  }
}
