class OpenMatchesPaginationParams {
  final DateTime startDate;
  final DateTime endDate;
  final List<int> locationIDs;
  final double minLevel;
  final double maxLevel;
  final int limit;

  OpenMatchesPaginationParams({
    required this.startDate,
    required this.endDate,
    this.locationIDs = const [],
    required this.minLevel,
    required this.maxLevel,
    required this.limit,
  });
}

class UpcomingBookingParams {
  final int limit;
  final bool isPast;

  const UpcomingBookingParams({
    required this.limit,
    required this.isPast,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpcomingBookingParams &&
          other.limit == limit &&
          other.isPast == isPast;

  @override
  int get hashCode => Object.hash(limit, isPast);
}

class PlayerRankingParams {
  final int limit;
  final int currentPage;
  final String sportName;

  PlayerRankingParams(
      {required this.limit,
      required this.currentPage,
      required this.sportName});
}
