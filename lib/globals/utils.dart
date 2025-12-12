import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as position;
import 'package:intl/intl.dart';
import 'package:hop/components/async_dialog.dart';
import 'package:hop/components/message_dialog.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/managers/dynamic_link_handler.dart';
import 'package:hop/models/club_locations.dart';
import 'package:hop/models/lesson_models.dart';
import 'package:hop/models/service_detail_model.dart';
import 'package:hop/screens/home_screen/tabs/play_match_tab/play_match_tab.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/utils/dubai_date_time.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/standalone.dart' as tz2;
import 'package:add_2_calendar/add_2_calendar.dart';
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../components/terms_and_condition.dart';
import '../managers/user_manager.dart';
import '../models/base_classes/booking_player_base.dart';
import '../models/payment_methods.dart';
import '../repository/user_repo.dart';
import '../screens/home_screen/tabs/booking_tab/booking_tab.dart';

class Utils {
  static bool checkUserLogin(WidgetRef ref) {
    final token = ref.read(userManagerProvider).user?.accessToken;

    if (token == null || token.isEmpty) {
      return false;
    }

    return true;
  }

  static List<ServiceDetailCoach> fetchLocationCoaches(
      List<ClubLocationData>? location) {
    List<ServiceDetailCoach> coaches = [];

    Set<int> seenIds = {};

    for (var service in (location ?? [])) {
      for (var coach in service.coaches ?? []) {
        if (!seenIds.contains(coach.id)) {
          seenIds.add(coach.id);
          coaches.add(coach);
        }
      }
    }

    return coaches;
  }

