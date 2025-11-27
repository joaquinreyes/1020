import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutterwebapp_reload_detector/flutterwebapp_reload_detector.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/firebase_options.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/current_platform.dart';
import 'package:hop/managers/fcm_manager.dart';
import 'package:hop/managers/shared_pref_manager.dart';
import 'package:hop/repository/club_repo.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';

import 'globals/images.dart';

WidgetRef? globalRef;

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      Stripe.publishableKey = kStripDevKey;
      Stripe.merchantIdentifier = "merchant.com.houseofpadelireland";
      await Stripe.instance.applySettings();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      tz.initializeTimeZones();
      if (!kIsWeb) {
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
      }
      runApp(
        ProviderScope(
          overrides: [
            sharedPrefManagerProvider
                .overrideWithValue(SharedPrefManager(prefs)),
          ],
          child: const HOPIreland(),
        ),
      );
    },
    (error, stack) {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(error, stack);
      }
      myPrint("------------------- Error -------------------");
      myPrint(error);
      myPrint(stack);
      myPrint("--------------------------------------");
    },
  );
}

class HOPIreland extends ConsumerStatefulWidget {
  const HOPIreland({super.key});

  @override
  ConsumerState<HOPIreland> createState() => _HOPIrelandState();
}

class _HOPIrelandState extends ConsumerState<HOPIreland> {
  @override
  void initState() {
    globalRef = ref;
    FcmManager().initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage(AppImages.authBackground.path), context);
    Future(() {
      ref.watch(checkUpdateProvider);
    });
    PlatformC().init(context);
    WebAppReloadDetector.onReload(() {
      PlatformC().init(context);
      ref.read(goRouterProvider).go(AppPages.initial);
    });
    ref.watch(sharedPrefManagerProvider);
    final router = ref.watch(goRouterProvider);
    initializeDateFormatting();

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: MaterialApp.router(
        title: "10 - 20",
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        locale: const Locale('en'),
        supportedLocales: const [
          Locale('en'),
        ],
        localizationsDelegates: [
          FlutterI18nDelegate(
            translationLoader: FileTranslationLoader(
              fallbackFile: 'en',
              basePath: "assets/locales",
              decodeStrategies: [JsonDecodeStrategy()],
            ),
            missingTranslationHandler: (key, locale) {
              myPrint(
                  "--- Missing Key: $key, languageCode: ${locale!.languageCode}");
            },
          )
        ],
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.white,
          // colorScheme: const ColorScheme.light().copyWith(
          //   primary: AppColors.orange,
          // ),
          useMaterial3: false,
          // textTheme: const TextTheme(
          //   bodySmall: TextStyle(
          //     color: AppColors.blue,
          //   ),
          //   bodyMedium: TextStyle(
          //     color: AppColors.blue,
          //   ),
          // ).apply(
          //   bodyColor: AppColors.blue,
          //   displayColor: AppColors.orange,
          // ),
        ),
        builder: (context, child) {
          final width = MediaQuery.of(context).size.width;
          final height = MediaQuery.of(context).size.height;
          final double ratio = width / height;
          double designWidth = ratio > 0.6 ? 470 : kDesignWidth;
          double designHeight = kDesignHeight;
          final MediaQueryData data = MediaQuery.of(context);

          if (width >= 850 && !PlatformC().isCurrentOSMobile) {
            designWidth = 1512;
            designHeight = 982;
          }

          final designSize = Size(designWidth, designHeight);
          return MediaQuery(
            data: data.copyWith(
              textScaler: const TextScaler.linear(1),
            ),
            child: ScreenUtilInit(
              designSize: designSize,
              builder: (context, c) {
                return child!;
              },
            ),
          );
        },
      ),
    );
  }
}
