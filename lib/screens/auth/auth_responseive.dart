import 'package:flutter/widgets.dart';

class AuthResponsive extends StatelessWidget {
  const AuthResponsive({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // image: PlatformC().isCurrentDesignPlatformDesktop
          //     ? DecorationImage(
          //         image: AssetImage(AppImages.webStaticPage.path),
          //         fit: BoxFit.fitWidth,
          //       )
          //     : null,
          ),
      child: child,
    );
  }
}
