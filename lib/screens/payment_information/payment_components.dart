part of 'payment_information.dart';

/// Modern iOS-style Amount Payable Widget
class _ModernAmountPayableWidget extends ConsumerWidget {
  const _ModernAmountPayableWidget({
    required this.originalAmount,
  });

  final double originalAmount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mdr = ref.watch(_selectedMDR);
    double payableAmount = ref.watch(totalMultiBookingAmount);

    if (mdr != null) {
      payableAmount += Utils.calculateMDR(payableAmount, mdr);
    }

    return ModernAmountDisplay(
      amount: payableAmount,
      originalAmount: originalAmount > payableAmount ? originalAmount : null,
      label: "AMOUNT_PAYABLE".tr(context),
    );
  }
}

class _AmountPayable extends ConsumerWidget {
  _AmountPayable({
    required this.originalAmount,
  });

  final double originalAmount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mdr = ref.watch(_selectedMDR);
    double payableAmount = ref.watch(totalMultiBookingAmount);
    // final appliedCoupon = ref.watch(_appliedCoupon);

    // if (payableAmount == 0 && appliedCoupon == null) {
    //   WidgetsBinding.instance
    //       .addPostFrameCallback((_) => ref.read(goRouterProvider).pop());
    // }
    if (mdr != null) {
      payableAmount += Utils.calculateMDR(payableAmount, mdr);
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(100.r),
      ),
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 8.h, bottom: 8.h),
      child: Row(
        children: [
          Text(
            "AMOUNT_PAYABLE".tr(context),
            style: AppTextStyles.manropeSemiBold(
              fontSize: 13.sp,
              color: AppColors.brick,
            ),
          ),
          const Spacer(),
          if (originalAmount > payableAmount) ...[
            Text(
              Utils.formatPrice(originalAmount),
              style: AppTextStyles.manropeSemiBold(
                fontSize: 13.sp,
                color: AppColors.brick,
              ).copyWith(
                decoration: TextDecoration.lineThrough,
              ),
            ),
            SizedBox(width: 4.h),
          ],
          Text(
            Utils.formatPrice(payableAmount),
            style: AppTextStyles.manropeSemiBold(
                fontSize: 13.sp,
                color: AppColors.brick,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentButton extends ConsumerStatefulWidget {
  const _PaymentButton({
    required this.locationID,
    required this.price,
    this.serviceID,
    required this.requestType,
    required this.getPendingPayment,
    required this.bookingToOpenMatch,
    required this.isMultiBooking,
    required this.isJoiningApproval,
    required this.purchaseMembership,
    this.title,
    // this.boldPosition,
  });

  final int locationID;
  final double price;
  final bool getPendingPayment;
  // final int? boldPosition;
  final int? serviceID;
  final PaymentProcessRequestType requestType;
  final bool isJoiningApproval;
  final bool isMultiBooking;
  final bool bookingToOpenMatch;
  final String? title;

  final bool purchaseMembership;

  @override
  ConsumerState<_PaymentButton> createState() => _PaymentButtonState();
}

class _PaymentButtonState extends ConsumerState<_PaymentButton> {
  bool get isButtonEnabled {
    final selectedMethod = ref.watch(_selectedPaymentMethod);
    final isRedeemSelected = ref.watch(_selectedRedeem) != null;
    if (selectedMethod == null) {
      return false;
    }
    if (isRedeemSelected && (selectedMethod.methodType == kPayLaterMethod || selectedMethod.methodType == kWalletMethod)) {
      return false;
    }

    if (selectedMethod.methodType == kWalletMethod) {
      return widget.price <= (selectedMethod.walletBalance ?? 0);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MainButton(
      enabled: isButtonEnabled,
      label: widget.title?.toUpperCase() ?? "PROCEED_WITH_PAYMENT".tr(context).toUpperCase(),
      // child: Text(
      //   widget.title?.capitalWord(context, isButtonEnabled) ?? "PROCEED_WITH_PAYMENT".tr(context).capitalWord(context, isButtonEnabled),
      //   style: isButtonEnabled
      //       ? AppTextStyles.sofiaSansMedium(
      //           fontSize: 18.sp,
      //           color: AppColors.black2,
      //         )
      //       : AppTextStyles.sofiaSansMedium(fontSize: 18.sp, color: AppColors.white),
      // ),
      isForPopup: true,
      // color: AppColors.rosewood,
      // labelColor: isButtonEnabled ? AppColors.white: AppColors.baseGreen,
      onTap: () {
        if (widget.isMultiBooking) {
          _onPayMultiBookingTap();
        } else {
          _onPayTap();
        }
      },
      // labelStyle: AppTextStyles.manropeLight().copyWith(fontSize: 18.sp, color: isButtonEnabled ? AppColors.yellow : AppColors.white),
    );
  }

  void _onPayTap() async {
    late PaymentProcessProvider provider;
    final selectedPaymentType = ref.read(_selectedPaymentMethod);
    if (selectedPaymentType == null) return;
    if (selectedPaymentType.methodType == kPayLaterMethod) {
      provider = _payLaterProvider();
    } else {
      provider = _normalPaymentProvider(selectedPaymentType);
    }
    final data = await Utils.showLoadingDialog(context, provider, ref);
    if (data == null) {
      return;
    }
    log("_onPayTap : data ::: $data");
    log("_onPayTap : data.runtimeType ::: ${data.runtimeType}");

    if (!mounted) return;

    final (id, redirectURL) = data;
    if (redirectURL != null && id == null && mounted) {
      await _midtranProcess(redirectURL);
    }
    if (id != null && redirectURL == null && mounted) {
      Navigator.pop(context, (id, null));
    }
  }

  Future<void> _midtranProcess(dynamic data) async {
    String redirectURL = data["confirmationURL"] ?? "";
    String transactionId = data["transaction_id"] ?? "";

    MidtransHelper midtransHelper = MidtransMobilePaymentHelper();

    Map<String, dynamic>? params = await midtransHelper.handleRedirectURL(
      url: redirectURL,
      context: context,
      ref: ref,
    );
    if (params != null && mounted) {
      try {
        final provider = fetchServiceIDWithTransactionIDProvider(
            orderID: transactionId,
            statusCode: 200.toString(),
            transactionStatus: 'succeeded');
        if (!mounted) {
          return;
        }
        final int? id = await Utils.showLoadingDialog(context, provider, ref);
        if (id != null && mounted) {
          Navigator.pop(context, (id, null));
        }
      } catch (e) {
        if (!mounted) {
          return;
        }
        await Utils.showMessageDialog(context, e.toString());
      }
    } else {
      if (mounted) {
        Utils.showMessageDialog(
          context,
          "PAYMENT_FAILED_OR_CANCELED".tr(context),
        );
      }
    }
  }

  void _onPayMultiBookingTap() async {
    late MultiBookingPaymentProcessProvider provider;
    final selectedPaymentType = ref.read(_selectedPaymentMethod);
    if (selectedPaymentType == null) return;
    if (selectedPaymentType.methodType == kPayLaterMethod) {
      provider = _payLaterProvider();
    } else {
      provider = _normalPaymentProvider(selectedPaymentType);
    }
    final data = await Utils.showLoadingDialog(context, provider, ref, barrierDismissible: false);
    if (data == null) {
      ref.invalidate(fetchBookingCartListProvider);
      return;
    }
    if (data is String && data == "Oops! One Of Your Selected Bookings Was Taken") {
      ref.read(goRouterProvider).pop();
      return;
    }
    final (id, redirectURL) = data;
    // if (redirectURL != null && id == null && mounted) {
    //   await _midTranProcess(redirectURL);
    // }
    if (id != null && redirectURL == null && mounted) {
      Navigator.pop(context, id);
    }
  }

  dynamic _payLaterProvider() {
    final couponID = ref.read(_appliedCoupon)?.couponId;
    if (widget.isMultiBooking) {
      return multiBookingPaymentProcessProvider(
        totalAmount: widget.price,
        payLater: true,
        requestType: widget.requestType,
        serviceID: widget.serviceID,
        isJoiningApproval: widget.isJoiningApproval,
        couponID: couponID,
      );
    }
    return paymentProcessProvider(
      pendingPayment: widget.getPendingPayment,
      totalAmount: widget.price,
      payLater: true,
      bookingToOpenMatch: widget.bookingToOpenMatch,
      requestType: widget.requestType,
      serviceID: widget.serviceID,
      isJoiningApproval: widget.isJoiningApproval,
      couponID: couponID,
    );
  }

  dynamic _normalPaymentProvider(AppPaymentMethods selectedPaymentType) {
    final redeemMethod = ref.read(_selectedRedeem);
    final appliedCoupon = ref.read(_appliedCoupon);
    final List<AppPaymentMethods> paymentMethods = [];

    if (redeemMethod != null) {
      paymentMethods.add(AppPaymentMethods(
        id: redeemMethod.id,
        methodType: kWalletMethod,
        amountToPay: (redeemMethod.walletBalance ?? 0.0),
      ));
      selectedPaymentType.amountToPay = widget.price - (redeemMethod.walletBalance ?? 0.0);
    } else {
      selectedPaymentType.amountToPay = widget.price;
    }

    paymentMethods.add(selectedPaymentType);

    if (widget.isMultiBooking && paymentMethods.isNotEmpty) {
      return multiBookingPaymentProcessProvider(
        totalAmount: widget.price,
        paymentMethod: paymentMethods.first,
        requestType: widget.requestType,
        serviceID: widget.serviceID,
        isJoiningApproval: widget.isJoiningApproval,
        couponID: appliedCoupon?.couponId,
      );
    }

    return paymentProcessProvider(
      totalAmount: widget.price,
      pendingPayment: widget.getPendingPayment,
      paymentMethod: paymentMethods,
      requestType: widget.requestType,
      serviceID: widget.serviceID,
      bookingToOpenMatch: widget.bookingToOpenMatch,
      isJoiningApproval: widget.isJoiningApproval,
      purchaseMembership: widget.purchaseMembership,
      couponID: appliedCoupon?.couponId,
      locationID: widget.locationID,
    );
  }
}

class _PaymentMethods extends ConsumerStatefulWidget {
  const _PaymentMethods(
      {required this.price,
      required this.paymentDetails,
      required this.requestType,
      required this.allowPayLater,
      required this.isMultiBooking,
      required this.serviceID,
      required this.bookingToOpenMatch,
      required this.startDate,
      required this.courtId,
      required this.duration,
      required this.isOpenMatch,
      required this.variantId,
      required this.allowWallet,
      required this.allowMembership,
      required this.locationID});

  final double price;
  final bool isMultiBooking;
  final bool allowPayLater;
  final bool isOpenMatch;
  final PaymentDetails paymentDetails;
  final int locationID;
  final int? serviceID;
  final PaymentDetailsRequestType requestType;
  final bool bookingToOpenMatch;
  final DateTime? startDate;
  final int? duration;
  final int? courtId;
  final int? variantId;

  final bool allowWallet;
  final bool allowMembership;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __WalletState();
}

class __WalletState extends ConsumerState<_PaymentMethods> {
  @override
  void initState() {
    if (widget.bookingToOpenMatch || !widget.allowWallet) {
      (widget.paymentDetails.appPaymentMethods ?? []).removeWhere((e) => e.methodType == kWalletMethod);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = ((widget.paymentDetails.userMemberships?.length ?? 0) == 0) && ((widget.paymentDetails.appPaymentMethods?.length ?? 0) == 0);

    if (isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: PaymentSheetColors.cardBackground,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: PaymentSheetColors.divider, width: 0.5),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: PaymentSheetColors.secondaryText,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  "NO_PAYMENT_METHOD_FOUND".tr(context),
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: PaymentSheetColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return ModernPaymentMethodsList(
      children: [
        if (widget.allowMembership)
          ...List.generate(
            widget.paymentDetails.userMemberships?.length ?? 0,
            (index) {
              final userMembership = widget.paymentDetails.userMemberships?[index];
              if (userMembership == null) {
                return const SizedBox();
              }
              final paymentMethod = AppPaymentMethods(
                id: userMembership.membership?.id,
                methodType: kMembershipMethod,
                membershipId: userMembership.id,
                methodTypeText: userMembership.membership?.membershipName,
              );
              final selectedPaymentMethod = ref.watch(_selectedPaymentMethod);
              bool isSelected = selectedPaymentMethod?.id == paymentMethod.id;
              return _buildModernPaymentOption(paymentMethod, isSelected: isSelected, prefix: userMembership.usesLeftString(context, isSelected));
            },
          ),
        ...List.generate(
          (widget.paymentDetails.appPaymentMethods ?? []).length,
          (index) {
            final paymentMethod = (widget.paymentDetails.appPaymentMethods ?? [])[index];
            if (paymentMethod.methodType == kPayLaterMethod && !widget.allowPayLater) {
              return const SizedBox(); // Hide "Pay Later"
            }
            return _buildModernPaymentMethodItem(paymentMethod);
          },
        ),
      ],
    );
  }

  Widget _buildPaymentOption(AppPaymentMethods paymentMethod, {MDRRates? mdr, required Widget? prefix, required bool isSelected}) {
    final selectedRedeemMethod = ref.watch(_selectedRedeem);
    final isRedeemSelected = selectedRedeemMethod != null;

    String title = _getPaymentMethodTitle(paymentMethod, isRedeemSelected);
    bool isRedeemAvailable = _isRedeemAvailable(paymentMethod);

    if (isRedeemAvailable) {
      if (widget.isMultiBooking) {
        return const SizedBox();
      }
      return _buildRedeemOption(
        title: title,
        isSelected: isRedeemSelected,
        imagePath: AppImages.walletIcon.path,
        onTap: () => _toggleRedeemSelection(isRedeemSelected, paymentMethod),
      );
    }

    if (paymentMethod.methodType == kPayLaterMethod && isRedeemSelected) {
      return SizedBox(); // Hide "Pay Later" if redeem is selected
    }

    return _buildPaymentMethodOption(
      title: title,
      isSelected: isSelected,
      prefix: prefix,
      imagePath: AppImages.walletIcon.path,
      onTap: () => _selectPaymentMethod(paymentMethod, mdr: mdr),
      showDelete: false,
      onDelete: null,
    );
  }

  Widget _buildPaymentMethodItem(AppPaymentMethods paymentMethod, {Widget? prefix}) {
    final selectedPaymentMethod = ref.watch(_selectedPaymentMethod);
    final selectedRedeemMethod = ref.watch(_selectedRedeem);
    final isRedeemSelected = selectedRedeemMethod != null;

    String title = _getPaymentMethodTitle(paymentMethod, isRedeemSelected);
    bool isSelected = selectedPaymentMethod?.id == paymentMethod.id;
    bool isRedeemAvailable = _isRedeemAvailable(paymentMethod);

    if (isRedeemAvailable) {
      return _buildRedeemOption(
        title: title,
        isSelected: isRedeemSelected,
        imagePath: AppImages.walletIcon.path,
        onTap: () => _toggleRedeemSelection(isRedeemSelected, paymentMethod),
      );
    }

    if (paymentMethod.methodType == kPayLaterMethod && isRedeemSelected) {
      return SizedBox(); // Hide "Pay Later" if redeem is selected
    }

    return _buildPaymentMethodOption(
      title: title,
      isSelected: isSelected,
      prefix: prefix,
      imagePath: AppImages.walletIcon.path,
      onTap: () => _selectPaymentMethod(paymentMethod),
      showDelete: false,
      onDelete: null,
    );
  }

  bool _isRedeemAvailable(AppPaymentMethods paymentMethod) {
    final walletBalance = paymentMethod.walletBalance ?? 0.0;
    return paymentMethod.methodType == kWalletMethod && widget.price > walletBalance;
  }

  void _toggleRedeemSelection(bool isRedeemSelected, AppPaymentMethods paymentMethod) {
    if ((paymentMethod.walletBalance ?? 0) == 0) {
      return;
    }
    ref.read(_selectedRedeem.notifier).state = isRedeemSelected ? null : paymentMethod;
  }

  void _selectPaymentMethod(AppPaymentMethods paymentMethod, {MDRRates? mdr}) {
    ref.read(_selectedPaymentMethod.notifier).state = paymentMethod;
    ref.read(_selectedMDR.notifier).state = mdr;
  }

  // Modern payment method builders
  Widget _buildModernPaymentOption(AppPaymentMethods paymentMethod, {MDRRates? mdr, required Widget? prefix, required bool isSelected}) {
    final selectedRedeemMethod = ref.watch(_selectedRedeem);
    final isRedeemSelected = selectedRedeemMethod != null;

    String title = _getPaymentMethodTitle(paymentMethod, isRedeemSelected);
    bool isRedeemAvailable = _isRedeemAvailable(paymentMethod);

    if (isRedeemAvailable) {
      if (widget.isMultiBooking) {
        return const SizedBox();
      }
      return _buildModernRedeemOption(
        title: title,
        isSelected: isRedeemSelected,
        onTap: () => _toggleRedeemSelection(isRedeemSelected, paymentMethod),
      );
    }

    if (paymentMethod.methodType == kPayLaterMethod && isRedeemSelected) {
      return const SizedBox();
    }

    return ModernPaymentMethodCard(
      title: title.capitalizeFirst,
      isSelected: isSelected,
      iconPath: AppImages.walletIcon.path,
      prefix: prefix,
      onTap: () => _selectPaymentMethod(paymentMethod, mdr: mdr),
    );
  }

  Widget _buildModernPaymentMethodItem(AppPaymentMethods paymentMethod, {Widget? prefix}) {
    final selectedPaymentMethod = ref.watch(_selectedPaymentMethod);
    final selectedRedeemMethod = ref.watch(_selectedRedeem);
    final isRedeemSelected = selectedRedeemMethod != null;

    String title = _getPaymentMethodTitle(paymentMethod, isRedeemSelected);
    bool isSelected = selectedPaymentMethod?.id == paymentMethod.id;
    bool isRedeemAvailable = _isRedeemAvailable(paymentMethod);

    if (isRedeemAvailable) {
      return _buildModernRedeemOption(
        title: title,
        isSelected: isRedeemSelected,
        onTap: () => _toggleRedeemSelection(isRedeemSelected, paymentMethod),
      );
    }

    if (paymentMethod.methodType == kPayLaterMethod && isRedeemSelected) {
      return const SizedBox();
    }

    IconData? icon;
    if (paymentMethod.methodType == kPayLaterMethod) {
      icon = Icons.schedule_outlined;
    } else if (paymentMethod.methodType == kWalletMethod) {
      icon = Icons.account_balance_wallet_outlined;
    }

    return ModernPaymentMethodCard(
      title: title.capitalizeFirst,
      isSelected: isSelected,
      icon: icon,
      iconPath: icon == null ? AppImages.walletIcon.path : null,
      prefix: prefix,
      onTap: () => _selectPaymentMethod(paymentMethod),
    );
  }

  Widget _buildModernRedeemOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ModernPaymentMethodCard(
      title: title.capitalizeFirst,
      subtitle: "USE_CREDITS".tr(context),
      isSelected: isSelected,
      icon: Icons.account_balance_wallet_outlined,
      showToggle: true,
      isToggled: isSelected,
      onTap: onTap,
    );
  }

  Widget _buildPaymentMethodOption(
      {required String title,
      required bool isSelected,
      required String imagePath,
      required VoidCallback onTap,
      Widget? prefix,
      required VoidCallback? onDelete,
      required bool showDelete}) {
    return _buildOptionContainer(
      title: title,
      isSelected: isSelected,
      imagePath: imagePath,
      prefix: prefix,
      onTap: onTap,
      showDelete: showDelete,
      onDelete: onDelete,
    );
  }

  Widget _buildRedeemOption({
    required String title,
    required bool isSelected,
    required String imagePath,
    required VoidCallback onTap,
    Widget? prefix,
  }) {
    return _buildOptionContainer(
      title: title,
      isSelected: isSelected,
      imagePath: imagePath,
      prefix: prefix,
      onTap: onTap,
      showSwitch: true,
    );
  }

  String _getPaymentMethodTitle(AppPaymentMethods paymentMethod, bool isRedeemSelected) {
    if (paymentMethod.methodType == kWalletMethod) {
      final walletBalance = paymentMethod.walletBalance ?? 0.0;
      return widget.price > walletBalance
          ? "${"REDEEM_CREDITS".tr(context)} ${Utils.formatPrice(walletBalance)}"
          : "${"WALLET".tr(context)} ${Utils.formatPrice(walletBalance)}";
    } else if (paymentMethod.methodType == kPayLaterMethod) {
      return "PAY_LATER".tr(context);
    } else {
      return paymentMethod.methodTypeText ?? "";
    }
  }

  Widget _buildOptionContainer({
    required String title,
    required bool isSelected,
    required String imagePath,
    required VoidCallback onTap,
    required Widget? prefix,
    VoidCallback? onDelete,
    bool showSwitch = false,
    bool showDelete = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : AppColors.white25,
          borderRadius: BorderRadius.circular(100.r),
        ),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 22.w,
              height: 22.w,
              color: isSelected ? AppColors.brick : AppColors.white,
            ),
            SizedBox(width: 15.w),
            Expanded(
              flex: 100,
              child: Text(
                title.capitalizeFirst,
                style: isSelected
                    ? AppTextStyles.manropeSemiBold(
                        fontSize: 16.sp,
                        color: AppColors.brick,
                      )
                    : AppTextStyles.manropeMedium(color: AppColors.white, fontSize: 16.sp),
              ),
            ),
            const Spacer(),
            if (showSwitch)
              SizedBox(
                height: 22.h,
                child: Transform.scale(
                  scale: 0.75,
                  child: CupertinoSwitch(
                    value: isSelected,
                    thumbColor: Colors.white,
                    activeColor: AppColors.brick,
                    trackColor: AppColors.white55,
                    onChanged: (value) {
                      onTap();
                    },
                  ),
                ),
              ),
            if (showDelete && !showSwitch)
              InkWell(
                onTap: () {
                  onDelete?.call();
                },
                child: Image.asset(
                  AppImages.closeIcon.path,
                  width: 10.h,
                  height: 10.h,
                  color: AppColors.brick,
                ),
              ),
            if (prefix != null) prefix,
          ],
        ),
      ),
    );
  }
}

