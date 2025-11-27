part of 'settings.dart';

class _DeletePasswordBtns extends ConsumerWidget {
  const _DeletePasswordBtns();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        InkWell(
          onTap: () async {
            final done = await showDialog(
              context: context,
              builder: (context) => const _DeleteAccountConfirmation(),
            );
            if (done == true && context.mounted) {
              Utils.showMessageDialog2(
                context,
                "ACCOUNT_DELETED".trU(context),
              );
              ref.read(userManagerProvider).signOut(ref);
              ref.read(goRouterProvider).pushReplacement(RouteNames.auth);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 28.w),
            decoration: BoxDecoration(
              color: AppColors.black5,
              borderRadius: BorderRadius.circular(100.r)
            ),
            child: Text(
              "DELETE_ACCOUNT".tr(context),
              style: AppTextStyles.manropeMedium(fontSize: 13.sp),
            ),
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const _ChangePasswordDialog(),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 21.w),
            decoration: BoxDecoration(
                color: AppColors.black5,
                borderRadius: BorderRadius.circular(100.r)
            ),
            child: Text(
              "CHANGE_PASSWORD".tr(context),
              style: AppTextStyles.manropeMedium(fontSize: 13.sp),
            ),
          ),
        )
      ],
    );
  }
}

class _CustomFields extends ConsumerStatefulWidget {
  const _CustomFields({required this.user});

  final User user;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __CustomFieldsState();
}

class __CustomFieldsState extends ConsumerState<_CustomFields> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(fetchAllCustomFieldsProvider);
    final userCustomFields = widget.user.customFields.map((key, value) {
      return MapEntry(key, value);
    });
    if (widget.user.customFields.isEmpty) {
      return Container();
    }

    return data.when(
      data: (data) {
        final allCustomFields = data;
        allCustomFields.removeWhere((element) =>
            element.visibleForUsers == false ||
            element.visibleForUsers == null);
        for (int i = 0; i < allCustomFields.length; i++) {
          final customField = allCustomFields[i];
          if (userCustomFields.containsKey(customField.columnName)) {
            userCustomFields[customField.sId!] =
                userCustomFields.remove(customField.columnName);
          }
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: allCustomFields.map((customField) {
            String value = "";
            if (userCustomFields.containsKey(customField.sId)) {
              value = userCustomFields[customField.sId].toString();
            }
            if (customField.columnType == ColumnType.date) {
              final date = DateTime.tryParse(value);
              value = date == null ? "" : date.format("MMMM yyyy");
            }
            if ((customField.columnName ?? "").toLowerCase() == "level") {
              return SizedBox();
            }
            return Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: _buildInfoField(
                (customField.columnName ?? "").capitalizeFirst,
                value,
              ),
            );
          }).toList(),
        );
      },
      loading: () => Container(),
      error: (error, _) => Text(error.toString()),
    );
  }
}

Row _buildInfoField(String heading, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        heading,
        style: AppTextStyles.manropeSemiBold(
          fontSize: 16.sp,
        ),
      ),
      Text(
        value,
        style: AppTextStyles.manropeMedium(
          fontSize: 15.sp,
        ),
      ),
    ],
  );
}

class _ChangePasswordDialog extends ConsumerStatefulWidget {
  const _ChangePasswordDialog();

  @override
  ConsumerState<_ChangePasswordDialog> createState() =>
      __ChangePasswordDialogState();
}

