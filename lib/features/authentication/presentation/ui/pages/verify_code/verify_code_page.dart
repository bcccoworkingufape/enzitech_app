// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/extensions/extensions.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../../shared/validator/validator.dart';
import '../../../dto/reset_password_args.dart';
import '../../../viewmodel/verify_code_viewmodel.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key, required this.email});

  final String email;

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  late final VerifyCodeViewmodel _verifyCodeViewmodel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _codeFieldController = TextEditingController(text: '');
  bool _enableVerify = false;

  @override
  void initState() {
    super.initState();
    _verifyCodeViewmodel = GetIt.I.get<VerifyCodeViewmodel>();

    _verifyCodeViewmodel.addListener(() {
      if (!mounted) return;

      if (_verifyCodeViewmodel.state == StateEnum.error) {
        EZTSnackBar.show(
          context,
          HandleFailure.of(context.l10n, _verifyCodeViewmodel.failure!, overrideDefaultMessage: true),
          eztSnackBarType: EZTSnackBarType.error,
        );
      } else if (_verifyCodeViewmodel.state == StateEnum.success) {
        Navigator.pushNamed(
          context,
          Routing.resetPassword,
          arguments: ResetPasswordArgs(email: widget.email, token: _codeFieldController.text.trim()),
        );
      }
    });
  }

  void _validateFields() {
    setState(() {
      _enableVerify = _codeFieldController.text.isNotEmpty;
    });
  }

  Widget get _codeInput {
    final fieldValidator = FieldValidator([ValidateRule(ValidateTypes.required)], context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: context.l10n.recoverCode,
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.number,
      controller: _codeFieldController,
      onChanged: (_) => _validateFields(),
      fieldValidator: fieldValidator,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _verifyCodeViewmodel,
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
                    Text(context.l10n.verifyCodeTitle, style: TextStyles.titleHome, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.verifyCodeInstructions,
                      textAlign: TextAlign.center,
                      style: TextStyles(context).bodyRegular,
                    ),
                    const SizedBox(height: 32),
                    _codeInput,
                    const SizedBox(height: 64),
                    EZTButton(
                      enabled: _enableVerify,
                      text: context.l10n.verifyCodeButton,
                      loading: _verifyCodeViewmodel.state == StateEnum.loading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _verifyCodeViewmodel.verifyPin(
                            email: widget.email,
                            token: _codeFieldController.text.trim(),
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
