part of 'book_court_dialog.dart';

class _OpenMatch extends ConsumerStatefulWidget {
  const _OpenMatch();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __OpenMatchState();
}

class __OpenMatchState extends ConsumerState<_OpenMatch> {
  bool isLevelSelectorVisible = false;
  final TextEditingController leaveNoteController = TextEditingController();
  final FocusNode leaveNoteNode = FocusNode();
  @override
  void initState() {
    Future(() {
      _setupForOpenMatch();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isFriedlyMatch = ref.watch(_isFriendlyMatchProvider);
    final appovePlayers = ref.watch(_isApprovePlayersProvider);
    final matchLevel = ref.watch(_matchLevelProvider);
    final reserveSpotsForMatch = ref.watch(_reserveSpotsForMatchProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 15.h),
        _selectionRowContainer(
          text: "APPROVE_PLAYERS_BEFORE_JOIN".tr(context),
          isSelected: appovePlayers,
          onTap: () {
            ref.read(_isApprovePlayersProvider.notifier).state = !appovePlayers;
          },
        ),
        SizedBox(height: 15.h),
        _selectionRowContainer(
          text: "FRIENDLY_MATCH".tr(context),
          isSelected: isFriedlyMatch,
          onTap: () {
            ref.read(_isFriendlyMatchProvider.notifier).state = !isFriedlyMatch;
          },
        ),
        SizedBox(height: 10.h),
        Text(
          "SELECT_MATCH_LEVEL".trU(context),
          style: AppTextStyles.sofiaSansMedium(
            color: AppColors.white,
            fontSize: 21.sp
          ),
        ),
        SizedBox(height: 5.h),
        InkWell(
          onTap: () {
            setState(() {
              isLevelSelectorVisible = !isLevelSelectorVisible;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white25,
              borderRadius: BorderRadius.circular(100.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (matchLevel.isNotEmpty) ...[
                  Text(
                    "${matchLevel.first} - ${matchLevel.last}",
                    style: AppTextStyles.manropeMedium(
                      color: AppColors.white,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
                const Spacer(),
                Icon(
                  isLevelSelectorVisible
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                  color: AppColors.white,
                  size: 20.h,
                )
              ],
            ),
          ),
        ),
        if (isLevelSelectorVisible) ...[
          _levelSelector(),
        ],
        SizedBox(height: 15.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                "ARE_YOU_GOING_WITH_SOMEONE_ELSE".trU(context),
                style: AppTextStyles.sofiaSansMedium(
                  fontSize: 21.sp,
                  color: AppColors.white,
                ),
              ),
            ),
            Text(
              " ${"OPTIONAL".tr(context).toLowerCase()}",
              style: AppTextStyles.manropeMedium(
                color: AppColors.white,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Container(
          decoration: BoxDecoration(
            // boxShadow: kInsetShadow2,
            color: AppColors.white25,
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
            child: Row(
              children: [
                _optionContainer(
                  text: "1_PLAYER".tr(context),
                  isSelected: reserveSpotsForMatch == 1,
                  onTap: () {
                    if (reserveSpotsForMatch == 1) {
                      ref.read(_reserveSpotsForMatchProvider.notifier).state =
                      0;
                    } else {
                      ref.read(_reserveSpotsForMatchProvider.notifier).state =
                      1;
                    }
                  },
                ),
                _optionContainer(
                  text: "2_PLAYERS".tr(context),
                  isSelected: reserveSpotsForMatch == 2,
                  onTap: () {
                    if (reserveSpotsForMatch == 2) {
                      ref.read(_reserveSpotsForMatchProvider.notifier).state =
                      0;
                    } else {
                      ref.read(_reserveSpotsForMatchProvider.notifier).state =
                      2;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                "LEAVE_A_NOTE".trU(context),
                style: AppTextStyles.sofiaSansMedium(
                  fontSize: 21.sp,
                  color: AppColors.white,
                ),
              ),
            ),
            Text(
              " ${"OPTIONAL".tr(context).toLowerCase()}",
              style: AppTextStyles.manropeMedium(
                color: AppColors.white,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        CustomTextField(
          controller: leaveNoteController,
          node: leaveNoteNode,
          borderRadius: BorderRadius.circular(100.r),
          onChanged: (value) {
            ref.read(_organizerNoteProvider.notifier).state = value;
          },
          hintText: 'TYPE_HERE'.tr(context),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          borderColor: Colors.transparent,
          isForPopup: true,
        ),
      ],
    );
  }
  Widget _selectionRowContainer(
      {required String text,
        required bool isSelected,
        required Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : AppColors.white25,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                text,
                style: AppTextStyles.manropeSemiBold(
                  fontSize: 13.sp,
                  color: isSelected ? AppColors.brick : AppColors.white,
                ),
              ),
            ),
            SelectedTag(isSelected: isSelected,selectedColor: AppColors.yellow,unSelectedColor: AppColors.white25,unSelectedBorderColor: AppColors.white,selectedBorderColor: AppColors.black25,)
          ],
        ),
      ),
    );
  }

  Widget _optionContainer(
      {required String text,
        required bool isSelected,
        required Function()? onTap}) {
    return Expanded(
      flex: 50,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(100.r),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20.h, vertical: 2.w),
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
          child: Center(
              child: Text(
                text,
                style: isSelected
                    ? AppTextStyles.manropeSemiBold(fontSize: 13.sp,color: AppColors.brick,)
                    : AppTextStyles.manropeMedium(color: AppColors.white,fontSize: 13.sp,),
              )),
        ),
      ),
    );
  }

  Widget _levelSelector() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...levelsList.map(
              (e) {
            bool isSelected = ref.watch(_matchLevelProvider).contains(e);
            return Padding(
              padding: EdgeInsets.only(top: 2.h, left: 2.w, right: 2.w),
              child: InkWell(
                onTap: () {
                  final appUser = ref.watch(userProvider);

                  final userLevel =
                      appUser?.user?.level(getSportsName(ref)) ?? 0.0;
                  if (userLevel == e) {
                    return;
                  }
                  setState(() {
                    final matchLevel = ref.read(_matchLevelProvider);
                    if (matchLevel.contains(e)) {
                      ref.read(_matchLevelProvider.notifier).state =
                          matchLevel.where((element) => element != e).toList();

                      ref.read(_matchLevelProvider.notifier).state.sort();
                    } else {
                      ref.read(_matchLevelProvider.notifier).state = [
                        ...matchLevel,
                        e,
                      ];
                      ref.read(_matchLevelProvider.notifier).state.sort();
                    }
                  });
                },
                child: Container(
                  padding:
                  EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.white
                        : AppColors.white25,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    e.toString(),
                    style: isSelected ? AppTextStyles.manropeSemiBold(color: AppColors.brick,fontSize: 13.sp,) : AppTextStyles.manropeMedium(fontSize: 13.sp,color: AppColors.white,),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _setupForOpenMatch() {
    final userLevel =
        ref.read(userProvider)?.user?.level(getSportsName(ref)) ?? 0.0;
    List<double> matchLevelToShowIn = [userLevel];
    if (userLevel > 0) {
      matchLevelToShowIn.add(userLevel - 0.5);
    }
    if (userLevel < 7.0) {
      matchLevelToShowIn.add(userLevel + 0.5);
    }
    matchLevelToShowIn.sort();
    ref.read(_matchLevelProvider.notifier).state = matchLevelToShowIn;
  }
}

// class _OpenMatch extends ConsumerStatefulWidget {
//   final bool allowAddPlayer;
//
//   const _OpenMatch({required this.allowAddPlayer});
//
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => __OpenMatchState();
// }
//
// class __OpenMatchState extends ConsumerState<_OpenMatch> {
//   final TextEditingController leaveNoteController = TextEditingController();
//   final FocusNode leaveNoteNode = FocusNode();
//
//   @override
//   void initState() {
//     Future(() {
//       _setupForOpenMatch();
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isFriedlyMatch = ref.watch(_isFriendlyMatchProvider);
//     final isPrivateMatch = ref.watch(_isPrivateMatchProvider);
//     // final isDUPRMatch = ref.watch(_isDUPRMatchProvider);
//     final appovePlayers = ref.watch(_isApprovePlayersProvider);
//     final matchLevel = ref.watch(_matchLevelProvider);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // HIDDEN: Approve players - always enabled by default
//         // InkWell(
//         //   onTap: () {
//         //     ref.read(_isApprovePlayersProvider.notifier).state = !appovePlayers;
//         //   },
//         //   child: Container(
//         //     decoration: BoxDecoration(
//         //       color: appovePlayers ? AppColors.darkYellow50 : AppColors.black25,
//         //       borderRadius: BorderRadius.circular(12.r),
//         //     ),
//         //     child: Padding(
//         //       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//         //       child: Row(
//         //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //         children: [
//         //           Text(
//         //             "APPROVE_PLAYERS_BEFORE_JOIN".tr(context),
//         //             style: AppTextStyles.qanelasSemiBold(
//         //                 color:
//         //                     appovePlayers ? AppColors.black2 : AppColors.black2,
//         //                 fontSize: 13.sp),
//         //           ),
//         //           SelectedTag(
//         //             isSelected: appovePlayers,
//         //             unSelectedBorderColor: AppColors.white,
//         //             unSelectedColor: Colors.transparent,
//         //             shape: BoxShape.circle,
//         //             selectedColor: AppColors.darkYellow,
//         //             selectedBorderColor: AppColors.black25,
//         //           )
//         //         ],
//         //       ),
//         //     ),
//         //   ),
//         // ),
//
//         // HIDDEN: Friendly Match - always ranked (not friendly)
//         // InkWell(
//         //   onTap: () {
//         //     ref.read(_isFriendlyMatchProvider.notifier).state = !isFriedlyMatch;
//         //   },
//         //   child: Container(
//         //     decoration: BoxDecoration(
//         //       color:
//         //           isFriedlyMatch ? AppColors.darkYellow50 : AppColors.black25,
//         //       borderRadius: BorderRadius.circular(12.r),
//         //     ),
//         //     child: Padding(
//         //         padding:
//         //             const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         //         child: Row(
//         //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //           children: [
//         //             Text(
//         //               "FRIENDLY_MATCH".tr(context),
//         //               style: AppTextStyles.qanelasSemiBold(
//         //                   color: isFriedlyMatch
//         //                       ? AppColors.black2
//         //                       : AppColors.black2,
//         //                   fontSize: 13.sp),
//         //             ),
//         //             SelectedTag(
//         //               isSelected: isFriedlyMatch,
//         //               unSelectedBorderColor: AppColors.white,
//         //               unSelectedColor: Colors.transparent,
//         //               shape: BoxShape.circle,
//         //               selectedColor: AppColors.darkYellow,
//         //               selectedBorderColor: AppColors.black25,
//         //             )
//         //           ],
//         //         )),
//         //   ),
//         // ),
//
//         // Match level selector - HIDDEN
//         // Row(
//         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //   children: [
//         //     Text(
//         //       "SELECT_MATCH_LEVEL".tr(context),
//         //       style: AppTextStyles.qanelasMedium(
//         //           color: AppColors.black2, fontSize: 16.sp),
//         //     ),
//         //     Text(
//         //       matchLevel.isNotEmpty
//         //           ? "${matchLevel.first.toStringAsFixed(2)} - ${matchLevel.last.toStringAsFixed(2)}"
//         //           : "0.00 - 7.00",
//         //       style: AppTextStyles.qanelasMedium(
//         //           color: AppColors.black2, fontSize: 16.sp),
//         //     ),
//         //   ],
//         // ),
//         // SizedBox(height: 10.h),
//         // // Range Slider for match level
//         // SliderTheme(
//         //   data: SliderThemeData(
//         //     activeTrackColor: AppColors.darkYellow,
//         //     inactiveTrackColor: AppColors.black25,
//         //     thumbColor: AppColors.darkYellow,
//         //     overlayColor: AppColors.darkYellow.withOpacity(0.2),
//         //     trackHeight: 4.h,
//         //     thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.h),
//         //     overlayShape: RoundSliderOverlayShape(overlayRadius: 20.h),
//         //   ),
//         //   child: RangeSlider(
//         //     values: RangeValues(
//         //       matchLevel.isNotEmpty ? matchLevel.first : 0.0,
//         //       matchLevel.isNotEmpty ? matchLevel.last : 7.0,
//         //     ),
//         //     min: 0.0,
//         //     max: 7.0,
//         //     divisions: 140, // 7.0 * 20 = 140 divisions for 0.05 increments
//         //     onChanged: (RangeValues values) {
//         //       setState(() {
//         //         ref.read(_matchLevelProvider.notifier).state = [
//         //           values.start,
//         //           values.end,
//         //         ];
//         //       });
//         //     },
//         //   ),
//         // ),
//         // SizedBox(height: 15.h),
//
//         if (widget.allowAddPlayer) ...[
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Expanded(
//                 child: Text(
//                   "ARE_YOU_GOING_WITH_SOMEONE_ELSE".tr(context),
//                   style: AppTextStyles.sofiaSansMedium(
//                       color: AppColors.black2, fontSize: 15.sp),
//                 ),
//               ),
//               Text(
//                 " ${"OPTIONAL".tr(context).toLowerCase()}",
//                 style: AppTextStyles.manropeMedium(
//                     color: AppColors.black2, fontSize: 13.sp),
//               ),
//             ],
//           ),
//           SizedBox(height: 5.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Flexible(
//                 child: OpenMatchParticipantRowWithBG(
//                   allowTap: false,
//                   textForAvailableSlot: "ADD".trU(context),
//                   players: _buildPlayersList(),
//                   slotIconColor: AppColors.white,
//                   backgroundColor: AppColors.tileBgColor,
//                   slotBackgroundColor: AppColors.black2,
//                   imageBgColor: AppColors.black2,
//                   onTap: (slotIndex, otherPlayerID) async {
//                     await _showPlayerSelectionDialog(context, slotIndex);
//                   },
//                   showReserveReleaseButton: true,
//                   alreadyReserved: true,
//                   currentPlayerID: ref.read(userProvider)?.user?.id ?? -1,
//                   onRelease: (playerID) {
//                     _handleRemovePlayer(playerID);
//                   },
//                   maxPlayers: 4,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 15.h),
//         ],
//       ],
//     );
//   }
//
//   void _handleRemovePlayer(int playerID) {
//     final currentPlayers = ref.read(_selectedPlayersProvider);
//
//     // Remove the player with matching ID
//     final updatedPlayers =
//         currentPlayers.where((p) => p.id != playerID).toList();
//
//     // Update state
//     ref.read(_selectedPlayersProvider.notifier).state = updatedPlayers;
//
//     // Refresh UI
//     setState(() {});
//   }
//
//   List<BookingPlayerBase> _buildPlayersList() {
//     final currentUser = ref.watch(userProvider)?.user;
//     final selectedPlayers = ref.watch(_selectedPlayersProvider);
//
//     final List<BookingPlayerBase> playersList = [];
//
//     // Always add current user in first position
//     if (currentUser != null) {
//       final currentUserPlayer = BookingPlayerBase(
//         id: currentUser.id,
//         customer: BookingCustomerBase(
//           id: currentUser.id,
//           firstName: currentUser.firstName,
//           lastName: currentUser.lastName,
//           profileUrl: currentUser.profileUrl,
//         ),
//         position: 1,
//         isOrganizer: true,
//       );
//       playersList.add(currentUserPlayer);
//     }
//
//     // Add selected players in subsequent positions
//     for (var i = 0; i < selectedPlayers.length; i++) {
//       final player = selectedPlayers[i];
//       playersList.add(player);
//     }
//
//     return playersList;
//   }
//
//   Future<void> _showPlayerSelectionDialog(
//       BuildContext context, int slotIndex) async {
//     await showDialog(
//       context: context,
//       builder: (context) => _AddPlayersDialog(
//         currentPlayersList: _buildPlayersList(),
//       ),
//     );
//   }
//
//   void _setupForOpenMatch() {
//     final userLevel =
//         ref.read(userProvider)?.user?.level(getSportsName(ref)) ?? 0.0;
//     List<double> matchLevelToShowIn = [userLevel];
//     if (userLevel > 0) {
//       matchLevelToShowIn.add(userLevel - 0.5);
//     }
//     if (userLevel < 7.0) {
//       matchLevelToShowIn.add(userLevel + 0.5);
//     }
//     matchLevelToShowIn.sort();
//     ref.read(_matchLevelProvider.notifier).state = matchLevelToShowIn;
//   }
// }

class _AddPlayersDialog extends ConsumerStatefulWidget {
  const _AddPlayersDialog({required this.currentPlayersList});

  final List<BookingPlayerBase> currentPlayersList;

  @override
  ConsumerState<_AddPlayersDialog> createState() => _AddPlayersDialogState();
}

class _AddPlayersDialogState extends ConsumerState<_AddPlayersDialog> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final Debouncer _debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  String searchQuery = '';
  bool isSearching = false;
  List<User> searchResultsList = [];
  bool isLoadingSearch = false;
  bool isLoadingMore = false;
  String? searchError;
  int currentPage = 1;
  int totalPages = 1;
  bool hasMoreResults = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    searchController.dispose();
    scrollController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100) {
      if (isSearching && hasMoreResults && !isLoadingMore && !isLoadingSearch) {
        _loadMoreResults();
      }
    }
  }

  Future<void> _loadMoreResults() async {
    if (currentPage >= totalPages || searchQuery.isEmpty) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      final nextPage = currentPage + 1;
      final response = await ref.read(searchUsersProvider(
        page: nextPage,
        pageSize: 30,
        search: searchQuery,
      ).future);

      if (mounted && response.data?.customers != null) {
        setState(() {
          searchResultsList.addAll(response.data!.customers!);
          currentPage = nextPage;
          totalPages = response.data?.totalPages ?? 1;
          hasMoreResults = currentPage < totalPages;
          isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value.toLowerCase();
      isSearching = value.isNotEmpty;
    });

    if (value.isEmpty) {
      setState(() {
        searchResultsList = [];
        isLoadingSearch = false;
        searchError = null;
        currentPage = 1;
        totalPages = 1;
        hasMoreResults = false;
      });
      return;
    }

    setState(() {
      isLoadingSearch = true;
      searchError = null;
    });

    _debouncer.run(() {
      _performSearch(value);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    try {
      final response = await ref.read(searchUsersProvider(
        page: 1,
        pageSize: 30,
        search: query,
      ).future);

      if (mounted) {
        setState(() {
          searchResultsList = response.data?.customers ?? [];
          currentPage = response.data?.currentPage ?? 1;
          totalPages = response.data?.totalPages ?? 1;
          hasMoreResults = currentPage < totalPages;
          isLoadingSearch = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          searchError = e.toString();
          isLoadingSearch = false;
        });
      }
    }
  }

  void _handleRemovePlayer(int playerID) {
    final currentPlayers = ref.read(_selectedPlayersProvider);

    // Remove the player with matching ID
    final updatedPlayers =
        currentPlayers.where((p) => p.id != playerID).toList();

    // Update state
    ref.read(_selectedPlayersProvider.notifier).state = updatedPlayers;

    // Refresh UI
    setState(() {});
  }

  Future<void> _handleAddPlayer(Following following) async {
    final currentPlayers = ref.read(_selectedPlayersProvider);
    final currentUser = ref.read(userProvider)?.user;

    // Check if max players reached (current user + 3 others = 4 total)
    if (currentPlayers.length >= 3) {
      return;
    }

    // Build current players list for position selection
    final List<BookingPlayerBase> playersForDisplay = [];

    // Add current user in position 1
    if (currentUser != null) {
      playersForDisplay.add(BookingPlayerBase(
        id: currentUser.id,
        customer: BookingCustomerBase(
          id: currentUser.id,
          firstName: currentUser.firstName,
          lastName: currentUser.lastName,
          profileUrl: currentUser.profileUrl,
        ),
        position: 1,
        isOrganizer: true,
      ));
    }

    // Add selected players - preserve their positions
    for (var i = 0; i < currentPlayers.length; i++) {
      final player = currentPlayers[i];
      // Don't modify position - keep the user's selected position
      playersForDisplay.add(player);
    }

    // Show position selection dialog
    final result = await showDialog<(int, int?)>(
      context: context,
      builder: (context) {
        return _PositionSelectionDialog(
          players: playersForDisplay,
        );
      },
    );

    if (result != null) {
      final (int selectedIndex, int? otherPlayerID) = result;

      // Convert Following to BookingPlayerBase
      final newPlayer = BookingPlayerBase(
        id: following.id,
        customer: BookingCustomerBase(
          id: following.following?.id,
          firstName: following.following?.firstName,
          lastName: following.following?.lastName,
          profileUrl: following.following?.profileUrl,
        ),
        position: selectedIndex + 1,
      );

      // Add to state
      final updatedPlayers = [...currentPlayers, newPlayer];
      ref.read(_selectedPlayersProvider.notifier).state = updatedPlayers;

      // Refresh the UI
      setState(() {});
    }
  }

  List<BookingPlayerBase> _buildCurrentPlayersList() {
    final currentUser = ref.watch(userProvider)?.user;
    final selectedPlayers = ref.watch(_selectedPlayersProvider);

    final List<BookingPlayerBase> playersList = [];

    // Always add current user in first position
    if (currentUser != null) {
      final currentUserPlayer = BookingPlayerBase(
        id: currentUser.id,
        customer: BookingCustomerBase(
          id: currentUser.id,
          firstName: currentUser.firstName,
          lastName: currentUser.lastName,
          profileUrl: currentUser.profileUrl,
        ),
        position: 1,
        isOrganizer: true,
      );
      playersList.add(currentUserPlayer);
    }

    // Add selected players - preserve their selected positions
    for (var i = 0; i < selectedPlayers.length; i++) {
      final player = selectedPlayers[i];
      // Don't overwrite position - keep the user's selected position
      playersList.add(player);
    }

    return playersList;
  }

  @override
  Widget build(BuildContext context) {
    final followingList = ref.watch(getFollowingListProvider);
    final currentPlayers = ref.watch(_selectedPlayersProvider);
    final displayPlayersList = _buildCurrentPlayersList();

    return CustomDialog(
      color: AppColors.white,
      closeIconColor: AppColors.black2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "ADD_PLAYERS".trU(context),
            style: AppTextStyles.sofiaSansMedium(
              fontSize: 19.sp,
              color: AppColors.black2,
            ),
          ),

          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: OpenMatchParticipantRowWithBG(
              textForAvailableSlot: "AVAILABLE".trU(context),
              players: displayPlayersList,
              backgroundColor: AppColors.transparentColor,
              textColor: AppColors.black2,
              slotBackgroundColor: AppColors.black2,
              imageBgColor: AppColors.white,
              imageLogoColor: AppColors.black2,
              slotIconColor: AppColors.white,
              allowTap: false,
              showReserveReleaseButton: true,
              alreadyReserved: true,
              currentPlayerID: ref.read(userProvider)?.user?.id ?? -1,
              onRelease: (playerID) {
                _handleRemovePlayer(playerID);
              },
            ),
          ),
          SizedBox(height: 10.h),
          // Search field section
          Container(
            decoration: BoxDecoration(
              color: AppColors.black2.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: SecondaryTextField(
              prefixIconConstraints:
                  BoxConstraints.tightFor(width: 25.h, height: 12.h),
              prefixIcon: Icon(Icons.search, color: AppColors.black50),
              controller: searchController,
              hintText: "SEARCH".tr(context),
              style: AppTextStyles.manropeMedium(
                color: AppColors.black2,
                fontSize: 13.sp,
              ),
              hintTextStyle: AppTextStyles.manropeMedium(
                color: AppColors.black2,
                fontSize: 13.sp,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              borderColor: AppColors.transparentColor,
              onChanged: _onSearchChanged,
            ),
          ),
          SizedBox(height: 15.h),
          // Show loading indicator while searching
          if (isLoadingSearch)
            SizedBox(
              height: 100.h,
              child: const Center(
                child: CupertinoActivityIndicator(
                  radius: 12,
                  color: AppColors.black2,
                ),
              ),
            ),
          // Show search error if any
          if (searchError != null && !isLoadingSearch)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: Text(
                  searchError ?? "",
                  style: AppTextStyles.manropeMedium(
                    fontSize: 14.sp,
                    color: AppColors.black2,
                  ),
                ),
              ),
            ),
          // Show search results if searching
          if (isSearching && !isLoadingSearch && searchError == null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SEARCH_RESULTS".tr(context),
                  style: AppTextStyles.sofiaSansMedium(
                    fontSize: 16.sp,
                    color: AppColors.black2,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildSearchResults(currentPlayers),
              ],
            ),
          // Show following list if not searching
          if (!isSearching && !isLoadingSearch)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "FOLLOWING".tr(context),
                  style: AppTextStyles.sofiaSansMedium(
                    fontSize: 16.sp,
                    color: AppColors.black2,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildFollowingList(followingList, currentPlayers),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFollowingList(
      AsyncValue<FollowList> followingList, List<BookingPlayerBase> currentPlayers) {
    return followingList.when(
            data: (data) {
              if (data.following == null || data.following!.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Text(
                    "NO_FOLLOWING_FOUND".tr(context),
                    style: AppTextStyles.manropeMedium(
                      fontSize: 14.sp,
                      color: AppColors.black2,
                    ),
                  ),
                );
              }

              final filteredFollowing = data.following!.where((following) {
                if (searchQuery.isEmpty) return true;
                final fullName =
                    following.following?.fullName.toLowerCase() ?? '';
                return fullName.contains(searchQuery);
              }).toList();

              if (filteredFollowing.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Text(
                    "NO_RESULTS_FOUND".tr(context),
                    style: AppTextStyles.manropeMedium(
                      fontSize: 14.sp,
                      color: AppColors.black2,
                    ),
                  ),
                );
              }

              return Container(
                constraints: BoxConstraints(maxHeight: 300.h),
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thumbColor: WidgetStateProperty.all(AppColors.darkGray50),
                    trackColor: WidgetStateProperty.all(AppColors.white),
                    trackBorderColor:
                        WidgetStateProperty.all(Colors.transparent),
                    thickness: WidgetStateProperty.all(8),
                    radius: Radius.circular(4.r),
                  ),
                  child: Scrollbar(
                    controller: scrollController,
                    interactive: true,
                    trackVisibility: true,
                    thumbVisibility: true,
                    child: ListView.separated(
                      shrinkWrap: true,
                      controller: scrollController,
                      padding: EdgeInsets.only(right: 15.w),
                      itemCount: filteredFollowing.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final following = filteredFollowing[index];
                        final isAlreadyAdded = currentPlayers.any(
                          (p) => p.customer?.id == following.following?.id,
                        );
                        return _PlayerItem(
                          following: following,
                          isAdded: isAlreadyAdded,
                          onTap: isAlreadyAdded
                              ? null
                              : () => _handleAddPlayer(following),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
            loading: () => SizedBox(
              height: 100.h,
              child: const Center(
                child: CupertinoActivityIndicator(
                  radius: 12,
                  color: AppColors.black2,
                ),
              ),
            ),
            error: (error, stack) => Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Text(
                "ERROR_LOADING_FOLLOWING".tr(context),
                style: AppTextStyles.manropeMedium(
                  fontSize: 14.sp,
                  color: AppColors.black2,
                ),
              ),
            ),
          );
  }

  Widget _buildSearchResults(List<BookingPlayerBase> currentPlayers) {
    if (searchResultsList.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: Text(
            "NO_USERS_FOUND".tr(context),
            style: AppTextStyles.manropeMedium(
              fontSize: 14.sp,
              color: AppColors.black2,
            ),
          ),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 300.h),
      child: ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(AppColors.darkGray50),
          trackColor: WidgetStateProperty.all(AppColors.white),
          trackBorderColor: WidgetStateProperty.all(Colors.transparent),
          thickness: WidgetStateProperty.all(8),
          radius: Radius.circular(4.r),
        ),
        child: Scrollbar(
          controller: scrollController,
          interactive: true,
          trackVisibility: true,
          thumbVisibility: true,
          child: ListView.separated(
            shrinkWrap: true,
            controller: scrollController,
            padding: EdgeInsets.only(right: 15.w),
            itemCount: searchResultsList.length + (isLoadingMore ? 1 : 0),
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              if (index == searchResultsList.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: const Center(
                    child: CupertinoActivityIndicator(
                      radius: 10,
                      color: AppColors.black2,
                    ),
                  ),
                );
              }
              final user = searchResultsList[index];
              final isAlreadyAdded = currentPlayers.any(
                (p) => p.customer?.id == user.id,
              );
              return _SearchPlayerItem(
                user: user,
                isAdded: isAlreadyAdded,
                onTap: isAlreadyAdded ? null : () => _handleAddSearchUser(user),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddSearchUser(User user) async {
    final currentPlayers = ref.read(_selectedPlayersProvider);
    final currentUser = ref.read(userProvider)?.user;

    // Check if max players reached (current user + 3 others = 4 total)
    if (currentPlayers.length >= 3) {
      return;
    }

    // Build current players list for position selection
    final List<BookingPlayerBase> playersForDisplay = [];

    // Add current user in position 1
    if (currentUser != null) {
      playersForDisplay.add(BookingPlayerBase(
        id: currentUser.id,
        customer: BookingCustomerBase(
          id: currentUser.id,
          firstName: currentUser.firstName,
          lastName: currentUser.lastName,
          profileUrl: currentUser.profileUrl,
        ),
        position: 1,
        isOrganizer: true,
      ));
    }

    // Add selected players - preserve their positions
    for (var i = 0; i < currentPlayers.length; i++) {
      final player = currentPlayers[i];
      playersForDisplay.add(player);
    }

    // Show position selection dialog
    final result = await showDialog<(int, int?)>(
      context: context,
      builder: (context) {
        return _PositionSelectionDialog(
          players: playersForDisplay,
        );
      },
    );

    if (result != null) {
      final (int selectedIndex, int? otherPlayerID) = result;

      // Convert User to BookingPlayerBase
      final newPlayer = BookingPlayerBase(
        id: user.id,
        customer: BookingCustomerBase(
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          profileUrl: user.profileUrl,
        ),
        position: selectedIndex + 1,
      );

      // Add to state
      final updatedPlayers = [...currentPlayers, newPlayer];
      ref.read(_selectedPlayersProvider.notifier).state = updatedPlayers;

      // Refresh the UI
      setState(() {});
    }
  }
}

class _PositionSelectionDialog extends StatelessWidget {
  const _PositionSelectionDialog({required this.players});

  final List<BookingPlayerBase> players;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      color: AppColors.white,
      closeIconColor: AppColors.black2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "CHOOSE_YOUR_SPOT".trU(context),
              style: AppTextStyles.sofiaSansMedium(
                fontSize: 19.sp,
                color: AppColors.black2,
              ),
            ),
            SizedBox(height: 20.h),
            OpenMatchParticipantRowWithBG(
              textForAvailableSlot: "RESERVE".trU(context),
              players: players,
              allowTap: false,
              backgroundColor: AppColors.black25,
              textColor: AppColors.black2,
              slotBackgroundColor: AppColors.black2,
              imageBgColor: AppColors.white,
              imageLogoColor: AppColors.black2,
              slotIconColor: AppColors.white,
              onTap: (index, playerID) {
                Navigator.pop(context, (index, playerID));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerItem extends StatelessWidget {
  final Following following;
  final VoidCallback? onTap;
  final bool isAdded;

  const _PlayerItem({
    required this.following,
    required this.onTap,
    this.isAdded = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          NetworkCircleImage(
            path: following.following?.profileUrl,
            width: 40.h,
            height: 40.h,
            showBG: true,
            bgColor: AppColors.black2,
            logoColor: AppColors.white,
            borderRadius: BorderRadius.circular(8.r),
            applyShadow: false,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              following.following?.fullName.toUpperCase() ?? "",
              style: AppTextStyles.sofiaSansMedium(
                fontSize: 12.sp,
                color: AppColors.black2,
              ),
            ),
          ),
          Container(
            height: 24.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: isAdded ? AppColors.black25 : AppColors.yellow,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: isAdded ? [] : [kBoxShadow],
            ),
            alignment: Alignment.center,
            child: Text(
              isAdded ? "ADDED".trU(context) : "ADD".trU(context),
              style: AppTextStyles.manropeMedium(
                fontSize: 13.sp,
                color: AppColors.black2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchPlayerItem extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final bool isAdded;

  const _SearchPlayerItem({
    required this.user,
    required this.onTap,
    this.isAdded = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          NetworkCircleImage(
            path: user.profileUrl,
            width: 40.h,
            height: 40.h,
            showBG: true,
            bgColor: AppColors.black2,
            logoColor: AppColors.white,
            borderRadius: BorderRadius.circular(8.r),
            applyShadow: false,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              user.fullName.toUpperCase(),
              style: AppTextStyles.sofiaSansMedium(
                fontSize: 12.sp,
                color: AppColors.black2,
              ),
            ),
          ),
          Container(
            height: 24.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: isAdded ? AppColors.black25 : AppColors.yellow,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: isAdded ? [] : [kBoxShadow],
            ),
            alignment: Alignment.center,
            child: Text(
              isAdded ? "ADDED".trU(context) : "ADD".trU(context),
              style: AppTextStyles.manropeMedium(
                fontSize: 13.sp,
                color: AppColors.black2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Payment info dialogs

class _PayMyShareInfoDialog extends StatelessWidget {
  const _PayMyShareInfoDialog({required this.bookingTime});

  final DateTime bookingTime;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      color: AppColors.white,
      closeIconColor: AppColors.black2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 26.w,
                height: 26.h,
                child: Image.asset(
                  'assets/images/pay_my_share_icon.png',
                  width: 26.w,
                  height: 26.h,
                  color: AppColors.black2,
                ),
              ),
              SizedBox(width: 15.w),
              Text(
                "Pay My Share",
                style: AppTextStyles.sofiaSansMedium(
                  fontSize: 19.sp,
                  color: AppColors.black2,
                ),
              ),
            ],
          ),

          SizedBox(height: 15.h),
          // Info box
          Container(
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
                color: AppColors.yellow30,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [kBoxShadow],
                border: Border.all(color: AppColors.black2.withOpacity(.05))),
            child: Column(
              children: [
                Text(
                  "We will put on hold the remaining amount of the booking until all players pay their share.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.manropeMedium(
                    fontSize: 15.sp,
                    color: AppColors.black2,
                  ),
                ),
                SizedBox(height: 10.h),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.manropeMedium(
                      fontSize: 15.sp,
                      color: AppColors.black2,
                    ),
                    children: [
                      const TextSpan(
                          text: "If other players do not pay before "),
                      TextSpan(
                        text:
                            "${DateFormat('dd MMMM HH:mm').format(bookingTime.add(Duration(hours: 2)))}",
                        style: AppTextStyles.manropeBold(
                          fontSize: 15.sp,
                          color: AppColors.black2,
                        ),
                      ),
                      const TextSpan(
                          text: " you will be charged the remaining amount."),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          MainButton(
            label: "PROCEED_WITH_PAYMENT".trU(context),
            isForPopup: true,
            onTap: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}

class _AddOtherPlayersInfoDialog extends StatelessWidget {
  const _AddOtherPlayersInfoDialog();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      color: AppColors.white,
      closeIconColor: AppColors.black2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 26.w,
                height: 26.h,
                child: Icon(
                  Icons.person_add_outlined,
                  color: AppColors.black2,
                  size: 30.h,
                ),
              ),
              SizedBox(width: 15.w),
              Text(
                "ADD_OTHER_PLAYERS".trU(context),
                style: AppTextStyles.sofiaSansMedium(
                  fontSize: 19.sp,
                  color: AppColors.black2,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          // Info box
          Container(
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
                color: AppColors.yellow30,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [kBoxShadow],
                border: Border.all(color: AppColors.black2.withOpacity(.05))),
            child: Column(
              children: [
                Text(
                  "You can add other players to the match and each player will pay their own slot.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.manropeMedium(
                    fontSize: 15.sp,
                    color: AppColors.black2,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "If any spot remains unpaid within two hours after the game, the pending amount will be charged to you.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.manropeMedium(
                    fontSize: 15.sp,
                    color: AppColors.black2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          MainButton(
            label: "ADD_PLAYERS".trU(context),
            isForPopup: true,
            onTap: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}

// Widget _selectionRowContainer(
//     {required String text,
//     required bool isSelected,
//     required Function()? onTap,
//     BoxShape? shape}) {
//   return InkWell(
//     onTap: onTap,
//     child: Container(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: AppColors.white,
//             width: 1.h,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           Text(
//             text,
//             style: AppTextStyles.aeonikBold13.copyWith(
//               color: AppColors.white,
//             ),
//           ),
//           const Spacer(),
//           SelectedTag(
//             isSelected: isSelected,
//             unSelectedBorderColor: AppColors.white,
//             unSelectedColor: AppColors.white25,
//             shape: shape != null ? shape : BoxShape.rectangle,
//           )
//         ],
//       ),
//     ),
//   );
// }
