part of 'signup_screen.dart';

class LevelAssessmentTab extends ConsumerStatefulWidget {
  const LevelAssessmentTab(
      {super.key,
        required this.index,
        required this.isLastQuestion,
        required this.levelQuesiton,
        required this.registerModel,
        required this.onProceed});
  final int index;
  final bool isLastQuestion;
  final RegisterModel registerModel;
  final Function() onProceed;
  final LevelQuestion levelQuesiton;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LevelAssessmentTab();
}

class _LevelAssessmentTab extends ConsumerState<LevelAssessmentTab> {
  bool get _canProceed =>
      widget.registerModel.levelAnswers[widget.index] != null;
  @override
  void initState() {
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
              alignment: Alignment.centerLeft,
              child: Text(
                "${widget.levelQuesiton.question}".toUpperCase(),
                style: AppTextStyles.sofiaSansMedium(fontSize: 26.sp,),
              ),
            ),
            8.verticalSpace,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'THIS_WILL_GIVE_OTHERS_AN_IDEA_ABOUT_YOUR_SKILLS'.tr(context),
                style: AppTextStyles.manropeMedium(
                  fontSize: 16.sp,
                ),
              ),
            ),
            SizedBox(height: 32.h),
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: 1,
              ),
              itemCount: widget.levelQuesiton.options?.length ?? 0,
              itemBuilder: (context, i) {
                return _optionTile(widget.levelQuesiton.options![i]);
              },
            ),
            SizedBox(height: 37.h),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 154.50.w,
                child: MainButton(
                  enabled: _canProceed,
                  label: widget.isLastQuestion
                      ? "FINISH".trU(context)
                      : 'NEXT'.trU(context),
                  showArrow: true,
                  onTap: () async {
                    if (_canProceed) {
                      widget.onProceed();
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 82.h),
          ],
        ),
      ),
    );
  }

  Widget _optionTile(LevelQuestionOptions option) {
    final selected =
        option.value == widget.registerModel.levelAnswers[widget.index];
    return InkWell(
      onTap: () {
        setState(() {
          widget.registerModel.levelAnswers[widget.index] = option.value;
        });
      },
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w,),
        decoration: BoxDecoration(
          color: selected ? AppColors.brick : AppColors.black5,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            SelectedTag(isSelected: selected),
            SizedBox(width: 15.w),
            Expanded(
              child: Text(
                option.text ?? "",
                softWrap: true,
                style: selected
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

// class LevelAssessmentTab extends ConsumerStatefulWidget {
//   const LevelAssessmentTab(
//       {required this.index,
//       required this.isLastQuestion,
//       required this.levelQuestion,
//       required this.registerModel,
//       this.isPage = true,
//       this.isForPopup = false,
//       required this.onProceed});
//
//   final int index;
//   final bool isLastQuestion;
//   final RegisterModel registerModel;
//   final Function() onProceed;
//   final bool isPage;
//   final bool isForPopup;
//   final LevelQuestion levelQuestion;
//
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => __LevelAssessmentTab();
// }
//
// class __LevelAssessmentTab extends ConsumerState<LevelAssessmentTab> {
//   bool get _canProceed =>
//       widget.registerModel.levelAnswers[widget.index] != null;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final textColor = widget.isPage ? AppColors.black2 : AppColors.black2;
//
//     return SingleChildScrollView(
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: widget.isPage ? 30.w : 0.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 39.h),
//             Padding(
//               padding: EdgeInsets.only(
//                 left: 5.w,
//               ),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'LEVEL_ASSESSMENT'.tr(context),
//                   style: AppTextStyles.sofiaSansMedium(
//                       fontSize: 20.sp, color: textColor),
//                   textAlign: TextAlign.center,
//                 ),
//                 // Text(
//                 //   'LEVEL_ASSESSMENT'.trU(context),
//                 //   textAlign: TextAlign.center,
//                 //   style: AppTextStyles.gothamNarrowBold(fontSize: 20.sp),
//                 // ),
//               ),
//             ),
//             SizedBox(height: 15.h),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "${widget.index + 1}. ${widget.levelQuestion.question}",
//                 style: AppTextStyles.manropeMedium(
//                     fontSize: 16.sp, color: textColor),
//               ),
//             ),
//             SizedBox(height: 20.h),
//             for (var i = 0;
//                 i < (widget.levelQuestion.options?.length ?? 0);
//                 i++) ...[
//               _optionTile(widget.levelQuestion.options![i], widget.isPage),
//             ],
//             widget.isPage
//                 ? SizedBox(height: widget.index == 5 ? 80.h : 119.h)
//                 : SizedBox(
//                     height: 5.h,
//                   ),
//             Align(
//               alignment: Alignment.centerRight,
//               child: SizedBox(
//                 width: 154.50.w,
//                 child: MainButton(
//                   enabled: _canProceed,
//                   isForPopup: widget.isForPopup,
//                   // color:
//                   //     _canProceed ? AppColors.rosewood : AppColors.rosewood25,
//                   // labelStyle: AppTextStyles.qanelasLight(
//                   //     fontSize: 18.sp, color: AppColors.white),
//                   label: widget.isLastQuestion
//                       ? "FINISH".tr(context).capitalWord(context, _canProceed)
//                       : 'NEXT'.capitalWord(context, _canProceed),
//                   showArrow: true,
//                   onTap: () async {
//                     if (_canProceed) {
//                       widget.onProceed();
//                     }
//                   },
//                   padding: EdgeInsets.symmetric(horizontal: 15.w),
//                 ),
//               ),
//             ),
//             SizedBox(height: 82.h),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _optionTile(LevelQuestionOptions option, bool isPage) {
//     final selected =
//         option.value == widget.registerModel.levelAnswers[widget.index];
//     return InkWell(
//       onTap: () {
//         setState(() {
//           widget.registerModel.levelAnswers[widget.index] = option.value;
//         });
//       },
//       child: Container(
//         width: 311.w,
//         padding: EdgeInsets.all(10.h),
//         margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 9.w),
//         decoration: BoxDecoration(
//           color: selected
//               ? (isPage ? AppColors.black2 : AppColors.black2)
//               : (isPage ? AppColors.tileBgColor : AppColors.tileBgColor),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Row(
//           children: [
//             SelectedTag(
//               isSelected: selected,
//               selectedBorderColor: AppColors.white,
//               unSelectedBorderColor:
//                   !widget.isPage ? AppColors.black2 : AppColors.black2,
//               unSelectedColor: AppColors.white,
//               shape: BoxShape.circle,
//             ),
//             SizedBox(width: 20.w),
//             Expanded(
//               child: Text(
//                 option.text ?? "",
//                 style: selected
//                     ? AppTextStyles.manropeBold(
//                         color: AppColors.white,
//                         fontSize: 16.sp,
//                       )
//                     : AppTextStyles.manropeMedium(
//                         fontSize: 16.sp,
//                         color:
//                             !widget.isPage ? AppColors.black2 : AppColors.black2,
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _SelectSports extends ConsumerWidget {
//   final Function onProceed;
//
//   const _SelectSports({required this.onProceed});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final data = ref.watch(clubLocationsProvider);
//     final sports = ref.watch(sportListProvider);
//
//     return SingleChildScrollView(
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 40.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 45.h),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'PICK_YOUR_PREFERRED_SPORT'.tr(context),
//                 style: AppTextStyles.sofiaSansMedium(
//                     fontSize: 20.sp, color: AppColors.black2),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(height: (25).h),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "THIS_CAN_BE_CHANGED_LATER".tr(context),
//                 style: AppTextStyles.manropeMedium(fontSize: 16.sp),
//               ),
//             ),
//             SizedBox(height: 20.h),
//             data.when(
//               data: (data) {
//                 if (data == null) {
//                   return const Center(
//                       child: SecondaryText(text: "Unable to get Locations."));
//                 }
//                 Future(() {
//                   if (ref.read(sportListProvider.notifier).sport.isEmpty) {
//                     ref.read(sportListProvider.notifier).sport = [
//                       ...Utils.fetchSportsList(data)
//                     ];
//                   }
//                 });
//
//                 final showSports = sports
//                     .where(
//                         (e) => (e.sportName ?? "").toLowerCase() != "recovery")
//                     .toList();
//
//                 return ListView.builder(
//                     itemCount: showSports.length,
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemBuilder: (BuildContext context, int index) {
//                       final sport = showSports[index];
//
//                       return _optionTile(sport, ref);
//                     });
//               },
//               error: (error, stackTrace) =>
//                   SecondaryText(text: error.toString()),
//               loading: () {
//                 return const CupertinoActivityIndicator(radius: 10);
//               },
//             ),
//             SizedBox(height: 40.h),
//             Align(
//               alignment: Alignment.centerRight,
//               child: SizedBox(
//                 width: 154.50.w,
//                 child: MainButton(
//                   label: 'NEXT'.trU(context),
//                   // labelStyle: AppTextStyles.qanelasLight(
//                   //     fontSize: 18.sp, color: AppColors.white),
//                   showArrow: true,
//                   // labelColor: Colors.white,
//                   onTap: () {
//                     onProceed();
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: (82).h),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _optionTile(ClubLocationSports title, WidgetRef ref) {
//     final sport = ref.watch(settingSportsValueProvider);
//     bool selected =
//         (sport.toLowerCase() == (title.sportName ?? "").toLowerCase());
//     return InkWell(
//       onTap: () {
//         ref.read(settingSportsValueProvider.notifier).setSports =
//             title.sportName ?? sport;
//       },
//       borderRadius: BorderRadius.circular(5.r),
//       child: Container(
//         width: 311.w,
//         padding: EdgeInsets.all(10.h),
//         margin: EdgeInsets.symmetric(
//           vertical: 5.h,
//         ),
//         decoration: BoxDecoration(
//           color: selected ? AppColors.black2 : AppColors.tileBgColor,
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Row(
//           children: [
//             SelectedTag(
//               isSelected: selected,
//               selectedBorderColor: AppColors.white,
//               unSelectedBorderColor: AppColors.black2,
//               unSelectedColor: AppColors.white,
//               shape: BoxShape.circle,
//             ),
//             SizedBox(width: 20.w),
//             Expanded(
//               child: Text(
//                 title.sportName ?? "",
//                 style: selected
//                     ? AppTextStyles.manropeBold(
//                         fontSize: 16.sp,
//                         color: AppColors.white,
//                       )
//                     : AppTextStyles.manropeMedium(
//                         fontSize: 16.sp,
//                         color: AppColors.black2,
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
