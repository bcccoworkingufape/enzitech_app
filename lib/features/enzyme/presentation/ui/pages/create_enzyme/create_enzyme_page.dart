// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../shared/extensions/build_context_extensions.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../../shared/utils/utils.dart';
import '../../../../../../shared/validator/validator.dart';
import '../../../viewmodel/create_enzyme_viewmodel.dart';
import '../../../viewmodel/enzymes_viewmodel.dart';

class CreateEnzymePage extends StatefulWidget {
  const CreateEnzymePage({super.key});

  @override
  State<CreateEnzymePage> createState() => _CreateEnzymePageState();
}

class _CreateEnzymePageState extends State<CreateEnzymePage> {
  late final CreateEnzymeViewmodel _createEnzymeViewmodel;
  late final EnzymesViewmodel _enzymesViewmodel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameFieldController = TextEditingController(text: '');
  final _variableAFieldController = TextEditingController(text: '');
  final _variableBFieldController = TextEditingController(text: '');
  final _typeFieldController = TextEditingController(text: '');

  bool enableCreate = false;

  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    _createEnzymeViewmodel = GetIt.I.get<CreateEnzymeViewmodel>();
    _enzymesViewmodel = GetIt.I.get<EnzymesViewmodel>();

    if (mounted) {
      _createEnzymeViewmodel.addListener(() {
        if (_createEnzymeViewmodel.state == StateEnum.error) {
          if (!mounted) return;
          EZTSnackBar.show(
            context,
            HandleFailure.of(context.l10n, _createEnzymeViewmodel.failure!),
            eztSnackBarType: EZTSnackBarType.error,
          );
        } else if (_createEnzymeViewmodel.state == StateEnum.success) {
          _enzymesViewmodel.fetch();

          EZTSnackBar.show(context, context.l10n.enzymeCreatedSuccess, eztSnackBarType: EZTSnackBarType.success);

          if (!mounted) return;
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    _variableAFieldController.dispose();
    _variableBFieldController.dispose();
    _typeFieldController.dispose();
    super.dispose();
  }

  void get _validateFields {
    if (_nameFieldController.text.isNotEmpty &&
        _variableAFieldController.text.isNotEmpty &&
        _variableBFieldController.text.isNotEmpty &&
        dropdownValue != null) {
      setState(() {
        enableCreate = _formKey.currentState!.validate();
      });
    } else {
      setState(() {
        enableCreate = false;
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
            child: Image.asset(
              context.isDarkMode ? AppImages.logoOnDark : AppImages.logoGreen,
              alignment: Alignment.center,
              width: 75,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(context.l10n.registerNewEnzyme, style: TextStyles.titleHome, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 64),
          Row(
            children: [
              Icon(PhosphorIcons.flask()),
              const SizedBox(width: 4),
              Text(context.l10n.enzymeIdentification, style: TextStyles.detailBold),
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
        _variableAInput,
        const SizedBox(height: 10),
        _variableBInput,
        const SizedBox(height: 20),
        _typeInput(context),
      ],
    );
  }

  Widget get _nameInput {
    final validations = <ValidateRule>[ValidateRule(ValidateTypes.required), ValidateRule(ValidateTypes.name)];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: context.l10n.nameLabel,
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.name,
      controller: _nameFieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
    );
  }

  Widget get _variableAInput {
    final validations = <ValidateRule>[ValidateRule(ValidateTypes.required), ValidateRule(ValidateTypes.numeric)];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: context.l10n.variableA_long,
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: _variableAFieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
      inputFormatters: Constants.enzymeDecimalInputFormatters,
    );
  }

  Widget get _variableBInput {
    final validations = <ValidateRule>[ValidateRule(ValidateTypes.required), ValidateRule(ValidateTypes.numeric)];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: context.l10n.variableB_long,
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: _variableBFieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
      inputFormatters: Constants.enzymeDecimalInputFormatters,
    );
  }

  Widget _typeInput(BuildContext context) {
    final Map<String, String> enzymeTypes = {
      'Betaglucosidase': context.l10n.enzymeType_betaGlucosidase,
      'Aryl': context.l10n.enzymeType_aryl,
      'FosfataseAcida': context.l10n.enzymeType_acidPhosphatase,
      'FosfataseAlcalina': context.l10n.enzymeType_alkalinePhosphatase,
      'Urease': context.l10n.enzymeType_urease,
      'FDA': context.l10n.enzymeType_fda,
    };

    String? selectedKey;
    if (dropdownValue != null) {
      enzymeTypes.forEach((key, value) {
        if (value == dropdownValue) {
          selectedKey = key;
        }
      });
    }

    return DropdownButton<String>(
      isExpanded: true,
      value: selectedKey,
      hint: Text(context.l10n.chooseEnzymeType),
      style: TextStyles.termRegular.copyWith(fontSize: 16, color: context.getApplyedColorScheme.onPrimaryContainer),
      icon: null,
      elevation: 16,
      underline: Container(height: 1.1),
      onChanged: (String? newSelectedKey) {
        setState(() {
          dropdownValue = enzymeTypes[newSelectedKey!];
        });

        _validateFields;
      },
      items: enzymeTypes.keys.map<DropdownMenuItem<String>>((String key) {
        return DropdownMenuItem<String>(value: key, child: Text(enzymeTypes[key]!));
      }).toList(),
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: enableCreate,
          loading: _createEnzymeViewmodel.state == StateEnum.loading,
          text: context.l10n.createEnzymeButton,
          onPressed: () async {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              if (mounted) {
                final Map<String, String> reverseEnzymeMap = {
                  context.l10n.enzymeType_betaGlucosidase: 'Betaglucosidase',
                  context.l10n.enzymeType_aryl: 'Aryl',
                  context.l10n.enzymeType_acidPhosphatase: 'FosfataseAcida',
                  context.l10n.enzymeType_alkalinePhosphatase: 'FosfataseAlcalina',
                  context.l10n.enzymeType_urease: 'Urease',
                  context.l10n.enzymeType_fda: 'FDA',
                };
                final String? originalEnzymeKey = reverseEnzymeMap[dropdownValue];
                if (originalEnzymeKey != null) {
                  await _createEnzymeViewmodel.createEnzyme(
                    _nameFieldController.text.trim(),
                    double.parse(_variableAFieldController.text.trim()),
                    double.parse(_variableBFieldController.text.trim()),
                    originalEnzymeKey,
                  );
                }
              }
            }
          },
        ),
        const SizedBox(height: 16),
        EZTButton(
          text: context.l10n.backButton,
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
    return ListenableBuilder(
      listenable: _createEnzymeViewmodel,
      builder: (context, child) {
        return Scaffold(
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(flex: 11, child: Center(child: _body)),
                SizedBox(
                  height: 160,
                  child: Padding(padding: Constants.padding16all, child: _buttons),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
