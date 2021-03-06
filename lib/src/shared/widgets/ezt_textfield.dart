// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/themes/app_colors.dart';
import 'package:enzitech_app/src/shared/themes/app_text_styles.dart';
import 'package:enzitech_app/src/shared/validator/validator.dart';

enum EZTTextFieldType {
  none,
  regular,
  underline,
  underlined,
  outline,
  outlineCheckout,
  rounded,
}

class EZTTextField extends StatefulWidget {
  final FieldValidator? fieldValidator;
  final FocusNode? focusNode;
  final EZTTextFieldType eztTextFieldType;
  final String? hintText;
  final String? helperText;
  final bool? shouldConfirm;
  final String Function()? valueMatcher;
  final String? labelText;
  final bool obscureText;
  final bool enabled;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintColor;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final double? fontsize;
  final double? lineHeight;
  final bool autoFocus;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool enableInteractiveSelection;
  final bool enableGreenSuccessBorder;
  final bool usePrimaryColorOnFocusedBorder;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final Widget? prefixIcon;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final int? maxLines;
  final Key? wdKey;
  final TextAlign textAlign;
  final TextStyle? hintStyle;
  final bool showSuffixValidationIcon;
  final bool readOnly;
  final bool disableSuffixIcon;

  const EZTTextField({
    Key? key,
    required this.eztTextFieldType,
    this.wdKey,
    this.fieldValidator,
    this.inputFormatters,
    this.enableGreenSuccessBorder = false,
    this.helperText,
    this.hintText,
    this.valueMatcher,
    this.shouldConfirm,
    this.labelText,
    this.fillColor,
    this.focusNode,
    this.hintColor,
    this.textColor,
    this.onChanged,
    this.controller,
    this.keyboardType,
    this.validator,
    this.autoFocus = false,
    this.enabled = true,
    this.obscureText = false,
    this.fontsize,
    this.prefixIcon,
    this.lineHeight,
    this.enableInteractiveSelection = true,
    this.usePrimaryColorOnFocusedBorder = false,
    this.textInputAction,
    this.textCapitalization,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.onTap,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.hintStyle,
    this.showSuffixValidationIcon = false,
    this.readOnly = false,
    this.disableSuffixIcon = false,
  }) : super(key: key);

  @override
  State<EZTTextField> createState() => _EZTTextFieldState();
}

class _EZTTextFieldState extends State<EZTTextField> {
  bool _passwordVisibile = false;
  bool? _validationSuccess;

  //! TODO: mudar cor padrão de alguns campos com "AppColors.greyLight"

  @override
  void initState() {
    super.initState();
    _passwordVisibile = !widget.obscureText;
  }

  InputDecoration get _baseInputDecoration {
    return InputDecoration(
      filled: widget.fillColor != null ? true : false,
      prefixIcon: widget.prefixIcon,
      hintText: widget.hintText,
      helperText: widget.helperText,
      helperStyle: const TextStyle(color: Colors.red),
      labelText: widget.labelText,
      labelStyle: const TextStyle(color: AppColors.greyMedium),
      suffixIcon: widget.suffixIcon ?? _passwordSuffixIcon,
      fillColor: widget.fillColor,
      hintStyle: TextStyle(color: widget.hintColor),
      errorMaxLines: 2,
    );
  }

