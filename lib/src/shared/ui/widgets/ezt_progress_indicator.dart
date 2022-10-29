// 🎯 Dart imports:
import 'dart:math' as math;

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';

class EZTProgressIndicator extends StatefulWidget {
  final String? message;
  const EZTProgressIndicator({super.key, this.message});

  @override
  State<EZTProgressIndicator> createState() => _EZTProgressIndicatorState();
}

class _EZTProgressIndicatorState extends State<EZTProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: animationController,
            builder: (_, child) {
              return Transform.rotate(
                angle: animationController.value * 2 * math.pi,
                child: child,
              );
            },
            child: SvgPicture.asset(
              AppSvgs.iconLogo,
              alignment: Alignment.center,
              width: 64,
            ),
          ),
          if (widget.message != null) ...[
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.message!,
                style: TextStyles.termRegular,
                textAlign: TextAlign.center,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