class _CouponApplyButton extends ConsumerWidget {
  const _CouponApplyButton({
    required this.price,
    required this.couponController,
  });

  final double price;
  final TextEditingController couponController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInvalidCoupon = ref.watch(_invalidCoupon);
    return InkWell(
      onTap: () async {
        if (couponController.text.isEmpty) {
          return;
        }
        final done = await Utils.showLoadingDialog(
          context,
          verifyCouponProvider(
            coupon: couponController.text,
            price: price,
          ),
          ref,
        );
        if (done is CouponModel) {
          done.coupon = couponController.text;
          ref.read(_appliedCoupon.notifier).state = done;
          ref.read(_invalidCoupon.notifier).state = false;
        } else {
          ref.read(_invalidCoupon.notifier).state = true;
        }
        ref.read(totalMultiBookingAmount.notifier).state = calculateAmountPayable(ref, price);
      },
      child: isInvalidCoupon
          ? Image.asset(
              AppImages.crossIcon.path,
              width: 18.w,
              height: 18.w,
              color: AppColors.errorColor,
            )
          : Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AppImages.unselectedTag.path,
                  ),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
    );
  }
}

class _CloseConfirmationDialog extends ConsumerWidget {
  final bool showDescription;
  const _CloseConfirmationDialog({
    Key? key,
    this.showDescription = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomDialog(
      // color: AppColors.darkYellow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.h),
          Image.asset(
            AppImages.warning2.path,
            height: 90.h,
            width: 90.h,
            color: AppColors.white,
          ),
          SizedBox(height: 28.h),
          Text(
            "YOU ARE LEAVING THE\nPAYMENT PROCESS",
            textAlign: TextAlign.center,
            style: AppTextStyles.popupHeaderTextStyle,
          ),
          if(showDescription)
          SizedBox(height: 12.h),
          if(showDescription)
          Text(
            "When exiting the payment process,\nthe court will be blocked and\nunavailable for 10 minutes.",
            textAlign: TextAlign.center,
            style: AppTextStyles.popupBodyTextStyle,
          ),
          SizedBox(height: 25.h),
          MainButton(
            label: "AGREE_AND_CONTINUE".trU(context),
            onTap: () {
              ref.read(goRouterProvider).pop(true);
            },
            isForPopup: true,
            // color: AppColors.darkYellow50,
            // labelStyle: AppTextStyles.qanelasRegular(
            //   color: AppColors.white,
            //   fontSize: 18.sp,
            //   letterSpacing: 0.5,
            // ),
            // borderRadius: 100.r,
            height: 40.h,
            width: double.infinity,
            applySize: false,
          ),
          SizedBox(height: 12.h),
          MainButton(
            label: "CANCEL_AND_GO_BACK".trU(context),
            onTap: () {
              ref.read(goRouterProvider).pop(false);
            },
            // color: AppColors.white25,
            isForPopup: true,
            // labelStyle: AppTextStyles.qanelasLight(
            //   color: AppColors.white,
            //   fontSize: 18.sp,
            //   letterSpacing: 0.3,
            // ),
            // borderRadius: 100.r,
            height: 40.h,
            width: double.infinity,
            applySize: false,
            enabled: true,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
