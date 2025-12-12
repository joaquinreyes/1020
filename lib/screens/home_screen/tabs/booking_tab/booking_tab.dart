import 'dart:async';
import 'dart:ui';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/components/network_circle_image.dart';
import 'package:hop/components/notification_button.dart';
import 'package:hop/components/secondary_text.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/club_locations.dart';
import 'package:hop/models/court_booking.dart';
import 'package:hop/models/lesson_model_new.dart';
import 'package:hop/repository/club_repo.dart';
import 'package:hop/repository/location_repo.dart';
import 'package:hop/repository/play_repo.dart';
import 'package:hop/screens/app_provider.dart';
import 'package:hop/screens/home_screen/tabs/booking_tab/book_court_dialog/book_court_dialog.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/utils/dubai_date_time.dart';
import 'package:intl/intl.dart';
import 'package:hop/box_shadow/flutter_inset_box_shadow.dart' as inset;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_core/theme.dart'
    show SfDateRangePickerTheme, SfDateRangePickerThemeData;
import '../../../../components/chat_icon_component.dart';
import '../../../../globals/current_platform.dart';
import '../../../../globals/images.dart';
import '../../../../managers/api_manager.dart';
import '../../../../managers/private_chat_socket_manager/private_chat_socket_manager.dart';
import '../../../../managers/user_manager.dart';
import '../../../../models/calculated_level_data.dart';
import '../../../../models/coach_list_model.dart';
import '../../../../models/register_model.dart';
import '../../../../models/user_membership.dart';
import '../../../../repository/booking_repo.dart';
import '../../../../repository/level_repo.dart';
import '../../../../repository/payment_repo.dart';
import '../../../../repository/user_repo.dart';
import '../../../../routes/app_pages.dart';
import '../../../../routes/app_routes.dart';
import '../../../auth/signup/signup_screen.dart';
import '../../../payment_information/payment_information.dart';
import '../play_match_tab/play_match_tab.dart';
import '../profile_tab/tabs/membership_tab/membership_tab.dart';

part 'booking_tab_components.dart';

part 'booking_tab_provider.dart';

class BookingTab extends ConsumerStatefulWidget {
  const BookingTab({super.key});