class __ChangePasswordDialogState extends ConsumerState<_ChangePasswordDialog> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final currentPassNode = FocusNode();
  final newCurrentPassNode = FocusNode();

  bool get enabled =>
      _oldPasswordController.text.isNotEmpty &&
      _newPasswordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // MultiStyleTextFirstLight(
              //   text: "CHANGE_PASSWORD".trU(context),
              //   fontSize: 19.sp,
              //   color: AppColors.white,
              //   letterSpacing: 1,
              // ),
              Text(
                "CHANGE_PASSWORD".trU(context),
                style: AppTextStyles.popupHeaderTextStyle,
              ),
              SizedBox(height: 25.h),
              Row(
                children: [
                  Text(
                    "CURRENT_PASSWORD".tr(context),
                    style: AppTextStyles.manropeMedium(
                        fontSize: 16.sp, color: AppColors.white,),
                  ),
                  const Spacer(),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return RecoverPassword1();
                          },
                        );
                      },
                      child: Text(
                        "RECOVER".tr(context),
                        style: AppTextStyles.manropeMedium(
                            fontSize: 15.sp, color: AppColors.white),
                      ))
                ],
              ),
              SizedBox(height: 5.h),
              CustomTextField(
                controller: _oldPasswordController,
                hintText: "TYPE_HERE".tr(context),
                obscureText: true,
                // hintTextStyle: AppTextStyles.qanelasLight(
                //     fontSize: 13.sp, color: AppColors.white55),
                // style: AppTextStyles.qanelasSemiBold(
                //     fontSize: 17.sp, color: AppColors.white),
                onChanged: (p0) {
                  setState(() {});
                },
                // contentPadding:
                //     EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                borderColor: Colors.transparent,
                isForPopup: true,
                borderRadius: BorderRadius.circular(100.r),
                node: currentPassNode,
              ),
              SizedBox(height: 15.h),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "NEW_PASSWORD".tr(context),
                  style: AppTextStyles.manropeMedium(
                      fontSize: 16.sp, color: AppColors.white,),
                ),
              ),
              SizedBox(height: 5.h),
              CustomTextField(
                controller: _newPasswordController,
                hintText: "TYPE_HERE".tr(context),
                obscureText: true,
                borderColor: Colors.transparent,
                isForPopup: true,
                node: newCurrentPassNode,
                // hintTextStyle: AppTextStyles.qanelasLight(
                //     fontSize: 13.sp, color: AppColors.white55),
                // style: AppTextStyles.qanelasSemiBold(
                //     fontSize: 17.sp, color: AppColors.white),
                borderRadius: BorderRadius.circular(100.r),
                // contentPadding:
                //     EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                onChanged: (p0) {
                  setState(() {});
                },
              ),
              SizedBox(height: 25.h),
              MainButton(
                isForPopup: true,
                label: "SAVE".trU(context),
                // labelColor: enabled ? AppColors.white : AppColors.baseGreen,
                // labelStyle: enabled
                //     ? AppTextStyles.qanelasRegular(
                //         fontSize: 18.sp,
                //         color: AppColors.white,
                //         letterSpacing: 18.sp * 0.12)
                //     : AppTextStyles.qanelasLight(
                //         fontSize: 18.sp,
                //         color: AppColors.darkYellow50,
                //       ),
                enabled: enabled,
                onTap: () async {
                  final provider = updatePasswordProvider(
                    oldPassword: _oldPasswordController.text,
                    newPassword: _newPasswordController.text,
                  );
                  final done =
                      await Utils.showLoadingDialog(context, provider, ref);
                  if (done == true && context.mounted) {
                    Navigator.pop(context);
                    Utils.showMessageDialog2(
                      context,
                      "PASSWORD_SUCCESSFULLY_CHANGED".trU(context),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteAccountConfirmation extends ConsumerStatefulWidget {
  const _DeleteAccountConfirmation();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __DeleteAccountConfirmationState();
}

class __DeleteAccountConfirmationState
    extends ConsumerState<_DeleteAccountConfirmation> {
  final TextEditingController _passwordController = TextEditingController();

  bool get enabled => _passwordController.text.isNotEmpty;
  final currentPassNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomDialog(
        // contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // MultiStyleTextPositionLight(
            //   text: "DELETE_CONFIRMATION".trU(context),
            //   fontSize: 19.sp,
            //   color: AppColors.white,
            //   textBoldPosition: 6,
            // ),
            Text(
              "DELETE_CONFIRMATION".trU(context),
              style: AppTextStyles.popupHeaderTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.h),
            Text(
              "DELETE_CONFIRMATION_DESC".tr(context),
              style: AppTextStyles.popupBodyTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "PASSWORD".tr(context),
                style: AppTextStyles.manropeMedium(
                    fontSize: 16.sp, color: AppColors.white,),
              ),
            ),
            SizedBox(height: 5.h),
            CustomTextField(
              // contentPadding:
              //     EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
              // hintTextStyle: AppTextStyles.qanelasLight(
              //     fontSize: 13.sp, color: AppColors.white55),
              // style: AppTextStyles.qanelasSemiBold(
              //     fontSize: 17.sp, color: AppColors.white),
              borderRadius: BorderRadius.circular(100.r),
              controller: _passwordController,
              hintText: "TYPE_HERE".tr(context),
              obscureText: true,
              borderColor: Colors.transparent,
              isForPopup: true,
              node: currentPassNode,
              onChanged: (p0) {
                setState(() {});
              },
            ),
            SizedBox(height: 20.h),
            MainButton(
              label: "DELETE_ACCOUNT".trU(context),
              enabled: enabled,
              isForPopup: true,
              onTap: () async {
                final provider = deleteAccountProvider(
                  password: _passwordController.text,
                );
                final done =
                    await Utils.showLoadingDialog(context, provider, ref);
                if (done == true && context.mounted) {
                  Navigator.pop(context, true);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class TransactionList extends ConsumerWidget {
  final bool isForPopUp;

  const TransactionList({super.key, this.isForPopUp = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    final showShareButton = ref.watch(_showShareButton);
    return Column(
      children: [
        if (!isForPopUp)
          Row(
            children: [
              Text(
                "TRANSACTION_HISTORY".trU(context),
                style: AppTextStyles.popupHeaderTextStyle.copyWith(color: AppColors.black),
              ),
              SizedBox(width: 5.w),
              if (showShareButton)
                InkWell(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: CustomDialog(
                              closeIconColor: AppColors.blue,
                              color: AppColors.white,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10.h),
                                    child: Text(
                                      "TRANSACTION_HISTORY".trU(context),
                                      style: AppTextStyles.popupHeaderTextStyle
                                          .copyWith(color: AppColors.blue),
                                    ),
                                  ),
                                  const TransactionList(isForPopUp: true)
                                ],
                              )),
                        );
                      },
                    );
                  },
                  child: Image.asset(AppImages.shareIcon.path,
                      width: 17.w, height: 17.w),
                ),
              5.horizontalSpace,
              Text(
                "(${"LATEST".tr(context)})",
                style: AppTextStyles.manropeMedium(
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        if (!isForPopUp) SizedBox(height: 10.h),
        transactions.when(
          data: (data) {
            List<TransactionModel> list = [...data];
            if (!showShareButton) {
              Future(() {
                ref.read(_showShareButton.notifier).state = data.length > 3;
              });
            }
            if (list.length > 3 && !isForPopUp) {
              list = list.sublist(0, 3);
            }
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: list.map((e) {
                  String showDate = e.date ?? "-";
                  final date = DateTime.tryParse(showDate);
                  if (date != null) {
                    showDate = date.format("dd/MM/yyyy");
                  } else {
                    showDate = "-";
                  }

                  final status = e.status ?? "-";
                  final paymentMethod = e.paymentMethod ?? "-";
                  final amount = Utils.formatPriceProfile(e.amount);

                  return Padding(
                      padding: EdgeInsets.only(bottom: 3.h),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            showDate,
                            style: AppTextStyles.manropeMedium(
                              fontSize: 13.sp,
                              color: isForPopUp ? AppColors.blue : AppColors.black,
                            ),
                          )),
                          Expanded(
                              child: Text(
                            status,
                            style: AppTextStyles.manropeMedium(
                              fontSize: 13.sp,
                              color: isForPopUp ? AppColors.blue : AppColors.black,
                            ),
                            textAlign: TextAlign.center,
                          )),
                          Expanded(
                              child: Text(
                            paymentMethod.capitalizeFirst,
                            style:
                                AppTextStyles.manropeSemiBold(fontSize: 13.sp,
                                  color: isForPopUp ? AppColors.blue : AppColors.black,
                                ),
                            textAlign: TextAlign.center,
                          )),
                          Expanded(
                              child: Text(
                            amount,
                            style: AppTextStyles.manropeMedium(
                              color: isForPopUp ? AppColors.blue : AppColors.black,
                              fontSize: 13.sp,
                            ),
                            textAlign: TextAlign.start,
                          )),
                        ],
                      ));
                }).toList());
          },
          error: (err, __) => SecondaryText(text: err.toString()),
          loading: () => const Center(
            child: CupertinoActivityIndicator(),
          ),
        )
      ],
    );
  }
}
