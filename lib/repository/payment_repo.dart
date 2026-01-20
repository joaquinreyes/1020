import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hop/globals/api_endpoints.dart';
import 'package:hop/managers/api_manager.dart';
import 'package:hop/managers/user_manager.dart';
import 'package:hop/models/coupon_model.dart';
import 'package:hop/models/payment_methods.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../globals/constants.dart';
import '../models/multi_booking_model.dart';

part 'payment_repo.g.dart';

enum PaymentProcessRequestType {
  join,
  reserved,
  courtBooking,
  membership;

  String get value {
    switch (this) {
      case join:
        return "Join";
      case reserved:
        return "Reserved";
      case courtBooking:
        return "Court Booking";
      case membership:
        return "Membership";
    }
  }
}

enum PaymentDetailsRequestType {
  booking,
  lesson,
  membership,
  join;

  String get value {
    switch (this) {
      case join:
        return "Join";
      case lesson:
        return "Lesson";
      case booking:
        return "Booking";
      case membership:
        return "Membership";
    }
  }
}

class PaymentRepo {
  Future<PaymentDetails> fetchPaymentDetails(
      int locationID,
      Ref ref,
      PaymentDetailsRequestType type,
      int id,
      DateTime? startDate,
      bool isOpenMatch,
      int? duration,
      {int? courtId, int? variantId}) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";
      final Map<String, dynamic> queryParams = {
        "booking_type": type.value,
        "booking_id": id,
        "is_open_match": isOpenMatch
      };

      if (courtId != null) {
        queryParams["court_id"] = courtId;
      }

      if (variantId != null) {
        queryParams["variant_id"] = variantId;
      }

      if (startDate != null && duration != null) {
        final startTime = startDate.format("HH:mm:ss");
        final endTime =
            startDate.add(Duration(minutes: duration)).format("HH:mm:ss");
        final date = startDate.format(kFormatForAPI);

        queryParams["start_time"] = startTime;
        queryParams["end_time"] = endTime == "00:00:00" ? "24:00:00" : endTime;
        queryParams["date"] = date;
      }

      final response = await ref.read(apiManagerProvider).get(
            ref,
            isV2Version: true,
            ApiEndPoint.paymentDetails,
            token: token,
            queryParams: queryParams,
            pathParams: [locationID.toString()],
          );
      return PaymentDetails.fromJson(response['data']);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<(int?, dynamic)> paymentProcess(
    Ref ref, {
    required PaymentProcessRequestType requestType,
    bool? payLater,
    List<AppPaymentMethods>? paymentMethod,
    double? totalAmount,
    required bool pendingPayment,
    int? serviceID,
    int? locationID,
    bool isJoiningApproval = false,
    bool bookingToOpenMatch = false,
    bool purchaseMembership = false,
    int? couponID,
  }) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken;
      final Map<String, dynamic> data = {
        'total_amount': totalAmount,
        if (payLater == true) 'pay_on_arrival': true,
        if (couponID != null) 'coupon_id': couponID,
      };

      // Validate payment methods
      if (payLater == true && paymentMethod != null) {
        throw 'Cannot use pay later with other payment methods';
      }
      if (payLater != true && paymentMethod?.isNotEmpty == true) {
        data['payments'] =
            paymentMethod!.map((method) => method.toJsonForProcess()).toList();
        if ((bookingToOpenMatch || purchaseMembership) &&
            data['payments'].isNotEmpty) {
          data['payments'] = data['payments'].first;
        }
      }

      // Prepare query parameters
      final Map<String, dynamic> queryParams = {
        if (requestType != PaymentProcessRequestType.courtBooking) ...{
          'request_type': requestType.value,
          'service_booking_id': serviceID,
          'pending_payment': pendingPayment,
          if (isJoiningApproval) 'joninning_approval': isJoiningApproval,
        }
      };

