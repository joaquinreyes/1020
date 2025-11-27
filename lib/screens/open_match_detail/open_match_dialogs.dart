part of 'open_match_detail.dart';

class OpenMatchChooseSpotDialog extends StatelessWidget {
  const OpenMatchChooseSpotDialog({super.key, required this.players});

  final List<BookingPlayerBase> players;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        // contentPadding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 30.h),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w,),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "CHOOSE_YOUR_SPOT".trU(context),
                style: AppTextStyles.popupHeaderTextStyle,
              ),
              SizedBox(height: 20.h),
              OpenMatchParticipantRowWithBG(
                textForAvailableSlot: "RESERVE".trU(context),
                players: players,
                backgroundColor: AppColors.white25,
                textColor: AppColors.white,
                slotBackgroundColor: AppColors.yellow,
                imageBgColor: AppColors.white,
                imageLogoColor: AppColors.brick,
                slotIconColor: AppColors.brick,
                onTap: (index, playerID) {
                  Navigator.pop(context, (index, playerID));
                },
              ),
            ],
          ),
        ));
  }
}

class _WaitingForApprovalDialog extends ConsumerStatefulWidget {
  const _WaitingForApprovalDialog({required this.serviceID});

  final int serviceID;

  @override
  ConsumerState<_WaitingForApprovalDialog> createState() =>
      _WaitingForApprovalDialogState();
}

class _WaitingForApprovalDialogState
    extends ConsumerState<_WaitingForApprovalDialog> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(fetchServiceWaitingPlayersProvider(
        widget.serviceID, RequestServiceType.booking));
    return CustomDialog(
      contentPadding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 45.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "YOU_ARE_NOW_WAITING_FOR_APPROVAL".trU(context),
            style: AppTextStyles.popupHeaderTextStyle,
            textAlign: TextAlign.center,
          ),
          provider.when(
            data: (data) {
              final currentPlayerID = ref.read(userProvider)?.user?.id;
              data.removeWhere(
                  (element) => element.customer?.id == currentPlayerID);
              if (data.isEmpty) {
                return Container();
              }
              return Column(
                children: [
                  SizedBox(height: 5.h),
                  Text(
                    "HERE_ARE_OTHER_PLAYERS_WAITING_FOR_APPROVAL".tr(context),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.popupBodyTextStyle.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < min(data.length, 4); i++) ...[
                        Column(
                          children: [
                            NetworkCircleImage(
                                path: data[i].customer?.profileUrl,
                                width: 40.w,
                                height: 40.w),
                            Text(
                              data[i].getCustomerName,
                              style: AppTextStyles.manropeBold(),
                            ),
                            Text(
                              "${data[i].customer?.level(getSportsName(ref))}",
                              // •  Right",
                              style: AppTextStyles.manropeBold(
                                height: 0.9,
                              ),
                            ),
                          ],
                        )
                      ]
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              );
            },
            error: (error, stackTrace) => Container(),
            loading: () => Container(),
          ),
        ],
      ),
    );
  }
}

