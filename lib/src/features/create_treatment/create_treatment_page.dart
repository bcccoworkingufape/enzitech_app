// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_treatment/create_treatment_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/treatments/treatments_controller.dart';
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_button.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_snack_bar.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_textfield.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';
import 'package:enzitech_app/src/shared/utilities/util/util.dart';
import 'package:enzitech_app/src/shared/utilities/validator/validator.dart';

class CreateTreatmentPage extends StatefulWidget {
  const CreateTreatmentPage({Key? key}) : super(key: key);

  @override
  State<CreateTreatmentPage> createState() => _CreateTreatmentPageState();
}

class _CreateTreatmentPageState extends State<CreateTreatmentPage> {
  late final CreateTreatmentController controller;
  late final TreatmentsController treatmentsController;

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
    controller = context.read<CreateTreatmentController>();
    treatmentsController = context.read<TreatmentsController>();

    if (mounted) {
      controller.addListener(() {
        if (controller.state == CreateTreatmentState.error) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(controller.failure!),
            eztSnackBarType: EZTSnackBarType.error,
          );
        } else if (controller.state == CreateTreatmentState.success) {
          // reload the experiments list
          treatmentsController.loadTreatments();

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
                'Identidicação do tratamento',
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
              await controller.createTreatment(
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
