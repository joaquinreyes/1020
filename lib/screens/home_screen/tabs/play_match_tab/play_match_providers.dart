part of 'play_match_tab.dart';
final kAllCoaches = ServiceDetailCoach(id: -1, fullName: 'All Coaches');
final kAllLocation = ClubLocationData(id: -1, locationName: 'All Locations');
final _pageController = StateProvider((ref) => PageController(initialPage: 0));
final _selectedTabIndex = StateProvider<int>((ref) => 0);
final dateRangeProvider = StateProvider<PickerDateRange>(
  (ref) => PickerDateRange(
    DateTime.now(),
    DateTime.now().add(const Duration(days: 7)),
  ),
);
final _storeAllLocationsProvider =
    StateProvider<List<ClubLocationData>>((ref) => []);
final selectedLocationProvider =
    StateProvider<List<int>>((ref) => [kAllLocation.id ?? -1]);
final _selectedSportsProvider = StateProvider<String>((ref) {
  final setting = ref.read(settingSportsValueProvider);

  return setting;
  // return [kAllSports.sportName.toString()];
});
final _selectedLevelProvider = StateProvider<List<double>>((ref) {
  return [0,7];
  final userLevel =
      ref.watch(userProvider)?.user?.level(getSportsName(ref)) ?? 0;
  if (userLevel == 0) {
    return const [0, 0];
  } else {
    if (userLevel >= 1.5 && userLevel <= (7.0 - 1.0)) {
      return [userLevel - 1.5, userLevel + 1.0];
    } else if (userLevel >= 1.5 && userLevel > (7.0 - 1.0)) {
      return [userLevel - 1.5, 7.0];
    } else if (userLevel < 1.5 && userLevel <= (7.0 - 1.0)) {
      return [0, userLevel + 1.0];
    } else {
      return const [0, 0];
    }
  }
});