  @override
  ConsumerState<BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends ConsumerState<BookingTab> with WidgetsBindingObserver {
  List<ClubLocationSports> sports = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeSocket();
    Future(() {
      ref.read(_selectedTabIndex.notifier).state = 0;
      ref.invalidate(_selectedDuration);
      ref.invalidate(_selectedTimeSlotAndLocationID);
      ref.invalidate(_pageViewController);
      ref.invalidate(selectedSportProvider);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh unread count when app comes to foreground
    if (state == AppLifecycleState.resumed) {
      _refreshUnreadCount();
    }
  }

  void _initializeSocket() {
    final socketNotifier = ref.read(privateChatSocketProvider.notifier);
    final state = ref.read(privateChatSocketProvider);

    if (!state.isConnected) {
      socketNotifier.connect(clubId: kClubID);
    } else {
      _refreshUnreadCount();
    }
  }

  void _refreshUnreadCount() {
    final socketNotifier = ref.read(privateChatSocketProvider.notifier);
    final state = ref.read(privateChatSocketProvider);

    if (state.isConnected) {
      Future(() {
        socketNotifier.getUnreadSenderCount();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(_selectedTabIndex, (previous, next) {
      if (next != previous) {
        Future(() {
          ref.read(_pageControllerFor.notifier).state.animateToPage(
                next,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
        });
      }
    });
    final data = ref.watch(clubLocationsProvider);
    final pageController = ref.watch(_pageControllerFor);

    return RefreshIndicator(
      color: AppColors.brick,
      backgroundColor: AppColors.white,
      onRefresh: () => ref.refresh(getCourtBookingProvider.future),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Row(
            children: [
              const Spacer(),
              // Builder(
              //   builder: (context) {
              //     final chatState = ref.watch(privateChatSocketProvider);
              //     return InkWell(
              //       onTap: () {
              //         ref.read(goRouterProvider).push(RouteNames.privateChatList);
              //       },
              //       child: ChatIconComponent(
              //         hasUnread: chatState.unreadSenderCount > 0,
              //         unreadCount: chatState.unreadSenderCount,
              //       ),
              //     );
              //   },
              // ),
              SizedBox(width: 15.w),
              const NotificationButton(),
              SizedBox(width: 30.w),
            ],
          ),
          SizedBox(height: 10.h),
          _viewSelectRow(),
          // Container(
          //   alignment: AlignmentDirectional.centerStart,
          //   padding: EdgeInsets.symmetric(horizontal: 20.w),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(),
          //     child: Text(
          //       '${'COURTS'.trU(context)}',
          //       style: AppTextStyles.gothamNarrowBold()
          //           .copyWith(height: 0.95, fontSize: 22.sp, letterSpacing: 1),
          //     ),
          //   ),
          // ),
          Expanded(
            child: data.when(
              data: (data) {
                if (data == null) {
                  return const Center(
                      child: SecondaryText(text: "Unable to get Locations."));
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;

                  sports = [...Utils.fetchSportsList(data)];

                  final sportNotifier =
                      ref.read(selectedSportProvider.notifier);
                  final lessonNotifier =
                      ref.read(selectedSportLessonProvider.notifier);

                  sportNotifier.sport ??= sports.first;
                  lessonNotifier.sport ??= sports.first;
                });
                return _slotsView(data, pageController);

                // return _bookingBody(data);
              },
              error: (error, stackTrace) =>
                  SecondaryText(text: error.toString()),
              loading: () {
                return const CupertinoActivityIndicator(radius: 10);
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _viewSelectRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: inset.BoxDecoration(
        color: AppColors.black5,
        boxShadow: kInsetShadow,
      ),
      child: Row(
        children: [
          20.horizontalSpace,
          _Selector(title: 'COURTS'.trU(context), index: 0),
          _Selector(title: "COACHES".trU(context), index: 1),
          20.horizontalSpace,
          // _Selector(title: "SAUNA".trU(context), index: 2),
        ],
      ),
    );
  }

  Widget _slotsView(
      List<ClubLocationData> locationsData, PageController pageController) {
    final lessonSelected = ref.watch(_selectedTabIndex) == 1;
    final isDateLessonSelected = ref.watch(_dateBookableLesson);
    final coachesProvider = ref.watch(fetchAllCoachesProvider);
    return coachesProvider.when(
        data: (coachesList) {
          final selectedLessonCoachId = ref.read(_selectedLessonCoachId);

          // Only set the value once when it's empty
          if (selectedLessonCoachId.isEmpty) {
            if (coachesList.isNotEmpty) {
              Future(() {
                ref.read(_selectedLessonCoachId.notifier).state = [
                  (coachesList.first.id ?? 0)
                ];
              });
            }
          }

          return Column(
            children: [
              Row(
                children: [
                  if (lessonSelected) _coachDateSelector(),
                  Expanded(
                    child: !isDateLessonSelected && lessonSelected
                        ? const _CoachSelection()
                        : _DateSelectorWidget(
                            futureDayLength: Utils.getFutureDateLength(
                                locationsData, getSportsName(ref)),
                          ),
                  )
                ],
              ),
              12.verticalSpace,
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (value) {
                    if (value == 0) {
                      final sportList = [...sports];
                      sportList.removeWhere(
                          (e) => (e.sportName ?? "").toLowerCase() != "padel");
                      ref.read(selectedSportProvider.notifier).sport =
                          sportList.first;
                    } else if (value == 2) {
                      final sportList = [...sports];
                      sportList.removeWhere((e) =>
                          (e.sportName ?? "").toLowerCase() != "recovery");
                      ref.read(selectedSportProvider.notifier).sport =
                          sportList.first;
                    } else {
                      if (ref.read(selectedSportProvider.notifier).sport ==
                          null) {
                        ref.read(selectedSportProvider.notifier).sport ??=
                            sports.first;
                      }
                      if (ref
                              .read(selectedSportLessonProvider.notifier)
                              .sport ==
                          null) {
                        ref.read(selectedSportLessonProvider.notifier).sport =
                            sports.first;
                      }
                    }
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _bookingBody(locationsData),
                    _lessonsBody(),
                    _saunaBody(locationsData),
                  ],
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) => SecondaryText(text: error.toString()),
        loading: () => const Center(
              child: CupertinoActivityIndicator(
                radius: 10,
              ),
            ));
  }

  Widget _coachDateSelector() {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(left: 6.w, top: 15.h, bottom: 7.h),
      decoration: inset.BoxDecoration(
        boxShadow: kInsetShadow,
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.black5
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dateAndCoach(text: "DATE".tr(context), value: true),
          _dateAndCoach(text: "COACH".tr(context), value: false),
        ],
      ),
    );
  }

  Widget _dateAndCoach({required String text, required bool value}) {
    final isDateLessonSelected = ref.watch(_dateBookableLesson) == value;
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.r),
      ),
      onTap: () {
        if (value) {
          ref.read(_selectedLessonCoachId.notifier).state = [];
        } else {
          final fetchAllCoaches = ref.read(fetchAllCoachesProvider).value ?? [];

          final selectedLessonCoachId = ref.read(_selectedLessonCoachId);

          if (selectedLessonCoachId.length == fetchAllCoaches.length ||
              selectedLessonCoachId.length > 1 ||
              selectedLessonCoachId.isEmpty) {
            if (fetchAllCoaches.isNotEmpty) {
              ref.read(_selectedLessonCoachId.notifier).state = [
                (fetchAllCoaches.first.id ?? 0)
              ];
            }
          }
        }
        ref.read(_dateBookableLesson.notifier).state = value;
      },
      child: Container(
        margin: EdgeInsets.all(4.h),
        padding: EdgeInsets.symmetric(horizontal: 9.5.w,vertical: 4.h),
        decoration: BoxDecoration(
          color: isDateLessonSelected ? AppColors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(100.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: isDateLessonSelected
              ? AppTextStyles.manropeSemiBold(fontSize: 14.sp)
                  .copyWith(color: AppColors.white)
              : AppTextStyles.manropeSemiBold(fontSize: 13.sp),
        ),
      ),
    );
  }

  Widget _lessonsBody() {
    return LayoutBuilder(
      builder: (context, constraint) {
        // final sportList = [...sports];
        // sportList.removeWhere(
        //     (e) => (e.sportName ?? "").toLowerCase() == "recovery");
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: Column(
              children: [
                // _sportsRow(sportList, selectedSport,
                //     (ClubLocationSports sport) {
                //   ref.read(_selectedTimeSlotAndLocationID.notifier).state =
                //       (null, null);
                //
                //   ref.read(selectedSportLessonProvider.notifier).sport = sport;
                // }),
                // SizedBox(height: 15.h),
                ExpandablePageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: ref.watch(_pageViewController),
                  children: const [LessonsList()],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sportsRow(List<ClubLocationSports> sportsList,
      ClubLocationSports? selectedSport, Function(ClubLocationSports) onTap) {
    final sports = sportsList
        .where((e) => (e.sportName ?? "").toLowerCase() != "recovery")
        .toList();

    if (sports.length > 3) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 9.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          // decoration: inset.BoxDecoration(
          //   color: AppColors.tileBgColor,
          //   boxShadow: kInsetShadow,
          //   // borderRadius: BorderRadius.circular(12.r)
          // ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              for (int i = 0; i < sports.length; i++)
                _Sport(
                    sportToShow: sports[i],
                    index: i,
                    isServiceSelected: selectedSport == sports[i],
                    onTap: () {
                      onTap(sports[i]);
                    }),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Container(
          // decoration: inset.BoxDecoration(
          //   color: AppColors.tileBgColor,
          //   // borderRadius: BorderRadius.circular(12.r),
          //   boxShadow: kInsetShadow,
          // ),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              for (int i = 0; i < sports.length; i++)
                Expanded(
                  child: _Sport(
                      sportToShow: sports[i],
                      index: i,
                      isServiceSelected: selectedSport == sports[i],
                      onTap: () {
                        onTap(sports[i]);
                      }),
                ),
            ],
          ),
        ),
      );
    }
  }

  Widget _bookingBody(List<ClubLocationData> locationsData) {
    final bookingSelected = ref.watch(_selectedTabIndex) == 0;
    final courtBookings = ref.watch(getCourtBookingProvider);
    final sport = ref.watch(selectedSportProvider);
    final futureDateLength =
        Utils.getFutureDateLength(locationsData, sport?.sportName ?? '');
    if (bookingSelected) {
      _invalidateDateIfBeyondFutureLimit(futureDateLength);
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // _DateSelectorWidget(futureDayLength: futureDateLength),
          // _sportsRow(sports, sport, (ClubLocationSports sport) {
          //   ref.read(_selectedTimeSlotAndLocationID.notifier).state =
          //       (null, null);
          //   ref.read(selectedSportProvider.notifier).sport = sport;
          // }),
          // SizedBox(height: 10.h),
          courtBookings.when(
            data: (data) {
              if (data == null) {
                return SecondaryText(text: "NO_AVAILABLE_SLOTS".trU(context));
              }
              return Column(
                children: [
                  _body(locationsData, data),
                ],
              );
            },
            error: (error, stackTrace) => SecondaryText(text: error.toString()),
            loading: () {
              return const CupertinoActivityIndicator(radius: 10);
            },
          ),
        ],
      ),
    );
  }

  Widget _body(List<ClubLocationData> locationsData, CourtBookingData data) {
    final selectedDate = ref.watch(selectedDateProvider);
    final PageController pageController = ref.watch(_pageViewController);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _sportsAndServiceRow(data),
        12.verticalSpace,
        // if((selectedSport?.sportName ?? "").toLowerCase() == "padel")
        // _MembershipComponent(),
        ExpandablePageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            for (int duration in data.durationsToShow)
              _locationsAndTimeSlots(
                data,
                duration,
                selectedDate,
                locationsData,
              ),
          ],
        ),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget _locationsAndTimeSlots(CourtBookingData data, int? selectedDuration,
      DubaiDateTime selectedDate, List<ClubLocationData> locationsData) {
    final userLoc = ref.watch(fetchLocationProvider).asData?.value;

    if (data.isAllTimeSlotsEmpty(
        selectedDuration ?? 0, selectedDate.dateTime)) {
      return SecondaryText(text: "NO_AVAILABLE_SLOTS".trU(context));
    }

    final locations = Utils.sortLocations(locationsData, userLoc);

    if (data.isAllTimeSlotsEmpty(
        selectedDuration ?? 0, selectedDate.dateTime)) {
      return SecondaryText(text: "NO_AVAILABLE_SLOTS".trU(context));
    }
    return ListView.builder(
      itemCount: locations.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final location = locations[index];
        final locationName = location.locationName?.capitalizeFirst ?? '';
        final distance =
            location.getLocationRadius(userLoc?.latitude, userLoc?.longitude);
        int? currentCourt = ref.watch(_selectedCourt);
        final sauna = ref.watch(_selectedTabIndex) == 2;

        final timeSlots = data.getTimeSlots(sauna ? currentCourt : null,
            selectedDuration ?? 0, location.id!, selectedDate.dateTime);

        if (timeSlots.isEmpty) return const SizedBox();

        return Padding(
          padding: EdgeInsets.only(bottom: 15.h),
          child: _serviceTimeSlotsBackgroundContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      locationName.toUpperCase(),
                      style: AppTextStyles.sofiaSansMedium(
                        fontSize: 20.sp,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${distance} km",
                      style: AppTextStyles.manropeMedium(
                          color: AppColors.black70, fontSize: 15.sp),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                _Timeslots(data: data, locationID: location.id!),
                _AvailableTimeslot(
                  data: data,
                  locationID: location.id!,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container _sportsAndServiceRow(CourtBookingData data) {
    int? currentDuration = ref.read(_selectedDuration);
    Future(() {
      if (currentDuration != null &&
          data.durationsToShow.contains(currentDuration)) {
        ref.read(_selectedDuration.notifier).state = currentDuration;
      } else {
        ref.read(_selectedDuration.notifier).state = data.durationsToShow.first;
      }
    });
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      // padding: EdgeInsets.all(0.h),
      child: Container(
        height: 38.h,
        constraints: kComponentWidthConstraint,
        decoration: inset.BoxDecoration(
          boxShadow: kInsetShadow,
          borderRadius: BorderRadius.circular(100.r),
          color: AppColors.black5,
        ),
        child: Row(
          children: [
            for (int i = 0; i < data.durationsToShow.length; i++)
              _Duration(duration: data.durationsToShow[i], index: i),
          ],
        ),
      ),
    );
  }

  Widget _courtsRow(CourtBookingData data) {
    final uniqueCourts = data.uniqueCourts;

    if (uniqueCourts.isEmpty) {
      return SizedBox();
    }

    // Initialize selected court if needed
    int? currentCourt = ref.read(_selectedCourt);
    Future(() {
      if (currentCourt != null && data.uniqueCourts.containsKey(currentCourt)) {
        ref.read(_selectedCourt.notifier).state = currentCourt;
      } else {
        if (data.uniqueCourts.isNotEmpty) {
          ref.read(_selectedCourt.notifier).state =
              data.uniqueCourts.keys.first;
        }
      }
    });

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      // padding: EdgeInsets.all(0.h),
      color: AppColors.white,
      child: Container(
        height: 38.h,
        constraints: kComponentWidthConstraint,
        decoration: inset.BoxDecoration(
          boxShadow: kInsetShadow,
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.black5,
        ),
        child: Row(
            children: uniqueCourts.entries
                .map((e) => Expanded(
                      child: _Court(
                        courtId: e.key,
                        courtName: e.value,
                      ),
                    ))
                .toList()),
      ),
    );
  }

  void _invalidateDateIfBeyondFutureLimit(int futureDateLength) {
    if (futureDateLength < 1) {
      return;
    }
    final selectedDate = ref.watch(selectedDateProvider);
    final today = DubaiDateTime.now();
    final difference =
        selectedDate.dateTime.difference(today.dateTime).inDays + 1;
    if (difference >= futureDateLength) {
      Future(() {
        ref.invalidate(selectedDateProvider);
      });
    }
  }

  Container _serviceTimeSlotsBackgroundContainer({Widget? child}) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 15.h),
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: AppColors.black5,
        // border: border,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }

  Widget _saunaBody(List<ClubLocationData> locationsData) {
    final saunaSelected = ref.watch(_selectedTabIndex) == 2;
    final courtBookings = ref.watch(getCourtBookingProvider);
    final sport = ClubLocationSports(sportName: 'Recovery');
    final futureDateLength =
        Utils.getFutureDateLength(locationsData, sport.sportName ?? '');
    if (saunaSelected) {
      _invalidateDateIfBeyondFutureLimit(futureDateLength);
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          courtBookings.when(
            data: (data) {
              if (data == null) {
                return SecondaryText(text: "NO_AVAILABLE_SLOTS".trU(context));
              }
              return Column(
                children: [
                  _bodySauna(locationsData, data),
                ],
              );
            },
            error: (error, stackTrace) => SecondaryText(text: error.toString()),
            loading: () {
              return const CupertinoActivityIndicator(radius: 10);
            },
          ),
        ],
      ),
    );
  }

  Widget _bodySauna(
      List<ClubLocationData> locationsData, CourtBookingData data) {
    final selectedDate = ref.watch(selectedDateProvider);
    final PageController pageController = ref.watch(_pageViewController);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _sportsAndServiceRow(data),
        SizedBox(height: 9.h),
        _courtsRow(data),
        SizedBox(height: 9.h),
        ExpandablePageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            for (int duration in data.durationsToShow)
              _locationsAndTimeSlots(
                data,
                duration,
                selectedDate,
                locationsData,
              ),
          ],
        ),
        SizedBox(height: 15.h),
      ],
    );
  }
}

