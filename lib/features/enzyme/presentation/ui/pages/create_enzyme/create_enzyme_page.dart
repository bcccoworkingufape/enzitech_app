// 🐦 Flutter imports:
import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../../shared/utils/utils.dart';
import '../../../../../../shared/validator/validator.dart';
import '../../../viewmodel/create_enzyme_viewmodel.dart';
import '../../../viewmodel/enzymes_viewmodel.dart';

class CreateEnzymePage extends StatefulWidget {
  const CreateEnzymePage({Key? key}) : super(key: key);

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
            HandleFailure.of(_createEnzymeViewmodel.failure!),
            eztSnackBarType: EZTSnackBarType.error,
          );
        } else if (_createEnzymeViewmodel.state == StateEnum.success) {
          // reload the experiments list
          _enzymesViewmodel.fetch();

          EZTSnackBar.show(
            context,
            "Tratamento criado com sucesso!",
            eztSnackBarType: EZTSnackBarType.success,
          );

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

  get _validateFields {
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
            child: SvgPicture.asset(
              AppSvgs.iconLogo,
              alignment: Alignment.center,
              width: 75,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "Cadastre uma nova\nenzima",
              style: TextStyles.titleHome,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 64),
          Row(
            children: [
              const Icon(
                PhosphorIcons.flask,
                // color: AppColors.greySweet, //TODO: COLOR-FIX
              ),
              const SizedBox(width: 4),
              Text(
                'Identificação da enzima',
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
        _variableAInput,
        const SizedBox(height: 10),
        _variableBInput,
        const SizedBox(height: 20),
        _typeInput,
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

  Widget get _variableAInput {
    final validations = <ValidateRule>[
      ValidateRule(
        ValidateTypes.required,
      ),
      ValidateRule(
        ValidateTypes.numeric,
      ),
    ];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: "Variável a - Coeficiente Angular da Curva",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: _variableAFieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
      inputFormatters: Constants.enzymeDecimalInputFormatters,
    );
  }

  Widget get _variableBInput {
    final validations = <ValidateRule>[
      ValidateRule(
        ValidateTypes.required,
      ),
      ValidateRule(
        ValidateTypes.numeric,
      ),
    ];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: "Variável b - Constante da Equação da Curva",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: _variableBFieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
      inputFormatters: Constants.enzymeDecimalInputFormatters,
    );
  }

  Widget get _typeInput {
    return DropdownButton<String>(
      isExpanded: true,
      value: dropdownValue,
      hint: const Text("Escolha o tipo da enzima"),
      style: TextStyles.termRegular.copyWith(
        fontSize: 16,
      ),
      icon: null,
      elevation: 16,
      // style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 1.1,
        // color: AppColors.line, //TODO: COLOR-FIX
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });

        _validateFields;
      },
      items: Constants.typesOfEnzymesListFormmated
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: enableCreate,
          loading: _createEnzymeViewmodel.state == StateEnum.loading,
          text: 'Criar enzima',
          onPressed: () async {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              if (mounted) {
                await _createEnzymeViewmodel.createEnzyme(
                  _nameFieldController.text.trim(),
                  double.parse(_variableAFieldController.text.trim()),
                  double.parse(_variableBFieldController.text.trim()),
                  Constants.typesOfEnzymesList[Constants
                      .typesOfEnzymesListFormmated
                      .indexOf(dropdownValue!)],
                );
              }
            }
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
    return AnimatedBuilder(
        animation: _createEnzymeViewmodel,
        builder: (context, child) {
          return Scaffold(
            body: Form(
              key: _formKey,
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
            ),
          );
        });
  }
}
