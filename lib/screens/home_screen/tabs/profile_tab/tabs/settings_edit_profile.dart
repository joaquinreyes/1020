part of 'settings.dart';

class _EditProfile extends ConsumerStatefulWidget {
  const _EditProfile({required this.user});

  final User user;

  @override
  ConsumerState<_EditProfile> createState() => __EDITProfileState();
}

class __EDITProfileState extends ConsumerState<_EditProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();

  Map<String, dynamic> userCustomFields = {};
  Map<String, dynamic> customFieldTextFields = {};
  Map<String, GlobalKey<CustomDropDownState>> customFieldDropDownsKeys = {};

  @override
  void initState() {
    _firstNameController.text = widget.user.firstName ?? "";
    _lastNameController.text = widget.user.lastName ?? "";
    _emailController.text = widget.user.email ?? "";
    _phoneController.text = widget.user.phoneNumber ?? "";
    _levelController.text = widget.user.level(getSportsName(ref)).toString();
    userCustomFields = widget.user.customFields.map(
      (key, value) => MapEntry(key, value),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomDialog(
        color: AppColors.alysumWhite,
        closeIconColor: AppColors.black,
        borderRadius: BorderRadius.circular(18.r),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "EDIT_YOUR_INFORMATION".trU(context),
                style: AppTextStyles.sofiaSansMedium(
                  fontSize: 22.sp,
                  color: AppColors.black,
                ),
              ),
              6.verticalSpace,
              Container(
                height: 2.h,
                width: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.brick,
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              18.verticalSpace,

              _buildTextField(
                "FIRST_NAME".tr(context),
                _firstNameController,
              ),
              SizedBox(height: 12.h),

              _buildTextField(
                "SURNAME".tr(context),
                _lastNameController,
              ),
              SizedBox(height: 12.h),

              _buildTextField(
                "EMAIL".tr(context),
                _emailController,
                isEnabled: false,
              ),
              SizedBox(height: 12.h),

              _buildTextField(
                "PHONE_NUMBER".tr(context),
                _phoneController,
                isNumber: true,
              ),
              SizedBox(height: 12.h),

              // _buildTextField(
              //   "LEVEL".tr(context),
              //   _levelController,
              //   isEnabled: false,
              //   isNumber: true,
              // ),
              _editCustomFields(),
              SizedBox(height: 12.h),
              _buildField(
                "LANGUAGE".tr(context),
                const LanguageSelectorAuth(),
              ),
              SizedBox(height: 20.h),
              MainButton(
                label: "SAVE".trU(context),
                enabled: true,
                color: AppColors.brick,
                labelStyle: AppTextStyles.sofiaSansMedium(
                  fontSize: 20.sp,
                  color: AppColors.white,
                ),
                applyShadow: true,
                isForPopup: false,
                onTap: () async {
                  final customFields = <String, dynamic>{};
                  for (final key in userCustomFields.keys) {
                    customFields[key] = userCustomFields[key];
                  }
                  User user = widget.user.copyWithForUpdate(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    email: _emailController.text,
                    phoneNumber: _phoneController.text,
                    customFields: customFields,
                  );

                  bool? done = await Utils.showLoadingDialog(
                      context, updateUserProvider(user), ref);
                  if (done == true && context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _editCustomFields() {
    final data = ref.watch(fetchAllCustomFieldsProvider);
    return data.when(
      data: (data) {
        final allCustomFields = data;
        for (int i = 0; i < allCustomFields.length; i++) {
          final customField = allCustomFields[i];
          if (userCustomFields.containsKey(customField.columnName)) {
            userCustomFields[customField.sId!] =
                userCustomFields.remove(customField.columnName);
          }
        }
        return ListView.separated(
          shrinkWrap: true,
          itemCount: allCustomFields.length,
          separatorBuilder: (context, index) {
            final customField = allCustomFields[index];
            if (customField.columnType == null ||
                (customField.columnName?.isEmpty ?? true) ||
                (customField.sId?.isEmpty ?? true)) {
              return Container();
            }
            return SizedBox(height: 5.h);
          },
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final customField = allCustomFields[index];
            switch (customField.columnType) {
              case ColumnType.date:
                return _buildDateField(customField);
              case ColumnType.selectbox:
                return _buildMultiSelectDropDown(
                  customField,
                );
              case ColumnType.radiobutton:
              case ColumnType.dropdown:
                return _buildSingleSelectDropDownField(
                  customField,
                );
              case ColumnType.number:
                if (!customFieldTextFields.containsKey(customField.sId ?? "")) {
                  final controller = TextEditingController();
                  controller.text =
                      (userCustomFields[customField.sId ?? ""] ?? "")
                          .toString();
                  customFieldTextFields[customField.sId ?? ""] = controller;
                }
                return _buildTextField(
                  customField.columnName ?? "",
                  customFieldTextFields[customField.sId ?? ""]!,
                  id: customField.sId,
                  isNumber: true,
                );

              case ColumnType.string:
                if (!customFieldTextFields.containsKey(customField.sId ?? "")) {
                  final controller = TextEditingController();
                  controller.text =
                      (userCustomFields[customField.sId ?? ""] ?? "")
                          .toString();
                  customFieldTextFields[customField.sId ?? ""] = controller;
                }
                return _buildTextField(
                  customField.columnName ?? "",
                  customFieldTextFields[customField.sId ?? ""]!,
                  id: customField.sId,
                  isNumber: false,
                );

              default:
                return Container(
                  height: 10,
                  color: Colors.black,
                  child: Text(customField.columnName ?? ""),
                );
            }
          },
        );
      },
      error: (err, st) => Container(),
      loading: () => Container(),
    );
  }

  Widget _buildDateField(CustomFields customField) {
    String id = customField.sId ?? "";
    String label = customField.columnName ?? "";
    DateTime? selectedDate = userCustomFields[id] != null
        ? DateTime.tryParse(userCustomFields[id])
        : null;
    return _buildField(
      label,
      Opacity(
        opacity: customField.editableForUsers == true ? 1 : 0.7,
        child: InkWell(
          onTap: customField.editableForUsers != true
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  await DatePicker.showPicker(
                    context,
                    onConfirm: (date) {
                      setState(() {
                        userCustomFields[id] = date.toIso8601String();
                      });
                      FocusScope.of(context).unfocus();
                    },
                    pickerModel: CustomMonthPicker(
                      minTime: DubaiDateTime.now()
                          .dateTime
                          .subtract(const Duration(days: 365 * 60)),
                      maxTime: DubaiDateTime.now().dateTime,
                      currentTime: selectedDate ?? DubaiDateTime.now().dateTime,
                    ),
                  );
                },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.black5,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.black10),
            ),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? selectedDate.format("MMMM yyyy")
                        : "mm/yyyy",
                    style: AppTextStyles.manropeMedium(
                      fontSize: 13.sp,
                      color: AppColors.black,
                    ),
                  ),
                ),
                Image.asset(
                  AppImages.dropdownIcon.path,
                  width: 16.w,
                  color: AppColors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectDropDown(
    CustomFields customField,
  ) {
    String id = customField.sId ?? "";
    String label = customField.columnName ?? "";
    List<String> options = customField.options ?? [];
    if (!customFieldDropDownsKeys.containsKey(id)) {
      customFieldDropDownsKeys[id] = GlobalKey<CustomDropDownState>();
    }
    String labelToShow = "Select $label";
    if (userCustomFields.containsKey(id)) {
      labelToShow = userCustomFields[id].join(", ");
    }
    return AbsorbPointer(
      absorbing: customField.editableForUsers == false ||
          customField.editableForUsers == null,
      child: _buildField(
        label,
        Opacity(
          opacity: customField.editableForUsers != true ? 0.7 : 1,
          child: Column(
            children: [
              CustomDropDown(
                key: customFieldDropDownsKeys[id],
                label: labelToShow,
                items: options,
                backgroundColor: AppColors.black5,
                textColor: AppColors.black,
                iconColor: AppColors.black,
                borderRadius: BorderRadius.circular(14.r),
                height: 40.h,
                onExpansionChanged: (isExpanded) {
                  for (final key in customFieldDropDownsKeys.keys) {
                    if (key != id) {
                      customFieldDropDownsKeys[key]?.currentState?.close();
                    }
                  }
                },
                childrenBuilder: (str, index) {
                  bool isSelected = false;
                  if (userCustomFields.containsKey(id)) {
                    isSelected = userCustomFields[id].contains(str);
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.5.h),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (userCustomFields[id] == null) {
                            userCustomFields[id] = [str];
                          } else {
                            if (isSelected) {
                              userCustomFields[id].remove(str);
                            } else {
                              userCustomFields[id].add(str);
                            }
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 12.w),
                        margin: EdgeInsets.symmetric(vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: !isSelected
                              ? AppColors.black5
                              : AppColors.yellow30,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          str,
                          style: isSelected
                              ? AppTextStyles.manropeMedium().copyWith(
                                  color: AppColors.black,
                                  fontSize: 15.sp,
                                )
                              : AppTextStyles.manropeMedium().copyWith(
                                  color: AppColors.black,
                                  fontSize: 15.sp,
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleSelectDropDownField(
    CustomFields customField,
  ) {
    String id = customField.sId ?? "";
    String label = customField.columnName ?? "";
    List<String> options = customField.options ?? [];
    if (!customFieldDropDownsKeys.containsKey(id)) {
      customFieldDropDownsKeys[id] = GlobalKey<CustomDropDownState>();
    }
    return AbsorbPointer(
      absorbing: customField.editableForUsers == false ||
          customField.editableForUsers == null,
      child: _buildField(
        label,
        Opacity(
          opacity: customField.editableForUsers == true ? 1 : 0.7,
          child: CustomDropDown(
            key: customFieldDropDownsKeys[id],
            label: userCustomFields[id] ?? "Select $label",
            items: options,
            backgroundColor: AppColors.black5,
            textColor: AppColors.black,
            iconColor: AppColors.black,
            borderRadius: BorderRadius.circular(14.r),
            height: 40.h,
            onExpansionChanged: (isExpanded) {
              for (final key in customFieldDropDownsKeys.keys) {
                if (key != id) {
                  customFieldDropDownsKeys[key]?.currentState?.close();
                }
              }
            },
            childrenBuilder: (str, index) {
              bool isSelected = userCustomFields[id] == str;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                child: InkWell(
                  onTap: () {
                    customFieldDropDownsKeys[id]
                        ?.currentState
                        ?.toggleExpansion();
                    setState(() {
                      userCustomFields[id] = str;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 12.w,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color:
                          !isSelected ? AppColors.black5 : AppColors.yellow30,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      str,
                      style: isSelected
                          ? AppTextStyles.manropeSemiBold(
                              color: AppColors.brick,
                              fontSize: 13.sp,
                            )
                          : AppTextStyles.manropeMedium(
                              color: AppColors.black,
                              fontSize: 13.sp,
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {String? id, bool isNumber = false, bool isEnabled = true}) {
    final currentPassNode = FocusNode();
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: BorderSide(color: AppColors.black10),
    );
    final enabled = isEnabled;

    return _buildField(
      label,
      CustomTextField(
        controller: controller,
        readOnly: !enabled,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        onChanged: (_) {
          if (id != null) {
            if (isNumber) {
              int? val = int.tryParse(controller.text);
              userCustomFields[id] = val;
              controller.text = val != null ? val.toString() : "";
            } else {
              userCustomFields[id] = controller.text;
            }
          }
          setState(() {});
        },
        borderRadius: BorderRadius.circular(14.r),
        border: border,
        fillColor: enabled ? AppColors.white : AppColors.black5,
        node: currentPassNode,
        style: AppTextStyles.manropeMedium(
          fontSize: 14.sp,
          color: enabled ? AppColors.black : AppColors.black50,
        ),
        hintTextStyle: AppTextStyles.manropeMedium(
          fontSize: 13.sp,
          color: AppColors.black50,
        ),
        isForPopup: false,
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      ),
    );
  }

  Widget _buildField(String header, Widget widget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header.tr(context),
          style: AppTextStyles.manropeSemiBold(
            fontSize: 13.sp,
            color: AppColors.black70,
            letterSpacing: 0.3,
          ),
        ),
        6.verticalSpace,
        widget,
      ],
    );
  }
}
