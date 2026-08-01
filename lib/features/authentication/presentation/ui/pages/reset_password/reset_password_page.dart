// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/extensions/extensions.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../../shared/validator/validator.dart';
import '../../../viewmodel/reset_password_viewmodel.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.email, required this.token});

  final String email;
  final String token;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final ResetPasswordViewmodel _resetPasswordViewmodel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _newPasswordFieldController = TextEditingController(text: '');
  final _confirmPasswordFieldController = TextEditingController(text: '');
  bool _enableSubmit = false;

  @override
  void initState() {
    super.initState();
    _resetPasswordViewmodel = GetIt.I.get<ResetPasswordViewmodel>();

    _resetPasswordViewmodel.addListener(() {
      if (!mounted) return;

      if (_resetPasswordViewmodel.state == StateEnum.error) {
        EZTSnackBar.show(
          context,
          HandleFailure.of(context.l10n, _resetPasswordViewmodel.failure!, overrideDefaultMessage: true),
          eztSnackBarType: EZTSnackBarType.error,
        );
      } else if (_resetPasswordViewmodel.state == StateEnum.success) {
        EZTSnackBar.show(context, context.l10n.passwordResetSuccess, eztSnackBarType: EZTSnackBarType.success);
        Navigator.pushNamedAndRemoveUntil(context, Routing.login, (route) => false);
      }
    });
  }

  void _validateFields() {
    setState(() {
      _enableSubmit = _newPasswordFieldController.text.isNotEmpty && _confirmPasswordFieldController.text.isNotEmpty;
    });
  }

  Widget get _newPasswordInput {
    final fieldValidator = FieldValidator(
      [ValidateRule(ValidateTypes.required), ValidateRule(ValidateTypes.strongPassword)],
      context,
    );

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: context.l10n.newPassword,
      usePrimaryColorOnFocusedBorder: true,
      controller: _newPasswordFieldController,
      obscureText: true,
      onChanged: (_) => _validateFields(),
      fieldValidator: fieldValidator,
    );
  }

  Widget get _confirmPasswordInput {
    final fieldValidator = FieldValidator(
      [ValidateRule(ValidateTypes.required), ValidateRule(ValidateTypes.passwordEquals)],
      context,
    );

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: context.l10n.confirmPassword,
      usePrimaryColorOnFocusedBorder: true,
      controller: _confirmPasswordFieldController,
      obscureText: true,
      onChanged: (_) => _validateFields(),
      fieldValidator: fieldValidator,
      valueMatcher: () => _newPasswordFieldController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _resetPasswordViewmodel,
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        context.isDarkMode ? AppImages.logoOnDark : AppImages.logoGreen,
                        alignment: Alignment.center,
                        width: 75,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(context.l10n.resetPassword, style: TextStyles.titleHome, textAlign: TextAlign.center),
                    const SizedBox(height: 32),
                    _newPasswordInput,
                    const SizedBox(height: 10),
                    _confirmPasswordInput,
                    const SizedBox(height: 64),
                    EZTButton(
                      enabled: _enableSubmit,
                      text: context.l10n.resetPassword,
                      loading: _resetPasswordViewmodel.state == StateEnum.loading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _resetPasswordViewmodel.resetPassword(
                            email: widget.email,
                            token: widget.token,
                            newPassword: _newPasswordFieldController.text,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    EZTButton(
                      text: context.l10n.backButton,
                      eztButtonType: EZTButtonType.outline,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
