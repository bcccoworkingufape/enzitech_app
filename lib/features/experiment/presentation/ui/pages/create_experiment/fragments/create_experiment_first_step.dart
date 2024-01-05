// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../../shared/ui/ui.dart';
import '../../../../../../../shared/validator/validator.dart';
import '../../../../dto/create_experiment_dto.dart';
import '../../../../viewmodel/create_experiment_viewmodel.dart';
import '../create_experiment_fragment_template.dart';

class CreateExperimentFirstStepPage extends StatefulWidget {
  const CreateExperimentFirstStepPage({
    super.key,
  });

  @override
  State<CreateExperimentFirstStepPage> createState() =>
      _CreateExperimentFirstStepPageState();
}

class _CreateExperimentFirstStepPageState
    extends State<CreateExperimentFirstStepPage> {
  late final CreateExperimentViewmodel _createExperimentViewmodel;

  final _nameFieldController = TextEditingController(text: '');
  final _descriptionFieldController = TextEditingController(text: '');

  final _validations = <ValidateRule>[
    ValidateRule(
      ValidateTypes.required,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _createExperimentViewmodel = GetIt.I.get<CreateExperimentViewmodel>();

    Future.delayed(const Duration(milliseconds: 1))
        .whenComplete(() => _validateFields);

    _initFields();
  }

  void _initFields() {
    _nameFieldController.text =
        _createExperimentViewmodel.temporaryExperiment.name ?? '';
    _descriptionFieldController.text =
        _createExperimentViewmodel.temporaryExperiment.description ?? '';

    setState(() {});
  }

  get _validateFields {
    if (_nameFieldController.text.isNotEmpty &&
        _descriptionFieldController.text.isNotEmpty) {
      if (_createExperimentViewmodel.formKey.currentState != null) {
        if (_createExperimentViewmodel.formKey.currentState!.validate() &&
            mounted) {
          setState(() {
            _createExperimentViewmodel.setEnableNextButtonOnFirstStep(true);
          });
        }
      }
    } else {
      setState(() {
        _createExperimentViewmodel.setEnableNextButtonOnFirstStep(false);
      });
    }
  }

  Widget get _nameInput {
    final fieldValidator = FieldValidator(_validations, context);

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
    final fieldValidator = FieldValidator(_validations, context);

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

  Widget get _textFields {
    return Column(
      children: [
        _nameInput,
        const SizedBox(height: 10),
        _descriptionInput,
      ],
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: _createExperimentViewmodel.enableNextButtonOnFirstStep,
          text: 'Próximo',
          onPressed: () {
            _createExperimentViewmodel.formKey.currentState!.save();

            if (_createExperimentViewmodel.formKey.currentState!.validate()) {
              var temporary = _createExperimentViewmodel.temporaryExperiment;

              _createExperimentViewmodel.setTemporaryExperiment(
                CreateExperimentDTO(
                  name: _nameFieldController.text,
                  description: _descriptionFieldController.text,
                  enzymes: temporary.enzymes,
                  repetitions: temporary.repetitions,
                  treatmentsIDs: temporary.treatmentsIDs,
                ),
              );
              _createExperimentViewmodel.onNext(context);
            }
          },
        ),
        const SizedBox(height: 16),
        EZTButton(
          text: 'Voltar',
          eztButtonType: EZTButtonType.outline,
          onPressed: () {
            _createExperimentViewmodel.onBack(mounted, context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CreateExperimentFragmentTemplate(
      titleOfStepIndicator: "Cadastre um novo experimento",
      messageOfStepIndicator: "Etapa 1 de 4 - Identificação",
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Icon(
                  PhosphorIcons.flask(),
                ),
                const SizedBox(width: 4),
                Text(
                  'Identificação do experimento',
                  style: TextStyles.detailBold,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            _textFields,
            const SizedBox(
              height: 64,
            ),
            _buttons,
          ],
        ),
      ),
    );
  }
}
