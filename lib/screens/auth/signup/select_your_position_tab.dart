part of 'signup_screen.dart';

class _SelectYourPosition extends StatefulWidget {
  const _SelectYourPosition(
      {super.key, required this.registerModel, required this.onProceed});
  final RegisterModel registerModel;
  final Function() onProceed;
  @override
  State<_SelectYourPosition> createState() => _SelectYourPositionState();
}

class _SelectYourPositionState extends State<_SelectYourPosition> {
  bool get canProceed => playingSide != null;
  PlayingSide? playingSide;
  @override
  void initState() {
    final playingSide = widget.registerModel.playingSide;
    if (playingSide != null) {
      this.playingSide = PlayingSide.fromString(playingSide);
    }
    // playingSide = PlayingSide.fromString(");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'REGISTER'.trU(context),
              style: AppTextStyles.sofiaSansMedium(
                color: AppColors.black,
                fontSize: 40.sp,
              ),
            ),
            33.verticalSpace,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'WHATS_YOUR_PREFERRED_POSITION'.tr(context),
                style: AppTextStyles.sofiaSansMedium(
                  fontSize: 26.sp,
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'THIS_WILL_GIVE_OTHERS_AN_IDEA_ABOUT_YOUR_SKILLS'.tr(context),
                style: AppTextStyles.manropeMedium(fontSize: 16.sp),
              ),
            ),
            SizedBox(height: 32.h),
            Column(
              children: [
                // Top Row with Left & Right options
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _imageOptionTile(
                        side: PlayingSide.left,
                        label: "Left Side",
                        imagePath: AppImages.leftSide.path, // replace with your image path
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: _imageOptionTile(
                        side: PlayingSide.right,
                        label: "Right Side",
                        imagePath: AppImages.rightSide.path,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                // Full-width Both Sides option
                _optionTile(PlayingSide.both, "BOTH_SIDES_EXPLANATION".tr(context)),
              ],
            ),
            SizedBox(height: 37.h),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 154.50.w,
                child: MainButton(
                  enabled: canProceed,
                  showArrow: true,
                  label: 'NEXT'.trU(context),
                  onTap: () async {
                    if (canProceed) {
                      widget.registerModel.playingSide =
                          playingSide?.getApiString;
                      widget.onProceed();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionTile(PlayingSide side, String explanation) {
    final selected = playingSide == side;
    return InkWell(
      onTap: () {
        playingSide = side;
        widget.registerModel.playingSide = side.getApiString;
        setState(() {});
      },
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        width: 330.w,
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.brick : AppColors.black5,
          borderRadius: BorderRadius.all(Radius.circular(100.r),),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SelectedTag(isSelected: selected),
            SizedBox(width: 20.w),
            Expanded(
              child: Text(
                textAlign: TextAlign.center,
                side.userFacingString,
                style: selected ? AppTextStyles.manropeSemiBold(fontSize: 16.sp,color: AppColors.white,) : AppTextStyles.manropeMedium(fontSize: 16.sp,),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _imageOptionTile({
    required PlayingSide side,
    required String label,
    String? imagePath,
    bool isFullWidth = false,
  }) {
    final selected = playingSide == side;

    return GestureDetector(
      onTap: () {
        playingSide = side;
        widget.registerModel.playingSide = side.getApiString;
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColors.brick : AppColors.black5,
          borderRadius: BorderRadius.all(Radius.circular(isFullWidth ? 100.r : 20.r),),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r),topRight: Radius.circular(20.r)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 201.h,
                ),
              ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SelectedTag(isSelected: selected),
                  15.horizontalSpace,
                  Text(
                    label,
                    style: selected ? AppTextStyles.manropeSemiBold(fontSize: 16.sp,color: AppColors.white,) : AppTextStyles.manropeMedium(fontSize: 16.sp,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
