part of 'signup_screen.dart';

class LevelScoreTab extends ConsumerStatefulWidget {
  const LevelScoreTab({required this.registerModel, this.isForPopUp = false, required this.onProceed, required this.sportsName});

  final RegisterModel registerModel;
  final Function() onProceed;
  final String sportsName;
  final bool isForPopUp;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __LevelScoreTab();
}

class __LevelScoreTab extends ConsumerState<LevelScoreTab> {
  bool get _canProceed => true;

  bool _isEditEnable = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _levelNode = FocusNode();
  final TextEditingController _levelController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final calculatedData =
        ref.watch(calculateLevelProvider(answers: widget.registerModel.levelAnswers, allowClub: false, sportsName: widget.sportsName));
    final textColor = widget.isForPopUp ? AppColors.black : AppColors.black;

    return calculatedData.when(
      data: (data) {
        if (widget.registerModel.level == null) {
          widget.registerModel.level = data.level;
        }
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: widget.isForPopUp ? 0.w : 30.w),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'REGISTER'.trU(context),
                      style: AppTextStyles.sofiaSansMedium(
                        color: AppColors.black,
                        fontSize: 40.sp,
                      ),
                    ),
                    33.verticalSpace,
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'LEVEL_ASSESSMENT'.trU(context),
                        style: AppTextStyles.sofiaSansMedium(fontSize: 26.sp, color: textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    8.verticalSpace,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'THIS_WILL_GIVE_OTHERS_AN_IDEA_ABOUT_YOUR_SKILLS'.tr(context),
                        style: AppTextStyles.manropeMedium(
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "GREAT_YOUR_STARTING_LEVEL_IS1".tr(context),
                        style: AppTextStyles.manropeMedium(
                          fontSize: 16.sp,
                        ),                      ),
                    ),
                    SizedBox(height: 6.h),
                    Image.asset(AppImages.levelAssessment.path, color: textColor),
                    SizedBox(height: 38.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'YOUR_STARTING_LEVEL_IS'.tr(context),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.manropeMedium(
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: AppColors.brick,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: _isEditEnable
                          ? SecondaryTextField(
                              controller: _levelController,
                              node: _levelNode,
                              textAlign: TextAlign.center,
                              hintText: 'TYPE_HERE'.tr(context),
                              border: InputBorder.none,
                              hintTextStyle: AppTextStyles.sofiaSansMedium(
                                fontSize: 22.sp,
                                color: AppColors.black2,
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                              hasBorders: false,
                              style: AppTextStyles.sofiaSansMedium(
                                fontSize: 22.sp,
                                color: AppColors.black2,
                              ),
                              validator: (String? value) {
                                if (double.tryParse(value.toString()) == null) {
                                  return "INVALID_NUMBER".tr(context);
                                } else if (double.parse(value.toString()) > kMaxLevel) {
                                  return "LEVEL_SHOULD_BE_LESS_THAN_".tr(
                                    context,
                                    params: {'FIELD': "${kMaxLevel + 1}"},
                                  );
                                }
                                return null;
                              },
                            )
                          : Center(
                              child: Text(
                                "${data.level?.formatString() ?? " "} ${getRankLabel(data.level ?? 0)}",
                                style: AppTextStyles.manropeSemiBold(
                                  fontSize: 22.sp,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                    ),
                    // SizedBox(height: 15.h),
                    // Text.rich(
                    //     TextSpan(
                    //       text: 'LEVEL_DESCRIPTION'.tr(context),
                    //       children: <TextSpan>[
                    //         TextSpan(
                    //           text: 'hello@picklepark.com',
                    //           style: TextStyle(
                    //               color: AppColors.darkGreen50,
                    //               decoration: TextDecoration.underline),
                    //           recognizer: TapGestureRecognizer()
                    //             ..onTap = () async {
                    //               final Uri emailLaunchUri = Uri(
                    //                 scheme: 'mailto',
                    //                 path: 'hello@picklepark.com',
                    //               );
                    //               if (await canLaunchUrl(emailLaunchUri)) {
                    //                 await launchUrl(emailLaunchUri);
                    //               } else {
                    //                 throw 'Could not launch $emailLaunchUri';
                    //               }
                    //             },
                    //         ),
                    //         TextSpan(
                    //           text: 'LEVEL_DESCRIPTION_TWO'.tr(context),
                    //         ),
                    //       ],
                    //     ),
                    //     style: AppTextStyles.outfitMedium(
                    //         color: AppColors.darkGreen)),
                    // SizedBox(height: 10.h),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: _isEditEnable
                    //       ? Row(
                    //           crossAxisAlignment: CrossAxisAlignment.end,
                    //           mainAxisSize: MainAxisSize.min,
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             SecondaryImageButton(
                    //               label: "CANCEL".tr(context),
                    //               image: AppImages.closeIcon.path,
                    //               textColor: AppColors.black,
                    //               iconColor: AppColors.black,
                    //               color: AppColors.black.withOpacity(0.05),
                    //               borderRadius: 8.r,
                    //               imageHeight: 15.h,
                    //               imageWidth: 13.w,
                    //               onTap: () {
                    //                 setState(() {
                    //                   _isEditEnable = false;
                    //                 });
                    //               },
                    //             ),
                    //             SizedBox(
                    //               width: 5.w,
                    //             ),
                    //             SecondaryImageButton(
                    //               label: "SAVE".tr(context),
                    //               image: AppImages.editIcon.path,
                    //               textColor: AppColors.black,
                    //               iconColor: AppColors.black,
                    //               color: AppColors.black.withOpacity(0.05),
                    //               borderRadius: 8.r,
                    //               imageHeight: 15.h,
                    //               imageWidth: 13.w,
                    //               onTap: () {
                    //                 if (!(_formKey.currentState?.validate() ??
                    //                     true)) {
                    //                   return;
                    //                 }
                    //                 data.level = double.tryParse(
                    //                     _levelController.text.trim());
                    //                 widget.registerModel.level = data.level;
                    //                 _isEditEnable = false;
                    //                 setState(() {});
                    //               },
                    //             ),
                    //           ],
                    //         )
                    //       : SecondaryImageButton(
                    //           label: "EDIT_LEVEL".tr(context),
                    //           image: AppImages.editIcon.path,
                    //           textColor: AppColors.black,
                    //           iconColor: AppColors.black,
                    //           color: AppColors.black.withOpacity(0.05),
                    //           borderRadius: 8.r,
                    //           imageHeight: 15.h,
                    //           imageWidth: 13.w,
                    //           onTap: () {
                    //             _levelController.text =
                    //                 (data.level ?? 0).toString();
                    //             _levelNode.requestFocus();
                    //             setState(() {
                    //               _isEditEnable = true;
                    //             });
                    //           },
                    //         ),
                    // ),
                    SizedBox(height: widget.isForPopUp ? 15.h : 88.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 160.w,
                        child: MainButton(
                          enabled: _canProceed,
                          isForPopup:widget.isForPopUp,
                          label: 'CONTINUE',
                          // labelStyle: AppTextStyles.qanelasLight(
                          //   color: AppColors.white,
                          //   fontSize: 18.sp,
                          // ),
                          // color: AppColors.rosewood,
                          showArrow: true,
                          onTap: () async {
                            if (_canProceed) {
                              widget.onProceed();
                            }
                          },
                          // padding: EdgeInsets.symmetric(horizontal: 15.w),
                        ),
                      ),
                    ),
                    SizedBox(height: 82.h),
                  ],
                )),
          ),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
    );
  }
}
