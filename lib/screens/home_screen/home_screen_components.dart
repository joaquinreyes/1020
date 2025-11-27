part of 'home_screen.dart';

class _AddProfilePicture extends ConsumerStatefulWidget {
  const _AddProfilePicture(
      {required this.selectImage, required this.selectDate});

  final bool selectImage;
  final bool selectDate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __AddProfilePictureState();
}

class __AddProfilePictureState extends ConsumerState<_AddProfilePicture> {
  DateTime? selectedDate;
  File? _img;

  bool get canProceed {
    if (widget.selectDate && selectedDate != null) {
      return true;
    }
    if (!widget.selectDate && widget.selectImage && _img != null) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userManagerProvider).user?.user;
      if ((user?.customFields.containsKey(kStartedPlayingCustomID) ?? false)) {
        final date = user?.customFields[kStartedPlayingCustomID];
        if (date != null) {
          setState(() {
            selectedDate = DateTime.tryParse(date);
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.selectImage) ...[
            Text(
              "ADD_A_PROFILE_PICTURE".trU(context),
              style: AppTextStyles.popupHeaderTextStyle,
            ),
            SizedBox(height: 20.h),
            Text(
              "ADD_A_PROFILE_PICTURE_EXPLANATION".tr(context),
              style: AppTextStyles.popupBodyTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            InkWell(
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
                    setState(() {
                      _img = File(pickedFile.path);
                    });
                  }
                }
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _image(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15.w, bottom: 5.h),
                    child: Image.asset(
                      AppImages.iconCamera.path,
                      color: AppColors.black2,
                      width: 13.w,
                      height: 13.w,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 25.h),
          ],
          if (widget.selectDate) ...[
            Text(
              "WHEN_DID_YOU_START_PLAYING".tr(context),
              style: AppTextStyles.manropeBold(
                color: AppColors.black2,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 5.h),
            Text(
              "WHEN_DID_YOU_START_PLAYING_EXPLANATION".tr(context),
              style: AppTextStyles.manropeMedium(
                color: AppColors.black70,
                fontSize: 15.sp,
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 5.h),
            InkWell(
              onTap: () async {
                await DatePicker.showPicker(
                  context,
                  onConfirm: (date) {
                    selectedDate = date;
                  },
                  pickerModel: CustomMonthPicker(
                    minTime: DubaiDateTime.now()
                        .dateTime
                        .subtract(const Duration(days: 365 * 60)),
                    maxTime: DubaiDateTime.now().dateTime,
                    currentTime: selectedDate,
                  ),
                );

                setState(() {});
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.black25,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? "mm/yyyy"
                                : selectedDate!.format("MMMM/yyyy"),
                            style: AppTextStyles.manropeMedium(
                              color: AppColors.black2,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 17.h,
                          color: AppColors.black2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25.h),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: MainButton(
              enabled: canProceed,
              label: "SAVE".tr(context).capitalWord(context, canProceed),
              isForPopup: true,
              onTap: () async {
                final user = ref.read(userManagerProvider).user?.user;

                final updatedUser = user?.copyWithForUpdate(customFields: {
                  kStartedPlayingCustomID: selectedDate?.toIso8601String(),
                });
                final done = await Utils.showLoadingDialog(context,
                    updatePictureAndUserProvider(_img, updatedUser), ref);
                if (done.$2 == true && context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _image() {
    if (_img != null) {
      return Container(
        width: 90.h,
        height: 90.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          image: DecorationImage(
            image: PlatformC().isCurrentOSMobile
                ? FileImage(_img!)
                : NetworkImage(_img!.path),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return NetworkCircleImage(
      path: ref.read(userManagerProvider).user?.user?.profileUrl,
      width: 90.w,
      height: 90.w,
      logoColor: AppColors.black2,
      bgColor: AppColors.white,
      borderRadius: BorderRadius.circular(12.r),
    );
  }
}

class CustomMonthPicker extends DatePickerModel {
  CustomMonthPicker(
      {DateTime? currentTime,
      DateTime? minTime,
      DateTime? maxTime,
      LocaleType? locale})
      : super(
            locale: locale,
            minTime: minTime,
            maxTime: maxTime,
            currentTime: currentTime);

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}
