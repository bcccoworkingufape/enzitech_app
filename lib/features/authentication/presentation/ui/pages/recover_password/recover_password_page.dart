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
import '../../../viewmodel/recover_password_viewmodel.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  late final RecoverPasswordViewmodel _recoverPasswordViewmodel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailFieldController = TextEditingController(text: '');
  bool _enableSend = false;

  @override
  void initState() {
    super.initState();
    _recoverPasswordViewmodel = GetIt.I.get<RecoverPasswordViewmodel>();

    _recoverPasswordViewmodel.addListener(() {
      if (!mounted) return;

      if (_recoverPasswordViewmodel.state == StateEnum.error) {
        EZTSnackBar.show(
          context,
          HandleFailure.of(context.l10n, _recoverPasswordViewmodel.failure!, overrideDefaultMessage: true),
          eztSnackBarType: EZTSnackBarType.error,
        );
      } else if (_recoverPasswordViewmodel.state == StateEnum.success) {
        EZTSnackBar.show(context, context.l10n.recoverEmailSent, eztSnackBarType: EZTSnackBarType.success);
        Navigator.pushNamed(context, Routing.verifyCode, arguments: _emailFieldController.text.trim());
      }
    });
  }

  void _validateFields() {
    setState(() {
      _enableSend = _emailFieldController.text.isNotEmpty;
    });
  }

  Widget get _emailInput {
    final fieldValidator = FieldValidator(
      [ValidateRule(ValidateTypes.required), ValidateRule(ValidateTypes.email)],
      context,
    );

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: context.l10n.email,
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.emailAddress,
      controller: _emailFieldController,
      onChanged: (_) => _validateFields(),
      fieldValidator: fieldValidator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _recoverPasswordViewmodel,
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
                    Text(context.l10n.recoverPassword, style: TextStyles.titleHome, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.recoverPasswordInstructions,
                      textAlign: TextAlign.center,
                      style: TextStyles(context).bodyRegular,
                    ),
                    const SizedBox(height: 32),
                    _emailInput,
                    const SizedBox(height: 64),
                    EZTButton(
                      enabled: _enableSend,
                      text: context.l10n.sendRecoverEmail,
                      loading: _recoverPasswordViewmodel.state == StateEnum.loading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _recoverPasswordViewmodel.recoverPassword(_emailFieldController.text.trim());
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