class LessonsList extends ConsumerStatefulWidget {
  const LessonsList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LessonState();
}

class _LessonState extends ConsumerState<LessonsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final date = ref.watch(selectedDateLessonProvider);
    final selectedLessonCoachId = ref.watch(_selectedLessonCoachId);
    final isDateLessonSelected = ref.watch(_dateBookableLesson);
    final dateLessonsRangeProvider = ref.watch(_dateLessonsRangeProvider);
    final startDate = dateLessonsRangeProvider.startDate!;
    final endDate = dateLessonsRangeProvider.endDate!;
    final lessons = ref.watch(lessonsSlotProvider(
        startTime: !isDateLessonSelected ? startDate : date.dateTime,
        sportName: "padel",
        endTime: !isDateLessonSelected ? endDate : null,
        coachId: selectedLessonCoachId,
        duration: null));
    return lessons.when(
      skipLoadingOnRefresh: false,
      data: (data) {
        if (data.data?.availableSlots?.isEmpty ?? true) {
          return SecondaryText(
            text: "NO_LESSONS_FOUND".tr(context),
            imagePath: 'assets/images/screens_icons/no coaching_balls_icon.png',
            imageSize: 250,
          );
        }
        final lessonVariants = ref.watch(_lessonVariantList);
        LessonVariants? lessonVariant = ref.watch(_selectedCoachLessonDuration);
        if (lessonVariants.isEmpty) {
          Future(() {
            ref.read(_lessonVariantList.notifier).state = data.durationsToShow;
          });
        }

        if (lessonVariant != null) {
          if (lessonVariants
                  .indexWhere((e) => e.duration == lessonVariant.id) !=
              -1) {
            Future(() {
              ref.read(_selectedCoachLessonDuration.notifier).state =
                  lessonVariant;
            });
          }
        } else {
          if (lessonVariants.isNotEmpty) {
            Future(() {
              ref.read(_selectedCoachLessonDuration.notifier).state =
                  lessonVariants.first;
            });
          }
        }

        final selectedCoach = ref.watch(_selectedLessonCoachId);
        final dateBookableSelected = ref.watch(_dateBookableLesson);

        final selectedLocation = ref.watch(_selectedLessonsLocationProvider);

        final availableSlots = data.data?.getAvailableSlotsByLocation(
                selectedCoach,
                dateBookableSelected,
                selectedLocation,
                lessonVariant) ??
            [];

        List<DateTime> days = [];
        for (DateTime date = startDate;
            !date.isAfter(endDate);
            date = date.add(const Duration(days: 1))) {
          days.add(date);
        }

        return Column(
          children: [
            _lessonDurationList(),
            15.verticalSpace,
            const _FilterRow(),
            11.verticalSpace,
            availableSlots.isNotEmpty
                ? !dateBookableSelected
                    ? Column(
                        children: days.map((date) {
                          final cardData = availableSlots.first;
                          return _coachCard(cardData, data, selectedDate: date);
                        }).toList(),
                      )
                    : ListView.builder(
                        itemCount: availableSlots.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final cardData = availableSlots[index];
                          return _coachCard(cardData, data);
                        },
                      )
                : SecondaryText(
                    text: "NO_LESSONS_FOUND".tr(context),
                    imagePath: 'assets/images/screens_icons/no coaching_balls_icon.png',
                    imageSize: 250,
                  )
          ],
        );

        // return Column(
        //   children: [
        //     // _sportsAndServiceRowForLesson(data),
        //     // SizedBox(height: 12.h),
        //     (data.data?.availableSlots ?? []).isNotEmpty
        //         ? ListView.builder(
        //             itemCount: data.data?.availableSlots?.length ?? 0,
        //             physics: const NeverScrollableScrollPhysics(),
        //             shrinkWrap: true,
        //             itemBuilder: (context, index) {
        //               final cardData = data.data?.availableSlots?[index];
        //               List<DateTime> timeSlots = data.data?.getTimeSlots(
        //                       cardData?.id ?? (-1),
        //                       null,
        //                       ref.watch(selectedDateLessonProvider).dateTime,
        //                       ref.watch(_selectedLessonBookingType)) ??
        //                   [];
        //
        //               if (timeSlots.isEmpty) {
        //                 return SecondaryText(
        //                     text: "NO_TIME_AVAILABLE".tr(context));
        //               }
        //
        //               return Padding(
        //                 padding: EdgeInsets.only(bottom: 15.h),
        //                 child: _serviceTimeSlotsBackgroundContainer(
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Row(
        //                         crossAxisAlignment: CrossAxisAlignment.center,
        //                         children: [
        //                           // if ((cardData?.profileUrl ?? "")
        //                           //     .isNotEmpty)
        //                           //   ...[
        //                             // CircleAvatar(
        //                             //   radius: 15.sp,
        //                             //   foregroundImage: ,
        //                             // ),
        //                               NetworkCircleImage(
        //                                 path: cardData?.profileUrl,
        //                                 height: 28.h,
        //                                 width: 28.h,
        //                                 logoColor: AppColors.white,
        //                                 bgColor: AppColors.black,
        //                                 borderRadius: BorderRadius.circular(4.r),
        //                                 // bgColor: AppColors.white,
        //                               ),
        //                             // Container(
        //                             //   height: 28.h,
        //                             //   width: 28.h,
        //                             //   decoration: BoxDecoration(
        //                             //     borderRadius: BorderRadius.circular(4.r),
        //                             //     image: DecorationImage(
        //                             //       image: NetworkImage(
        //                             //         cardData?.profileUrl ?? "",
        //                             //       ),
        //                             //     ),
        //                             //   ),
        //                             // ),
        //                             SizedBox(width: 8.w),
        //                           // ],
        //                           Text(
        //                             "${"COACH".trU(context)} ${cardData?.fullName?.toUpperCase()}" ??
        //                                 "",
        //                             style: AppTextStyles.qanelasMedium(
        //                                 fontSize: 15.sp,),
        //                           ),
        //                           const Spacer(),
        //                           // if ((cardData?.profileUrl ?? "").isNotEmpty)
        //                             InkWell(
        //                               onTap: () {
        //                                 showDialog(
        //                                   context: context,
        //                                   builder: (BuildContext context) {
        //                                     return CoachDetailsDialog(
        //                                         data: cardData);
        //                                   },
        //                                 );
        //                               },
        //                               child: Text(
        //                                 "${"SEE_PROFILE".tr(context)}",
        //                                 style: AppTextStyles.qanelasRegular(
        //                                   color: AppColors.black70,
        //                                   fontSize: 15.sp
        //                                 ),
        //                                 textAlign: TextAlign.center,
        //                               ),
        //                             )
        //                         ],
        //                       ),
        //                       /* SizedBox(height: 5.h),
        //               Divider(
        //                 color: kSecondaryColor,
        //                 height: 0.75.h,
        //                 thickness: 2,
        //               ),*/
        //                       SizedBox(height: 10.h),
        //                       _TimeslotsLesson(
        //                         data: data.data,
        //                         locationID: cardData?.id ?? (-1),
        //                         lessonId: cardData?.lessons
        //                                 ?.firstWhere(
        //                                     (e) =>
        //                                         e.duration ==
        //                                         ref.read(
        //                                             _selectedLessonBookingType),
        //                                     orElse: () => Lessons())
        //                                 .id ??
        //                             0,
        //                       ),
        //                       // SizedBox(height: 7.h),
        //                       _AvailableTimeslotLesson(
        //                         data: data.data,
        //                         calenderTitle:
        //                             "${cardData?.fullName ?? ""} ${cardData?.location?.locationName}",
        //                         lesson_id: cardData?.lessons
        //                                 ?.firstWhere(
        //                                     (e) =>
        //                                         e.duration ==
        //                                         ref.read(
        //                                             _selectedLessonBookingType),
        //                                     orElse: () => Lessons())
        //                                 .id ??
        //                             0,
        //                         // (cardData?.lessonIds?.isNotEmpty ?? false)
        //                         //     ? cardData?.lessonIds?.first ?? 0
        //                         //     : (-1),
        //                         title: cardData?.fullName ?? "",
        //                         coach_id: cardData?.id ?? 0,
        //                         // locationID: cardData?.id ?? (-1),
        //                         location_id: cardData?.location?.id ?? 0,
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               );
        //             },
        //           )
        //         : SecondaryText(text: "NO_AVAILABLE_SLOTS".tr(context))
        //   ],
        // );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (error, _) => SecondaryText(text: error.toString()),
    );
  }

  Container _lessonDurationList() {
    final listLessonTypes = ref.watch(_lessonVariantList);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w,),
      constraints: kComponentWidthConstraint,
      decoration: inset.BoxDecoration(
        boxShadow: kInsetShadow,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        children: [
          for (int i = 0; i < listLessonTypes.length; i++)
            _CoachDurationList(lessonVariants: listLessonTypes[i], index: i),
        ],
      ),
    );
  }

  Container _serviceTimeSlotsBackgroundContainer({Widget? child}) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 15.h),
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: AppColors.black5,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }

  Widget _coachCard(AvailableSlots cardData, LessonModelNew data,
      {DateTime? selectedDate}) {
    final dateBookableSelected = ref.watch(_dateBookableLesson);

    final selectedDateTemp = ref.watch(selectedDateLessonProvider);
    final selectedDuration = ref.watch(_selectedCoachLessonDuration);

    final List<DateTime> timeSlots = data.data?.getTimeSlots(
            cardData.id ?? 0,
            selectedDate ?? selectedDateTemp.dateTime,
            selectedDuration,
            null) ??
        [];

    if (timeSlots.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: _serviceTimeSlotsBackgroundContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!dateBookableSelected)
                  Text(
                    selectedDate != null
                        ? DateFormat('EEE d MMM').format(selectedDate)
                        : cardData.getDateCourt(selectedDuration),
                    style: AppTextStyles.manropeMedium(
                      fontSize: 15.sp,
                      color: AppColors.black70,
                    ),
                  ),
                InkWell(
                  onTap: () {
                    if ((cardData.profileUrl ?? "").isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CoachDetailsDialog(data: cardData);
                        },
                      );
                    }
                  },
                  child: Row(
                    children: [
                      if ((cardData.profileUrl ?? "").isNotEmpty) ...[
                        NetworkCircleImage(
                          path: cardData.profileUrl ?? "",
                          width: 28.h,
                          height: 28.h,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        SizedBox(width: 8.w)
                      ],
                      Text(
                        cardData.fullName?.toUpperCase() ?? "",
                        style: AppTextStyles.sofiaSansMedium(fontSize: 20.sp),
                      ),
                    ],
                  ),
                ),
                if (dateBookableSelected)
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CoachDetailsDialog(data: cardData);
                        },
                      );
                    },
                    child: Text("INFO".tr(context),
                        style: AppTextStyles.manropeMedium(fontSize: 15.sp,color: AppColors.black70,)),
                  )
              ],
            ),
            // SizedBox(height: 5.h),
            // Divider(
            //   color: AppColors.black,
            // ),
            // SizedBox(height: 5.h),
            Column(
              children: cardData.location?.map((e) {
                    final selectedCoachLocation =
                        ref.watch(_selectedLessonsLocationProvider);

                    if (selectedCoachLocation.id != -1 &&
                        selectedCoachLocation.id != e.id) {
                      return SizedBox();
                    }

                    final List<DateTime> timeSlots = data.data?.getTimeSlots(
                            cardData.id ?? 0,
                            selectedDate ?? selectedDateTemp.dateTime,
                            selectedDuration,
                            e) ??
                        [];

                    if (timeSlots.isEmpty) {
                      return const SizedBox();
                    }

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Text(
                          //   (e.locationName ?? "").capitalizeFirst,
                          //   style: AppTextStyles.manropeMedium(fontSize: 14.sp)
                          //       .copyWith(fontWeight: FontWeight.bold),
                          //   textAlign: TextAlign.start,
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          10.verticalSpace,
                          _TimeslotsLesson(
                              selectedDate: selectedDate,
                              data: data.data,
                              coachId: cardData.id ?? (-1),
                              lessonLocation: e),
                          _AvailableTimeslotLesson(
                              selectedDate: selectedDate,
                              data: data.data,
                              calenderTitle: "${cardData.fullName ?? ""}",
                              title: cardData.fullName ?? "",
                              lessonLocation: e,
                              coachId: cardData.id ?? 0),
                        ]);
                  }).toList() ??
                  [],
            ),
          ],
        ),
      ),
    );
  }
}

class CoachDetailsDialog extends StatelessWidget {
  const CoachDetailsDialog({super.key, required this.data});

  final AvailableSlots? data;

  @override
  Widget build(BuildContext context) {
    final description = data?.description ?? "";
    return CustomDialog(
      color: AppColors.white,
      closeIconColor: AppColors.blue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${'COACH'.trU(context)} ${data?.fullName?.trU(context)}',
            style: AppTextStyles.popupHeaderTextStyle
                .copyWith(color: AppColors.blue),
            textAlign: TextAlign.center,
          ),
          // Text(
          //   '${'COACH'.trU(context)} ${data?.fullName?.trU(context)}',
          //   textAlign: TextAlign.center,
          //   style: AppTextStyles.popupHeaderTextStyle,
          // ),
          20.verticalSpace,
          NetworkCircleImage(
            path: data?.profileUrl,
            height: 80.h,
            width: 80.h,
            bgColor: AppColors.blue,
            logoColor: AppColors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          if (description.trim().isNotEmpty) SizedBox(height: 15.h),
          if (description.trim().isNotEmpty)
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.manropeMedium(
                fontSize: 15.sp,
                color: AppColors.blue,
              ),
            ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
