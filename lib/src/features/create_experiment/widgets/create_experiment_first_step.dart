// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_experiment/create_experiment_controller.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/util/constants.dart';
import 'package:enzitech_app/src/shared/validator/field_validator.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_button.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_textfield.dart';

class CreateExperimentFirstStepPage extends StatefulWidget {
  const CreateExperimentFirstStepPage({
    Key? key,
    required this.callback,
    required this.formKey,
  }) : super(key: key);
  final void Function() callback;
  final GlobalKey<FormState> formKey;

  @override
  State<CreateExperimentFirstStepPage> createState() =>
      _CreateExperimentFirstStepPageState();
}

class _CreateExperimentFirstStepPageState
    extends State<CreateExperimentFirstStepPage> {
  late final CreateExperimentController controller;
  final _nameFieldController = TextEditingController(text: '');
  final _descriptionFieldController = TextEditingController(text: '');

  bool enableNextButton1 = false;

  @override
  void initState() {
    super.initState();
    controller = context.read<CreateExperimentController>();
    initFieldControllerTexts();
  }

  void initFieldControllerTexts() {
    _nameFieldController.text.isEmpty
        ? _nameFieldController.text = controller.experimentRequestModel.name
        : null;
    _descriptionFieldController.text.isEmpty
        ? _descriptionFieldController.text =
            controller.experimentRequestModel.description
        : null;

    setState(() {});
  }

  get _validateFields {
    if (_nameFieldController.text.isNotEmpty &&
        _descriptionFieldController.text.isNotEmpty) {
      setState(() {
        enableNextButton1 = widget.formKey.currentState!.validate();
      });
    } else {
      setState(() {
        enableNextButton1 = false;
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
                'Identidicação do experimento',
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

  Widget get _textFields {
    return Column(
      children: [
        _nameInput,
        const SizedBox(height: 10),
        _descriptionInput,
      ],
    );
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
      keyboardType: TextInputType.name,
      controller: _nameFieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
      // disableSuffixIcon: true,
    );
  }

  Widget get _descriptionInput {
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
      labelText: "Descrição",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.name,
      controller: _descriptionFieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
      // disableSuffixIcon: true,
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: enableNextButton1,
          text: 'Próximo',
          onPressed: () {
            widget.formKey.currentState!.save();

            controller.experimentRequestModel.name = _nameFieldController.text;
            controller.experimentRequestModel.description =
                _descriptionFieldController.text;

            controller.pageController.animateTo(
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
            widget.callback();
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
