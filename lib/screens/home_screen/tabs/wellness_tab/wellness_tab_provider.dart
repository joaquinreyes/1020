part of 'wellness_tab.dart';

final _selectedDuration = StateProvider<int?>((ref) => null);
final _pageControllerFor = StateProvider((ref) => PageController());
final _selectedTabIndex = StateProvider<int>((ref) => 0);
final _selectedLessonBookingType = StateProvider<int?>((ref) => null);

final _selectedTimeSlotAndLocationID =
    StateProvider<(DateTime?, int?)>((ref) => (null, null));

final _pageViewController = StateProvider<PageController>((ref) {
  return PageController();
});