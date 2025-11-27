import 'dart:developer';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hop/globals/api_endpoints.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/managers/api_manager.dart';
import 'package:hop/managers/user_manager.dart';
import 'package:hop/models/court_booking.dart';
import 'package:hop/models/user_bookings.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/active_memberships.dart';
import '../models/base_classes/booking_player_base.dart';
import '../models/court_price_model.dart';
import '../models/lesson_model_new.dart';
import '../models/membership_list_category_model.dart';
import '../models/membership_model.dart';
import '../models/multi_booking_model.dart';
import '../models/user_membership.dart';

part 'booking_repo.g.dart';

enum CourtPriceRequestType {
  join,
  booking,
  lesson;

  String get value {
    switch (this) {
      case join:
        return "join_service";
      case booking:
        return "booking_service";
      case lesson:
        return "lesson_service";
    }
  }
}

enum BookingRequestType {
  addToCart,
  processingBooking;

  String get value {
    switch (this) {
      case addToCart:
        return "ADD_TO_CART";
      case processingBooking:
        return "PROCESS_BOOKING";
    }
  }
}

class BookingRepo {
  Future<double?> bookCourt(Ref ref,
      {required Bookings booking,
      required int courtID,
      required DateTime dateTime,
      required bool isOpenMatch,
      required bool payMyShare,
      required int reservedPlayers,
      required BookingRequestType requestType,
      String? organizerNote,
      double? openMatchMinLevel,
      double? openMatchMaxLevel,
      bool? isFriendlyMatch,
      required bool isPrivateMatch,
      bool? approvalNeeded,
      List<BookingPlayerBase>? customerPlayers}) async {
    try {
      final startTime = dateTime.format("HH:mm:ss");
      final endTime =
          dateTime.add(Duration(minutes: booking.duration!)).format("HH:mm:ss");
      final date = dateTime.format(kFormatForAPI);
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";
      final data = {
        "court_id": courtID,
        "booking_id": booking.id,
        "location_id": booking.location!.id,
        "start_time": startTime,
        "end_time": endTime,
        "date": date,
        "is_open_match": isOpenMatch,
        "reserved_players_count": reservedPlayers,
      };

      // Add customer players if provided
      if (customerPlayers != null && customerPlayers.isNotEmpty) {
        data['customer_players'] = customerPlayers.map((player) {
          return {
            "customer_id": player.customer?.id,
            "position": player.position,
          };
        }).toList();
      }

      if (isOpenMatch) {
        data['is_private_match'] = isPrivateMatch;
        data['organizer_notes'] = organizerNote;
        data['friendly_match'] = isFriendlyMatch;
        data['approve_before_join'] = approvalNeeded ?? false;
        if (openMatchMinLevel != null) {
          data['open_match_options'] = {
            "min_level": openMatchMinLevel,
            "max_level": openMatchMaxLevel,
          };
        }
      }
      final Map<String, dynamic> queryParams = {};
      queryParams['request_type'] = requestType.value;
      queryParams['pay_my_share'] = payMyShare;

      final response = await ref.read(apiManagerProvider).post(
            isV2Version: true,
            queryParams: queryParams,
            ref,
            ApiEndPoint.courtBookingPost,
            data,
            token: token,
          );
      if (requestType == BookingRequestType.addToCart) {
        return response['data']['savedBookingCart']['total_price'].toDouble();
      }
      return response['data']['price'].toDouble();
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }

      rethrow;
    }
  }

  Future<List<ActiveMemberships>> fetchActiveMemberships(Ref ref) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";

      if (token.trim().isEmpty) {
        return [];
      }

      final response = await ref.read(apiManagerProvider).get(
            ref,
            ApiEndPoint.usersActiveMembership,
            token: token,
          );
      final List<ActiveMemberships> memberships = [];

      for (final membership in response['data']["activeMemberships"]) {
        memberships.add(ActiveMemberships.fromJson(membership));
      }
      return memberships;
    } catch (e) {
      return [];
    }
  }

  Future<UserActiveMembership> fetchActiveAndAllMemberships(Ref ref) async {
    final future = await Future.wait([
      ref.refresh(activeMembershipProvider.future),
      ref.refresh(fetchAllMembershipsProvider.future),
      ref.refresh(fetchMembershipCategoryProvider.future),
    ]);
    final activeMembershipValue = future[0] as List<ActiveMemberships>;
    final allMembershipValue = future[1] as List<MembershipModel>;
    final allMembershipCatValue = future[2] as List<MembershipCategory>;

    return UserActiveMembership(
        activeMembership: activeMembershipValue,
        membershipCategories: allMembershipCatValue,
        membershipModel: allMembershipValue);
  }

  Future<List<MembershipModel>> fetchAllMemberships(Ref ref) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";

      if (token.trim().isEmpty) {
        return [];
      }

      final response = await ref.read(apiManagerProvider).get(
          ref, ApiEndPoint.getAllMembership,
          token: token, queryParams: {"show_all": true});
      final List<MembershipModel> memberships = [];

      for (final membership in response['data']["memberships"]) {
        memberships.add(MembershipModel.fromJson(membership));
      }
      return memberships;
    } catch (e) {
      return [];
    }
  }

  Future<List<UserBookings>> fetchUserBooking(Ref ref) async {
    log('in fetchUserBooking');
    try {
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";
      final response = await ref.read(apiManagerProvider).get(
            ref,
            ApiEndPoint.userBookings,
            token: token,
          );
      final List<UserBookings> bookings = [];
      for (final booking in response['data']["bookings"]) {
        bookings.add(UserBookings.fromJson(booking));
      }
      return bookings;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<UserBookings>> fetchUserBookingWaitingList(Ref ref) async {
    log('in fetchUserBookingWaitingList');
    try {
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";
      final response = await ref.read(apiManagerProvider).get(
            ref,
            ApiEndPoint.userBookingsWaitingList,
            token: token,
          );
      final List<UserBookings> bookings = [];
      for (final booking in response['data']["bookings"]) {
        bookings.add(UserBookings.fromJson(booking));
      }
      return bookings;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> addToCalendar(
      String title, DateTime startDate, DateTime endDate) async {
    try {
      final Event event = Event(
        title: title,
        startDate: startDate,
        endDate: endDate,
      );
      await Add2Calendar.addEvent2Cal(event);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchCourtPrice(Ref ref,
      {required int serviceId,
      required CourtPriceRequestType requestType,
      required DateTime dateTime,
      required List courtId,
      required LessonVariants? lessonVariant,
      required bool isOpenMatch,
      required bool pendingPayment,
      required int reserveCounter,
      required int? coachId,
      required int durationInMin}) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";
      if (isOpenMatch) {
        final data = {"reserve_counter": reserveCounter};

        final response = await ref.read(apiManagerProvider).patch(
          ref,
          ApiEndPoint.openMatchCalculatePriceApi,
          data,
          token: token,
          pathParams: [serviceId.toString()],
        );
        return response["message"];
      }

      final startTime = dateTime.format("HH:mm:ss");
      final endTime =
          dateTime.add(Duration(minutes: durationInMin)).format("HH:mm:ss");
      final date = dateTime.format(kFormatForAPI);
      final data = {
        "request_type": requestType.value,
        "service_id": serviceId,
        "booking_details": {
          "date": date,
          "start_time": startTime,
          "end_time": endTime,
          "courts": courtId
        }
      };
      if (lessonVariant != null) {
        data['variant_id'] = lessonVariant.id ?? 0;
      }
      if (coachId != null) {
        data["coach_id"] = coachId;
      }
      final response = await ref.read(apiManagerProvider).post(
            ref,
            ApiEndPoint.courtPricePost,
            data,
            token: token,
          );
      return CourtPriceModel.fromJson(response['data']);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<(int?, double?)> upgradeBookingToOpen(Ref ref,
      {required Bookings booking,
      required int reservedPlayers,
      String? organizerNote,
      double? openMatchMinLevel,
      bool? isFriendlyMatch,
      required bool isPrivateMatch,
      double? openMatchMaxLevel,
      bool? approvalNeeded}) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";
      final Map<String, dynamic> data = {
        "reserved_players_count": reservedPlayers
      };
      data['organizer_notes'] = organizerNote;
      data['friendly_match'] = isFriendlyMatch;
      data['is_private_match'] = isPrivateMatch;
      data['approve_before_join'] = approvalNeeded ?? false;
      if (openMatchMinLevel != null) {
        data['open_match_options'] = {
          "min_level": openMatchMinLevel,
          "max_level": openMatchMaxLevel,
        };
      }

      final response = await ref.read(apiManagerProvider).patch(
            ref,
            pathParams: [(booking.id ?? 0).toString()],
            ApiEndPoint.upgradeBookingToOpen,
            data,
            token: token,
          );

      if (response["message"].toString().contains("process for payments")) {
        return (null, double.tryParse(response['data'].toString()) ?? 0);
      } else {
        return (
          int.tryParse(response['data']["service_id"].toString()) ?? 0,
          null
        );
      }
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<MultipleBookings>> fetchBookingCartList(Ref ref) async {
    log('in fetchBookingCartList');
    try {
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";
      final response = await ref.read(apiManagerProvider).get(
            ref,
            ApiEndPoint.userBookingCartList,
            token: token,
          );
      final List<MultipleBookings> bookings = [];
      for (final booking in response) {
        bookings.add(MultipleBookings.fromJson(booking));
      }
      return bookings;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> deleteCartBooking(Ref ref, String bookingId) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";
      await apiManager.delete(
        ref,
        ApiEndPoint.deleteCartBooking,
        token: token,
        pathParams: [bookingId],
      );
      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<double?> fetchChatCount(Ref ref, {required int matchId}) async {
    log('in fetchChatCount');
    try {
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";

      final response = await ref.read(apiManagerProvider).get(
            ref,
            ApiEndPoint.fetchChatCount,
            pathParams: [
              matchId.toString(),
            ],
            token: token,
          );
      return double.tryParse(response['data'].toString());
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<MembershipCategory>> fetchMembershipCategory(Ref ref) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";

      if (token.trim().isEmpty) {
        return [];
      }

      final response = await ref.read(apiManagerProvider).get(
            ref,
            ApiEndPoint.getAllMembershipCategory,
            token: token,
          );
      final List<MembershipCategory> membershipsCat = [];

      for (final membership in response['data']) {
        membershipsCat.add(MembershipCategory.fromJson(membership));
      }
      return membershipsCat;
    } catch (e) {
      return [];
    }
  }

  Future<void> bookLessonCourt(
    Ref ref, {
    required int lessonTime,
    required int courtId,
    required int lessonId,
    required int coachId,
    required int locationId,
    required LessonVariants? lessonVariant,
    required DateTime dateTime,
  }) async {
    try {
      final startTime = dateTime.format("HH:mm:ss");
      final endTime =
          dateTime.add(Duration(minutes: lessonTime)).format("HH:mm:ss");
      final date = dateTime.format(kFormatForAPI);
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";
      final data = {
        "court_id": courtId,
        "lesson_id": lessonId,
        "coach_id": coachId,
        "location_id": locationId,
        "start_time": startTime,
        "end_time": endTime,
        "date": date
      };
      if (lessonVariant != null) {
        data['variant_id'] = lessonVariant.id ?? 0;
      }

      final response = await ref.read(apiManagerProvider).post(
          ref, ApiEndPoint.bookingLessons, data,
          isV2Version: true,
          token: token,
          queryParams: {"request_type": "PROCESS_BOOKING"});
      return response['data']['price'].toDouble();
    } catch (e, _) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }

      rethrow;
    }
  }
}

@riverpod
BookingRepo bookingRepo(Ref ref) => BookingRepo();

@riverpod
Future<double?> bookCourt(BookCourtRef ref,
    {required Bookings booking,
    required int courtID,
    required DateTime dateTime,
    required bool isOpenMatch,
    required bool payMyShare,
    required int reservedPlayers,
    required BookingRequestType requestType,
    String? organizerNote,
    bool? isPrivateMatch,
    bool? isFriendlyMatch,
    required double? openMatchMinLevel,
    required double? openMatchMaxLevel,
    bool? approvalNeeded,
    List<BookingPlayerBase>? customerPlayers}) async {
  return ref.read(bookingRepoProvider).bookCourt(ref,
      requestType: requestType,
      booking: booking,
      courtID: courtID,
      payMyShare: payMyShare,
      dateTime: dateTime,
      isOpenMatch: isOpenMatch,
      reservedPlayers: reservedPlayers,
      openMatchMinLevel: openMatchMinLevel,
      openMatchMaxLevel: openMatchMaxLevel,
      organizerNote: organizerNote,
      isFriendlyMatch: isFriendlyMatch,
      isPrivateMatch: isPrivateMatch ?? false,
      approvalNeeded: approvalNeeded,
      customerPlayers: customerPlayers);
}

@riverpod
Future<List<UserBookings>> fetchUserBooking(FetchUserBookingRef ref) {
  return ref.read(bookingRepoProvider).fetchUserBooking(ref);
}

@riverpod
Future<List<UserBookings>> fetchUserBookingWaitingList(
    FetchUserBookingWaitingListRef ref) {
  return ref.read(bookingRepoProvider).fetchUserBookingWaitingList(ref);
}

@riverpod
Future<List<UserBookings>> fetchUserAllBookings(
    FetchUserAllBookingsRef ref) async {
  final results = await Future.wait([
    ref.refresh(fetchUserBookingProvider.future),
    // ref.refresh(fetchUserBookingWaitingListProvider.future),
  ]);

  final List<UserBookings> bookings = [];
  bookings.addAll(results[0]);
  // bookings.addAll(results[1]);
  //SORT BOOKINGS BY DATE, in descending order
  bookings.sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
  return bookings;
}

@riverpod
Future<bool> addToCalendar(AddToCalendarRef ref,
    {required String title,
    required DateTime startDate,
    required DateTime endDate}) {
  return ref.read(bookingRepoProvider).addToCalendar(title, startDate, endDate);
}

@riverpod
Future<dynamic> fetchCourtPrice(
  FetchCourtPriceRef ref, {
  required int serviceId,
  required CourtPriceRequestType requestType,
  required DateTime dateTime,
  required List courtId,
  bool isOpenMatch = false,
  bool pendingPayment = false,
  int reserveCounter = 0,
  LessonVariants? lessonVariant,
  required int durationInMin,
  required int? coachId,
}) async {
  return ref.read(bookingRepoProvider).fetchCourtPrice(ref,
      requestType: requestType,
      serviceId: serviceId,
      isOpenMatch: isOpenMatch,
      pendingPayment: pendingPayment,
      reserveCounter: reserveCounter,
      courtId: courtId,
      lessonVariant: lessonVariant,
      coachId: coachId,
      dateTime: dateTime,
      durationInMin: durationInMin);
}

@riverpod
Future<List<MultipleBookings>> fetchBookingCartList(
    FetchBookingCartListRef ref) {
  return ref.read(bookingRepoProvider).fetchBookingCartList(ref);
}

@riverpod
Future<bool> deleteCart(DeleteCartRef ref, String bookingId) async {
  return ref.read(bookingRepoProvider).deleteCartBooking(ref, bookingId);
}

@riverpod
Future<(int?, double?)> upgradeBookingToOpen(UpgradeBookingToOpenRef ref,
    {required Bookings booking,
    required int reservedPlayers,
    String? organizerNote,
    bool? isFriendlyMatch,
    bool? isPrivateMatch,
    required double? openMatchMinLevel,
    required double? openMatchMaxLevel,
    bool? approvalNeeded}) async {
  return ref.read(bookingRepoProvider).upgradeBookingToOpen(ref,
      booking: booking,
      reservedPlayers: reservedPlayers,
      openMatchMinLevel: openMatchMinLevel,
      openMatchMaxLevel: openMatchMaxLevel,
      organizerNote: organizerNote,
      isPrivateMatch: isPrivateMatch ?? false,
      isFriendlyMatch: isFriendlyMatch,
      approvalNeeded: approvalNeeded);
}

@riverpod
Future<double?> fetchChatCount(FetchChatCountRef ref,
    {required int matchId}) async {
  return ref.read(bookingRepoProvider).fetchChatCount(ref, matchId: matchId);
}

@riverpod
Future<void> bookLessonCourt(
  BookLessonCourtRef ref, {
  required int lessonTime,
  required int courtId,
  required int lessonId,
  required int coachId,
  required int locationId,
  required DateTime dateTime,
  required LessonVariants? lessonVariant,
}) async {
  return ref.read(bookingRepoProvider).bookLessonCourt(
        ref,
        lessonTime: lessonTime,
        dateTime: dateTime,
        coachId: coachId,
        courtId: courtId,
        lessonVariant: lessonVariant,
        lessonId: lessonId,
        locationId: locationId,
      );
}

@riverpod
Future<List<ActiveMemberships>> activeMembership(ActiveMembershipRef ref) {
  return ref.read(bookingRepoProvider).fetchActiveMemberships(ref);
}

@riverpod
Future<UserActiveMembership> fetchActiveAndAllMemberships(
    FetchActiveAndAllMembershipsRef ref) {
  return ref.read(bookingRepoProvider).fetchActiveAndAllMemberships(ref);
}

@riverpod
Future<List<MembershipModel>> fetchAllMemberships(FetchAllMembershipsRef ref) {
  return ref.read(bookingRepoProvider).fetchAllMemberships(ref);
}

@riverpod
Future<List<MembershipCategory>> fetchMembershipCategory(
    FetchMembershipCategoryRef ref) {
  return ref.read(bookingRepoProvider).fetchMembershipCategory(ref);
}
