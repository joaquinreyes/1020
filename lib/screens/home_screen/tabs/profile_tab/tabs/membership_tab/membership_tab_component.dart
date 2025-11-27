part of 'membership_tab.dart';

class _MembershipDialog extends StatelessWidget {
  final MembershipModel membership;
  final ActiveMemberships? activeMembership;

  const _MembershipDialog(
      {required this.membership, required this.activeMembership});

  @override
  Widget build(BuildContext context) {
    final membershipName = membership.membershipName?.toUpperCase() ?? "";
    final categoryName = membership.categoryName ?? "";

    final membershipDescription = membership.description ?? "";
    final membershipPrice = membership.price ?? 0;
    final bool isGold = membershipName.toLowerCase().contains("coach");

    final membershipValidity =
        activeMembership?.finishDateString(context) ?? "";

    return CustomDialog(
      maxHeight: MediaQuery.of(context).size.height * 0.85,

      child: Column(
        children: [
          // Image.asset(
          //   isGold
          //       ? AppImages.membershipGoldCard.path
          //       : AppImages.membershipCard.path,
          //   height: 99.h,
          //   width: 99.h,
          //   fit: BoxFit.contain,
          // ),
          SizedBox(height: 5.h),
          Text(
            "${"MEMBERSHIP".trU(context)} ${"INFORMATION".trU(context)}",
            style: AppTextStyles.popupHeaderTextStyle,
          ),
          5.verticalSpace,
          Text(
            "MEMBERSHIPS_WILL_BE_SHOWN_IN_YOUR_PROFILE".tr(context),
            style: AppTextStyles.popupBodyTextStyle,
          ),
          // Text(
          //   membershipName,
          //   style: AppTextStyles.popupHeaderTextStyle,
          //   textAlign: TextAlign.center,
          // ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            constraints: kComponentWidthConstraint,
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${categoryName.trim().isNotEmpty ? "${categoryName.toUpperCase()} : " : ""}$membershipName",
                  style: AppTextStyles.sofiaSansMedium(
                      color: AppColors.brick, fontSize: 21.sp),
                  textAlign: TextAlign.start,
                ),
                CDivider(
                  color: AppColors.white25,
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${"PRICE".tr(context)} ${Utils.formatPrice(membershipPrice)}",
                          style: AppTextStyles.manropeMedium(
                            fontSize: 15.sp,
                            color: AppColors.brick,
                          ),
                        ),
                        // Text(
                        //   Utils.formatPrice(membershipPrice),
                        //   style: AppTextStyles.qanelasSemiBold(fontSize: 15.sp,),
                        // ),
                      ],
                    ),
                    // Text(
                    //   membershipValidity,
                    //   style: AppTextStyles.qanelasRegular(fontSize: 15.sp,),
                    // ),
                  ],
                ),
                // SizedBox(height: 5.h),
                // CDivider(
                //   color: AppColors.black25,
                // ),
                // SizedBox(height: 5.h),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       "DESCRIPTION".tr(context),
                //       style: AppTextStyles.qanelasMedium(
                //           fontSize: 16.sp,),
                //     ),
                //     SizedBox(height: 5.h),
                //     Text(
                //       membershipDescription,
                //       style: AppTextStyles.qanelasRegular(
                //           fontSize: 15.sp,),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          if (membershipDescription.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  Text(
                    "${"DESCRIPTION".trU(context)} :",
                    style: AppTextStyles.sofiaSansMedium(
                        color: AppColors.white, fontSize: 20.sp),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    membershipDescription,
                    style: AppTextStyles.popupBodyTextStyle,
                  ),
                ],
              ),
            ),

          SizedBox(height: 25.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: MainButton(
              isForPopup: true,
              // padding: EdgeInsets.only(top: 9.h, bottom: 5.h),
              label: "PAY_MEMBERSHIP".trU(context),
              // labelStyle: AppTextStyles.qanelasRegular(
              //   color: AppColors.white,
              //   fontSize: 17.sp,
              //   letterSpacing: 17.sp * 0.12,
              // ),
              onTap: () {
                Navigator.pop(context, true);
              },
            ),
          )
        ],
      ),
    );
  }
}

