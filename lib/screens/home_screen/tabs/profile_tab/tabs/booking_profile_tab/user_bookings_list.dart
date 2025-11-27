import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/secondary_text.dart';
import 'package:hop/components/user_booking_card.dart';
import 'package:hop/components/user_lessons_events_card.dart';
import 'package:hop/components/user_open_match_card.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/managers/user_manager.dart';
import 'package:hop/models/user_bookings.dart';
import 'package:hop/repository/booking_repo.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:hop/routes/app_routes.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../../../../../../globals/constants.dart';

class UserBookingsList extends ConsumerStatefulWidget {
  const UserBookingsList({super.key, this.isPast = false});

  final bool isPast;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpComingBookingsState();
}

class _UpComingBookingsState extends ConsumerState<UserBookingsList> {
  @override
  Widget build(BuildContext context) {
    final bookings = ref.watch(fetchUserAllBookingsProvider);
    return bookings.when(
      data: (data) => buildBookingList(context, data),
      loading: () => const CupertinoActivityIndicator(radius: 10),
      error: (error, stackTrace) {
        myPrint("stackTrace: $stackTrace");
        return SecondaryText(text: error.toString());
      },
    );
  }

  Widget buildBookingList(BuildContext context, List<UserBookings> data) {
    List<UserBookings> bookings = [];
    if (widget.isPast) {
      bookings = data.where((e) => e.isPast).toList();
    } else {
      bookings = data.where((e) => !e.isPast).toList();
    }

    final currentCustomerID = ref.read(userProvider)?.user?.id ?? "";
    bookings.removeWhere(
      (e) {
        int? index = e.players?.indexWhere(
            (element) => element.customer?.id == currentCustomerID);
        if (index == null || index == -1) {
          return false;
        } else {
          return false;
        }
      },
    );

    if (bookings.isEmpty) {
      return SecondaryText(
        text: widget.isPast
            ? "NO_PAST_BOOKINGS".tr(context)
            : "NO_UPCOMING_BOOKINGS".tr(context),
      );
    }

    final dateList = bookings.dateList;
    if (widget.isPast) {
      dateList.sort((a, b) => b.compareTo(a));
    } else {
      dateList.sort((a, b) => a.compareTo(b));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: buildBookingWidgets(dateList, bookings),
    );
  }

  List<Widget> buildBookingWidgets(
      List<DateTime> dateList, List<UserBookings> bookings) {
    final widgets = <Widget>[];

    for (var date in dateList) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 10.h,),
          child: Text(
            Utils.formatBookingDate(date, context).toUpperCase(),
            style: AppTextStyles.sofiaSansMedium(
              fontSize: 23.sp,
            ),
          ),
        ),
      );

      final dateBookings =
          bookings.where((e) => e.bookingDate == date).toList();

      widgets.addAll(
        dateBookings.map((booking) {
          final isOpenMatch = booking.service?.isOpenMatch ?? false;
          final isEvent = booking.service?.isEvent ?? false;
          final isLessonEvent = booking.service?.isLesson ?? false;
          return Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: Builder(builder: (context) {
                if (isEvent || isLessonEvent) {
                  return InkWell(
                    onTap: () {
                      _onTap(isOpenMatch, isEvent, isLessonEvent, booking);
                    },
                    child: UserLessonsEventsCard(
                      booking: booking, isPast:widget.isPast
                    ),
                  );
                }
                if (isOpenMatch) {
                  return InkWell(
                    onTap: () {
                      _onTap(isOpenMatch, isEvent, isLessonEvent, booking);
                    },
                    child: UserOpenMatchCard(booking: booking),
                  );
                }
                return InkWell(
                  onTap: () {
                    _onTap(isOpenMatch, isEvent, isLessonEvent, booking);
                  },
                  child: UserBookingCard(
                    booking: booking,
                  ),
                );
              }),
            ),
          );
        }),
      );
      // widgets.add(16.verticalSpace);
    }
    return widgets;
  }

  _onTap(bool isOpenMatch, bool isEvent, bool isLessonEvent,
      UserBookings booking) {
    Future nav;
    if (isEvent || isLessonEvent) {
      if (isLessonEvent) {
        nav = ref
            .read(goRouterProvider)
            .push("${RouteNames.lesson_info}/${booking.id}");
      } else {
        nav = ref
            .read(goRouterProvider)
            .push("${RouteNames.event_info}/${booking.id}");
      }
    } else if (isOpenMatch) {
      nav = ref
          .read(goRouterProvider)
          .push("${RouteNames.match_info}/${booking.id}");
    } else {
      nav = ref
          .read(goRouterProvider)
          .push("${RouteNames.bookingInfo}/${booking.id}");
    }
    nav.then((value) {
      ref.invalidate(fetchUserAllBookingsProvider);
    });
  }
}
