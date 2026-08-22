// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class EZTForcedCenter extends StatelessWidget {
  final Widget child;
  const EZTForcedCenter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final minHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight - kBottomNavigationBarHeight - kFloatingActionButtonMargin
            : 0.0;

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: Container(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Center(child: child),
          ),
        );
      },
    );
  }
}
