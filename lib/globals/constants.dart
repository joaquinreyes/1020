import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/box_shadow/flutter_inset_box_shadow.dart' as inset;
import '../app_styles/app_colors.dart';
import '../screens/app_provider.dart';

const allowPadelQuestionInRegistration = false;
const allowOpenMatch = true;
const allowAddToCart = false;
const allowShowPadelMembershipInProfile = true;
const kAllowPlayerRanking = true;

const kAppName = '10 - 20';
const kSportName = "Падел"; //sport
const kPadelName = "padel"; //sport
const kPickleBallName = "pickleball"; //sport
const kWhatsAppContact = "+353870356077";
const int kMinimumLimit = 8;
const int kPageLimit = 30;
const int kUserSearchPageSize = 30;
const kDeepLinkUrl = 'https://share.bookandgo.app/1020';

// const currency = "RM";
const currency = "RUB";

const double kDesignHeight = 844;
const double kDesignWidth = 390;
const kFutureDayLength = 14;

inset.BoxDecoration get kShadow =>
    inset.BoxDecoration(
      color: AppColors.black5,
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: kInsetShadow,
    );
const kMaxLevel = 10;

const kWhatsAppLink = "https://api.whatsapp.com/send";

String kFormatForAPI = "yyyy-MM-dd";

final kComponentWidthConstraint = BoxConstraints(maxWidth: 450.w);
const kAnimationDuration = Duration(milliseconds: 250);
const kStartedPlayingCustomID = "68b06af553f6b47a6a8edd8b";
const kPositionID = "68b06aeb53f6b47a6a8edd5b";
const kTermsConditions = "688754a171f940dd68e0e209";
const kGender = "68de0fa9e086dde9a76f1e48";

List<inset.BoxShadow> get kInsetShadow =>
    kIsWeb
        ? [
      // Web fallback: use regular shadows (non-inset)
      inset.BoxShadow(
        offset: const Offset(-4, -4),
        blurRadius: 60,
        color: const Color(0xff000000).withOpacity(.20),
        inset: true,
      ),
      inset.BoxShadow(
        offset: const Offset(4, 4),
        blurRadius: 4,
        color: const Color(0xFFBEBEBE).withOpacity(.55),
        inset: true,
      ),
    ]
        : [
      inset.BoxShadow(
        offset: const Offset(-4, -4),
        blurRadius: 60,
        color: const Color(0xff000000).withOpacity(.20),
        inset: true,
      ),
      inset.BoxShadow(
        offset: const Offset(4, 4),
        blurRadius: 4,
        color: const Color(0xFFBEBEBE).withOpacity(.55),
        inset: true,
      ),
    ];

List<inset.BoxShadow> get kInsetShadow2 =>
    kIsWeb
        ? [
      // Web fallback: use regular shadows (non-inset)
      inset.BoxShadow(
        offset: const Offset(2, 2),
        blurRadius: 8,
        color: const Color(0xff000000).withOpacity(.15),
        inset: false,
      ),
      inset.BoxShadow(
        offset: const Offset(-2, -2),
        blurRadius: 8,
        color: const Color(0xFFFFFFFF).withOpacity(.7),
        inset: false,
      ),
    ]
        : [
      inset.BoxShadow(
        offset: const Offset(-4, -4),
        blurRadius: 60,
        // color: const Color(0xff000000).withOpacity(.20),
        color: const Color(0xFFBEBEBE).withOpacity(.20),
        inset: true,
      ),
      inset.BoxShadow(
        offset: const Offset(4, 4),
        blurRadius: 4,
        color: const Color(0xff000000).withOpacity(.55),
        inset: true,
      ),
    ];

BoxShadow get kBoxShadow =>
    const BoxShadow(
      color: Color(0x0C000000),
      blurRadius: 4,
      offset: Offset(0, 4),
      spreadRadius: 0,
    );

List<BoxShadow> get newShadow =>
    [
      BoxShadow(
        color: AppColors.black.withOpacity(0.05),
        offset: const Offset(0, 4),
        blurRadius: 4,
        spreadRadius: 0,
      ),
    ];

BoxDecoration get decoration =>
    BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: border,
        boxShadow:newShadow
    );

Border get border =>
    Border.all(color: AppColors.black2.withOpacity(.05));



List<double> levelsList = List.generate(15, (index) => index * 0.5);

void myPrint(dynamic value) {
  if (kDebugMode) {
    if (kIsWeb) {
      print(value.toString());
    } else
      log(value.toString());
  }
}

String getSportsName(var ref) {
  // return kSportName;
  return ref
      .read(selectedSportProvider.notifier)
      .name;
}

const chatRoles = {
  1: "SUPER_ADMIN",
  2: "CLUB_ADMIN",
  3: "LOCATION_OWNER",
  4: "STAFF_MANAGER",
  5: "STAFF"
};

const kPilatesMembershipCategoryId = 107; // 107 = Pilates Memberships
const kYogaMembershipCategoryId = 115; // 115 = Yoga Memberships

final Map<double, String> rankMap = {
  0.0: '(Entry)',
  0.25: '(D1)',
  0.5: '(D2)',
  0.75: '(D3)',
  1.0: '(D4)',
  1.25: '(C1)',
  1.5: '(C2)',
  1.75: '(C3)',
  2.0: '(C4)',
  2.5: '(C-)',
  3.0: '(C)',
  3.5: '(C strong)',
  4.0: '(C+)',
  4.5: '(C++)',
  5.5: '(B-)',
  6.5: '(B)',
  7.5: '(B+)',
};


String getRankLabel(double level) {
  return "";
  // Get all keys <= input level
  // final lowerKeys = rankMap.keys.where((k) => k <= level);
  // if (lowerKeys.isEmpty) return 'Unknown';

  // Find the highest among the valid lower keys
  // final closestKey = lowerKeys.reduce((a, b) => a > b ? a : b);
  // return rankMap[closestKey] ?? 'Unknown';
}
