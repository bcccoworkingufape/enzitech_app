// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class EZTForcedCenter extends StatelessWidget {
  final Widget child;
  const EZTForcedCenter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight -
                  kBottomNavigationBarHeight -
                  kFloatingActionButtonMargin,
            ),
            child: Center(child: child),
          ),
        );
      },
    );
  }
}