class _MembershipCategorySelection extends ConsumerWidget {
  final List<ShowMembershipCategory> showMembershipCategories;

  const _MembershipCategorySelection({required this.showMembershipCategories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(selectedMembershipCatIndex);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: inset.BoxDecoration(
          color: AppColors.black5,
          boxShadow: kInsetShadow,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: showMembershipCategories.map((e) {
            final id = e.id;
            final isSelected = listEquals(e.id, value);
            final categoryName = e.categoryName ?? "";
            return InkWell(
              onTap: () {
                if (!isSelected) {
                  ref.read(selectedMembershipCatIndex.notifier).state = id;
                }
              },
              child: Container(
                width: 90.w,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                margin: EdgeInsets.symmetric(
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  categoryName.capitalizeFirst,
                  textAlign: TextAlign.center,
                  style: isSelected
                      ? GoogleFonts.gothicA1(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        )
                      : GoogleFonts.gothicA1(
                          color: AppColors.black70,
                          fontWeight: FontWeight.w300,
                          fontSize: 12.sp,
                        ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MembershipListComponent extends ConsumerWidget {
  final UserActiveMembership data;
  final Axis scrollDirection;
  final bool showAllMembership;

  const MembershipListComponent(
      {super.key,
      required this.data,
      this.scrollDirection = Axis.vertical,
      this.showAllMembership = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMembershipCategory = ref.watch(selectedMembershipCatIndex);

    final Map<String, List<MembershipModel>> membershipDetails = data
        .getMembershipDetails(selectedMembershipCategory, showAllMembership);

    if (membershipDetails.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: membershipDetails.entries.map((entry) {
        final membershipCategoryName = entry.key;
        final membershipModels = entry.value;

        final isHorizontalScroll = scrollDirection == Axis.horizontal;
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(bottom: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!showAllMembership)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Text(
                      membershipCategoryName.toUpperCase(),
                      style: AppTextStyles.sofiaSansMedium(
                        fontSize: 23.sp,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                membershipModels.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Text("NO_PURCHASE_MEMBERSHIP_FOUND".tr(context),
                            style: AppTextStyles.manropeMedium(
                              fontSize: 13.sp,
                            )),
                      )
                    : isHorizontalScroll
                        ? SizedBox(
                            height: 80.h,
                            width: double.infinity,
                            child: listMembership(
                                ref: ref, membershipModels: membershipModels))
                        : listMembership(
                            ref: ref, membershipModels: membershipModels),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget listMembership(
      {required WidgetRef ref,
      required List<MembershipModel> membershipModels}) {
    final isHorizontalScroll = scrollDirection == Axis.horizontal;
    return ListView.builder(
        shrinkWrap: !isHorizontalScroll,
        scrollDirection: scrollDirection,
        itemCount: membershipModels.length,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        physics: isHorizontalScroll
            ? BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final e = membershipModels[index];
          final membershipName = (e.membershipName ?? "");
          final activeMembership = data.activeMemberships(e.id ?? 0);
          return Padding(
            padding: isHorizontalScroll
                ? EdgeInsets.only(right: 15.w)
                : EdgeInsets.only(bottom: 5.h),
            child: isHorizontalScroll
                ? Container(
                    width: 270.w,
                    height: 100.h,
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    decoration: BoxDecoration(
                      color: AppColors.blue50,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            membershipName.toUpperCase(),
                            style: AppTextStyles.sofiaSansMedium(
                              fontSize: 19.sp,
                              color: AppColors.white
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${"PRICE".tr(context)} ${Utils.formatPrice(e.price)}',
                                style: AppTextStyles.manropeSemiBold(
                                  fontSize: 13.sp,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final selectedDate = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return _MembershipDialog(
                                        activeMembership: activeMembership,
                                        membership: e);
                                  },
                                );
                                if (selectedDate is! bool &&
                                    selectedDate != true) {
                                  return;
                                }
                                final data = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return PaymentInformation(
                                      type: PaymentDetailsRequestType
                                          .membership,
                                      locationID: e.locationId,
                                      allowCoupon: false,
                                      allowMembership: false,
                                      allowWallet: false,
                                      purchaseMembership: true,
                                      price: e.price ?? 0,
                                      requestType: PaymentProcessRequestType
                                          .membership,
                                      serviceID: e.id ?? 0,
                                      startDate: null,
                                      duration: null,
                                    );
                                  },
                                );
                                var (int? paymentDone, double? amount) =
                                    (null, null);
                                if (data is (int, double?)) {
                                  (paymentDone, amount) = data;
                                }
                                if (paymentDone != null && context.mounted) {
                                  await Utils.showMessageDialog(
                                    context,
                                    "YOU_HAVE_PURCHASED_MEMBERSHIP_SUCCESSFULLY"
                                        .tr(context),
                                  );
                                }
                                ref.invalidate(
                                    fetchActiveAndAllMembershipsProvider);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 4.5.h),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  boxShadow: kInsetShadow,
                                  borderRadius: BorderRadius.circular(8.r),
                                  // border: Border.all(color: AppColors.black25, width: 1),
                                ),
                                child: Text(
                                  'Buy',
                                  style: AppTextStyles.sofiaSansMedium(
                                    fontSize: 18.sp,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          membershipName,
                          style: AppTextStyles.manropeSemiBold(
                              fontSize: 16.sp,),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          final selectedDate = await showDialog(
                            context: context,
                            builder: (context) {
                              return _MembershipDialog(
                                  activeMembership: activeMembership,
                                  membership: e);
                            },
                          );
                          if (selectedDate is! bool && selectedDate != true) {
                            return;
                          }
                          final data = await showDialog(
                            context: context,
                            builder: (context) {
                              return PaymentInformation(
                                type: PaymentDetailsRequestType.membership,
                                locationID: e.locationId,
                                allowCoupon: false,
                                allowMembership: false,
                                allowWallet: false,
                                purchaseMembership: true,
                                price: e.price ?? 0,
                                requestType:
                                    PaymentProcessRequestType.membership,
                                serviceID: e.id ?? 0,
                                startDate: null,
                                duration: null,
                              );
                            },
                          );
                          var (int? paymentDone, double? amount) =
                              (null, null);
                          if (data is (int, double?)) {
                            (paymentDone, amount) = data;
                          }
                          if (paymentDone != null && context.mounted) {
                            await Utils.showMessageDialog(
                              context,
                              "YOU_HAVE_PURCHASED_MEMBERSHIP_SUCCESSFULLY"
                                  .tr(context),
                            );
                          }
                          ref.invalidate(
                              fetchActiveAndAllMembershipsProvider);
                        },
                        child: activeMembership == null
                            ? Container(
                                width: 120.w,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 6.h),
                                decoration: inset.BoxDecoration(
                                    color: AppColors.black5,
                                    boxShadow: kInsetShadow,
                                    borderRadius:
                                        BorderRadius.circular(100.r)),
                                alignment: Alignment.center,
                                child: Text(
                                  "GET_MEMBERSHIP".tr(context),
                                  style: AppTextStyles.manropeMedium(
                                      fontSize: 12.sp),
                                ),
                              )
                            : Container(
                                width: 120.w,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 4.h),
                                decoration: inset.BoxDecoration(
                                    color: AppColors.blue,
                                    boxShadow: kInsetShadow,
                                    borderRadius:
                                        BorderRadius.circular(100.r)),
                                alignment: Alignment.center,
                                child: Center(
                                    child: activeMembership
                                        .usesLeftString(context)),
                              ),
                      )
                    ],
                  ),
          );
        });
  }
}
