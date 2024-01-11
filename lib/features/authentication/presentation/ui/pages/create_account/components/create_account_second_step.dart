// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../../shared/extensions/context_theme_mode_extensions.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../../../../../shared/utils/utils.dart';
import '../../../../../../../shared/validator/validator.dart';
import '../../../../viewmodel/create_account_viewmodel.dart';

class CreateAccountSecondStep extends StatefulWidget {
  const CreateAccountSecondStep({
    super.key,
    required this.pageController,
    required this.formKey,
    required this.userDataCache,
  });

  final PageController pageController;
  final GlobalKey<FormState> formKey;
  final Map<String, String> userDataCache;

  @override
  CreateAccountSecondStepState createState() => CreateAccountSecondStepState();
}

class CreateAccountSecondStepState extends State<CreateAccountSecondStep> {
  final _emailFieldController = TextEditingController(text: '');
  final _passwordFieldController = TextEditingController(text: '');
  final _confirmPasswordFieldController = TextEditingController(text: '');
  bool enableNextButton = false;

  final GlobalKey<FormState> formKeyFinal = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  get _validateFields {
    if (_emailFieldController.text.isNotEmpty &&
        _passwordFieldController.text.isNotEmpty &&
        _confirmPasswordFieldController.text.isNotEmpty) {
      setState(() {
        enableNextButton = formKeyFinal.currentState!.validate();
      });
    } else {
      setState(() {
        enableNextButton = false;
      });
    }
  }

  Widget get _emailInput {
    final validations = <ValidateRule>[
      ValidateRule(
        ValidateTypes.required,
      ),
      ValidateRule(
        ValidateTypes.email,
      ),
    ];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: "Email",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.emailAddress,
      controller: _emailFieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
    );
  }

  Widget get _passwordInput {
    final validations = <ValidateRule>[
      ValidateRule(
        ValidateTypes.required,
      ),
      ValidateRule(
        ValidateTypes.strongPassword,
      ),
    ];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: "Senha",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.emailAddress,
      controller: _passwordFieldController,
      obscureText: true,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
      // disableSuffixIcon: true,
    );
  }

  Widget get _confirmPasswordInput {
    final validations = <ValidateRule>[
      ValidateRule(
        ValidateTypes.required,
      ),
      ValidateRule(
        ValidateTypes.passwordEquals,
      ),
    ];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: "Confirmar senha",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.emailAddress,
      controller: _confirmPasswordFieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
      obscureText: true,
      valueMatcher: () => _passwordFieldController.text,

      // disableSuffixIcon: true,
    );
  }

  Widget get _textFields {
    return Column(
      children: [
        _emailInput,
        const SizedBox(height: 10),
        _passwordInput,
        const SizedBox(height: 10),
        _confirmPasswordInput,
      ],
    );
  }

  _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              context.isDarkMode ? AppImages.logoOnDark : AppImages.logoGreen,
              alignment: Alignment.center,
              width: 75,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "Cadastre-se",
              style: TextStyles.titleHome,
            ),
          ),
          const SizedBox(height: 64),
          Row(
            children: [
              Icon(
                PhosphorIcons.at(PhosphorIconsStyle.bold),
              ),
              const SizedBox(width: 4),
              Text(
                'Acesso',
                style: TextStyles.detailBold,
              ),
            ],
          ),
          _textFields,
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget get _buttons {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        EZTButton(
          enabled: enableNextButton,
          text: 'Criar conta',
          onPressed: () async {
            if (formKeyFinal.currentState!.validate()) {
              var cacheMap = widget.userDataCache;

              cacheMap.update('email', (value) => _emailFieldController.text);
              cacheMap.update(
                  'password', (value) => _confirmPasswordFieldController.text);

              await GetIt.I.get<CreateAccountViewmodel>().createUser(
                    cacheMap['name']!,
                    cacheMap['institution']!,
                    cacheMap['email']!,
                    cacheMap['password']!,
                  );
            }
          },
        ),
        const SizedBox(height: 16),
        EZTButton(
          text: 'Voltar',
          eztButtonType: EZTButtonType.outline,
          onPressed: () {
            widget.pageController.animateTo(
              0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
            );
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKeyFinal,
      child: Column(
        children: [
          Expanded(
            flex: 11,
            child: Padding(
              padding: Constants.padding16all,
              child: Center(child: _body(context)),
            ),
          ),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: Constants.padding16all,
                child: _buttons,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
