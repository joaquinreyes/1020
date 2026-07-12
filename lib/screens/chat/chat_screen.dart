import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/managers/chat_socket_manager/chat_socket_manager.dart';
import 'package:hop/managers/chat_socket_manager/chat_socket_state.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/widgets/background_view.dart';
import '../../app_styles/app_text_styles.dart';
import '../../components/custom_textfield.dart';
import '../../components/secondary_text.dart';
import '../../globals/constants.dart';
import '../../globals/images.dart';
import '../../managers/user_manager.dart';
import '../../models/chat_socket_chat_message_model.dart';
import '../../models/chat_socket_join_model.dart';
import '../../routes/app_pages.dart';
import '../responsive_widgets/home_responsive_widget.dart';
import 'package:hop/box_shadow/flutter_inset_box_shadow.dart' as inset;

class ChatScreen extends ConsumerStatefulWidget {
  final int matchId;

  const ChatScreen({super.key, required this.matchId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _chatNode = FocusNode();
  late Stream<ChatSocketState> stream;

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      bool value = ref
          .read(chatSocketProvider.notifier)
          .sendMessage(_controller.text.trim());
      if (value) {
        _controller.clear();
      }
    }
  }

  @override
  void initState() {
    connectSocket();
    super.initState();
  }

  void connectSocket() {
    ref.read(chatSocketProvider.notifier).connect(matchId: widget.matchId);
    stream = ref.read(chatSocketProvider.notifier).stream;
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
            )),
      ),
    );
  }

  Widget _body() {
    final userId = ref.read(userManagerProvider).user?.user?.id;
    return Column(
      children: [
        SizedBox(height: 20.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 18.w),
            child: InkWell(
              onTap: () => ref.read(goRouterProvider).pop(),
              child: Image.asset(
                AppImages.back_arrow_new.path,
                width: 24.w,
                height: 24.w,
              ),
            ),
          ),
        ),
        Text(
          "CHAT".trU(context),
          style: AppTextStyles.sofiaSansMedium(
            fontSize: 30.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        Expanded(
            child: StreamBuilder<ChatSocketState>(
          stream: stream, // Stream of messages
          builder: (context, snapshot) {
            // Loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }

            // Error state
            if (snapshot.hasError) {
              return Center(
                  child: SecondaryText(text: snapshot.error.toString()));
            }

            // No data state
            if (!snapshot.hasData || snapshot.data!.chats.isEmpty) {
              return Center(
                  child: Text('${"NO_MESSAGES_AVAILABLE".tr(context)}.'));
            }

            // Chat data state
            List<Message> messages = snapshot.data!.chats.reversed.toList();
            List<Admin> admins = snapshot.data!.admin;
            List<Users> users = snapshot.data!.users;

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              primary: false,
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isSend = message.customerId == userId;
                String value = message.message ?? "";

                String name = "";
                String role = "";

                bool isOrganizer = false;
                bool isPlayer = message.customerId != null;

                if (!isSend) {
                  if (message.customerId != null) {
                    int index = users.indexWhere(
                        (e) => e.customer?.id == message.customerId);
                    if (index != -1) {
                      name =
                          "${users[index].customer?.firstName ?? ""} ${users[index].customer?.lastName ?? ""}";
                      isOrganizer = users[index].isOrganizer ?? false;
                      role = isOrganizer ? "ORGANIZER" : "PLAYER";
                    }
                  } else if (message.adminId != null) {
                    int index =
                        admins.indexWhere((e) => e.id == message.adminId);
                    if (index != -1) {
                      name = admins[index].fullName ?? "";
                      role = chatRoles[admins[index].roleId ?? 0] ?? "ADMIN";
                    }
                  }
                }
                String time = (DateTime.tryParse(message.createdAt ?? "") ??
                        DateTime.now()).toLocal()
                    .format("HH:mm");

                // Generate consistent color for each user based on their ID
                Color incomingMsgColor = AppColors.blue;
                if (!isSend) {
                  // Use user ID to generate consistent color for this user
                  int userId = message.customerId ?? message.adminId ?? 0;
                  int colorVariation = userId.hashCode.abs() % 12;

                  // Base color: 0xFFF3F3F3 (243, 243, 243)
                  // Create noticeable variations by shifting RGB values significantly
                  int baseR = 243;
                  int baseG = 243;
                  int baseB = 243;

                  int offsetR = ((colorVariation % 4) - 2) * 15; // Range: -30 to +15
                  int offsetG = (((colorVariation ~/ 4) % 4) - 2) * 15; // Range: -30 to +15
                  int offsetB = (((colorVariation ~/ 8) % 4) - 2) * 15; // Range: -30 to +15

                  incomingMsgColor = AppColors.chatColor;
                }

                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
                  child: Align(
                    alignment:
                        isSend ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.h),
                      decoration: BoxDecoration(
                        color: incomingMsgColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.10),
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width / 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (!isSend)
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          "$name ${role.isNotEmpty ? "(${role.trU(context)})" : ""}"
                                              .toUpperCase(),
                                          style: AppTextStyles.sofiaSansMedium(
                                            fontSize: 19.sp,
                                            color: isPlayer
                                                ? AppColors.black70
                                                : AppColors.intenseGreen,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                    ),
                                  Text(
                                    value,
                                    style: AppTextStyles.manropeMedium(
                                      fontSize: 16.sp,
                                      color: isSend ? AppColors.white : AppColors.black,
                                    ),
                                    textAlign: TextAlign.start,
                                  )
                                ],
                              )),
                          SizedBox(width: 5.w),
                          Text(
                            time,
                            style: AppTextStyles.manropeMedium(
                              fontSize: 13.sp,
                                color: isSend
                                    ? AppColors.white95
                                    : AppColors.black70),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        )),
        SizedBox(height: 15.h),
        Container(
            height: 85.h,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5.r),
                  topLeft: Radius.circular(5.r)),
              boxShadow: [
                BoxShadow(
                    color: AppColors.black.withOpacity(0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: CustomTextField(
              hintText: "TYPE_HERE".tr(context),
              controller: _controller,
              hintTextStyle: AppTextStyles.manropeMedium(
                  fontSize: 13.sp, color: AppColors.black25),
              // style: AppTextStyles.qanelasLight(fontSize: 16.sp),
              contentPadding: EdgeInsets.only(
                  left: 10.w, top: 10.h, bottom: 10.h, right: 10.w),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.black90)),
              fillColor: Colors.transparent,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: InkWell(
                    onTap: _sendMessage,
                    child: const Icon(Icons.send, color: AppColors.black),
                  )),
              onFieldSubmitted: (String value) {
                _sendMessage();
              },
              node: _chatNode,
            ))
      ],
    );
  }
}
