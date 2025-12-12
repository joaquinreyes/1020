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
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "EDIT_YOUR_INFORMATION".trU(context),
                style: AppTextStyles.popupHeaderTextStyle,
              ),
              SizedBox(height: 20.h),

              _buildTextField(
                "FIRST_NAME".tr(context),
                _firstNameController,
              ),
              SizedBox(height: 5.h),

              _buildTextField(
                "SURNAME".tr(context),
                _lastNameController,
              ),
              SizedBox(height: 5.h),

              _buildTextField(
                "EMAIL".tr(context),
                _emailController,
                isEnabled: false,
              ),
              SizedBox(height: 5.h),

              _buildTextField(
                "PHONE_NUMBER".tr(context),
                _phoneController,
                isNumber: true,
              ),
              SizedBox(height: 5.h),

              // _buildTextField(
              //   "LEVEL".tr(context),
              //   _levelController,
              //   isEnabled: false,
              //   isNumber: true,
              // ),
              _editCustomFields(),
              SizedBox(height: 15.h),
              _buildField(
                "LANGUAGE".tr(context),
                const LanguageSelectorAuth(),
              ),
              SizedBox(height: 20.h),
              MainButton(
                label: "SAVE".trU(context),
                enabled: true,
                isForPopup: true,
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
              color: AppColors.white25,
              borderRadius: BorderRadius.circular(100.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? selectedDate.format("MMMM yyyy")
                        : "mm/yyyy",
                    style: AppTextStyles.manropeMedium(
                      fontSize: 13.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
                Image.asset(
                  AppImages.dropdownIcon.path,
                  width: 16.w,
                  color: AppColors.white,
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
                            vertical: 6.h, horizontal: 12.w),
                        margin: EdgeInsets.symmetric(vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: !isSelected
                              ? AppColors.black25
                              : AppColors.yellow50,
                          borderRadius: BorderRadius.circular(8.r),
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
            borderRadius: BorderRadius.circular(100.r),
            key: customFieldDropDownsKeys[id],
            label: userCustomFields[id] ?? "Select $label",
            items: options,
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
                      vertical: 6.h,
                      horizontal: 12.w,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color:
                          !isSelected ? AppColors.white25 : AppColors.white,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      str,
                      style: isSelected
                          ? AppTextStyles.manropeSemiBold(
                              color: AppColors.brick,
                              fontSize: 13.sp,
                            )
                          : AppTextStyles.manropeMedium(
                              color: AppColors.white,
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

    return _buildField(
      label,
      CustomTextField(
        controller: controller,
        // isEnabled: isEnabled,
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
        borderRadius: BorderRadius.circular(100.r),
        node: currentPassNode,
        fillColor: AppColors.white25,
        borderColor: Colors.transparent,
        isForPopup: true
      ),
    );
  }

  Widget _buildField(String header, Widget widget) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            header.tr(context),
            style: AppTextStyles.manropeMedium(fontSize: 16.sp,color: AppColors.white,),
          ),
        ),
        Expanded(
          flex: 3,
          child: widget,
        ),
      ],
    );
  }
}