      // Perform the API request
      myPrint("Payment Process Data: $data");
      myPrint("Payment Process Query Params: $queryParams");
      final response = purchaseMembership
          ? await ref.read(apiManagerProvider).post(
              ref, ApiEndPoint.membershipPurchase, data,
              token: token,
              pathParams: [serviceID.toString(), locationID.toString()])
          : await ref.read(apiManagerProvider).post(
                ref,
                ApiEndPoint.paymentsProcess,
                data,
                token: token,
                queryParams: queryParams,
                pathParams: [bookingToOpenMatch.toString()],
                isV2Version: bookingToOpenMatch ? false : true,
              );

      // For pay later, wallet, or membership payments - return service booking ID directly
      if (payLater == true ||
          paymentMethod?.last.methodType == kWalletMethod ||
          paymentMethod?.last.methodType == kMembershipMethod) {
        if (bookingToOpenMatch) {
          return (0, null);
        }
        final id =
            response['data']['service']['serviceBookings'][0]['id'] as int;
        return (id, null);
      } else {
        // For gateway payments - return the gateway URL data
        final data = response['data']['gatewayUrl'];
        return (null, data);
      }
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<int> fetchServiceIDWithTransactionID(
    Ref ref, {
    required String orderID,
    required String statusCode,
    required String transactionStatus,
  }) async {
    final token = ref.read(userManagerProvider).user?.accessToken;
    if (token == null) {
      throw Exception('No access token available');
    }

    // Compute deadline 15 seconds from now.
    final deadline = DateTime.now().add(const Duration(seconds: 17));
    // Initial wait
    await Future.delayed(const Duration(seconds: 4));

    // Polling loop
    while (DateTime.now().isBefore(deadline)) {
      try {
        final response = await ref.read(apiManagerProvider).get(
          ref,
          ApiEndPoint.transaction,
          token: token,
          queryParams: {
            'order_id': orderID,
            'status_code': statusCode,
            'transaction_status': transactionStatus,
          },
        );

        // If we got a valid service ID, return it
        final serviceId = response['data']?['service']?['id'];
        if (serviceId is int) {
          return serviceId;
        }

        // Otherwise, wait before retrying
      } catch (e) {
        // If the API itself returns an error payload, propagate it
        if (e is Map<String, dynamic> && e.containsKey('message')) {
          if (e['message'] != "Transaction not found") {
            throw e['message'];
          }
        }
        // rethrow;
      }

      // Wait 2 seconds between polls
      await Future.delayed(const Duration(seconds: 3));
    }

    // If we reach here, we've timed out
    throw "Transaction not found";
  }

  Future<CouponModel> verifyCoupon(Ref ref, String coupon, double price) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";
      final response = await ref.read(apiManagerProvider).post(
            ref,
            ApiEndPoint.couponsVerify,
            {'coupon_name': coupon, 'price': price},
            token: token,
          );
      return CouponModel.fromJson(response['data']);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<(List<MultipleBookings>?, String?)> multiBookingPaymentProcess(
      Ref ref,
      {required PaymentProcessRequestType requestType,
      bool? payLater,
      AppPaymentMethods? paymentMethod,
      double? totalAmount,
      int? serviceID,
      bool isJoiningApproval = false,
      int? couponID}) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken ?? "";
      final Map<String, dynamic> data = {};

      data['total_amount'] = totalAmount;
      if (payLater == true && paymentMethod != null) {
        throw 'Can not use pay later with other payment methods';
      }

      if (payLater == true) {
        data['pay_on_arrival'] = true;
      } else if (paymentMethod != null) {
        data["payments"] = paymentMethod.toJsonForProcess();
      }
      if (couponID != null) {
        data['coupon_id'] = couponID;
      }
      final Map<String, dynamic> queryParams = {};
      if (requestType != PaymentProcessRequestType.courtBooking) {
        queryParams['request_type'] = requestType.value;
        queryParams['service_booking_id'] = serviceID;
        if (isJoiningApproval) {
          queryParams['joninning_approval'] = isJoiningApproval;
        }
      }

      final response = await ref.read(apiManagerProvider).post(
            ref,
            ApiEndPoint.multiBookingPaymentsProcess,
            data,
            token: token,
            queryParams: queryParams,
          );

