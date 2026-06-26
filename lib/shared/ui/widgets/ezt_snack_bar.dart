// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../extensions/build_context_extensions.dart';

enum EZTSnackBarType { regular, success, error }

class EZTSnackBar {
  const EZTSnackBar({Key? key});

  SnackBar _buildSnackBar(
    BuildContext context,
    String message,
    Color? snackBarColor,
    TextStyle? textStyle,
    bool centerTitle,
    SnackBarAction? action,
    Duration? duration,
  ) {
    return SnackBar(
      content: centerTitle
          ? SizedBox(
              height: 19,
              width: MediaQuery.of(context).size.width,
              child: Center(child: Text(message, style: textStyle)),
            )
          : Text(message, style: textStyle),
      duration: duration ?? const Duration(seconds: 4),
      backgroundColor: snackBarColor,
      action: action,
    );
  }

  SnackBar _buildSuccessSnackBar(
    BuildContext context,
    String message,
    TextStyle? textStyle,
    bool centerTitle,
    SnackBarAction? action,
    Duration? duration,
  ) {
    return SnackBar(
      content: centerTitle
          ? SizedBox(
              height: 19,
              width: MediaQuery.of(context).size.width,
              child: Center(child: Text(message, style: textStyle)),
            )
          : Text(message, style: textStyle),
      duration: duration ?? const Duration(seconds: 4),
      backgroundColor: Colors.green,
      action: action,
    );
  }

  SnackBar _buildErrorSnackBar(
    BuildContext context,
    String message,
    TextStyle? textStyle,
    bool centerTitle,
    SnackBarAction? action,
    Duration? duration,
  ) {
    return SnackBar(
      content: Text(message),
      duration: duration ?? const Duration(seconds: 4),
      backgroundColor: context.getApplyedColorScheme.error,
      action: action,
    );
  }

  SnackBar _eztSnackBarType(
    BuildContext context,
    String message,
    EZTSnackBarType eztSnackBarType,
    Color? snackBarColor,
    TextStyle? textStyle,
    bool centerTitle,
    SnackBarAction? action,
    Duration? duration,
  ) {
    switch (eztSnackBarType) {
      case EZTSnackBarType.success:
        return _buildSuccessSnackBar(context, message, textStyle, centerTitle, action, duration);
      case EZTSnackBarType.error:
        return _buildErrorSnackBar(context, message, textStyle, centerTitle, action, duration);
      case EZTSnackBarType.regular:
        return _buildSnackBar(context, message, snackBarColor, textStyle, centerTitle, action, duration);
    }
  }

  static Future show(
    BuildContext context,
    String message, {
    EZTSnackBarType eztSnackBarType = EZTSnackBarType.regular,
    Color? color,
    TextStyle? textStyle,
    bool centerTitle = false,
    SnackBarAction? action,
    void Function()? onDismissFunction,
    Duration? duration,
  }) async {
    const instance = EZTSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
          instance._eztSnackBarType(context, message, eztSnackBarType, color, textStyle, centerTitle, action, duration),
        )
        .closed
        .then((reason) {
          if (onDismissFunction != null) {
            onDismissFunction();
          }
        });
  }

  static void clear(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
