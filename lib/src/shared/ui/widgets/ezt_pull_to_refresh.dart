// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';
import 'package:enzitech_app/src/shared/ui/widgets/full_widgets_override/liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

enum EZTPullToRefreshType {
  regular,
  outline,
  center,
  checkout,
}

class EZTPullToRefresh extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final Key? customKey;
  final bool showChildOpacityTransition;
  final double springAnimationDurationInMilliseconds;

  const EZTPullToRefresh({
    required this.onRefresh,
    required this.child,
    this.customKey,
    this.showChildOpacityTransition = false,
    this.springAnimationDurationInMilliseconds = 500,
    Key? key,
  }) : super(key: key);

  @override
  State<EZTPullToRefresh> createState() => _EZTPullToRefreshState();
}

class _EZTPullToRefreshState extends State<EZTPullToRefresh> {
  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      key: widget.customKey,
      onRefresh: widget.onRefresh,
      showChildOpacityTransition: widget.showChildOpacityTransition,
      springAnimationDurationInMilliseconds: 500,
      backgroundImage: const AssetImage(
        AppImages.logoWhite,
      ),
      child: widget.child,
    );
  }
}
