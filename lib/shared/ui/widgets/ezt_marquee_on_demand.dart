// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'ezt_auto_scroll.dart';

class EZTMarqueeOnDemand extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final double? switchWidth;

  const EZTMarqueeOnDemand(
      {Key? key, required this.text, required this.textStyle, this.switchWidth})
      : super(key: key);

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    final textWidth = _textSize(text, textStyle).width;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return textWidth < (switchWidth ?? constraints.maxWidth)
            ? Text(
                text,
                style: textStyle,
              )
            : EZTAutoScroll(
                delayAfterScrollInput: const Duration(seconds: 3),
                delay: const Duration(seconds: 0),
                duration: text.length > 30
                    ? text.length > 60
                        ? const Duration(seconds: 800)
                        : const Duration(seconds: 400)
                    : text.length < 15
                        ? const Duration(seconds: 180)
                        : const Duration(seconds: 320),
                gap: 64,
                scrollDirection: Axis.horizontal,
                enableScrollInput: true,
                child: Text(
                  text,
                  style: textStyle,
                ),
              );
      },
    );
  }
}
