import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hop/globals/api_endpoints.dart';
import 'package:hop/managers/api_manager.dart';
import 'package:hop/managers/user_manager.dart';
import 'package:hop/models/coupon_model.dart';
import 'package:hop/models/payment_methods.dart';
import 'package:hop/models/stripe_payment_method.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hop/repository/stripe_repo.dart';

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
      {int? courtId,int? variantId}) async {
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

  Future<(int, double?)> paymentProcess(
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
      final bool isStripePayment =
          paymentMethod?.any((method) => method.methodType == kStripeMethod) ??
              false;
      final bool isNativePayment = paymentMethod?.any((method) =>
              method.methodType == kApplePayMethod ||
              method.methodType == kGooglePayMethod) ??
          false;

      // Check for Native Payment availability
      if (isNativePayment) {
        final isNativeAvailable =
            await ref.read(isNativeAvailableProvider.future);
        if (!isNativeAvailable) {
          throw Platform.isIOS
              ? "PLEASE_SETUP_APPLE_PAY"
              : "PLEASE_SETUP_GOOGLE_PAY";
        }
      }

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
          'pending_payment' : pendingPayment,
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

      if (isStripePayment) {
        return await _handleStripePayment(
            ref, response, false, paymentMethod, purchaseMembership) as (
          int,
          double?
        );
      } else if (isNativePayment) {
        final amount = paymentMethod!
            .firstWhere(
              (element) =>
                  element.methodType == kApplePayMethod ||
                  element.methodType == kGooglePayMethod,
            )
            .amountToPay;
        return await _handleNativePayment(
            ref,
            response,
            amount ?? totalAmount ?? 0.0,
            false,
            purchaseMembership) as (int, double?);
      } else {
        if (bookingToOpenMatch) {
          return (0, null);
        }
        ;
        return _extractServiceBookingID(response);
      }
    } catch (e) {
      _handlePaymentError(e);
      rethrow;
    }
  }

// Helper method to handle Stripe payment
  Future<(dynamic, double?)> _handleStripePayment(
      Ref ref,
      dynamic response,
      bool isCart,
      List<AppPaymentMethods>? paymentMethod,
      bool isMembership) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final rdata = isCart ?  response['data'] : response['data']['gatewayUrl'];
      String status = (rdata['status'] ?? "").toLowerCase();
      final clientSecret = rdata['clientSecret'].toString();
      final transactionID = rdata['transaction_id'].toString();

      while (status == "requires_action") {
        String stripePaymentMethodId = "";

        if ((paymentMethod ?? []).isNotEmpty) {
          stripePaymentMethodId =
              paymentMethod!.first.stripePaymentMethodID ?? "";
        }

        final PaymentIntent? paymentIntent = await ref.read(
            stripeRequireActionProvider(clientSecret, stripePaymentMethodId)
                .future);
        status = paymentIntent?.toJson()['status'].toString().toLowerCase() ??
            "unknown";
      }

      while (status == "requires_payment_method") {
        await ref.read(stripePaymentMethodProvider(clientSecret).future);
        status = "succeeded";
      }

      if (status == "succeeded") {
        myPrint("chargeID: $transactionID");
        return _fetchServiceIDFromChargeID(ref,
            chargeID: transactionID,
            isCart: isCart,
            isMembership: isMembership);
      }
      throw "SOMETHING_WENT_WRONG";
    } catch (e) {
      if (e is StripeError) {
        throw e.message;
      }
      throw e.toString();
    }
  }

// Helper method to handle Native payment
  Future<(dynamic, double?)> _handleNativePayment(Ref ref, dynamic response,
      double totalAmount, bool isCart, bool isMembership) async {
    final rdata = response['data']['gatewayUrl'];
    final clientSecret = rdata['clientSecret'].toString();
    final transactionID = rdata['transaction_id'].toString();

    final PaymentIntent? paymentIntent = await ref.read(
      startNativePayProvider(
        clientSec: clientSecret,
        amount: totalAmount.toString(),
      ).future,
    );

    if (paymentIntent == null) {
      throw "SOMETHING_WENT_WRONG";
    }

    return _fetchServiceIDFromChargeID(ref,
        chargeID: transactionID, isCart: isCart, isMembership: isMembership);
  }

