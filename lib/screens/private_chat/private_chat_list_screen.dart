import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/managers/private_chat_socket_manager/private_chat_socket_manager.dart';
import 'package:hop/routes/app_routes.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/widgets/background_view.dart';
import '../../app_styles/app_text_styles.dart';
import '../../components/chat_icon_component.dart';
import '../../components/network_circle_image.dart';
import '../../components/secondary_textfield.dart';
import '../../globals/images.dart';
import '../../managers/api_manager.dart';
import '../../routes/app_pages.dart';
import '../responsive_widgets/home_responsive_widget.dart';

class PrivateChatListScreen extends ConsumerStatefulWidget {
  const PrivateChatListScreen({super.key});

  @override
  ConsumerState<PrivateChatListScreen> createState() =>
      _PrivateChatListScreenState();
}

class _PrivateChatListScreenState extends ConsumerState<PrivateChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeSocket();
  }

  void _initializeSocket() {
    final socketNotifier = ref.read(privateChatSocketProvider.notifier);
    final state = ref.read(privateChatSocketProvider);

    if (!state.isConnected) {
      socketNotifier.connect(clubId: kClubID);
    } else {
      _refreshConversations();
    }
  }

  void _refreshConversations() {
    final socketNotifier = ref.read(privateChatSocketProvider.notifier);
    final state = ref.read(privateChatSocketProvider);

    if (state.isConnected) {
      Future(() {
        socketNotifier.getUserConversations();
        socketNotifier.getUnreadSenderCount();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundView(
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        body: SafeArea(
          child: HomeResponsiveWidget(
            child: _body(),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    final chatState = ref.watch(privateChatSocketProvider);

    return Column(
      children: [
        SizedBox(height: 20.h),

        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            children: [
              InkWell(
                onTap: () => ref.read(goRouterProvider).pop(),
                child: Image.asset(
                  AppImages.back_arrow_new.path,
                  width: 24.w,
                  height: 24.w,
                ),
              ),
              Expanded(
                child: Text(
                  "MESSAGES".trU(context),
                  style: AppTextStyles.sofiaSansMedium(
                    fontSize: 22.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 24.w), // Balance the back button
            ],
          ),
        ),

        SizedBox(height: 15.h),

        // Search bar

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SecondaryTextField(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.black10),
                borderRadius: BorderRadius.circular(25.r)),
            prefixIconConstraints:
                BoxConstraints.tightFor(width: 25.h, height: 12.h),
            prefixIcon: Icon(Icons.search, color: AppColors.black50),
            controller: _searchController,
            hintText: "SEARCH".tr(context),
            style: AppTextStyles.manropeMedium(
              color: AppColors.black50,
              fontSize: 13.sp,
            ),
            hintTextStyle: AppTextStyles.manropeMedium(
              color: AppColors.black50,
              fontSize: 13.sp,
            ),
            fillColor: AppColors.black10,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            borderColor: AppColors.transparentColor,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
        ),

        SizedBox(height: 15.h),

        // Error display
        if (chatState.error != null) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 20.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      chatState.error!,
                      style: AppTextStyles.manropeMedium(
                        fontSize: 14.sp,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15.h),
        ],

        // Conversations list
        Expanded(
          child: !chatState.isConnected || chatState.isLoadingConversations
              ? const Center(child: CupertinoActivityIndicator())
              : chatState.conversations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 80.sp,
                            color: AppColors.black25,
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            "${"NO_CONVERSATIONS_YET".tr(context)}",
                            style: AppTextStyles.sofiaSansMedium(
                              fontSize: 18.sp,
                              color: AppColors.black70,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Start chatting with other players!",
                            style: AppTextStyles.manropeMedium(
                              fontSize: 14.sp,
                              color: AppColors.black50,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      color: AppColors.brick,
                      backgroundColor: AppColors.white,
                      onRefresh: () async {
                        ref
                            .read(privateChatSocketProvider.notifier)
                            .getUserConversations();
                        await Future.delayed(const Duration(seconds: 1));
                      },
                      child: Builder(
                        builder: (context) {
                          // Filter conversations based on search query
                          final filteredConversations = _searchQuery.isEmpty
                              ? chatState.conversations
                              : chatState.conversations.where((conv) {
                                  final fullName = conv.userName;
                                  return fullName
                                      .toLowerCase()
                                      .contains(_searchQuery);
                                }).toList();

                          if (filteredConversations.isEmpty) {
                            return Center(
                              child: Text(
                                'No conversations found',
                                style: AppTextStyles.manropeMedium(
                                  fontSize: 14.sp,
                                  color: AppColors.black50,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: filteredConversations.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final conversation = filteredConversations[index];
                              final hasUnread =
                                  (conversation.myUnreadCount ?? 0) > 0;

                              final otherUser = conversation.otherUser;
                              final userName = conversation.userName;

                              return InkWell(
                                onTap: () {
                                  // Navigate to private chat screen
                                  ref.read(goRouterProvider).push(
                                    RouteNames.privateChat,
                                    extra: {
                                      'otherUserId': otherUser?.id ?? '',
                                      'otherUserName': userName,
                                      'otherUserAvatar':
                                          otherUser?.profileImage,
                                    },
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18.w,
                                    vertical: 6.h,
                                  ),
                                  child: Row(
                                    children: [
                                      NetworkCircleImage(
                                        borderRadius:
                                            BorderRadius.circular(100.r),
                                        path: otherUser?.profileImage,
                                        boxBorder: Border.all(
                                            color: AppColors.white25),
                                        width: 37.w,
                                        height: 37.w,
                                        bgColor: AppColors.black2,
                                        logoColor: AppColors.white,
                                      ),
                                      SizedBox(width: 12.w),
                                      // Name
                                      Expanded(
                                        child: Text(
                                          userName,
                                          style: AppTextStyles.sofiaSansMedium(
                                            fontSize: 15.sp,
                                            color: AppColors.black,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      // Chat bubble with badge
                                      ChatIconComponent(
                                        hasUnread: hasUnread,
                                        unreadCount:
                                            conversation.myUnreadCount ?? 0,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchNode.dispose();
    // Don't disconnect here as we want to keep receiving messages in background
    super.dispose();
  }
}
