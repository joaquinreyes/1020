part of 'book_court_dialog.dart';

final _isOpenMatchProvider = StateProvider<bool>((ref) => false);
final _isFriendlyMatchProvider = StateProvider<bool>((ref) => false);
final _isPrivateMatchProvider = StateProvider<bool>((ref) => false);
// final _isDUPRMatchProvider = StateProvider<bool>((ref) => false);
final _isApprovePlayersProvider = StateProvider<bool>((ref) => false);
final _organizerNoteProvider = StateProvider<String>((ref) => '');
final _matchLevelProvider = StateProvider<List<double>>((ref) => []);
final _reserveSpotsForMatchProvider = StateProvider<int>((ref) => 0);
final totalMultiBookingAmount = StateProvider<double>((ref) => 1);
final _selectedPlayersProvider = StateProvider<List<BookingPlayerBase>>((ref) => []);
final _payFullCourtInPrivateProvider = StateProvider<bool>((ref) => true); // Default to pay full court in private match
