part of 'signup_screen.dart';

class _ProfilePictureTab extends StatefulWidget {
  const _ProfilePictureTab({
    required this.registerModel,
    required this.onProceed,
  });

  final RegisterModel registerModel;
  final Function() onProceed;

  @override
  State<_ProfilePictureTab> createState() => _ProfilePictureTabState();
}

class _ProfilePictureTabState extends State<_ProfilePictureTab> {
  String? selectedImagePath;

  @override
  void initState() {
    selectedImagePath = widget.registerModel.profileImagePath;
    super.initState();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          selectedImagePath = image.path;
          widget.registerModel.profileImagePath = image.path;
        });
      }
    } catch (e) {
      myPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 39.w),
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
            Text(
              'ADD_YOUR_PROFILE_PICTURE'.trU(context),
              style: AppTextStyles.sofiaSansMedium(
                fontSize: 26.sp,
              ),
            ),
            8.verticalSpace,
            Text(
              'SO_EVERYONE_KNOWS_WHO_TO_CHEER_FOR'.tr(context),
              style: AppTextStyles.manropeMedium(
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 32.h),
            InkWell(
              onTap: () => _showImageSourceOptions(),
              child: Container(
                width: 150.w,
                height: 150.w,
                decoration: BoxDecoration(
                  // color: selectedImagePath == null
                  //     ? AppColors.green5.withOpacity(0.8)
                  //     : AppColors.charcoalBlack05,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: selectedImagePath == null
                    ? Stack(
                        children: [
                          Image.asset(
                            AppImages.registerImage.path,
                            width: 150.w,
                            height: 150.w,
                          ),
                          Positioned(
                            bottom: 11.h,
                            right: 11.w,
                            child: Icon(
                              Icons.camera_alt,
                              size: 20.h,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Stack(
                          children: [
                            Image.file(
                              File(selectedImagePath!),
                              width: 150.w,
                              height: 150.w,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 11.h,
                              right: 11.w,
                              child: Icon(
                                Icons.camera_alt,
                                size: 20.h,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            SizedBox(height: 30.h),
            _optionTile(
              icon: Icons.camera_alt,
              label: 'CAMERA'.tr(context),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            SizedBox(height: 10.h),
            _optionTile(
              icon: Icons.photo_library,
              label: 'GALLERY'.tr(context),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            SizedBox(height: 60.h),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 154.50.w,
                child: MainButton(
                  enabled: true,
                  showArrow: true,
                  label: 'NEXT'.trU(context),
                  onTap: () {
                    widget.onProceed();
                  },
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _optionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.black5,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.manropeMedium(
                  fontSize: 16.sp,
                ),
              ),
            ),
            Image.asset(
              AppImages.rightArrow.path,
              height: 18.h,
              width: 18.h,
              color: AppColors.black70,
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          color: AppColors.backgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColors.blue,
                  ),
                ),
              ),
              5.verticalSpace,
              Text(
                'CHOOSE_IMAGE_SOURCE'.trU(context),
                style: AppTextStyles.popupHeaderTextStyle.copyWith(color: AppColors.blue),
              ),
              SizedBox(height: 20.h),
              MainButton(
                label: 'CAMERA'.tr(context),
                enabled: true,
                showArrow: true,
                labelStyle: AppTextStyles.manropeSemiBold(
                  fontSize: 17.sp,
                  color: AppColors.white,
                ),
                color: AppColors.blue,
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              SizedBox(height: 17.h),
              MainButton(
                label: 'GALLERY'.tr(context),
                enabled: true,
                showArrow: true,
                labelStyle: AppTextStyles.manropeSemiBold(
                  fontSize: 17.sp,
                  color: AppColors.white,
                ),
                color: AppColors.blue,
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              // ListTile(
              //   // leading: Icon(Icons.camera_alt, color: AppColors.black2),
              //   title: Text(
              //     'CAMERA'.tr(context),
              //     style: AppTextStyles.grotesqueMedium20.copyWith(
              //         height: 1
              //     ),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //     _pickImage(ImageSource.camera);
              //   },
              // ),
              // ListTile(
              //   // leading: Icon(Icons.photo_library, color: AppColors.black2),
              //   title: Text(
              //     'GALLERY'.tr(context),
              //     style: AppTextStyles.grotesqueMedium20.copyWith(
              //         height: 1
              //     ),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //     _pickImage(ImageSource.gallery);
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }
}
