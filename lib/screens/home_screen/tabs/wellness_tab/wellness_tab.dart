import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:hop/CustomDatePicker/flutter_datetime_picker.dart';
import 'package:hop/CustomDatePicker/src/i18n_model.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/book_court_info_card.dart';
import 'package:hop/components/c_divider.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/components/secondary_text.dart';
import 'package:hop/components/service_detail_components.dart/event_lesson_card_coach.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/club_locations.dart';
import 'package:hop/models/events_model.dart';
import 'package:hop/repository/club_repo.dart';
import 'package:hop/screens/app_provider.dart';
import 'package:hop/screens/home_screen/tabs/profile_tab/tabs/membership_tab/membership_tab.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/utils/dubai_date_time.dart';
import 'package:hop/box_shadow/flutter_inset_box_shadow.dart' as inset;
import '../../../../models/active_memberships.dart';
import '../../../../models/membership_model.dart';
import '../../../../repository/booking_repo.dart';
import '../../../../repository/payment_repo.dart';
import '../../../../repository/play_repo.dart';
import '../../../../routes/app_pages.dart';
import '../../../../routes/app_routes.dart';
import '../../../payment_information/payment_information.dart';
import '../play_match_tab/play_match_tab.dart';
import '../play_match_tab/tabs/events_list.dart';

part 'wellness_tab_components.dart';

part 'wellness_tab_provider.dart';

class WellnessTab extends ConsumerStatefulWidget {
  const WellnessTab({
    super.key,
    required this.start,
    required this.end,
    required this.locationIds,
    required this.sportsIds,
  });

  final DateTime start;
  final DateTime end;
  final List<int> locationIds;
  final List<int> sportsIds;

  @override
  ConsumerState<WellnessTab> createState() => _WellnessTabState();
}

class _WellnessTabState extends ConsumerState<WellnessTab> {
  List<ClubLocationSports> sports = [];

  String selected = "CLASSES";

  @override
  void initState() {
    Future(() {
      ref.read(_selectedTabIndex.notifier).state = 0;
      ref.invalidate(_selectedDuration);
      ref.invalidate(_selectedTimeSlotAndLocationID);
      ref.invalidate(_pageViewController);
      ref.invalidate(selectedSportProvider);
    });
    super.initState();
  }

