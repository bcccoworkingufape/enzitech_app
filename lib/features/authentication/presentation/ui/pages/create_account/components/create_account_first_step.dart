// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../../shared/extensions/context_theme_mode_extensions.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../../../../../shared/utils/utils.dart';
import '../../../../../../../shared/validator/validator.dart';

class CreateAccountFirstStep extends StatefulWidget {
  const CreateAccountFirstStep({
    super.key,
    required this.pageController,
    required this.formKey,
    required this.userDataCache,
  });

  final PageController pageController;
  final GlobalKey<FormState> formKey;
  final Map<String, String> userDataCache;

  @override
  CreateAccountFirstStepState createState() => CreateAccountFirstStepState();
}

class CreateAccountFirstStepState extends State<CreateAccountFirstStep> {
  final _nameFieldController = TextEditingController(text: '');
  final _institutionFieldController = TextEditingController(text: '');

  bool enableNextButton = false;

  @override
  void initState() {
    super.initState();
    initFieldControllerTexts();
  }

  void initFieldControllerTexts() {
    _nameFieldController.text.isEmpty
        ? _nameFieldController.text = widget.userDataCache['name'] ?? ''
        : null;
    _institutionFieldController.text.isEmpty
        ? _institutionFieldController.text =
            widget.userDataCache['institution'] ?? ''
        : null;

    enableNextButton = widget.userDataCache['enableNext'] != null
        ? widget.userDataCache['enableNext']!.isNotEmpty
        : false;

    setState(() {});
  }

  get _validateFields {
    if (_nameFieldController.text.isNotEmpty &&
        _institutionFieldController.text.isNotEmpty) {
      setState(() {
        enableNextButton = widget.formKey.currentState!.validate();
      });
    } else {
      setState(() {
        enableNextButton = false;
      });
    }
  }

  Widget get _nameInput {
    final validations = <ValidateRule>[
      ValidateRule(
        ValidateTypes.required,
      ),
      ValidateRule(
        ValidateTypes.name,
      ),
    ];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: "Nome",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.emailAddress,
      controller: _nameFieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
    );
  }

  Widget get _institutionInput {
    final validations = <ValidateRule>[
      ValidateRule(
        ValidateTypes.required,
      ),
      ValidateRule(
        ValidateTypes.name,
      ),
    ];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: "Instituição",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.emailAddress,
      controller: _institutionFieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
    );
  }

  Widget get _textFields {
    return Column(
      children: [
        _nameInput,
        const SizedBox(height: 10),
        _institutionInput,
      ],
    );
  }

  _body(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
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
                PhosphorIcons.identificationCard(),
              ),
              const SizedBox(width: 4),
              Text(
                'Dados pessoais',
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
      children: [
        EZTButton(
          enabled: enableNextButton,
          text: 'Próximo',
          onPressed: () {
            widget.formKey.currentState!.save();

            widget.userDataCache
                .update('name', (value) => _nameFieldController.text);
            widget.userDataCache.update(
                'institution', (value) => _institutionFieldController.text);
            widget.userDataCache.update('enableNext', (value) => 'true');

            widget.pageController.animateTo(
              MediaQuery.of(context).size.width,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
            );
          },
        ),
        const SizedBox(height: 16),
        EZTButton(
          text: 'Voltar',
          eztButtonType: EZTButtonType.outline,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 11,
          child: Center(child: _body(context)),
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
    );
  }
}
