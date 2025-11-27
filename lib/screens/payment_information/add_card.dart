part of 'payment_information.dart';

class _AddCard extends ConsumerStatefulWidget {
  _AddCard();

  @override
  ConsumerState<_AddCard> createState() => _AddCardState();
}

class _AddCardState extends ConsumerState<_AddCard> {
  final CardFormEditController _formController = CardFormEditController();
  final CardEditController _editFormController = CardEditController();

  @override
  void initState() {
    _formController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "PAYMENT_INFORMATION".trU(context),
            style: AppTextStyles.popupHeaderTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.h),
          Text(
            "ENTER_CARD_DETAILS".tr(context),
            style: AppTextStyles.popupBodyTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: isCurrentOSMobile ? 230.h : 70.h,
            child: isCurrentOSMobile ? _cardFormField() : _cardField(),
          ),
          MainButton(
            label: "SAVE_CARD".tr(context).capitalWord(
                context,
                isCurrentOSMobile
                    ? _formController.details.complete
                    : _editFormController.details.complete),
            isForPopup: true,
            enabled: isCurrentOSMobile
                ? _formController.details.complete
                : _editFormController.details.complete,
            // labelStyle: AppTextStyles.gothicLight().copyWith(
            //     fontSize: 18.sp,
            //     color: _formController.details.complete
            //         ? AppColors.mediumGreen
            //         : AppColors.white),
            onTap: () async {
              final bool? done = await Utils.showLoadingDialog(
                context,
                createAndAttachPaymentMethodProvider,
                ref,
              );
              if (done == true && context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
          )
        ],
      ),
    );
    // return Scaffold(
    //   backgroundColor: Colors.transparent,
    //   body: Center(
    //     child: Material(
    //       color: Colors.transparent,
    //       child: Container(
    //         width: 344.w,
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           borderRadius: BorderRadius.circular(7.r),
    //         ),
    //         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
    //         child: ListView(
    //           shrinkWrap: true,
    //           children: [
    //             Align(
    //               alignment: AlignmentDirectional.centerEnd,
    //               child: InkWell(
    //                 onTap: () => Get.back(),
    //                 child: Image.asset("$kAssets/icon-close.png", height: 24.h),
    //               ),
    //             ),
    //             SizedBox(height: 5.h),
    //             Center(
    //               child: Text(
    //                 'payment_information'.trU,
    //                 style: TextStyle(
    //                   color: kSecondaryColor,
    //                   fontSize: 18.sp,
    //                   fontFamily: kHighSpeed,
    //                   fontWeight: FontWeight.w400,
    //                   letterSpacing: -1.89,
    //                 ),
    //               ),
    //             ),
    //             SizedBox(height: 25.h),
    //             Center(
    //               child: Text(
    //                 'enter_card_details'.trU,
    //                 style: TextStyle(
    //                   color: kSecondaryColor,
    //                   fontSize: 12.sp,
    //                   fontFamily: kMontserrat,
    //                   fontWeight: FontWeight.w800,
    //                 ),
    //               ),
    //             ),
    //             SizedBox(height: 20.h),
    //             Theme(
    //               data: ThemeData(
    //                 primaryColor: kSecondaryColor,
    //               ),
    //               child: SizedBox(
    //                 height: 200.h,
    //                 child: CardFormField(
    //                   controller: _formController,
    //                   dangerouslyGetFullCardDetails: false,
    //                   autofocus: true,
    //                   enablePostalCode: false,
    //                   countryCode: 'AE',
    //                   style: CardFormStyle(
    //                     borderWidth: 0,
    //                     borderRadius: 15.r.toInt(),
    //                     textColor: kSecondaryColor,
    //                     placeholderColor: kSecondaryColor,
    //                     backgroundColor: calculateColorOverBackground(
    //                       kAlto,
    //                       "7F",
    //                       Colors.white,
    //                     ),
    //                     cursorColor: kPrimaryColor,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(height: 25.sp),
    //             MainButton(
    //               label: "save_card".trU, //'book_court'.trU,
    //               enabled: _formController.details.complete,
    //               onTap: () async {
    //                 //bookService(context);
    //                 Overlay.of(context).insert(kLoadingOverlay);
    //                 bool isCreated =
    //                     await AppController.I.createPaymentMethod();
    //                 kLoadingOverlay.remove();
    //                 if (isCreated) {
    //                   Get.back(result: isCreated);
    //                 }
    //               },
    //             ),
    //             SizedBox(height: 15.h),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  CardField _cardField() {
    return CardField(
      controller: _editFormController,
      autofocus: true,
      enablePostalCode: false,
      countryCode: "MY",
      decoration: const InputDecoration(
        fillColor: Colors.white,
        filled: true,
      ),
      onCardChanged: (CardFieldInputDetails? card) {
        setState(() {});
      },
    );
  }

  CardFormField _cardFormField() {
    return CardFormField(
      controller: _formController,
      autofocus: true,
      enablePostalCode: false,
      countryCode: "MY",
      style: CardFormStyle(
        borderWidth: 0,
        borderRadius: 8,
        textColor: AppColors.black,
        placeholderColor: AppColors.black,
        backgroundColor: AppColors.white,
        cursorColor: AppColors.black,
      ),
    );
  }
}