  @override
  void dispose() {
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
          if (selected == "PACKAGES") {
            ref.refresh(fetchActiveAndAllMembershipsProvider);
          } else {
            ref.refresh(eventsListProvider(
                    startDate: widget.start,
                    endDate: widget.end,
                    locationIDs: widget.locationIds,
                    sportsIds: widget.sportsIds)
                .future);
          }
        });
      }
    });
    final data = ref.watch(clubLocationsProvider);
    final pageController = ref.watch(_pageControllerFor);

    return RefreshIndicator(
        color: AppColors.brick,
        backgroundColor: AppColors.white,
      onRefresh: () {
        if (selected == "CLASSES") {
          ref.refresh(eventsListProvider(
                  startDate: widget.start,
                  endDate: widget.end,
                  locationIDs: widget.locationIds,
                  sportsIds: widget.sportsIds)
              .future);
        }

        return ref.refresh(fetchActiveAndAllMembershipsProvider.future);
      },
      child: Column(
        children: [
          SizedBox(height: 30.h),
          Row(
            children: [
              const Spacer(),
              // const NotificationButton(), // Temporarily hidden
              SizedBox(width: 30.w),
            ],
          ),
          SizedBox(height: 2.5.h),
          // _viewSelectRow(),
          Container(
            alignment: AlignmentDirectional.centerStart,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Padding(
              padding: const EdgeInsets.symmetric(),
              child: Text(
                '${'PILATES'.trU(context)}',
                style: AppTextStyles.sofiaSansMedium(fontSize: 22.sp, letterSpacing: 1),
              ),
            ),
          ),
          Expanded(
            child: data.when(
              data: (data) {
                if (data == null) {
                  return const Center(
                      child: SecondaryText(text: "Unable to get Locations."));
                }
                Future(() {
                  sports = [...Utils.fetchSportsList(data)];
                  if (ref.read(selectedSportProvider.notifier).sport == null) {
                    ref.read(selectedSportProvider.notifier).sport ??=
                        sports.first;
                  }
                  if (ref.read(selectedSportLessonProvider.notifier).sport ==
                      null) {
                    ref.read(selectedSportLessonProvider.notifier).sport =
                        sports.first;
                  }
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
      // margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
      ),
      decoration: inset.BoxDecoration(
        color: AppColors.black5,
        boxShadow: kInsetShadow,
      ),
      child: Row(
        children: [
          _Selector(title: 'REFORMER_PILATES'.trU(context), index: 0),
          _Selector(title: "YOGA".trU(context), index: 1),
        ],
      ),
    );
  }

  Widget _slotsView(
      List<ClubLocationData> locationsData, PageController pageController) {
    return Column(
      children: [
        // _DateSelectorWidget(futureDayLength: Utils.getFutureDateLength(locationsData, getSportsName(ref))),
        SizedBox(height: 13.h),
        Expanded(
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _moveRoom(),
              _alignRoom(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _moveRoom() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // ToggleTabs(
          //   tabs: ["CLASSES", "PACKAGES"],
          //   selectedTab: selected,
          //   onTabSelected: (tab) {
          //     setState(() {
          //       selected = tab;
          //     });
          //   },
          // ),
          // SizedBox(height: 10.h),
          if (selected == "CLASSES")
            Column(
              children: [_classesSlots()],
            )
          else
            Column(
              children: [_membershipView()],
            ),
        ],
      ),
    );
  }

  Widget _alignRoom() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          ToggleTabs(
            tabs: ["CLASSES", "PACKAGES"],
            selectedTab: selected,
            onTabSelected: (tab) {
              setState(() {
                selected = tab;
              });
            },
          ),
          SizedBox(height: 10.h),
          if (selected == "CLASSES")
            Column(
              children: [
                _classesSlots(),
              ],
            )
          else
            Column(
              children: [
                _membershipView(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _classesSlots() {
    final selectedIndex = ref.watch(_selectedTabIndex);

    final events = ref.watch(eventsListProvider(
        startDate: widget.start,
        endDate: widget.end,
        locationIDs: widget.locationIds,
        sportsIds: widget.sportsIds));

    return Column(
      children: [
        // FilterRow(allowLevelFilter: false),
        Padding(
          padding: EdgeInsets.only(top: 15.h),
          child: _MembershipComponent(),
        ),
        events.when(
          data: (data) {
            final selectedEvents = data.where((element) {
              final categoryName =
                  element.service?.event?.eventCategory?.categoryName ?? "";
              return categoryName.toLowerCase() ==
                  (selectedIndex == 0 ? "" : "YOGA").toLowerCase();
            }).toList();
            if (selectedEvents.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SecondaryText(text: "NO_PILATES_FOUND".tr(context)),
              );
            }

            final dateList = selectedEvents.dateList;
            dateList.sort((a, b) => a.compareTo(b));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildBookingWidgets(
                context: context,
                dateList: dateList,
                events: selectedEvents,
              ),
            );
          },
          loading: () => const Padding(
              padding: const EdgeInsets.only(top: 20),
              child: CupertinoActivityIndicator()),
          error: (error, _) => Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SecondaryText(text: error.toString()),
          ),
        ),
      ],
    );
  }

  List<Widget> buildBookingWidgets(
      {required BuildContext context,
      required List<DateTime> dateList,
      required List<EventsModel> events}) {
    final widgets = <Widget>[];
    widgets.add(
      Padding(
        padding: EdgeInsets.only(right: 15.w,left: 15.w,bottom: 15.sp),
        child: Text("CLASSES".trU(context),style: AppTextStyles.sofiaSansMedium(fontSize: 17.sp),),
      ),
    );
    for (var date in dateList) {
      // widgets.add(
      //   Text(
      //     ''??Utils.formatBookingDate(date, context).toUpperCase(),
      //     style: AppTextStyles.qanelasMedium(
      //         fontSize: 17.sp,),
      //   ),
      // );

      final dateBookings = events.where((e) => e.bookingDate == date).toList();

      widgets.addAll(
        dateBookings.map((event) {
          return Padding(
            padding: EdgeInsets.only(bottom: 15.h, left: 15.w, right: 15.w),
            child: InkWell(
              onTap: () async {
                await ref
                    .read(goRouterProvider)
                    .push("${RouteNames.class_info}/${event.id}");
                ref.invalidate(eventsListProvider);
              },
              child: ClassesCard(event: event),
            ),
          );
        }),
      );
    }
    return widgets;
  }

  Widget _membershipView() {
    final selectedIndex = ref.watch(_selectedTabIndex);
    final membership = ref.watch(fetchActiveAndAllMembershipsProvider);

    return membership.when(
        data: (data) {
          if (data.getMemberships(selectedIndex).isEmpty) {
            return SecondaryText(text: "NO_MEMBERSHIP_FOUND".tr(context));
          }
          return Column(
            children: data.getMemberships(selectedIndex).map((e) {
              final membershipName = (e.membershipName ?? "").capitalizeFirst;
              final activeMembership = data.activeMemberships(e.id ?? 0);
              final membershipPrice = e.price ?? 0;
              final duration = (e.duration ?? "").capitalizeFirst;

              return Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: _membershipSlotsBackgroundContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            membershipName,
                            style: AppTextStyles.manropeBold(
                                letterSpacing: 14.sp * 0.10),
                          ),
                        ],
                      ),
                      CDivider(),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                duration,
                                style:
                                    AppTextStyles.manropeLight(fontSize: 13.sp),
                              ),
                              Text(
                                "${"PRICE".tr(context)} ${Utils.formatPrice(membershipPrice)}",
                                style:
                                    AppTextStyles.manropeLight(fontSize: 13.sp),
                              ),
                            ],
                          ),
                          Spacer(),
                          MainButton(
                            color: AppColors.white,
                            showArrow: false,
                            applyShadow: true,
                            height: 30.h,
                            width: 75.w,
                            padding: EdgeInsets.only(left: 8.w, top: 2.h),
                            label: "BUY".trU(context),
                            labelStyle:
                                AppTextStyles.manropeLight(fontSize: 15.sp),
                            onTap: () async {
                              final selectedDate = await showDialog(
                                context: context,
                                builder: (context) {
                                  return MembershipInformation(
                                      membershipModel: e,
                                      activeMembership: activeMembership);
                                },
                              );

                              if (selectedDate is! DateTime) {
                                return;
                              }

                              final data = await showDialog(
                                context: context,
                                builder: (context) {
                                  return PaymentInformation(
                                    type: PaymentDetailsRequestType.membership,
                                    locationID: e.locationId,
                                    allowCoupon: false,
                                    allowMembership: false,
                                    allowWallet: false,
                                    purchaseMembership: true,
                                    price: e.price ?? 0,
                                    requestType: PaymentProcessRequestType.membership,
                                    serviceID: e.id ?? 0,
                                    startDate: null,
                                    duration: null,
                                  );
                                },
                              );
                              var (int? paymentDone, double? amount) =
                                  (null, null);
                              if (data is (int, double?)) {
                                (paymentDone, amount) = data;
                              }
                              if (paymentDone != null && context.mounted) {
                                await Utils.showMessageDialog(
                                  context,
                                  "YOU_HAVE_PURCHASED_MEMBERSHIP_SUCCESSFULLY"
                                      .tr(context),
                                );
                              }
                              ref.invalidate(
                                  fetchActiveAndAllMembershipsProvider);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
        error: (e, _) => SecondaryText(text: "NO_MEMBERSHIP_FOUND".tr(context)),
        loading: () => const Center(child: CupertinoActivityIndicator()));
  }

  Row _colInfo(
    String text1,
    String text2, {
    bool isEnd = false,
  }) {
    return Row(
      crossAxisAlignment:
          isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          style: AppTextStyles.manropeLight(fontSize: 13.sp),
        ),
        Spacer(),
        Text(
          text2,
          style: AppTextStyles.manropeLight(fontSize: 13.sp),
        ),
      ],
    );
  }

  Container _serviceTimeSlotsBackgroundContainer({Widget? child}) {
    return Container(
      padding: EdgeInsets.all(15.h),
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: AppColors.black5,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: child,
    );
  }

  Container _membershipSlotsBackgroundContainer({Widget? child}) {
    return Container(
      padding: EdgeInsets.all(15.h),
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: AppColors.black2.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }
}
class ClassesCard extends ConsumerWidget {
  const ClassesCard({required this.event});

  final EventsModel event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.tileBgColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  (event.service?.event?.eventName ?? "").capitalizeFirst,
                  style:
                  AppTextStyles.manropeBold(fontSize: 16.sp),
                ),
              ),
              Text(
                "${event.timeDifferent} MIN",
                textAlign: TextAlign.center,
                style: AppTextStyles.sofiaSansMedium(fontSize: 14.sp),
              ),
            ],
          ),
          CDivider(),
          ClassCardCoach(
            coaches: event.getCoaches,
          ),
          Row(
            children: [
              Expanded(
                child: _colInfo(
                  event.service?.location?.locationName ?? "",
                  "${"PRICE".tr(context)} ${Utils.formatPrice(event.service?.price)}",
                ),
              ),
              Expanded(
                child: _colInfo(
                  event.bookingDate.format("EEE dd MMM"),
                  "${event.bookingStartTime.format("HH:mm")} - ${event.bookingEndTime.format("HH:mm a").toLowerCase()}",
                  isEnd: true,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Column _colInfo(String text1, String text2, {bool isEnd = false}) {
    return Column(
      crossAxisAlignment:
      isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          style: AppTextStyles.manropeMedium(fontSize: 13.sp),
        ),
        SizedBox(height: 2.h),
        Text(
          text2,
          style: AppTextStyles.manropeMedium(fontSize: 13.sp),
        ),
      ],
    );
  }
}


class ToggleTabs extends StatefulWidget {
  final List<String> tabs;
  final ValueChanged<String> onTabSelected;
  final String selectedTab;

  const ToggleTabs({
    required this.tabs,
    required this.onTabSelected,
    required this.selectedTab,
    super.key,
  });

  @override
  State<ToggleTabs> createState() => _ToggleTabsState();
}

class _ToggleTabsState extends State<ToggleTabs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: inset.BoxDecoration(
        color: AppColors.black5,
        borderRadius: BorderRadius.circular(5.r),
        boxShadow: kInsetShadow,
      ),
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        children: widget.tabs.map((tab) {
          bool isSelected = widget.selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onTabSelected(tab),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 5.h,
                ),
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.black2 : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    tab.toUpperCase(),
                    style: isSelected
                        ? AppTextStyles.manropeSemiBold(
                            color: AppColors.white,
                            fontSize: 13.sp,
                          )
                        : AppTextStyles.manropeLight(
                            fontSize: 13.sp,
                            color: AppColors.black70,
                          ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
class _MembershipComponent extends ConsumerWidget {
  const _MembershipComponent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(fetchActiveAndAllMembershipsProvider);

    return membership.when(
        data: (data) {
          if (data.membershipModel.isEmpty) {
            return SizedBox(height: 15.h,);
          }

          if (data.showMembershipCategories.isNotEmpty) {
            final padelCategory = data.showMembershipCategories.firstWhere(
                    (element) =>
                (element.categoryName ?? "")
                    .toString()
                    .trim()
                    .toLowerCase() ==
                    "padel",
                orElse: () => data.showMembershipCategories.first);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(selectedMembershipCatIndex.notifier).state =
                  padelCategory.id;
            });
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 15.h,left: 15.w),
                child: Text(
                  'MEMBERSHIP'.trU(context),
                  style: AppTextStyles.sofiaSansMedium(
                    fontSize: 17.sp,),
                ),
              ),
              MembershipListComponent(
                  data: data, scrollDirection: Axis.horizontal),
            ],
          );
        },
        error: (e, _) => SizedBox(),
        loading: () => Padding(
          padding: EdgeInsets.only(bottom: 15.h),
          child: const Center(child: CupertinoActivityIndicator()),
        ));
  }
}