// Helper method to extract service booking ID
  (int, double?) _extractServiceBookingID(dynamic response) {
    final int id = response['data']['service']['serviceBookings'][0]['id'];
    double? amount;
    if (response['data']['service']['serviceBookings'][0]["players"] is List) {
      amount = response['data']['service']['serviceBookings'][0]["players"]
          .fold(
              0,
              (previousValue, element) =>
                  (double.parse((previousValue ?? 0).toString())) +
                  (element["paid_price"] ?? 0));
    }
    return (id, amount);
  }

// Error handling helper
  void _handlePaymentError(dynamic error) {
    if (error is StripeException) {
      throw error.error.localizedMessage ?? "SOMETHING_WENT_WRONG";
    }
    if (error is Map<String, dynamic>) {
      throw error['message'];
    }
  }

  Future<(dynamic, double?)> _fetchServiceIDFromChargeID(Ref ref,
      {required String chargeID,
      required bool isCart,
      required bool isMembership}) async {
    final token = ref.read(userManagerProvider).user?.accessToken;
    if (token == null) {
      throw Exception('No access token available');
    }
    // Compute deadline 15 seconds from now.
    final deadline = DateTime.now().add(const Duration(seconds: 17));
    // Initial wait
    await Future.delayed(const Duration(seconds: 4));
    final query = {
      'order_id': chargeID,
      'status_code': 200,
      'transaction_status': 'succeeded'
    };
    if (isCart) {
      query["request_type"] = "CART";
    }

    if (isMembership) {
      return (0, null);
      // query["request_type"] = "MEMBERSHIP";
    }

    // Polling loop
    while (DateTime.now().isBefore(deadline)) {
      try {
        final response = await ref.read(apiManagerProvider).get(
              ref,
              ApiEndPoint.transaction,
              token: token,
              queryParams: query,
            );

        final dynamic value = isCart
            ? response['data']
            : (response['data']['service']['id'] ?? 0);
        return (value, null);
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

  Future<(List<MultipleBookings>?, String?)> multiBookingPaymentProcess(Ref ref,
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
      final bool isStripePayment = (paymentMethod?.methodType == kStripeMethod);
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
      if (isStripePayment) {
        final temp = await _handleStripePayment(
            ref, response, true, [paymentMethod!], false);
        final (value, amount) = temp;
        List<MultipleBookings> list = [];
        if (value != null && value is List) {
          value.map((e) => list.add(MultipleBookings.fromJson(e))).toList();
        }
        return (list, null);
      } else if (payLater == true ||
          paymentMethod?.methodType == kWalletMethod) {
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
    {int? courtId,int? variantId}) {
  return ref.read(paymentRepoProvider).fetchPaymentDetails(
      locationID, ref, type, id, startDate, isOpenMatch, duration,
      courtId: courtId,variantId: variantId);
}

@riverpod
Future<PaymentDetails> fetchAllPaymentMethods(
    FetchAllPaymentMethodsRef ref,
    int locationID,
    int serviceID,
    PaymentDetailsRequestType type,

    DateTime? startDate,
    int? duration,{int? courtId,int? variantId,required bool isOpenMatch}) async {
  final future = await Future.wait([
    ref.refresh(fetchPaymentDetailsProvider(
            locationID, type, serviceID, isOpenMatch, startDate, duration,courtId: courtId,variantId:variantId)
        .future),
    ref.refresh(fetchStripPaymentMethodsProvider.future),
  ]);

  final paymentMethods = future[0] as PaymentDetails;
  final stripePaymentMethods = future[1] as List<StripePaymentMethod>;

  final List<AppPaymentMethods> appPaymentMethods =
      paymentMethods.appPaymentMethods ?? [];
  final stripeIDIndex = appPaymentMethods.indexWhere((element) =>
      element.methodType?.toLowerCase() == kStripeMethod.toLowerCase());

  if (stripeIDIndex == -1) {
    return PaymentDetails(
        appPaymentMethods: appPaymentMethods,
        userMemberships: paymentMethods.userMemberships);
  }

  final stripeID = appPaymentMethods[stripeIDIndex].id;
  for (final paymentMethod in stripePaymentMethods) {
    paymentMethods.appPaymentMethods?.add(AppPaymentMethods(
      id: stripeID,
      methodType: kStripeMethod,
      stripePaymentMethodID: paymentMethod.id,
      last4: paymentMethod.card?.last4 ?? "",
      brand: paymentMethod.card?.brand ?? "",
    ));
  }

  appPaymentMethods.removeAt(stripeIDIndex);

  return PaymentDetails(
      appPaymentMethods: appPaymentMethods,
      userMemberships: paymentMethods.userMemberships);
}

@riverpod
Future<(int, double?)> paymentProcess(
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
