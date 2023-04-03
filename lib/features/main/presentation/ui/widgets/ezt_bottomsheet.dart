import 'package:flutter/material.dart';

class EZTBottomSheet extends StatelessWidget {
  final Widget child;
  const EZTBottomSheet({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 0.0),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: child,
      ),
    );
  }
}
