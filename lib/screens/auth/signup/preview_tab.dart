part of 'signup_screen.dart';

class _PreviewTab extends StatefulWidget {
  const _PreviewTab({
    required this.registerModel,
    required this.onProceed,
  });

  final RegisterModel registerModel;
  final Function() onProceed;

  @override
  State<_PreviewTab> createState() => _PreviewTabState();
}

class _PreviewTabState extends State<_PreviewTab> {
  @override
  Widget build(BuildContext context) {
    final fullName =
        '${widget.registerModel.firstName ?? ''} ${widget.registerModel.lastName ?? ''}'
            .trim()
            .toUpperCase();

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 39.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'ALL_DONE'.trU(context),
              style: AppTextStyles.sofiaSansMedium(
                fontSize: 40.sp,
              ),
            ),
            33.verticalSpace,
            Text(
              'HERES_YOUR_PLAYER'.trU(context),
              style: AppTextStyles.sofiaSansMedium(
                fontSize: 26.sp,
              ),
            ),
            25.verticalSpace,
            InkWell(
              onTap: () => _showImageSourceOptions(context),
              child: Container(
                width: 150.h,
                height: 150.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: widget.registerModel.profileImagePath == null
                    ? Stack(
                        children: [
                          Image.asset(
                            AppImages.registerImage.path,
                            width: 150.w,
                            height: 150.w,
                          ),
                          Positioned(
                            bottom: 13.h,
                            right: 13.w,
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
                              File(widget.registerModel.profileImagePath!),
                              width: 150.w,
                              height: 150.w,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 13.h,
                              right: 13.w,
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
            Text(
              fullName,
              style: AppTextStyles.sofiaSansMedium(
                fontSize: 30.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            _infoRow(
                'EXPERIENCE'.tr(context),
                widget.registerModel.level != null
                    ? (widget.registerModel.level ?? 0).toString()
                    : '-'),
            8.verticalSpace,
            _infoRow('POSITION'.tr(context),
                _formatPosition(widget.registerModel.playingSide)),
            8.verticalSpace,
            _infoRow(
                'PREFERRED_GAME'.tr(context),
                widget.registerModel.gamePreference != null
                    ? widget.registerModel.gamePreference!.tr(context)
                    : '-'),
            100.verticalSpace,
            Align(
              alignment: Alignment.centerRight,
              child: MainButton(
                enabled: true,
                width: 154.50.w,
                showArrow: true,
                label: 'NEXT'.trU(context),
                onTap: () {
                  widget.onProceed();
                },
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
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
          widget.registerModel.profileImagePath = image.path;
        });
      }
    } catch (e) {
      myPrint('Error picking image: $e');
    }
  }

  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
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

  String _formatPosition(String? position) {
    if (position == null) return '-';
    try {
      final side = PlayingSide.fromString(position);
      return side.userFacingString;
    } catch (e) {
      return position;
    }
  }
}