  static showLoadingDialog<T>(
      BuildContext context, AutoDisposeFutureProvider value, WidgetRef ref,
      {bool isUpperCase = false, bool? barrierDismissible}) async {
    ref.invalidate(value);
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? false,
      // barrierColor: Colors.transparent,
      builder: (context) {
        return AsyncDialog(
          provider: value,
          isUpperCase: isUpperCase,
        );
      },
    );
  }

  static List<int> getSportsIds(String selectedSports,
      List<ClubLocationData> locations, List<int> locationIds) {
    List<int> value = [];
    List<SportFilterModel> sports = fetchSportsListPlayShow(
        fetchSportsListPlay(locations, locationIds), locationIds);

    sports.map((e) {
      if (e.sportName.toLowerCase() == selectedSports.toLowerCase()) {
        value.addAll(e.id);
      }
    }).toList();
    // selectedSports
    //     .map((sport) => sports.map((e) {
    //           if (e.sportName.toLowerCase() == sport.toLowerCase()) {
    //             value.addAll(e.id);
    //           }
    //         }).toList())
    //     .toList();
    return value;
  }

  static List<ClubLocationSports> fetchSportsListPlay(
      List<ClubLocationData> locations, List<int> locationIds) {
    List<ClubLocationSports> sportsList = [];
    final tempLocation = [...locationIds];
    log("location :::: ${locations}");
    tempLocation.remove(-1);
    for (var location in locations) {
      bool check = true;
      if (tempLocation.isNotEmpty) {
        check = tempLocation.contains(location.id);
      }
      if (check) {
        sportsList.addAll(location.sports);
      }
    }
    sportsList.removeWhere((element) => element.sportName?.isEmpty ?? true);
    return sportsList.reversed.toList();
  }

  static List<SportFilterModel> fetchSportsListPlayShow(
      List<ClubLocationSports> sports, List<int> locationIds) {
    Map<String, List<int>> groupedMap = {};
    for (var item in sports) {
      String sportsName = (item.sportName ?? "").toLowerCase();
      int id = item.id ?? 0;
      if (!groupedMap.containsKey(sportsName)) {
        groupedMap[sportsName] = [];
      }
      groupedMap[sportsName]!.add(id);
    }
    List<SportFilterModel> result = [];
    groupedMap.forEach((sportsName, ids) {
      result.add(SportFilterModel(id: ids, sportName: sportsName));
    });
    return result;
  }

  static Future<void> showMessageDialog(BuildContext context, String message,
      {Color? backgroundColor}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return MessageDialog(
          message: message,
          backgroundColor: backgroundColor,
        );
      },
    );
  }

  static Future<void> showMessageDialog2(
      BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (context) {
        return MessageDialog2(message: message);
      },
    );
  }

  static List<List<T>> getChunks<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    int len = list.length;
    for (var i = 0; i < len; i += chunkSize) {
      int size = i + chunkSize;
      chunks.add(list.sublist(i, size > len ? len : size));
    }
    return chunks;
  }

  static String formatPrice(double? price) {
    if (price == null) return '0.00 RUB';

    final formatted = NumberFormat('#,##0.00', 'en_AE').format(price);
    return '$formatted RUB';
  }

  static String formatPriceNew(double? price) {
    if (price == null) return '0 RUB';

    final formatted = NumberFormat('', 'en_AE').format(price);
    return '$formatted RUB';
  }

  static String formatPriceProfile(double? price) {
    if (price == null) {
      return '0';
    }
    // to K
    if (price >= 1000) {
      // return '$currency ${(price / 1000).toStringAsFixed(0)}K';
      return '$currency ${(price / 1000).toStringAsFixed(0)}K';
    }
    // return '$currency ${price.toStringAsFixed(2)}';
    return '$currency ${price.toStringAsFixed(2)}';
  }

  static String formatPrice2(double? price, String currencyValue) {
    if (price == null) {
      return '0 $currencyValue';
    }

    final formatter = NumberFormat('#,##0', 'id_ID');

    // Format the price with thousands separator (.)
    return '${formatter.format(price).replaceAll(',', '.')} $currencyValue';
  }

  static DateTime serverTimeToDateTime(String time, DateTime date) {
    final timeSplit = time.split(':');
    final dateTime = DubaiDateTime.custom(
      date.year,
      date.month,
      date.day,
      int.parse(timeSplit[0]),
      int.parse(timeSplit[1]),
    ).dateTime;
    return dateTime;
  }

  static String formatBookingDate(DateTime date, BuildContext context) {
    final now = DubaiDateTime.now().dateTime;
    final today = DubaiDateTime.custom(now.year, now.month, now.day).dateTime;
    final tomorrow =
        DubaiDateTime.custom(now.year, now.month, now.day + 1).dateTime;
    final bookingDate =
        DubaiDateTime.custom(date.year, date.month, date.day).dateTime;
    if (today.isAtSameMomentAs(bookingDate)) {
      return 'TODAY'.tr(context);
    } else if (tomorrow.isAtSameMomentAs(bookingDate)) {
      return 'TOMORROW'.tr(context);
    } else {
      return date.format('EE d MMM');
    }
  }

  static Future<void> addCalendarEvent(
      {required String title,
      required DateTime startDate,
      required DateTime endDate}) async {
    try {
      final singapore = tz2.getLocation('Asia/Singapore');

      tz.TZDateTime startTime = tz.TZDateTime(
          singapore,
          startDate.year,
          startDate.month,
          startDate.day,
          startDate.hour,
          startDate.minute,
          startDate.second);
      tz.TZDateTime endTime = tz.TZDateTime(
          singapore,
          endDate.year,
          endDate.month,
          endDate.day,
          endDate.hour,
          endDate.minute,
          endDate.second);
      final Event event = Event(
        title: title,
        startDate: startTime,
        endDate: endTime,
      );
      await Add2Calendar.addEvent2Cal(event);
    } catch (e) {
      myPrint(e.toString());
    }
  }

  static double calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    // Convert latitude and longitude from degrees to radians
    double lat1Rad = radians(lat1);
    double lng1Rad = radians(lng1);
    double lat2Rad = radians(lat2);
    double lng2Rad = radians(lng2);

    // Calculate the differences between coordinates
    double deltaLat = lat2Rad - lat1Rad;
    double deltaLng = lng2Rad - lng1Rad;

    // Haversine formula
    double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLng / 2) *
            math.sin(deltaLng / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    // Calculate the distance
    double distance = earthRadius * c;

    return distance;
  }

  static double radians(double degrees) {
    return degrees * (math.pi / 180);
  }

  static Color calculateColorOverBackground(
      Color color, String alphaHex, Color backgroundColor) {
    double opacity = int.parse(alphaHex, radix: 16) / 255.0;

    int red =
        ((color.red * opacity) + (backgroundColor.red * (1 - opacity))).round();
    int green =
        ((color.green * opacity) + (backgroundColor.green * (1 - opacity)))
            .round();
    int blue = ((color.blue * opacity) + (backgroundColor.blue * (1 - opacity)))
        .round();

    return Color.fromRGBO(red, green, blue, 1.0);
  }

  static Future<File?> bakeImageOrientation(File imageFile) async {
    // Step 1: Read the file as a byte array
    final Uint8List imageBytes = await imageFile.readAsBytes();

    // Step 2: Decode the image to handle EXIF data
    img.Image? image = img.decodeImage(imageBytes);

    if (image == null) {
      return null; // Return null if decoding fails
    }

    // Step 3: Correct the orientation by baking EXIF orientation into the image
    final img.Image orientedImage = img.bakeOrientation(image);

    // Step 4: Write the corrected image back to the file
    final File bakedFile =
        await imageFile.writeAsBytes(img.encodeJpg(orientedImage));

    return bakedFile; // Return the corrected image file
  }

  static String eventLessonStatusText({
    required BuildContext context,
    required int playersCount,
    int? maxCapacity,
    int? minCapacity,
  }) {
    maxCapacity = maxCapacity ?? 0;
    minCapacity = minCapacity ?? 0;
    if (playersCount >= maxCapacity) {
      return "FILLED".tr(context);
    } else if (playersCount >= minCapacity) {
      return "CONFIRMED".tr(context);
    } else {
      return "OPEN".tr(context);
    }
  }

  static List<ClubLocationSports> fetchSportsList(
      List<ClubLocationData> locations) {
    List<ClubLocationSports> sportsList = [];
    for (var location in locations) {
      for (var sport in location.sports) {
        final alreadyExists = sportsList
                .firstWhere((element) => element.sportName == sport.sportName,
                    orElse: () => ClubLocationSports(sportName: ''))
                .sportName !=
            '';
        if ((sport.sportName?.isNotEmpty ?? false) && !alreadyExists) {
          sportsList.add(sport);
        }
      }
    }
    sportsList.removeWhere((element) => element.sportName?.isEmpty ?? true);
    sportsList.sort((a, b) {
      if (b.sportName?.toLowerCase() == kSportName) return -1;
      if (a.sportName?.toLowerCase() == kSportName) return 1;
      return 0;
    });
    return sportsList.reversed.toList();
    // return sportsList;
  }

  static int getFutureDateLength(
      List<ClubLocationData> locations, String sportName) {
    int maxLen = 0;

    for (var location in locations) {
      int indexOfSport = location.sports.indexWhere((element) =>
          element.sportName?.toLowerCase() == sportName.toLowerCase());
      if (indexOfSport == -1) {
        continue;
      }
      final sport = location.sports[indexOfSport];
      for (ClubLocationSportsCourts court in sport.courts ?? []) {
        final courtLength = court.appBookableDaysInFuture ?? 0;
        if (courtLength > maxLen) {
          maxLen = courtLength;
        }
      }
    }
    return maxLen;
  }

  static calculateMDR(double amount, MDRRates mdrRate) {
    double percentage = mdrRate.percentage ?? 0;
    double fixedAmount = mdrRate.fixedAmount ?? 0;
    return (amount * percentage / 100) + fixedAmount;
  }

  static Future<void> openWhatsapp(
      {required BuildContext context, message}) async {
    try {
      myPrint("----------- Message -----------");
      myPrint(message);
      myPrint("----------------------");
      final encodedMessage = Uri.encodeComponent(message);
      final Uri url = Uri.parse('whatsapp://send?text=$encodedMessage');
      // final Uri url =  Uri.parse('$kWhatsAppLink?text=$encodedMessage');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (!context.mounted) {
          return;
        }
        Utils.showMessageDialog(
          context,
          "NO_WHATSAPP_APP_DETECTED".tr(context),
        );
      }
    } catch (_) {
      myPrint('Error opening whatsapp');
    }
  }

  static Future<void> openWhatsappSupport(
      {String message = "Hello $kAppName",
      required BuildContext context}) async {
    try {
      final Uri url =
          Uri.parse('whatsapp://send?phone=$kWhatsAppContact&text=$message');
      // Uri.parse('$kWhatsAppLink?phone=$kWhatsAppContact&text=$message');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (!context.mounted) {
          return;
        }
        Utils.showMessageDialog(
          context,
          "NO_WHATSAPP_APP_DETECTED".tr(context),
        );
      }
    } catch (_) {}
  }

  static shareOpenMatch(
      BuildContext context, ServiceDetail service, WidgetRef ref) {
    final level = service.openMatchLevelRange;
    final date = service.formattedDateStartEndTimeForShare;
    final players = service.players ?? [];
    final court = service.courtName.capitalizeFirst;
    final link = DynamicLinkHandler.instance.getMatchURL(service.id!);
    final location = service.service?.location?.locationName ?? "";

    // Build confirmed players list with checkmarks
    final confirmedPlayers = players.map((e) {
      final name = (e.reserved ?? false) ? "Reserved" : e.getCustomerName;
      final ranking = e.customer?.level(getSportsName(ref)) ?? "";
      return ranking.isNotEmpty ? "✅ $name ($ranking)" : "✅ $name";
    }).toList();

    // Build available spots list with circles
    final missingPlayers = 4 - players.length;
    final availableSpots = List.generate(missingPlayers, (_) => "⚪ ??");

    // Combine all players
    final allPlayers = [...confirmedPlayers, ...availableSpots];
    final playersList = allPlayers.join("\n");

    String shareStr = """
• MATCH IN HOUSE OF PADEL
📅 $date
📍 $court
📊 Level $level
$playersList

Click to join 👇🏼
$link
""";
    Utils.openWhatsapp(context: context, message: shareStr);
  }

  static shareBookingWhatsapp(
      BuildContext context, ServiceDetail service, WidgetRef ref) {
    final level = service.openMatchLevelRange;
    final date = service.formattedDateStartEndTimeForShare;
    final court = service.courtName;
    final link = DynamicLinkHandler.instance.getBookingURL(service.id!);
    final location = service.service?.location?.locationName ?? "";
    String shareStr = """
*BOOKING${level}*\n📅$date\n📍$location\n-Court $court""";
    Utils.openWhatsapp(context: context, message: shareStr);
  }

  static List<ClubLocationData> sortLocations(
      List<ClubLocationData> locationsData, position.Position? userLoc) {
    final locations = locationsData.toSet().toList();
    locations.sort((a, b) {
      final distanceA =
          a.getLocationRadius(userLoc?.latitude, userLoc?.longitude);
      final distanceB =
          b.getLocationRadius(userLoc?.latitude, userLoc?.longitude);
      return distanceA.compareTo(distanceB);
    });
    return locations;
  }

  static void shareEventLessonUrl(
      {required BuildContext context,
      required ServiceDetail service,
      required bool isLesson}) {
    String level = service.service?.event?.levelRestriction ?? "";
    if (level.isNotEmpty) {
      level = "($level)";
    }
    // Fixed partner or Single signup
    final fixedPartner = "SHARE_FIXED_PARTNER".tr(context);
    final singleSignup = "SHARE_SINGLE_SIGNUP".tr(context);
    String title =
        "${(service.service?.isDoubleEvent ?? false) ? fixedPartner : singleSignup} ${service.service?.event?.eventName} $level";
    // Sat. 26 October at 02:30 PM
    final date = service.formattedDateStartEndTimeForShare;
    String location = service.service?.location?.locationName ?? "";
    final maxSLots = service.getMaximumCapacity;
    String info = service.service?.additionalService ?? "";
    final infoLabel = "SHARE_INFO".tr(context);
    if (info.isNotEmpty) {
      info = "•⁠  ⁠$infoLabel:\n$info\n";
    }
    int availableSlots;
    int currentParticipants;
    String playerNamesString;
    final availableSlotText = "SHARE_AVAILABLE_SLOT".tr(context);
    final reservedText = "SHARE_RESERVED".tr(context);
    final availableText = "SHARE_AVAILABLE".tr(context);

    if (service.service?.isDoubleEvent ?? false) {
      final totalTeams = maxSLots ~/ 2;
      final playersL = service.players ?? [];
      int playersCount = math.min(maxSLots, playersL.length);
      List<BookingPlayerBase?> players = List.generate(
        maxSLots,
        (_) => null,
      );

      for (int i = 0; i < playersCount; i++) {
        final player = playersL[i];
        int? pos = player.position; // Get the player's position
        int posIndex = (pos ?? (i + 1)) - 1; // Calculate index
        if (posIndex < players.length) {
          players[posIndex] = player; // Assign player to their position
        }
      }

      List<String> playerNames = players.map((e) {
        if (e == null) {
          return availableSlotText;
        } else {
          return (e.reserved ?? false)
              ? reservedText
              : "${e.getCustomerName}${!(service.isWellnessSport ?? true) ? " ${e.customer?.level("padel")} ${getRankLabel(e.customer?.levelD("padel") ?? 0)}" : ""}";
        }
      }).toList();

      currentParticipants =
          playerNames.where((name) => name != availableSlotText).length;
      availableSlots = maxSLots - currentParticipants;

      List<String> playerNames2 = [];
      for (int i = 0; i < playerNames.length; i += 2) {
        if (i + 1 < playerNames.length) {
          playerNames2.add("${playerNames[i]} + ${playerNames[i + 1]}");
        } else {
          playerNames2.add("${playerNames[i]} + $availableSlotText");
        }
      }

      if (playerNames2.length < totalTeams) {
        playerNames2.addAll(List.generate(totalTeams - playerNames2.length,
            (index) => "$availableSlotText + $availableSlotText"));
      }

      playerNames2.asMap().forEach((index, element) {
        playerNames2[index] = "${index + 1}. $element";
      });

      playerNamesString = playerNames2.map((line) => line.trim()).join("\n");
    } else {
      final playerNames = service.players?.map((e) {
            return (e.reserved ?? false)
                ? reservedText
                : "${e.getCustomerName}${!(service.isWellnessSport ?? true) ? " ${e.customer?.level("padel")} ${getRankLabel(e.customer?.levelD("padel") ?? 0)}" : ""}";
          }).toList() ??
          [];
      currentParticipants = playerNames.length;
      availableSlots = maxSLots - currentParticipants;

      if (playerNames.length < maxSLots) {
        playerNames.addAll(List.generate(
            maxSLots - playerNames.length, (index) => availableText));
      }
      // add counting to player names
      playerNames.asMap().forEach((index, element) {
        playerNames[index] = "${index + 1}. $element";
      });
      playerNamesString = playerNames.join("\n");
    }
    final link = isLesson
        ? DynamicLinkHandler.instance.getLessonUrl(service.id!)
        : DynamicLinkHandler.instance.getEventURL(service.id!);
    final spotsAvailable = "SHARE_SPOTS_AVAILABLE".tr(context);
    final currentParticipantsLabel = "SHARE_CURRENT_PARTICIPANTS".tr(context);
    final clickToJoin = "SHARE_CLICK_TO_JOIN".tr(context);
    final text = """
*${title.toUpperCase()}*
📅 $date
📍 $location
• ${availableSlots > 0 ? availableSlots : 0} $spotsAvailable
• $currentParticipants $currentParticipantsLabel
$info
$playerNamesString

$clickToJoin 👇🏼
$link
""";

    Share.share(text);
  }

  static void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static Future<dynamic> termsAndCommunicationDialog(
      {required BuildContext context,
      bool isTerms = true,
      bool showButton = false}) async {
    ScrollController scrollController = ScrollController();
    return await showDialog(
      context: context,
      builder: (context) {
        return TermsAndCondition(
            isTerms: isTerms,
            showButton: showButton,
            scrollController: scrollController);
      },
    );
  }

  Future<bool> checkForLevelAssessment(
      {required WidgetRef ref,
      required BuildContext context,
      required String? sportsName}) async {
    // return true;
    // final checkTermsAndCondition =
    //     ref.read(userProvider)?.user?.termsAndCondition ?? false;
    //
    // if (!checkTermsAndCondition) {
    //   final value =
    //       await termsAndCommunicationDialog(context: context, showButton: true);
    //   if (value is bool) {
    //     if (value) {
    //       final user = ref.read(userManagerProvider).user?.user;
    //
    //       final updatedUser = user
    //           ?.copyWithForUpdate(customFields: {kTermsConditions: "Accepted"});
    //       final done = await Utils.showLoadingDialog(
    //           context, updatePictureAndUserProvider(null, updatedUser), ref);
    //       if (!(done.$2 == true && context.mounted)) {
    //         return false;
    //       }
    //     } else {
    //       return false;
    //     }
    //   } else {
    //     return false;
    //   }
    // }
    //
    // if (sportsName == null) {
    //   return true;
    // }
    // if (sportsName.trim().toLowerCase() != "padel") {
    //   return true;
    // }



    bool proceedToBook = false;

    final checkUserHasLevel =
        ref.read(userProvider)?.user?.isPadelLevelSet ?? true;

    // Also check if user's level is 0
    final userLevel = ref.read(userProvider)?.user?.level(sportsName ?? "padel") ?? 0.0;

    if (checkUserHasLevel && userLevel > 0.0) {
      proceedToBook = true;
    } else {
      final data = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return QuizQuestions(sportsName: sportsName ?? "padel");
        },
      );
      if (data is bool) {
        proceedToBook = data;
      }
    }
    return proceedToBook;
  }

  static List<ServiceDetailCoach> fetchLessonCoaches(LessonsModel lesson) {
    List<ServiceDetailCoach> coaches = [];
    Set<int> seenIds = {};
    lesson.coaches.map((e) {
      if (!seenIds.contains(e.id)) {
        seenIds.add(e.id ?? 0);
        coaches.add(e);
      }
    }).toList();
    return coaches;
  }
}

bool get isCurrentOSMobile {
  return !kIsWeb;
  // if ((Platform.isAndroid || Platform.isIOS) && !kIsWeb) {
  //   return true;
  // } else {
  //   return false;
  // }
}
