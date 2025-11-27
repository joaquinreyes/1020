import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hop/app_styles/app_colors.dart';

class PlayTabsParentWidget extends ConsumerStatefulWidget {
  const PlayTabsParentWidget(
      {super.key,
      required this.child,
      required this.onRefresh,
      this.scrollPhysics,
      this.scrollController});
  final Widget child;
  final Future<void> Function() onRefresh;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __TabParentState();
}

class __TabParentState extends ConsumerState<PlayTabsParentWidget> {
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //     GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          color: AppColors.brick,
          backgroundColor: AppColors.white,
          onRefresh: widget.onRefresh,
          child: SingleChildScrollView(
            controller: widget.scrollController,
            physics:
                widget.scrollPhysics ?? const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
