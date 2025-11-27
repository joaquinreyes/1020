import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/managers/private_chat_socket_manager/private_chat_socket_manager.dart';
import 'package:hop/managers/shared_pref_manager.dart';
import 'package:hop/models/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_manager.g.dart';

@Riverpod(keepAlive: true)
UserManager userManager(UserManagerRef ref) {
  return UserManager();
}

final userProvider =
    StateProvider<AppUser?>((ref) => ref.read(userManagerProvider).user);

@Riverpod(keepAlive: true)
Future<bool> isAuthenticated(IsAuthenticatedRef ref) async {
  return ref.read(userManagerProvider).isAuthenticated(ref);
}

class UserManager {
  bool? _isAuthenticated;
  AppUser? _user;

  AppUser? get user => _user;

  authenticate(Ref ref, AppUser user) async {
    _user = AppUser.fromJson(user.toJson());
    ref.read(userProvider.notifier).state = _user;
    await ref.read(sharedPrefManagerProvider).saveUser(user);
  }

  updateUser(WidgetRef ref, AppUser user) async {
    _user = AppUser.fromJson(user.toJson());
    ref.read(userProvider.notifier).state = _user;
    await ref.read(sharedPrefManagerProvider).saveUser(user);
  }

  Future<bool> isAuthenticated(IsAuthenticatedRef ref) async {
    _isAuthenticated ??= await _checkIfAuthenticated(ref);
    return _isAuthenticated!;
  }

  Future<bool> _checkIfAuthenticated(IsAuthenticatedRef ref) async {
    final user = ref.read(sharedPrefManagerProvider).fetchUser();
    if (user != null) {
      _user = user;
      return true;
    }
    return false;
  }

  signOut(dynamic ref) async {
    if (ref is Ref || ref is WidgetRef) {
      // Disconnect socket before clearing user data
      try {
        final socketNotifier = ref.read(privateChatSocketProvider.notifier);
        socketNotifier.disconnect();
      } catch (e) {
        myPrint('Error disconnecting socket on logout: $e');
      }

      _user = null;
      _isAuthenticated = false;
      ref.refresh(isAuthenticatedProvider);

      // Invalidate the private chat socket provider to reset it completely
      ref.invalidate(privateChatSocketProvider);

      await ref.read(sharedPrefManagerProvider).clearUser();
      await ref.read(sharedPrefManagerProvider).setSkip(false);
      await ref.read(sharedPrefManagerProvider).setProfilePictureDialogShown(false);
    }
  }
}
