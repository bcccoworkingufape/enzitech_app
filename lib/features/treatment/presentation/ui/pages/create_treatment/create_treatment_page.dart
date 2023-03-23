// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../../shared/utils/utils.dart';
import '../../../../../../shared/validator/validator.dart';
import '../../../viewmodel/create_treatment_viewmodel.dart';
import '../../../viewmodel/treatments_viewmodel.dart';

class CreateTreatmentPage extends StatefulWidget {
  const CreateTreatmentPage({Key? key}) : super(key: key);

  @override
  State<CreateTreatmentPage> createState() => _CreateTreatmentPageState();
}

class _CreateTreatmentPageState extends State<CreateTreatmentPage> {
  late final CreateTreatmentViewmodel _createTreatmentViewmodel;
  late final TreatmentsViewmodel _treatmentsViewmodel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameFieldController = TextEditingController(text: '');
  final _descriptionFieldController = TextEditingController(text: '');

  bool enableCreate = false;

  final validations = <ValidateRule>[
    ValidateRule(
      ValidateTypes.required,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _createTreatmentViewmodel = GetIt.I.get<CreateTreatmentViewmodel>();
    _treatmentsViewmodel = GetIt.I.get<TreatmentsViewmodel>();

    if (mounted) {
      _createTreatmentViewmodel.addListener(() {
        if (_createTreatmentViewmodel.state == StateEnum.error) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(_createTreatmentViewmodel.failure!),
            eztSnackBarType: EZTSnackBarType.error,
          );
        } else if (_createTreatmentViewmodel.state == StateEnum.success) {
          // reload the experiments list
          _treatmentsViewmodel.fetch();

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

  get _validateFields {
    if (_nameFieldController.text.isNotEmpty &&
        _descriptionFieldController.text.isNotEmpty) {
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
              "Cadastre um novo\ntratamento",
              style: TextStyles.titleHome,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 64),
          Row(
            children: [
              const Icon(
                PhosphorIcons.flask,
                color: AppColors.greySweet,
              ),
              const SizedBox(width: 4),
              Text(
                'Identificação do tratamento',
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
          enabled: enableCreate,
          text: 'Criar tratamento',
          onPressed: () async {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              await _createTreatmentViewmodel.createTreatment(
                _nameFieldController.text.trim(),
                _descriptionFieldController.text.trim(),
              );
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
    return Scaffold(
      body: SafeArea(
        child: Form(
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
      ),
    );
  }
}
