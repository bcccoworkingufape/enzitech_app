// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../shared/routes/route_generator.dart';
import '../../../shared/themes/app_complete_theme.dart';
import '../../../shared/util/constants.dart';
import '../../../shared/validator/field_validator.dart';
import '../../../shared/widgets/ezt_button.dart';
import '../../../shared/widgets/ezt_textfield.dart';

class CreateExperimentFourthStepPage extends StatefulWidget {
  const CreateExperimentFourthStepPage({
    Key? key,
    required this.pageController,
    required this.formKey,
    required this.experimentDataCache,
  }) : super(key: key);

  final PageController pageController;
  final GlobalKey<FormState> formKey;
  final Map<String, String> experimentDataCache;

  @override
  State<CreateExperimentFourthStepPage> createState() => _CreateExperimentFourthStepPageState();
}

class _CreateExperimentFourthStepPageState extends State<CreateExperimentFourthStepPage> {

  final _aFieldController = TextEditingController(text: '');
  final _bFieldController = TextEditingController(text: '');
  final _v1FieldController = TextEditingController(text: '');
  final _v2FieldController = TextEditingController(text: '');
  final _v3FieldController = TextEditingController(text: '');
  final _v4FieldController = TextEditingController(text: '');

  bool enableNextButton = false;

  get _validateFields {
    if (_aFieldController.text.isNotEmpty &&
        _bFieldController.text.isNotEmpty) {
      setState(() {
        enableNextButton = widget.formKey.currentState!.validate();
      });
    } else {
      setState(() {
        enableNextButton = false;
      });
    }
  }

  Widget get _body {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppSvgs.iconLogo,
              alignment: Alignment.center,
              width: 75,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "Cadastre um novo\nexperimento",
              style: TextStyles.titleHome,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 64),
          Row(
            children: [
              const Icon(
                PhosphorIcons.flask,
                color: AppColors.greyMedium,
              ),
              const SizedBox(width: 4),
              Text(
                'Dados da Enzima 1',
                style: TextStyles.detailBold,
              ),
            ],
          ),
          const SizedBox(height: 40),
          _textFields,
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget get _textFields {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações da Curva',
          style: TextStyles.detailBold,
        ),
        _aInput,
        const SizedBox(height: 10),
        _bInput,
        const SizedBox(height: 40),
        Text(
          'Demais Variáveis',
          style: TextStyles.detailBold,
        ),
        const SizedBox(height: 10),
        _v1Input,
        const SizedBox(height: 10),
        _v2Input,
        const SizedBox(height: 10),
        _v3Input,
        const SizedBox(height: 10),
        _v4Input,
      ],
    );
  }

  Widget get _aInput {
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
      labelText: "Variável A",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.name,
      controller: _aFieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
      // disableSuffixIcon: true,
    );
  }

  Widget get _bInput {
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
      labelText: "Variável B",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.name,
      controller: _bFieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
      // disableSuffixIcon: true,
    );
  }

  Widget get _v1Input {
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
      labelText: "Variável 1",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.name,
      controller: _v1FieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
      // disableSuffixIcon: true,
    );
  }

  Widget get _v2Input {
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
      labelText: "Variável 2",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.name,
      controller: _v2FieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
      // disableSuffixIcon: true,
    );
  }

  Widget get _v3Input {
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
      labelText: "Variável 3",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.name,
      controller: _v3FieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
      // disableSuffixIcon: true,
    );
  }

  Widget get _v4Input {
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
      labelText: "Variável 4",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.name,
      controller: _v4FieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
      // disableSuffixIcon: true,
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: enableNextButton,
          text: 'Criar Experimento',
          onPressed: () {
            widget.formKey.currentState!.save();

            widget.experimentDataCache
                .update('varA', (value) => _aFieldController.text);
            widget.experimentDataCache
                .update('varB', (value) => _bFieldController.text);
            widget.experimentDataCache
                .update('var1', (value) => _v1FieldController.text);
            widget.experimentDataCache
                .update('var2', (value) => _v2FieldController.text);
            widget.experimentDataCache
                .update('var3', (value) => _v3FieldController.text);
            widget.experimentDataCache
                .update('var4', (value) => _v4FieldController.text);
            widget.experimentDataCache.update('enableNext', (value) => 'true');

            Navigator.popAndPushNamed(
              context,
              RouteGenerator.experiment,
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
          child: Center(child: _body),
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
