// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';

// 📦 Package imports:

enum EZTSnackBarType {
  regular,
  success,
  error,
}

class EZTSnackBar {
  const EZTSnackBar({
    Key? key,
  });

  _buildSnackBar(
    BuildContext context,
    String message,
    Color? snackBarColor,
    TextStyle? textStyle,
    bool centerTitle,
  ) {
    return SnackBar(
      // elevation: 0.0,
      //behavior: SnackBarBehavior.floating,
      // content: Text(message, style: textStyle),
      content: centerTitle
          ? SizedBox(
              height: 19,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(message, style: textStyle),
              ),
            )
          : Text(message, style: textStyle),
      // duration: new Duration(seconds: 5000000),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      // ),
      backgroundColor: snackBarColor,
      // action: SnackBarAction(
      //   textColor: Color(0xFFFAF2FB),
      //   label: 'OK',
      //   onPressed: () {},
      // ),
    );
  }

  _buildSuccessSnackBar(
    BuildContext context,
    String message,
  ) {
    return SnackBar(
      // elevation: 0.0,
      //behavior: SnackBarBehavior.floating,
      content: Text(message),
      // duration: new Duration(seconds: 5000000),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      // ),
      backgroundColor: AppColors.success, // action: SnackBarAction(
      //   textColor: Color(0xFFFAF2FB),
      //   label: 'OK',
      //   onPressed: () {},
      // ),
    );
  }

  _buildErrorSnackBar(
    BuildContext context,
    String message,
  ) {
    return SnackBar(
      // elevation: 0.0,
      //behavior: SnackBarBehavior.floating,
      content: Text(message),
      // duration: new Duration(seconds: 5000000),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      // ),
      backgroundColor: AppColors.danger, // action: SnackBarAction(
      //   textColor: Color(0xFFFAF2FB),
      //   label: 'OK',
      //   onPressed: () {},
      // ),
    );
  }

  SnackBar _eztSnackBarType(
    BuildContext context,
    String message,
    EZTSnackBarType eztSnackBarType,
    Color? snackBarColor,
    TextStyle? textStyle,
    bool centerTitle,
  ) {
    switch (eztSnackBarType) {
      case EZTSnackBarType.success:
        return _buildSuccessSnackBar(context, message);
      case EZTSnackBarType.error:
        return _buildErrorSnackBar(context, message);
      case EZTSnackBarType.regular:
      default:
        return _buildSnackBar(
            context, message, snackBarColor, textStyle, centerTitle);
    }
  }

  static show(
    BuildContext context,
    String message, {
    EZTSnackBarType eztSnackBarType = EZTSnackBarType.regular,
    Color? color,
    TextStyle? textStyle,
    bool centerTitle = false,
  }) {
    const instance = EZTSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      instance._eztSnackBarType(
        context,
        message,
        eztSnackBarType,
        color,
        textStyle,
        centerTitle,
      ),
    );
  }

  static clear(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
