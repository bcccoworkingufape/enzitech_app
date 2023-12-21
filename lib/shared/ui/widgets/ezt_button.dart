// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../themes/themes.dart';

const double _defaultFlutterButtonElevation = 2;

enum EZTButtonType {
  regular,
  outline,
  center,
  checkout,
}

class EZTButton extends StatefulWidget {
  final EZTButtonType eztButtonType;
  final bool enabled;
  final bool loading;
  final Widget? icon;
  final Color? color;
  final Color? outlineButtonColor;
  final String text;
  final TextStyle? style;
  final VoidCallback? onPressed;
  final Key? wdKey;
  final double? elevation;
  final Color? borderColor;
  final MainAxisAlignment? alignmentWithIcon;
  final Color? disabledButtonColor;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? padding;

  const EZTButton({
    super.key,
    this.eztButtonType = EZTButtonType.regular,
    this.enabled = true,
    this.loading = false,
    this.color,
    this.outlineButtonColor,
    required this.text,
    this.icon,
    this.onPressed,
    this.style,
    this.wdKey,
    this.elevation,
    this.borderColor,
    this.alignmentWithIcon,
    this.disabledButtonColor,
    this.textAlign,
    this.padding,
  });

  @override
  State<EZTButton> createState() => _EZTButtonState();
}

class _EZTButtonState extends State<EZTButton> {
  Widget _eztButtonType(BuildContext context) {
    switch (widget.eztButtonType) {
      case EZTButtonType.outline:
        return _buildOutlinedButton(context);
      case EZTButtonType.center:
        return _buildButtonCenter(context);
      case EZTButtonType.checkout:
        return _buildButtonCheckout(context);
      case EZTButtonType.regular:
      default:
        return _buildButton(context);
    }
  }

  //! TODO: Checar comportamento de alguns botoes, cores e estilos

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: _eztButtonType(context),
    );
  }

  Widget _getContent() {
    final text = Text(
      widget.text,
      style: widget.style ?? TextStyles.buttonBackground,
      textAlign: widget.textAlign ?? TextAlign.center,
    );

    if (widget.icon != null) {
      return Row(
        mainAxisAlignment: widget.alignmentWithIcon ?? MainAxisAlignment.center,
        children: [
          widget.icon!,
          const SizedBox(
            width: 8,
          ),
          Flexible(child: text),
        ],
      );
    }

    return text;
  }

  Widget _getOutlineContent() {
    final text = Text(
      widget.text,
      style: widget.style ?? TextStyles.buttonPrimary,
      textAlign: widget.textAlign ?? TextAlign.center,
    );

    if (widget.icon != null) {
      return Row(
        mainAxisAlignment: widget.alignmentWithIcon ?? MainAxisAlignment.center,
        children: [
          widget.icon!,
          const SizedBox(
            width: 8,
          ),
          Flexible(child: text),
        ],
      );
    }

    return text;
  }

  Widget _getContentCenter() {
    final text = Text(
      widget.text,
      style: widget.style ?? TextStyles.buttonBackground,
      textAlign: widget.textAlign ?? TextAlign.center,
    );

    if (widget.icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.icon!,
          const SizedBox(
            width: 8,
          ),
          text,
        ],
      );
    }

    return text;
  }

  Widget _buildOutlinedButton(BuildContext context) {
    return OutlinedButton(
      key: widget.wdKey,
      style: OutlinedButton.styleFrom(
        backgroundColor: widget.outlineButtonColor,
        side: BorderSide(
            width: 2, color: widget.borderColor ?? _buildButtonColor(context)),
      ),
      onPressed: (!widget.enabled || widget.loading) ? null : widget.onPressed,
      child: widget.loading
          ? const SizedBox(
              height: 28,
              width: 28,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : _getOutlineContent(),
    );
  }

  Widget _buildButton(BuildContext context) {
    return ElevatedButton(
      key: widget.wdKey,
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(_buildButtonColor(context)),
        elevation: MaterialStateProperty.all<double>(
            widget.elevation ?? _defaultFlutterButtonElevation),
      ),
      onPressed: (!widget.enabled || widget.loading) ? null : widget.onPressed,
      child: widget.loading
          ? const SizedBox(
              height: 28,
              width: 28,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : _getContent(),
    );
  }

  Widget _buildButtonCheckout(BuildContext context) {
    return ElevatedButton(
      key: widget.wdKey,
      style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
          (_) => const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.zero,
              topLeft: Radius.zero,
              topRight: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
        ),
        backgroundColor:
            MaterialStateProperty.all<Color>(_buildButtonColor(context)),
        elevation: MaterialStateProperty.all<double>(
            widget.elevation ?? _defaultFlutterButtonElevation),
      ),
      onPressed: (!widget.enabled || widget.loading) ? null : widget.onPressed,
      child: widget.loading
          ? const SizedBox(
              height: 28,
              width: 28,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : _getContent(),
    );
  }

  Widget _buildButtonCenter(BuildContext context) {
    return ElevatedButton(
      key: widget.wdKey,
      style: ButtonStyle(
        padding:
            ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(widget.padding),
        backgroundColor:
            MaterialStateProperty.all<Color>(_buildButtonColor(context)),
        elevation: MaterialStateProperty.all<double>(
            widget.elevation ?? _defaultFlutterButtonElevation),
      ),
      onPressed: (!widget.enabled || widget.loading) ? null : widget.onPressed,
      child: widget.loading
          ? const SizedBox(
              height: 28,
              width: 28,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : _getContentCenter(),
    );
  }

  Color _buildButtonColor(context) {
    if (!widget.enabled) {
      return widget.disabledButtonColor ??
          Colors.red; //AppColors.materialTheme.shade50  //TODO: COLOR-FIX
    }

    if (widget.color != null) {
      return widget.color!;
    }

    return ButtonTheme.of(context).colorScheme!.primary;
  }
}
