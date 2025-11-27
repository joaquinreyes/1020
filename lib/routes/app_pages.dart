import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hop/globals/current_platform.dart';
import 'package:hop/routes/app_routes.dart';
import 'package:hop/screens/auth/auth_screen.dart';
import 'package:hop/screens/auth/signin/signin_screen.dart';
import 'package:hop/screens/auth/signup/signup_screen.dart';
import 'package:hop/screens/booking_detail/booking_detail.dart';
import 'package:hop/screens/class_detail/class_detail.dart';
import 'package:hop/screens/event_detail/event_detail.dart';
import 'package:hop/screens/home_screen/home_screen.dart';
import 'package:hop/screens/lesson_detail/lesoon_detail.dart';
import 'package:hop/screens/notification_screen/notification_screen.dart';
import 'package:hop/screens/open_match_detail/open_match_detail.dart';
import 'package:hop/screens/splash_screen/splash_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/full_screen_image/full_screen_image_screen.dart';
import '../screens/private_chat/private_chat_list_screen.dart';
import '../screens/private_chat/private_chat_screen.dart';
import '../screens/ranking_profile/ranking_profile.dart';

final goRouterProvider = Provider((ref) => AppPages.router);
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppPages {
  AppPages._();
  static const String initial = RouteNames.splash;

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initial,
    routes: [
      GoRoute(
        name: "splash",
        path: RouteNames.splash,
        pageBuilder: (context, state) {
          return _buildPage(const SplashScreen());
        },
      ),
      GoRoute(
        path: RouteNames.auth,
        name: "auth",
        pageBuilder: (context, state) {
          return _buildPage(const AuthScreen());
        },
      ),
      GoRoute(
        path: RouteNames.sign_in,
        name: "sign_in",
        pageBuilder: (context, state) {
          return _buildPage(const SigninScreen());
        },
      ),
      GoRoute(
        path: RouteNames.sign_up,
        name: "sign_up",
        pageBuilder: (context, state) {
          return _buildPage(const SignUpScreen());
        },
      ),
      GoRoute(
        path: "${RouteNames.bookingInfo}/:booking_id",
        name: "booking_info",
        pageBuilder: (context, state) {
          final bookingId =
              int.tryParse(state.pathParameters['booking_id'] ?? '');

          return _buildPage(BookingDetail(bookingId: bookingId));
        },
      ),
      GoRoute(
        path: "${RouteNames.match_info}/:id",
        name: "match_info",
        pageBuilder: (context, state) {
          final matchId = int.tryParse(state.pathParameters['id'] ?? '');
          return _buildPage(OpenMatchDetail(matchId: matchId));
        },
      ),
      GoRoute(
        path: "${RouteNames.event_info}/:id",
        name: "event_info",
        pageBuilder: (context, state) {
          final matchId = int.tryParse(state.pathParameters['id'] ?? '');
          return _buildPage(EventDetail(matchId: matchId));
        },
      ),
      GoRoute(
        path: "${RouteNames.class_info}/:id",
        name: "class_info",
        pageBuilder: (context, state) {
          final matchId = int.tryParse(state.pathParameters['id'] ?? '');
          return _buildPage(ClassDetail(matchId: matchId));
        },
      ),
      GoRoute(
        path: "${RouteNames.lesson_info}/:id",
        name: "lesson_info",
        pageBuilder: (context, state) {
          final matchId = int.tryParse(state.pathParameters['id'] ?? '');
          return _buildPage(LessonDetail(matchId: matchId));
        },
      ),
      GoRoute(
        path: RouteNames.home,
        name: "home",
        pageBuilder: (context, state) {
          return _buildPage(const HomeScreen());
        },
      ),
      GoRoute(
        path: RouteNames.notifications,
        name: "notifications",
        pageBuilder: (context, state) {
          return _buildPage(const NotificationScreen());
        },
      ),
      GoRoute(
        path: "${RouteNames.rankingProfile}/:id",
        name: "ranking_profile",
        pageBuilder: (context, state) {
          // myPrint("PLayer ID:::: ${state.pathParameters['id'] ?? '----'}");
          int id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return _buildPage(RankingProfile(customerID: id));
        },
      ),
      GoRoute(
        path: RouteNames.chat,
        name: "chat",
        pageBuilder: (context, state) {
          int matchId = 0;
          if (state.extra is List) {
            matchId = (state.extra as List)[0] ?? 0;
          }
          return _buildPage(ChatScreen(matchId: matchId));
        },
      ),
      GoRoute(
        path: RouteNames.showImage,
        name: "show_image",
        pageBuilder: (context, state) {
          String image = "";
          if (state.extra is List) {
            image = (state.extra as List)[0] ?? "";
          }
          return _buildPage(FullScreenImage(imageUrl: image));
        },
      ),
      GoRoute(
        path: RouteNames.privateChatList,
        name: "private_chat_list",
        pageBuilder: (context, state) {
          return _buildPage(const PrivateChatListScreen());
        },
      ),
      GoRoute(
        path: RouteNames.privateChat,
        name: "private_chat",
        pageBuilder: (context, state) {
          final params = state.extra as Map<String, dynamic>?;
          return _buildPage(
            PrivateChatScreen(
              otherUserId: params?['otherUserId'] ?? '',
              otherUserName: params?['otherUserName'] ?? 'User',
              otherUserAvatar: params?['otherUserAvatar'],
            ),
          );
        },
      ),
    ],
  );
  static Page<dynamic> _buildPage(Widget child) {
    if (PlatformC().isCurrentDesignPlatformDesktop) {
      return CustomTransitionPage(
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    } else {
      return MaterialPage(child: child);
    }
  }
}
