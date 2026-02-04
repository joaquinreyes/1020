part of 'profile_tab.dart';

class _HeaderInfo extends ConsumerWidget {
  const _HeaderInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)?.user;
    final userLevel = user?.level(kSportName);
    // final userLevel = user?.level(getSportsName(ref));
    // final userLevelTag = user?.getLevelTag(userLevel) ?? "";
    final paymentDetails = ref.watch(walletInfoProvider);
    final membership = ref.watch(fetchActiveAndAllMembershipsProvider);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      PlatformC().isCurrentDesignPlatformDesktop
          ? SizedBox(height: 10.h)
          : SignOutButtonComponent(),
      5.verticalSpace,
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  ImageSource? src = await showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.r),
                        topRight: Radius.circular(25.r),
                      ),
                    ),
                    context: context,
                    builder: (_) => const ImageSourceSheet(),
                  );
                  if (src != null) {
                    final XFile? pickedFile = await ImagePicker().pickImage(
                      source: src,
                      imageQuality: 10,
                      maxHeight: 500,
                      maxWidth: 500,
                    );
                    if (pickedFile != null) {
                      final File file = File(pickedFile.path);
                      if (context.mounted) {
                        await Utils.showLoadingDialog(
                            context, updateProfileProvider(file), ref);
                      }
                    }
                  }
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    NetworkCircleImage(
                      path: user?.profileUrl,
                      width: 90.h,
                      height: 90.h,
                      borderRadius: BorderRadius.circular(18.r),
                      bgColor: AppColors.blue,
                      logoColor: AppColors.white,
                      showBG: true,
                    ),
                    Positioned(
                      right: 8.w,
                      bottom: 8.h,
                      child: Image.asset(
                        AppImages.iconCameraNew.path,
                        width: 13.w,
                        height: 13.w,
                        color: AppColors.white,
                      ),
                    )
                  ],
                ),
              ),
              // SizedBox(height: 10.h),
              // const FollowingFollowerComponent()
            ],
          ),
          SizedBox(width: 20.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 5.h),
              Text(
                user?.firstName?.toUpperCase() ?? "",
                style: AppTextStyles.sofiaSansMedium(
                  fontSize: 30.sp,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (userLevelTag.isNotEmpty)
                  //   Container(
                  //       padding:
                  //           EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  //       decoration: BoxDecoration(
                  //           color: AppColors.brightGold,
                  //           borderRadius: BorderRadius.circular(10)),
                  //       child: Text(
                  //         userLevelTag.tr(context),
                  //         style: AppTextStyles.gothamNarrowLight()
                  //             .copyWith(fontSize: 15.sp, color: Colors.black),
                  //       )),
                  // SizedBox(width: 5.w),
                  Text(
                    "${(userLevel ?? 0).toStringAsFixed(2)} ${getRankLabel(userLevel ?? 0)}• ${user?.playingSide ?? ""}",
                    style: AppTextStyles.manropeMedium(
                      fontSize: 15.sp,
                      height: 1,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 13.h),
              Row(
                children: [
                  Text(
                    "WALLET".tr(context),
                    style: AppTextStyles.manropeSemiBold(
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  paymentDetails.when(
                      data: (data) {
                        if (data.isNotEmpty) {
                          return Text(
                            "${NumberFormat('#,##0', 'id_ID').format(data.first.balance)} $currency",
                            style: AppTextStyles.manropeMedium(
                              fontSize: 15.sp,
                            ),
                          );
                        }

                        return Text(
                          Utils.formatPrice2(0, currency),
                          style: AppTextStyles.manropeMedium(
                            fontSize: 15.sp,
                          ),
                        );
                      },
                      error: (error, stackTrace) => Text(
                            Utils.formatPrice2(0, currency),
                            style: AppTextStyles.manropeMedium(
                              fontSize: 15.sp,
                            ),
                          ),
                      loading: () => const Center(
                            child: CupertinoActivityIndicator(
                              radius: 10,
                            ),
                          ))
                ],
              )
            ],
          ),
          // SizedBox(width: 15.w),
          // membership.when(
          //     data: (data) {
          //       return Padding(
          //           padding: EdgeInsets.only(top: 25),
          //           child: _membershipButton(ref, context, data));
          //     },
          //     error: (e, _) => SizedBox(),
          //     loading: () => const Center(child: CupertinoActivityIndicator()))
        ],
      )
    ]);
  }

  Widget _membershipButton(
      WidgetRef ref, BuildContext context, UserActiveMembership data) {
    bool haveMembership = data.haveActiveHOPMembership != null;

    return InkWell(
      onTap: () async {
        final value = await showDialog(
          context: context,
          builder: (context) => _MembershipDialog(data: data),
        );

        if (value is bool && value) {
          onPurchaseMembership(ref, context, data);
        }
      },
      child: Container(
        width: 82.w,
        height: 49.h,
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        decoration: inset.BoxDecoration(
          color: haveMembership ? AppColors.yellow : AppColors.tileBgColor,
          boxShadow: kInsetShadow,
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 25.w,
              height: 18.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AppImages.hopSmall.path,
                  ),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            Expanded(
              child: Text(
                (!haveMembership ? "BECOME_MEMBER" : "MEMBER_CARD").tr(context),
                style: AppTextStyles.manropeMedium(fontSize: 11.sp),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> onPurchaseMembership(
      WidgetRef ref, BuildContext context, UserActiveMembership value) async {
    final selectedMembership = value.haveHOPMembership;
    if (selectedMembership == null) {
      return;
    }
    final data = await showPaymentSheet(
      context: context,
      child: PaymentInformation(
          allowWallet: false,
          type: PaymentDetailsRequestType.join,
          locationID: selectedMembership.locationId,
          requestType: PaymentProcessRequestType.membership,
          price: selectedMembership.price ?? 0,
          serviceID: selectedMembership.id,
          startDate: null,
          duration: null,
          allowCoupon: false,
          purchaseMembership: true),
    );
    var (int? success, double? amount) = (null, null);
    if (data is (int, double?)) {
      (success, amount) = data;
    }

    if (success != null && context.mounted) {
      await Utils.showMessageDialog(
        context,
        ("YOU_HAVE_PURCHASED_MEMBERSHIP").tr(context),
      );
      ref.invalidate(fetchActiveAndAllMembershipsProvider);
    }
  }
}

class SignOutButtonComponent extends ConsumerWidget {
  const SignOutButtonComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)?.user;
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(right: 18.5.w, bottom: 10.h, top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: InkWell(
              onTap: () {
                ref.read(goRouterProvider).push(
                  "${RouteNames.rankingProfile}/${user?.id ?? -1}",
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.black5,
                  borderRadius: BorderRadius.circular(100.r)
                ),
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 20.w),
                child: Text(
                  "SEE_RANKING_PROFILE".tr(context),
                  style: AppTextStyles.manropeMedium(
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              bool? logout = await showDialog(
                  context: context,
                  builder: (_) => const _SignOutConfirmation());
              if (logout == true) {
                await ref.read(userManagerProvider).signOut(ref);
                ref.read(goRouterProvider).pushReplacement(RouteNames.auth);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 20.w),
              decoration: BoxDecoration(
                  color: AppColors.black5,
                  borderRadius: BorderRadius.circular(100.r)
              ),
              child: Text(
                "SIGN_OUT".tr(context),
                style: AppTextStyles.manropeMedium(
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignOutConfirmation extends StatelessWidget {
  const _SignOutConfirmation();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // MultiStyleTextPositionLight(
          //   text: "SIGN_OUT_CONFIRMATION".trU(context),
          //   fontSize: 19.sp,
          //   color: AppColors.white,
          //   textBoldPosition: 3,
          //   letterSpacing: 1,
          // ),
          Text(
            "SIGN_OUT_CONFIRMATION".trU(context),
            style: AppTextStyles.popupHeaderTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          MainButton(
            label: "SIGN_OUT".trU(context),
            isForPopup: true,
            enabled: true,
            // borderRadius: 12.r,
            onTap: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    );
  }
}

class _MembershipDialog extends ConsumerWidget {
  final UserActiveMembership data;

  const _MembershipDialog({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final price = data.haveHOPMembership?.price ?? 0;

    final haveMembership = data.haveActiveHOPMembership;

    final isActive = haveMembership != null;

    return CustomDialog(
      color: isActive ? AppColors.white : AppColors.black2,
      closeIconColor: isActive ? AppColors.black : AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              isActive
                  ? "HOUSE_OF_PADEL_MEMBERSHIP".trU(context)
                  : "BECOME_A_MEMBER".trU(context),
              style: AppTextStyles.sofiaSansMedium(
                  fontSize: 19.sp,
                  color: isActive ? AppColors.black : AppColors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (isActive) _membershipCard(ref, context, data),
            if (isActive) const SizedBox(height: 16),
            _benefits(color: isActive ? AppColors.black : AppColors.white),
            if (!isActive) const SizedBox(height: 10),
            // Price
            if (!isActive)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Price: ${price.toStringAsFixed(0)} $currency/month",
                  style: AppTextStyles.manropeLight(
                      fontSize: 15.sp, color: AppColors.white),
                ),
              ),
            if (!isActive) const SizedBox(height: 20),
            // Purchase Button
            if (!isActive)
              MainButton(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  isForPopup: true,
                  label: "PURCHASE_MEMBERSHIP".trU(context))
          ],
        ),
      ),
    );
  }

  Widget _benefits({Color? color}) {
    final temp = [
      "25% Off individual booking.",
      "14 Day advance on bookings (7 day advance on general public)."
    ];

    return Column(
      children: [
        // Membership Benefits
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Membership Benefits:",
            style: AppTextStyles.manropeLight(
                fontSize: 15.sp, color: color ?? AppColors.white),
          ),
        ),
        const SizedBox(height: 12),

        // Benefits List
        ...temp.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check, color: AppColors.yellow, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    e,
                    style: AppTextStyles.manropeLight(
                        fontSize: 15.sp, color: color ?? AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _membershipCard(
      WidgetRef ref, BuildContext context, UserActiveMembership data) {
    final haveMembership = data.haveActiveHOPMembership;
    final user = ref.read(userManagerProvider).user?.user;
    final profilePicture = user?.profileUrl ?? "";
    final fullName = (user?.fullName ?? "").toUpperCase();

    final userLeft = haveMembership?.usesLeft ?? 0;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r), color: AppColors.black),
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Avatar + Member Info
          Row(
            children: [
              NetworkCircleImage(
                path: profilePicture,
                width: 50.w,
                height: 50.w,
                borderRadius: BorderRadius.circular(12.r),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MEMBER".tr(context),
                    style: AppTextStyles.manropeMedium(
                        fontSize: 13.sp, color: AppColors.white),
                  ),
                  SizedBox(height: 2),
                  Text(
                    fullName,
                    style: AppTextStyles.sofiaSansMedium(
                        fontSize: 13.sp, color: AppColors.white),
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 20),

          Center(
              child: Image.asset(AppImages.splashLogo.path,
                  width: 140.w, height: 77.h)),

          const SizedBox(height: 24),

          // Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Off-Peak Coaching
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Text(
              //       "${"OFF_PEAK_COACHING".tr(context)}:",
              //       style: AppTextStyles.qanelasRegular(
              //           fontSize: 13.sp, color: AppColors.white),
              //     ),
              //     Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Container(
              //           padding: const EdgeInsets.all(6),
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             shape: BoxShape.circle,
              //           ),
              //           child: Text(
              //             "$userLeft",
              //             style: AppTextStyles.qanelasMedium(
              //                 fontSize: 11.sp, color: AppColors.black),
              //           ),
              //         ),
              //         SizedBox(
              //           width: 5.w,
              //         ),
              //         Text(
              //           "${"REMAINING".tr(context)}",
              //           style: AppTextStyles.qanelasRegular(
              //               fontSize: 13.sp, color: AppColors.white),
              //         )
              //       ],
              //     )
              //   ],
              // ),

              // Valid Until
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    haveMembership?.finishDateString(context) ?? "",
                    style: AppTextStyles.manropeMedium(
                        fontSize: 13.sp, color: AppColors.white),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
