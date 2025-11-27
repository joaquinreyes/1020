class PaginationState<T> {
  final List<T> items;
  final int page;
  final bool isLoading;
  final bool mainLoading;
  final bool hasMore;
  final String? error;
  final dynamic extraData;

  PaginationState(
      {required this.items,
      required this.page,
      required this.isLoading,
      required this.mainLoading,
      required this.hasMore,
      this.error,
      this.extraData});

  factory PaginationState.initial() {
    return PaginationState<T>(
      items: [],
      page: 0,
      isLoading: false,
      mainLoading: false,
      hasMore: true,
      error: null,
      extraData: null,
    );
  }

  /// Creates a new state with updated items.
  PaginationState<T> setItems(List<T> newItems) {
    return copyWith(items: newItems);
  }

  PaginationState<T> copyWith({
    List<T>? items,
    int? page,
    bool? isLoading,
    bool? mainLoading,
    bool? hasMore,
    String? error,
    dynamic extraData,
  }) {
    return PaginationState<T>(
        items: items ?? this.items,
        page: page ?? this.page,
        mainLoading: mainLoading ?? this.mainLoading,
        isLoading: isLoading ?? this.isLoading,
        hasMore: hasMore ?? this.hasMore,
        error: error,
        extraData: extraData ?? this.extraData);
  }
}