enum ConfirmationDialogType {
  join,
  reserve,
  leave,
  cancel,
  approvalNeeded,
  approveConfirm,
  releaseReserve,
  withdraw,
}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog(
      {super.key, required this.type, this.boldPosition, this.policy});

  final ConfirmationDialogType type;
  final int? boldPosition;
  final CancellationPolicy? policy;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 5.h,
          ),
          Text(
            _headingText(context),
            style: AppTextStyles.popupHeaderTextStyle,
            textAlign: TextAlign.center,
          ),
          if (type != ConfirmationDialogType.withdraw) ...[
            SizedBox(height: 20.h),
            Text(_descText(context),
                textAlign: TextAlign.center,
                style: AppTextStyles.popupBodyTextStyle,),
          ],
          if (type == ConfirmationDialogType.join ||
              type == ConfirmationDialogType.leave ||
              type == ConfirmationDialogType.cancel) ...[
            RefundDescriptionComponent(
                policy: policy,
                text: type == ConfirmationDialogType.join
                    ? "CANCELLATION_POLICY".tr(context)
                    : null,
                style: AppTextStyles.popupBodyTextStyle,)
          ],
          SizedBox(height: 20.h),
          MainButton(
            isForPopup: true,
            // color: AppColors.rosewood,
            label: _buttonText(context).toString().toUpperCase(),
            // child: Text(
            //   _buttonText(context).toString().toUpperCase(),
            //   style: AppTextStyles.gothicRegular(fontSize: 19.sp, color: AppColors.white, letterSpacing: 1.2),
            // ),
            // labelStyle: AppTextStyles.qanelasRegular(
            //     fontSize: 19.sp,
            //     color: AppColors.white,
            //     letterSpacing: 19.sp * 0.12),
            onTap: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    );
  }

  _headingText(BuildContext context) {
    switch (type) {
      case ConfirmationDialogType.cancel:
        return "ARE_YOU_SURE_YOU_WANT_TO_CANCEL_THIS_MATCH".trU(context);
      case ConfirmationDialogType.join:
        return "ARE_YOU_SURE_YOU_WANT_TO_JOIN_THE_MATCH".trU(context);
      case ConfirmationDialogType.reserve:
        return "ARE_YOU_SURE_YOU_WANT_TO_RESERVE_THIS_SPOT".trU(context);
      case ConfirmationDialogType.leave:
        return "ARE_YOU_SURE_YOU_WANT_TO_LEAVE_THIS_OPEN_MATCH".trU(context);
      case ConfirmationDialogType.approvalNeeded:
        return "NEEDS_ORGANIZER_APPROVAL".trU(context);
      case ConfirmationDialogType.approveConfirm:
        return "ARE_YOU_SURE_YOU_WANT_TO_APPROVE_THIS_PLAYER".trU(context);
      case ConfirmationDialogType.releaseReserve:
        return "ARE_YOU_SURE_YOU_WANT_TO_RELEASE_THIS_RESERVE".trU(context);
      case ConfirmationDialogType.withdraw:
        return "ARE_YOU_SURE_YOU_WANT_TO_WITHDRAW_FROM_THE_MATCH".trU(context);
    }
  }

  _buttonText(BuildContext context) {
    switch (type) {
      case ConfirmationDialogType.cancel:
        return "CANCEL_MATCH".tr(context);
      case ConfirmationDialogType.join:
        return "JOIN_PAY_MY_SHARE".tr(context);
      case ConfirmationDialogType.reserve:
        return "RESERVE_PAY_SLOT".tr(context);
      case ConfirmationDialogType.leave:
        return "LEAVE_OPEN_MATCH".tr(context);
      case ConfirmationDialogType.approvalNeeded:
        return "APPLY_TO_OPEN_MATCH".tr(context);
      case ConfirmationDialogType.approveConfirm:
        return "APPROVE_PLAYER".tr(context);
      case ConfirmationDialogType.releaseReserve:
        return "YES_RELEASE_THIS_SPOT".tr(context);
      case ConfirmationDialogType.withdraw:
        return "YES_WITHDRAW".tr(context);
    }
  }

  _descText(BuildContext context) {
    switch (type) {
      case ConfirmationDialogType.join:
        return "IF_YOU_JOIN_DESC".tr(context);
      case ConfirmationDialogType.leave:
        return "IF_YOU_LEAVE_DESC".tr(context);
      case ConfirmationDialogType.cancel:
        return "IF_YOU_CANCEL_DESC".tr(context);
      case ConfirmationDialogType.approvalNeeded:
        return "NEEDS_ORGANIZER_APPROVAL_DESC".tr(context);
      case ConfirmationDialogType.approveConfirm:
      case ConfirmationDialogType.releaseReserve:
        return "RELEASE_THIS_SPOT_BEFORE_24_HOUR".tr(context);
      case ConfirmationDialogType.reserve:
        return "YOU_WONT_BE_ABLE_TO_EDIT_THIS_LATER".tr(context);
      case ConfirmationDialogType.withdraw:
        return "";
    }
  }
}

class _AddPlayerToWaitingListDialog extends ConsumerStatefulWidget {
  const _AddPlayerToWaitingListDialog({
    required this.serviceId,
    required this.players,
  });

  final int serviceId;
  final List<BookingPlayerBase> players;

  @override
  ConsumerState<_AddPlayerToWaitingListDialog> createState() =>
      _AddPlayerToWaitingListDialogState();
}

