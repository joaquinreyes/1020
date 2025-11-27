part of 'signup_screen.dart';

class _GamePreferenceTab extends StatefulWidget {
  const _GamePreferenceTab({
    required this.registerModel,
    required this.onProceed,
    required this.isPage,
  });

  final RegisterModel registerModel;
  final Function() onProceed;
  final bool isPage;

  @override
  State<_GamePreferenceTab> createState() => _GamePreferenceTabState();
}

class _GamePreferenceTabState extends State<_GamePreferenceTab> {
  String? selectedGameType;

  List<String> get gameTypeOptions => [
        'FRIENDLY_MATCH',
        'RANKED_MATCH',
        'AMERICANA',
        'TOURNAMENT',
      ];

  bool get canProceed => selectedGameType != null;

  @override
  void initState() {
    selectedGameType = widget.registerModel.gamePreference;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.w),
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
            Align(
              alignment: Alignment.center,
              child: Text(
                'WHICH_TYPE_OF_GAME_DO_YOU_PREFER'.trU(context),
                style: AppTextStyles.sofiaSansMedium(
                  fontSize: 26.sp,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'THIS_WILL_GIVE_OTHERS_AN_IDEA_ABOUT_YOUR_SKILLS'.tr(context),
                style: AppTextStyles.manropeMedium(
                  fontSize: 16.sp,
                ),
              ),
            ),
            32.verticalSpace,
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 15.h,
                childAspectRatio: 1.5,
              ),
              itemCount: gameTypeOptions.length,
              itemBuilder: (context, index) {
                final option = gameTypeOptions[index];
                final isSelected = selectedGameType == option;
                return _gameTypeTile(option, isSelected,widget.isPage);
              },
            ),
            SizedBox(height: 80.h),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 154.50.w,
                child: MainButton(
                  enabled: canProceed,
                  showArrow: true,
                  label: 'NEXT',
                  onTap: () {
                    if (canProceed) {
                      widget.registerModel.gamePreference = selectedGameType;
                      widget.onProceed();
                    }
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

  Widget _gameTypeTile(String gameType, bool isSelected, bool isPage) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedGameType = gameType;
        });
      },
      child: Container(
        width: 311.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 0.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brick : AppColors.black5,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            SelectedTag(isSelected: isSelected),
            SizedBox(width: 20.w),
            Expanded(
              child: Text(
                gameType.tr(context),
                maxLines: 5,
                style: isSelected
                    ? AppTextStyles.manropeSemiBold(fontSize: 16.sp,color: AppColors.white,)
                    : AppTextStyles.manropeMedium(fontSize: 16.sp,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
