// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_experiment/create_experiment_controller.dart';
import 'package:enzitech_app/src/features/create_experiment/widgets/ezt_create_experiment_step_indicator.dart';
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_button.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_textfield.dart';
import 'package:enzitech_app/src/shared/utilities/util/constants.dart';
import 'package:enzitech_app/src/shared/utilities/validator/field_validator.dart';

class CreateExperimentFirstStepPage extends StatefulWidget {
  const CreateExperimentFirstStepPage({
    Key? key,
    required this.callback,
    required this.formKey,
  }) : super(key: key);
  final void Function({int page}) callback;
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

  final validations = <ValidateRule>[
    ValidateRule(
      ValidateTypes.required,
    ),
  ];

  @override
  void initState() {
    super.initState();
    controller = context.read<CreateExperimentController>();
    initFieldControllerTexts();
    Future.delayed(const Duration(milliseconds: 1))
        .whenComplete(() => _validateFields);
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
      if (widget.formKey.currentState != null) {
        if (widget.formKey.currentState!.validate() && mounted) {
          setState(() {
            enableNextButton1 = true;
          });
        }
      }
    } else {
      setState(() {
        enableNextButton1 = false;
      });
    }
  }

  Widget get _body {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: [
          const EZTCreateExperimentStepIndicator(
            title: "Cadastre um novo experimento",
            message: "Etapa 1 de 4 - Identificação",
          ),
          const SizedBox(
            height: 64,
          ),
          Row(
            children: [
              const Icon(
                PhosphorIcons.flask,
                color: AppColors.greySweet,
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

            if (widget.formKey.currentState!.validate()) {
              controller.experimentRequestModel.name =
                  _nameFieldController.text;
              controller.experimentRequestModel.description =
                  _descriptionFieldController.text;

              controller.pageController.animateTo(
                MediaQuery.of(context).size.width,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeIn,
              );
            }
          },
        ),
        const SizedBox(height: 16),
        EZTButton(
          text: 'Voltar',
          eztButtonType: EZTButtonType.outline,
          onPressed: () {
            widget.callback();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 11,
            child: Center(child: _body),
          ),
          SizedBox(
            height: 160,
            child: Padding(
              padding: Constants.padding16all,
              child: _buttons,
            ),
          ),
        ],
      ),
    );
  }
}
