import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../app_styles/app_colors.dart';
import '../../components/update_app_dialog.dart';
import '../../globals/images.dart';
import '../../managers/shared_pref_manager.dart';
import '../../managers/user_manager.dart';
import '../../models/app_update_model.dart';
import '../../repository/club_repo.dart';
import '../../repository/user_repo.dart';
import '../../routes/app_pages.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  AsyncValue<bool>? _auth;
  String? _currentAppVersion;

  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      Future(() {
        setState(() {
          _currentAppVersion = value.version;
        });
      });
    });
  }

  @override
  void didChangeDependencies() {
    precacheImage(AssetImage(AppImages.backgroundImage.path), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final update = ref.watch(checkUpdateProvider);

    if (_currentAppVersion == null) {
      return const _SplashBody();
    }
    return update.when(
      data: (data) {
        if (data != null && data.showUpdate(_currentAppVersion!)) {
          Future(() {
            showUpdateDialog(data);
          });
        } else {
          listenToAuthentication();
        }
        return const _SplashBody();
      },
      error: (_, __) {
        listenToAuthentication();
        return const _SplashBody();
      },
      loading: () => const _SplashBody(),
    );
  }

  void listenToAuthentication() {
    ref.listen(isAuthenticatedProvider, (previous, current) async {
      if (previous != current && current.value != null) {
        final isAuthenticated = current.value ?? false;
        final hasSkipped = ref.read(sharedPrefManagerProvider).getSkip();

        ref.read(clubLocationsProvider);

        if (isAuthenticated) {
          // Wait for user data to load
          final userAsync = await ref.read(fetchUserProvider.future);

          final isBlocked = userAsync;

          if (isBlocked) {
            ref.read(userManagerProvider).signOut(ref);
            ref.read(goRouterProvider).go(RouteNames.auth);
            return;
          }

          ref.read(goRouterProvider).go(RouteNames.home);
        } else {
          Future(() {
            if (hasSkipped) {
              ref.read(goRouterProvider).go(RouteNames.home);
            } else {
              ref.read(goRouterProvider).go(RouteNames.auth);
            }
          });
        }
      }
    });
  }


  Future<void> showUpdateDialog(AppUpdateModel updateModel) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AppUpdateDialog(url: updateModel.url),
      ),
    );
  }
}

class _SplashBody extends StatelessWidget {
  const _SplashBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          // color: AppColors.black2,
          image: DecorationImage(
            image: AssetImage(AppImages.authBackground.path),
            fit: BoxFit.cover,
          ),
        ),
        // child: Center(
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 55.w),
        //     child: Image.asset(AppImages.splashLogo.path, height: 298.h),
        //   ),
        // ),
      ),
    );
  }
}