      if (payLater == true || paymentMethod?.methodType == kWalletMethod) {
        List<MultipleBookings> list = [];
        if (response['data'] != null && response['data'] is List) {
          response['data']
              .map((e) => list.add(MultipleBookings.fromJson(e)))
              .toList();
        }
        return (list, null);
      } else {
        final redirectURL = response['data'] as String;
        return (null, redirectURL);
      }
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }
}

@riverpod
PaymentRepo paymentRepo(Ref ref) => PaymentRepo();

@riverpod
Future<PaymentDetails> fetchPaymentDetails(
    FetchPaymentDetailsRef ref,
    int locationID,
    PaymentDetailsRequestType type,
    int id,
    bool isOpenMatch,
    DateTime? startDate,
    int? duration,
    {int? courtId,
    int? variantId}) {
  return ref.read(paymentRepoProvider).fetchPaymentDetails(
      locationID, ref, type, id, startDate, isOpenMatch, duration,
      courtId: courtId, variantId: variantId);
}

@riverpod
Future<PaymentDetails> fetchAllPaymentMethods(
    FetchAllPaymentMethodsRef ref,
    int locationID,
    int serviceID,
    PaymentDetailsRequestType type,
    DateTime? startDate,
    int? duration,
    {int? courtId,
    int? variantId,
    required bool isOpenMatch}) async {
  final paymentMethods = await ref
      .refresh(fetchPaymentDetailsProvider(
              locationID, type, serviceID, isOpenMatch, startDate, duration,
              courtId: courtId, variantId: variantId)
          .future);

  return PaymentDetails(
      appPaymentMethods: paymentMethods.appPaymentMethods,
      userMemberships: paymentMethods.userMemberships);
}

@riverpod
Future<(int?, dynamic)> paymentProcess(
  PaymentProcessRef ref, {
  required PaymentProcessRequestType requestType,
  bool? payLater,
  double? totalAmount,
  List<AppPaymentMethods>? paymentMethod,
  required bool pendingPayment,
  int? serviceID,
  int? locationID,
  bool isJoiningApproval = false,
  bool bookingToOpenMatch = false,
  bool purchaseMembership = false,
  int? couponID,
}) {
  return ref.read(paymentRepoProvider).paymentProcess(ref,
      requestType: requestType,
      payLater: payLater,
      totalAmount: totalAmount,
      serviceID: serviceID,
      paymentMethod: paymentMethod,
      pendingPayment: pendingPayment,
      isJoiningApproval: isJoiningApproval,
      bookingToOpenMatch: bookingToOpenMatch,
      locationID: locationID,
      purchaseMembership: purchaseMembership,
      couponID: couponID);
}

@riverpod
Future<CouponModel> verifyCoupon(
  VerifyCouponRef ref, {
  required String coupon,
  required double price,
}) {
  return ref.read(paymentRepoProvider).verifyCoupon(ref, coupon, price);
}

@riverpod
Future<(List<MultipleBookings>?, String?)> multiBookingPaymentProcess(
  MultiBookingPaymentProcessRef ref, {
  required PaymentProcessRequestType requestType,
  bool? payLater,
  double? totalAmount,
  AppPaymentMethods? paymentMethod,
  int? serviceID,
  bool isJoiningApproval = false,
  int? couponID,
}) {
  return ref.read(paymentRepoProvider).multiBookingPaymentProcess(ref,
      requestType: requestType,
      payLater: payLater,
      totalAmount: totalAmount,
      serviceID: serviceID,
      paymentMethod: paymentMethod,
      isJoiningApproval: isJoiningApproval,
      couponID: couponID);
}

@riverpod
Future<int> fetchServiceIDWithTransactionID(
    FetchServiceIDWithTransactionIDRef ref,
    {required String orderID,
    required String statusCode,
    required String transactionStatus}) {
  return ref.read(paymentRepoProvider).fetchServiceIDWithTransactionID(ref,
      orderID: orderID,
      statusCode: statusCode,
      transactionStatus: transactionStatus);
}
