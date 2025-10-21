// 🐦 Flutter imports:
import 'package:flutter/material.dart';

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
import '../../../viewmodel/create_treatment_viewmodel.dart';
import '../../../viewmodel/treatments_viewmodel.dart';

class CreateTreatmentPage extends StatefulWidget {
  const CreateTreatmentPage({super.key});

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

  final validations = <ValidateRule>[ValidateRule(ValidateTypes.required)];

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
            HandleFailure.of(context.l10n, _createTreatmentViewmodel.failure!),
            eztSnackBarType: EZTSnackBarType.error,
          );
        } else if (_createTreatmentViewmodel.state == StateEnum.success) {
          _treatmentsViewmodel.fetch();

          EZTSnackBar.show(context, context.l10n.treatmentCreatedSuccess, eztSnackBarType: EZTSnackBarType.success);

          if (!mounted) return;
          Navigator.pop(context);
        }
      });
    }
  }

  get _validateFields {
    if (_nameFieldController.text.isNotEmpty && _descriptionFieldController.text.isNotEmpty) {
      setState(() {
        enableCreate = _formKey.currentState!.validate();
      });
    } else {
      setState(() {
        enableCreate = false;
      });
    }
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
            child: Text(context.l10n.registerNewTreatment, style: TextStyles.titleHome, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 64),
          Row(
            children: [
              Icon(PhosphorIcons.flask()),
              const SizedBox(width: 4),
              Text(context.l10n.treatmentIdentification, style: TextStyles.detailBold),
            ],
          ),
          _textFields,
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget get _textFields {
    return Column(children: [_nameInput, const SizedBox(height: 10), _descriptionInput]);
  }

  Widget get _nameInput {
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

  Widget get _descriptionInput {
    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: context.l10n.descriptionLabel,
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.name,
      controller: _descriptionFieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: enableCreate,
          text: context.l10n.createTreatmentButton,
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
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(flex: 11, child: Center(child: _body(context))),
              SizedBox(
                height: 160,
                child: Padding(padding: Constants.padding16all, child: _buttons),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
