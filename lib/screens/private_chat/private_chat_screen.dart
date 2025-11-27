import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/managers/private_chat_socket_manager/private_chat_socket_manager.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/widgets/background_view.dart';
import '../../app_styles/app_text_styles.dart';
import '../../components/custom_textfield.dart';
import '../../components/network_circle_image.dart';
import '../../globals/images.dart';
import '../../managers/user_manager.dart';
import '../../routes/app_pages.dart';
import '../responsive_widgets/home_responsive_widget.dart';

class PrivateChatScreen extends ConsumerStatefulWidget {
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;

  const PrivateChatScreen({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
  });

  @override
  ConsumerState<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends ConsumerState<PrivateChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _chatNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _scrollController.addListener(_scrollListener);
  }

  void _initializeChat() {
    Future(() {
      // Clear previous messages first
      ref.read(privateChatSocketProvider.notifier).clearMessages();
      // Then get conversation history
      ref.read(privateChatSocketProvider.notifier).getConversationHistory(
        otherUserId: widget.otherUserId,
        limit: 50,
        skip: 0,
      );
    });
  }

  void _scrollListener() {
    // Load more messages when scrolled to top
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      final state = ref.read(privateChatSocketProvider);
      if (state.hasMoreMessages && !state.isLoadingHistory) {
        setState(() {
          _isLoadingMore = true;
        });

        ref.read(privateChatSocketProvider.notifier).getConversationHistory(
              otherUserId: widget.otherUserId,
              limit: 50,
              skip: state.messages.length,
            );

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        });
      }
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      bool value = ref.read(privateChatSocketProvider.notifier).sendMessage(
            receiverId: widget.otherUserId,
            message: _controller.text.trim(),
          );
      if (value) {
        _controller.clear();
      }
    }
  }

  @override
  void deactivate() {
    // Clear messages and currentOtherUserId when leaving the screen
    // Store notifier reference before widget is disposed
    final notifier = ref.read(privateChatSocketProvider.notifier);
    // Wrap in Future to avoid modifying provider during widget lifecycle
    Future(() {
      notifier.clearMessages();
    });
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _chatNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundView(
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        body: SafeArea(
          bottom: false,
          child: GestureDetector(
            onTap: () {
              Utils.closeKeyboard();
            },
            child: HomeResponsiveWidget(
              child: _body(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    final userId = ref.read(userManagerProvider).user?.user?.id?.toString();
    final chatState = ref.watch(privateChatSocketProvider);

    return Column(
      children: [
        SizedBox(height: 20.h),
        // Header with back button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  ref.read(goRouterProvider).pop();
                },
                child: Image.asset(
                  AppImages.back_arrow_new.path,
                  width: 24.w,
                  height: 24.w,
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NetworkCircleImage(
                      borderRadius:
                      BorderRadius.circular(100.r),
                      path: widget.otherUserAvatar,
                      boxBorder: Border.all(
                          color: AppColors.white25),
                      width: 37.w,
                      height: 37.w,
                      bgColor: AppColors.black2,
                      logoColor: AppColors.white,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      widget.otherUserName.toUpperCase(),
                      style: AppTextStyles.sofiaSansMedium(
                        fontSize: 17.sp,
                        color: AppColors.black2
                      ),
                      textAlign: TextAlign.center
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24.w), // Balance the back button
            ],
          ),
        ),
        SizedBox(height: 15.h),

        // Messages list
        Expanded(
          child: chatState.messages.isEmpty
              ? Center(
                  child: chatState.isLoadingHistory || !chatState.isConnected
                      ? const CupertinoActivityIndicator()
                      : Text('${"NO_MESSAGES_AVAILABLE".tr(context)}.'),
                )
              : ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  itemCount: chatState.messages.length +
                      (chatState.isLoadingHistory ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show loading indicator at top when loading more
                    if (chatState.isLoadingHistory && index == chatState.messages.length) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CupertinoActivityIndicator()),
                      );
                    }

                    // Reverse the messages (newest at bottom)
                    final messages = chatState.messages.reversed.toList();
                    final message = messages[index];
                    final isSend = message.senderId == userId;

                    String value = message.message ?? "";
                    String time = (DateTime.tryParse(message.createdAt ?? "") ??
                            DateTime.now())
                        .toLocal()
                        .format("HH:mm");

                    // Message bubble
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 5.h, horizontal: 15.w),
                      child: Align(
                        alignment: isSend
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(12.h),
                          decoration: BoxDecoration(
                            color: isSend
                                ? AppColors.yellow
                                : AppColors.white.withOpacity(0.95),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black5.withOpacity(0.10),
                                offset: const Offset(0, 4),
                                blurRadius: 4,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width / 1.5,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!isSend)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          widget.otherUserName.toUpperCase(),
                                          style: AppTextStyles.sofiaSansMedium(
                                            fontSize: 14.sp,
                                            color: AppColors.black2,
                                          ),
                                        ),
                                      ),
                                    Text(
                                      value,
                                      style: AppTextStyles.manropeMedium(
                                        fontSize: 16.sp,
                                        color: AppColors.black2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    time,
                                    style: AppTextStyles.manropeMedium(
                                      fontSize: 12.sp,
                                      color: isSend
                                          ? AppColors.black90
                                          : AppColors.black70,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),

        SizedBox(height: 3.h),

        // Input field
        Container(
          height: 85.h,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5.r),
              topLeft: Radius.circular(5.r),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.2),
                blurRadius: 24,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CustomTextField(
            hintText: "TYPE_HERE".tr(context),
            controller: _controller,
            hintTextStyle: AppTextStyles.manropeMedium(
              fontSize: 13.sp,
              color: AppColors.black25,
            ),
            contentPadding: EdgeInsets.only(
              left: 10.w,
              top: 10.h,
              bottom: 10.h,
              right: 10.w,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.black90),
            ),
            fillColor: Colors.transparent,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: InkWell(
                onTap: _sendMessage,
                child: const Icon(Icons.send, color: AppColors.black),
              ),
            ),
            onFieldSubmitted: (String value) {
              _sendMessage();
            },
            node: _chatNode,
          ),
        ),
      ],
    );
  }
}
