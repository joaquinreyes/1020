import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/utils/custom_extensions.dart';

import '../app_styles/app_colors.dart';
import '../app_styles/app_text_styles.dart';

const String kWalletMethod = "wallet";
const String kPayLaterMethod = "pay later";
const String kMembershipMethod = "membership";
const String kCashMethod = "cash";

class PaymentDetails {
  List<Wallets>? wallets;
  List<PaymentMethods>? paymentMethods;
  List<AppPaymentMethods>? appPaymentMethods;
  List<UserMemberships>? userMemberships;

  PaymentDetails(
      {this.wallets,
      this.paymentMethods,
      this.appPaymentMethods,
      this.userMemberships});

  PaymentDetails.fromJson(Map<String, dynamic> json) {
    if (json['wallets'] != null) {
      wallets = <Wallets>[];
      json['wallets'].forEach((v) {
        wallets!.add(Wallets.fromJson(v));
      });
    }
    if (json['userMemberships'] != null) {
      userMemberships = <UserMemberships>[];
      json['userMemberships'].forEach((v) {
        userMemberships!.add(UserMemberships.fromJson(v));
      });
    }
    if (json['paymentMethods'] != null) {
      paymentMethods = <PaymentMethods>[];
      json['paymentMethods'].forEach((v) {
        paymentMethods!.add(PaymentMethods.fromJson(v));
      });
    }

    appPaymentMethods = <AppPaymentMethods>[];
    for (var i = 0; i < (wallets?.length ?? 0); i++) {
      final appPayment = AppPaymentMethods(
        id: wallets![i].id,
        methodType: kWalletMethod,
        methodTypeText: "",
        walletBalance: wallets![i].balance,
      );
      appPaymentMethods!.add(appPayment);
    }
    if (wallets?.isEmpty ?? true) {
      final appPayment = AppPaymentMethods(
        id: 0,
        methodType: kWalletMethod,
        methodTypeText: "",
        walletBalance: 0.0,
      );
      appPaymentMethods!.add(appPayment);
    }

    for (var i = 0; i < (paymentMethods?.length ?? 0); i++) {
      // Skip cash method
      if (paymentMethods![i].methodName == kCashMethod) {
        continue;
      }
      final appPayment = AppPaymentMethods(
        id: paymentMethods![i].id,
        methodTypeText: paymentMethods![i].methodName,
        methodType: paymentMethods![i].methodName,
        walletBalance: null,
      );
      appPaymentMethods!.add(appPayment);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (wallets != null) {
      data['wallets'] = wallets!.map((v) => v.toJson()).toList();
    }
    if (paymentMethods != null) {
      data['paymentMethods'] = paymentMethods!.map((v) => v.toJson()).toList();
    }
    if (userMemberships != null) {
      data['userMemberships'] =
          userMemberships!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Wallets {
  int? id;
  String? currency;
  double? balance;

  Wallets({this.id, this.currency, this.balance});

  Wallets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currency = json['currency'];
    balance = json['balance']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['currency'] = currency;
    data['balance'] = balance;
    return data;
  }
}

class PaymentMethods {
  int? id;
  String? methodName;
  int? sequence;

  PaymentMethods({this.id, this.methodName, this.sequence});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    methodName = json['method_name'];
    sequence = json['sequence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['method_name'] = methodName;
    data['sequence'] = sequence;
    return data;
  }
}

class AppPaymentMethods {
  int? id;
  String? methodType;
  String? methodTypeText;
  double? walletBalance;
  double? amountToPay;
  int? membershipId;

  AppPaymentMethods({
    this.id,
    this.methodType,
    this.walletBalance,
    this.methodTypeText,
    this.membershipId,
    this.amountToPay,
  });

  Map<String, dynamic> toJsonForProcess() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['method_id'] = id;
    data['method_type'] = methodType;
    data["amount"] = amountToPay;
    if (methodType == kMembershipMethod) {
      data["customer_membership_id"] = membershipId;
    }
    return data;
  }
}

class MDRRates {
  double? percentage;
  double? fixedAmount;
  String? iconUrl;

  MDRRates({required this.percentage, required this.fixedAmount});

  MDRRates.fromJson(Map<String, dynamic> json) {
    percentage = json['percentage']?.toDouble();
    fixedAmount = json['fixedAmount']?.toDouble();
    iconUrl = json['iconUrl'];
  }
}

class UserMemberships {
  int? id;
  int? usesLeft;
  Membership? membership;

  Widget usesLeftString(BuildContext context, bool isSelected) {
    final color = isSelected ? AppColors.black : AppColors.white;
    final containerColor = isSelected ? AppColors.white : AppColors.black;
    if (usesLeft == null || usesLeft == -1) {
      return Text(
        "UNLIMITED".tr(context),
        style: AppTextStyles.manropeMedium(fontSize: 14.sp, color: color),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration:
              BoxDecoration(color: containerColor, shape: BoxShape.circle),
          padding: EdgeInsets.all(4.w),
          alignment: Alignment.center,
          child: Text(
            usesLeft.toString(),
            style: AppTextStyles.manropeMedium(fontSize: 14.sp, color: color),
          ),
        ),
        SizedBox(width: 5.h),
        Text(
          "REMAINING".tr(context).toLowerCase(),
          style: AppTextStyles.manropeMedium(fontSize: 14.sp, color: color),
        )
      ],
    );
  }

  UserMemberships({this.id, this.usesLeft, this.membership});

  UserMemberships.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usesLeft = json['uses_left'];
    membership = json['membership'] != null
        ? Membership.fromJson(json['membership'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uses_left'] = usesLeft;
    if (membership != null) {
      data['membership'] = membership!.toJson();
    }
    return data;
  }
}

class Membership {
  int? id;
  String? membershipName;
  List<Bookings>? bookings;

  Membership({this.id, this.membershipName, this.bookings});

  Membership.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    membershipName = json['membership_name'];
    if (json['bookings'] != null) {
      bookings = <Bookings>[];
      json['bookings'].forEach((v) {
        bookings!.add(Bookings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['membership_name'] = membershipName;
    if (bookings != null) {
      data['bookings'] = bookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bookings {
  int? id;

  Bookings({this.id});

  Bookings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
