// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$crashlyticsHash() => r'89f582b17599547f29e9c5587eb027fd25d7540f';

/// See also [crashlytics].
@ProviderFor(crashlytics)
final crashlyticsProvider = Provider<FirebaseCrashlytics>.internal(
  crashlytics,
  name: r'crashlyticsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$crashlyticsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CrashlyticsRef = ProviderRef<FirebaseCrashlytics>;
String _$pageControllerHash() => r'70956ab89652fc2f04e7208d78af4e30b77cda31';

/// See also [pageController].
@ProviderFor(pageController)
final pageControllerProvider = AutoDisposeProvider<PageController>.internal(
  pageController,
  name: r'pageControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pageControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PageControllerRef = AutoDisposeProviderRef<PageController>;
String _$pageIndexHash() => r'a03781324adfd37f4dd0417f78c1097140c6e36c';

/// See also [PageIndex].
@ProviderFor(PageIndex)
final pageIndexProvider = NotifierProvider<PageIndex, int>.internal(
  PageIndex.new,
  name: r'pageIndexProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pageIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PageIndex = Notifier<int>;
String _$selectedSportHash() => r'b659e11d98098f56918756a00b02899c70feea22';

/// See also [SelectedSport].
@ProviderFor(SelectedSport)
final selectedSportProvider =
    NotifierProvider<SelectedSport, ClubLocationSports?>.internal(
  SelectedSport.new,
  name: r'selectedSportProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedSportHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedSport = Notifier<ClubLocationSports?>;
String _$selectedSportLessonHash() =>
    r'97acc32099e8d804f17eff0e222b63ad32a2bc1b';

/// See also [SelectedSportLesson].
@ProviderFor(SelectedSportLesson)
final selectedSportLessonProvider =
    NotifierProvider<SelectedSportLesson, ClubLocationSports?>.internal(
  SelectedSportLesson.new,
  name: r'selectedSportLessonProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedSportLessonHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedSportLesson = Notifier<ClubLocationSports?>;
String _$settingSportsValueHash() =>
    r'4d6d7eaf72d2a6a52de5144faefe7587d778163b';

/// See also [SettingSportsValue].
@ProviderFor(SettingSportsValue)
final settingSportsValueProvider =
    NotifierProvider<SettingSportsValue, String>.internal(
  SettingSportsValue.new,
  name: r'settingSportsValueProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingSportsValueHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingSportsValue = Notifier<String>;
String _$sportListHash() => r'53b2234871ff5be7e97dfb92ef28a57f49291747';

/// See also [SportList].
@ProviderFor(SportList)
final sportListProvider =
    NotifierProvider<SportList, List<ClubLocationSports>>.internal(
  SportList.new,
  name: r'sportListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sportListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SportList = Notifier<List<ClubLocationSports>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