class _AddPlayerToWaitingListDialogState
    extends ConsumerState<_AddPlayerToWaitingListDialog> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final Debouncer _debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  String searchQuery = '';
  List<User> searchResults = [];
  bool isSearching = false;
  bool isLoadingMore = false;
  int currentPage = 1;
  bool hasMore = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      _loadMoreResults();
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchQuery = '';
        searchResults = [];
        currentPage = 1;
        hasMore = false;
        isSearching = false;
      });
      return;
    }

    setState(() {
      searchQuery = query;
      currentPage = 1;
      isSearching = true;
    });

    try {
      final response = await ref.read(searchUsersProvider(
        page: 1,
        pageSize: kUserSearchPageSize,
        search: query,
      ).future);

      if (mounted) {
        setState(() {
          searchResults = response.data?.customers ?? [];
          currentPage = response.data?.currentPage ?? 1;
          hasMore = (response.data?.currentPage ?? 0) < (response.data?.totalPages ?? 0);
          isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          searchResults = [];
          isSearching = false;
        });
      }
    }
  }

  Future<void> _loadMoreResults() async {
    if (!hasMore || isLoadingMore || searchQuery.isEmpty) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      final response = await ref.read(searchUsersProvider(
        page: currentPage + 1,
        pageSize: kUserSearchPageSize,
        search: searchQuery,
      ).future);

      if (mounted) {
        setState(() {
          searchResults = [...searchResults, ...(response.data?.customers ?? [])];
          currentPage = response.data?.currentPage ?? currentPage;
          hasMore = (response.data?.currentPage ?? 0) < (response.data?.totalPages ?? 0);
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

  Future<void> _handleAddPlayer(User user) async {
    // Show confirmation dialog
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => CustomDialog(
        color: AppColors.brick,
        closeIconColor: AppColors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "ARE_YOU_SURE".trU(context),
              style: AppTextStyles.popupHeaderTextStyle,
            ),
            SizedBox(height: 15.h),
            Text(
              "DO_YOU_WANT_TO_ADD_PLAYER_TO_WAITING_LIST".tr(context, params: {
                "PLAYER_NAME": user.fullName
              }),
              textAlign: TextAlign.center,
              style: AppTextStyles.popupBodyTextStyle,
            ),
            SizedBox(height: 20.h),
            MainButton(
              label: "YES".trU(context),
              isForPopup: true,
              onTap: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    // Show position selection dialog
    final result = await showDialog<(int, int?)>(
      context: context,
      builder: (context) {
        return CustomDialog(
          color: AppColors.brick,
          closeIconColor: AppColors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "CHOOSE_YOUR_SPOT".trU(context),
                  style: AppTextStyles.popupHeaderTextStyle,
                ),
                SizedBox(height: 20.h),
                OpenMatchParticipantRowWithBG(
                  textForAvailableSlot: "SELECT".trU(context),
                  players: widget.players,
                  allowTap: false,
                  backgroundColor: AppColors.white25,
                  textColor: AppColors.white,
                  slotBackgroundColor: AppColors.yellow,
                  imageBgColor: AppColors.white,
                  imageLogoColor: AppColors.brick,
                  slotIconColor: AppColors.brick,
                  onTap: (index, playerID) {
                    Navigator.pop(context, (index, playerID));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == null || !mounted) {
      return;
    }

    final (int selectedIndex, int? otherPlayerID) = result;
    final position = selectedIndex + 1;

    // Call API to add player to waiting list
    final customerPlayers = [
      {
        "customer_id": user.id,
        "position": position,
      }
    ];

    final provider = addPlayersToWaitingListProvider(
      serviceId: widget.serviceId,
      customerPlayers: customerPlayers,
    );

    final bool? success =
        await Utils.showLoadingDialog(context, provider, ref);

    if (success == true && mounted) {
      // Refresh the waiting list
      ref.invalidate(fetchServiceWaitingPlayersProvider(
          widget.serviceId, RequestServiceType.booking));

      // Close the dialog
      Navigator.pop(context);

      // Show success message
      Utils.showMessageDialog(
        context,
        "PLAYER_ADDED_TO_WAITING_LIST_SUCCESSFULLY".tr(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final followingList = ref.watch(getFollowingListProvider);

    return CustomDialog(
      color: AppColors.brick,
      closeIconColor: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "ADD_PLAYERS".trU(context),
            style: AppTextStyles.popupHeaderTextStyle,
          ),
          SizedBox(height: 15.h),
          // Search field
          Container(
            decoration: BoxDecoration(
              color: AppColors.black2.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: SecondaryTextField(
              prefixIconConstraints:
                  BoxConstraints.tightFor(width: 25.h, height: 12.h),
              prefixIcon: Icon(Icons.search, color: AppColors.white),
              controller: searchController,
              borderRadius: 100.r,
              hintText: "SEARCH".tr(context),
              style: AppTextStyles.manropeMedium(
                color: AppColors.white,
                fontSize: 13.sp,
              ),
              hintTextStyle: AppTextStyles.manropeMedium(
                color: AppColors.white,
                fontSize: 13.sp,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              borderColor: AppColors.transparentColor,
              fillColor: AppColors.white25,
              onChanged: (value) {
                _debouncer.run(() {
                  _performSearch(value);
                });
              },
            ),
          ),
          SizedBox(height: 15.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              searchQuery.isEmpty ? "FOLLOWING".trU(context) : "SEARCH_RESULTS".trU(context),
              style: AppTextStyles.sofiaSansMedium(
                fontSize: 20.sp,
                color: AppColors.white,
              ),
            ),
          ),
          SizedBox(height: 10.h),

          // Show search results if searching, otherwise show following list
          if (searchQuery.isNotEmpty)
            _buildSearchResults()
          else
            _buildFollowingList(followingList),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (isSearching && searchResults.isEmpty) {
      return SizedBox(
        height: 100.h,
        child: const Center(
          child: CupertinoActivityIndicator(
            radius: 12,
            color: AppColors.black2,
          ),
        ),
      );
    }

    if (searchResults.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Text(
          "NO_RESULTS_FOUND".tr(context),
          style: AppTextStyles.manropeMedium(
            fontSize: 14.sp,
            color: AppColors.white,
          ),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 300.h),
      padding: EdgeInsets.only(left: 10.w,bottom: 10.h,top: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white25,
        borderRadius: BorderRadius.circular(12.r),
      ),
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
            itemCount: searchResults.length + (hasMore ? 1 : 0),
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              if (index == searchResults.length) {
                return SizedBox(
                  height: 40.h,
                  child: const Center(
                    child: CupertinoActivityIndicator(
                      radius: 12,
                      color: AppColors.black2,
                    ),
                  ),
                );
              }
              final user = searchResults[index];
              return _UserItemForWaitingList(
                user: user,
                serviceId: widget.serviceId,
                onTap: () => _handleAddPlayer(user),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFollowingList(AsyncValue<FollowList> followingList) {
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
                itemCount: data.following!.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final following = data.following![index];
                  final user = following.following;
                  if (user == null) return const SizedBox.shrink();
                  return _UserItemForWaitingList(
                    user: user,
                    serviceId: widget.serviceId,
                    onTap: () => _handleAddPlayer(user),
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
}

class _UserItemForWaitingList extends ConsumerWidget {
  final User user;
  final VoidCallback? onTap;
  final int serviceId;

  const _UserItemForWaitingList({
    required this.user,
    required this.onTap,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waitingListData = ref.watch(fetchServiceWaitingPlayersProvider(
        serviceId, RequestServiceType.booking));

    // Check if the player is already in the waiting list
    bool isPlayerInWaitingList = false;

    if (waitingListData.hasValue && waitingListData.value is List<ServiceWaitingPlayers>) {
      final data = waitingListData.value as List<ServiceWaitingPlayers>;
      isPlayerInWaitingList = data.any(
        (player) => player.customer?.id == user.id,
      );
    }

    return InkWell(
      onTap: isPlayerInWaitingList ? null : onTap,
      child: Row(
        children: [
          NetworkCircleImage(
            path: user.profileUrl,
            width: 40.h,
            height: 40.h,
            showBG: true,
            bgColor: AppColors.white,
            logoColor: AppColors.brick,
            borderRadius: BorderRadius.circular(6.r),
            applyShadow: false,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              user.fullName.toUpperCase(),
              style: AppTextStyles.sofiaSansMedium(
                fontSize: 16.sp,
                color: AppColors.white,
              ),
            ),
          ),
          Container(
            height: 24.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: isPlayerInWaitingList
                  ? AppColors.white25
                  : AppColors.yellow,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [kBoxShadow],
            ),
            alignment: Alignment.center,
            child: Text(
              isPlayerInWaitingList
                  ? "ADDED".trU(context)
                  : "ADD".trU(context),
              style: AppTextStyles.manropeMedium(
                fontSize: 13.sp,
              color: isPlayerInWaitingList
                      ? AppColors.white
                      : AppColors.brick,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