  Widget get _passwordSuffixIcon {
    final Widget iconToUse;
    if (_passwordVisibile) {
      iconToUse = const Icon(
        PhosphorIcons.eye,
      );
    } else {
      iconToUse = const Icon(
        PhosphorIcons.eyeClosed,
      );
    }

    return Visibility(
      visible: widget.obscureText,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _passwordVisibile = !_passwordVisibile;
          });
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [iconToUse],
        ),
      ),
    );
  }

  InputDecoration get _underlineInputDecoration {
    final inputBorder = UnderlineInputBorder(
      borderSide: BorderSide(
        color: (_validationSuccess ?? false)
            ? widget.enableGreenSuccessBorder
                ? AppColors.success
                : AppColors.lines
            : AppColors.lines,
      ),
    );

    return _baseInputDecoration.copyWith(
      alignLabelWithHint: true,
      hintStyle: widget.hintStyle ?? TextStyles.termRegular,
      enabledBorder: inputBorder,
      focusedBorder: (widget.usePrimaryColorOnFocusedBorder)
          ? const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary,
              ),
            )
          : inputBorder,
      border: inputBorder,
      labelStyle: (widget.focusNode?.hasFocus ?? false)
          ? const TextStyle(
              color: AppColors.primary,
            )
          : null,
      errorBorder: inputBorder.copyWith(
        borderSide: const BorderSide(
          color: AppColors.delete,
        ),
      ),
      contentPadding: const EdgeInsets.only(bottom: 5, top: 15),
      suffixIcon: _validationSuffixIcon,
    );
  }

  Widget? get _validationSuffixIcon {
    if (widget.obscureText) {
      return _passwordSuffixIcon;
    }

    if (_validationSuccess == null) {
      return null;
    }
    if (!widget.enabled) {
      return null;
    }

    if (widget.controller!.text.isEmpty) {
      return null;
    }

    if (widget.disableSuffixIcon) {
      return null;
    }

    return _validationSuccess!
        ? const Icon(PhosphorIcons.check)
        : const Icon(
            PhosphorIcons.warningCircle,
            color: AppColors.danger,
          );
  }

  InputDecoration get _underlinedInputDecoration {
    const inputBorder = UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.primary,
      ),
    );

    return _baseInputDecoration.copyWith(
      hintStyle: widget.hintStyle ??
          const TextStyle(
            color: AppColors.grey,
            fontSize: 16,
          ),
      enabledBorder: inputBorder,
      focusedBorder: inputBorder,
      errorBorder: inputBorder,
      border: inputBorder,
      labelStyle: null,
      contentPadding: const EdgeInsets.only(bottom: 5, top: 12),
      suffixIcon: _validationSuffixIcon,
    );
  }

  InputDecoration get _outlineInputDecoration {
    final outlineBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: (_validationSuccess ?? false)
            ? widget.enableGreenSuccessBorder
                ? AppColors.success
                : AppColors.lines
            : AppColors.lines,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(4),
      ),
    );
    var focusedOutlineBorder = outlineBorder;

    if (widget.usePrimaryColorOnFocusedBorder) {
      focusedOutlineBorder = focusedOutlineBorder.copyWith(
        borderSide: const BorderSide(
          color: AppColors.primary,
        ),
      );
    }

    return _baseInputDecoration.copyWith(
      fillColor: widget.enabled
          ? (widget.fillColor ?? AppColors.white)
          : AppColors.white,
      border: outlineBorder,
      hintStyle: widget.hintStyle,
      suffixIcon:
          widget.showSuffixValidationIcon ? _validationSuffixIcon : null,
      enabledBorder: outlineBorder,
      focusedBorder: focusedOutlineBorder,
      errorBorder: outlineBorder.copyWith(
        borderSide: const BorderSide(
          color: AppColors.danger,
        ),
      ),
    );
  }

  InputDecoration get _outlineInputDecorationCheckout {
    const outlineBorder = OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.grey),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4),
        bottomLeft: Radius.circular(4),
      ),
    );

    var focusedOutlineBorder = outlineBorder;

    if (widget.usePrimaryColorOnFocusedBorder) {
      focusedOutlineBorder = focusedOutlineBorder.copyWith(
        borderSide: const BorderSide(
          color: AppColors.primary,
        ),
      );
    }

    return _baseInputDecoration.copyWith(
      fillColor: widget.enabled
          ? (widget.fillColor ?? AppColors.white)
          : AppColors.grey,
      border: outlineBorder,
      hintStyle: widget.hintStyle,
      suffixIcon: _validationSuffixIcon,
      enabledBorder: outlineBorder,
      focusedBorder: focusedOutlineBorder,
      errorBorder: outlineBorder.copyWith(
        borderSide: const BorderSide(
          color: AppColors.danger,
        ),
      ),
    );
  }

  InputDecoration get _regularInputDecoration {
    return _baseInputDecoration.copyWith(
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
    );
  }

  InputDecoration get _roundedInputDecoration {
    return _baseInputDecoration.copyWith(
      enabledBorder: _outlineRoundedBorder,
      focusedBorder: _outlineRoundedBorder,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 12,
      ),
    );
  }

  OutlineInputBorder get _outlineRoundedBorder {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(100.0),
      ),
      borderSide: BorderSide(
        width: 0,
        style: BorderStyle.none,
      ),
    );
  }

  InputDecoration get _inputDecoration {
    switch (widget.eztTextFieldType) {
      case EZTTextFieldType.regular:
        return _regularInputDecoration;

      case EZTTextFieldType.underline:
        return _underlineInputDecoration;

      case EZTTextFieldType.underlined:
        return _underlinedInputDecoration;

      case EZTTextFieldType.outline:
        return _outlineInputDecoration;

      case EZTTextFieldType.rounded:
        return _roundedInputDecoration;

      case EZTTextFieldType.outlineCheckout:
        return _outlineInputDecorationCheckout;

      case EZTTextFieldType.none:
      default:
        return _regularInputDecoration;
    }
  }

  void _updateValidation(String? validationResult) {
    setState(() {
      _validationSuccess = validationResult == null;
    });
  }

  String? _validator(String? value) {
    String? validationResult;

    validationResult = widget.fieldValidator?.validate(
      value,
      confirmation: widget.valueMatcher?.call(),
    );

    _updateValidation(validationResult);

    return validationResult;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      key: widget.wdKey,
      onTap: widget.onTap,
      inputFormatters: widget.inputFormatters,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: _inputDecoration,
      style: TextStyle(
        fontSize: widget.fontsize,
        height: widget.lineHeight,
        color: widget.enabled ? widget.textColor : AppColors.grey,
      ),
      validator: widget.validator ?? _validator,
      obscureText: widget.obscureText && !_passwordVisibile,
      maxLines: widget.maxLines,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      controller: widget.controller,
      autofocus: widget.autoFocus,
      keyboardType: widget.keyboardType,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      textAlign: widget.textAlign,
    );
  }
}
