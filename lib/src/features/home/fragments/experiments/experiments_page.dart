// 🐦 Flutter imports:
import 'package:enzitech_app/src/features/home/fragments/experiments/components/experiment_card.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_controller.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/validator/validator.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_textfield.dart';

class ExperimentsPage extends StatefulWidget {
  const ExperimentsPage({
    Key? key,
    required this.homeController,
  }) : super(key: key);

  final HomeController homeController;
  @override
  State<ExperimentsPage> createState() => _ExperimentsPageState();
}

class _ExperimentsPageState extends State<ExperimentsPage> {
  late final ExperimentsController controller;

  final _searchTermController = TextEditingController(text: '');
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    controller = context.read<ExperimentsController>();
    if (mounted) {
      controller.addListener(() {
        if (controller.state == ExperimentsState.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(controller.failure!.message),
            ),
          );
        }
      });
    }
  }

  Widget get _searchTermInput {
    final validations = <ValidateRule>[
      ValidateRule(
        ValidateTypes.name,
      ),
    ];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      controller: _searchTermController,
      lineHeight: 1.8,
      eztTextFieldType: EZTTextFieldType.underline,
      hintText: "Pesquisar experimento",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.name,
      suffixIcon: const Icon(
        PhosphorIcons.magnifyingGlass,
        color: AppColors.primary,
        size: 35,
      ),
      fieldValidator: fieldValidator,
    );
  }

  Widget get _buildExperimentsList {
    if (controller.state == ExperimentsState.error) {
      return const Center(
        child: Text("Erro ao carregar experimentos"),
      );
    }

    if (controller.state == ExperimentsState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: controller.experiments.length,
      itemBuilder: (context, index) {
        var experiment = controller.experiments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ExperimentCard(
            name: experiment.name,
            updatedAt: experiment.updatedAt,
            description: experiment.description,
            progress: experiment.progress,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var widthMQ = MediaQuery.of(context).size.width;
    var heightMQ = MediaQuery.of(context).size.height;
    final controller = context.watch<ExperimentsController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _searchTermInput,
          ),
          const SizedBox(
            height: 16,
          ),
          ToggleSwitch(
            minWidth: widthMQ,
            totalSwitches: 2,
            labels: const ['Em andamento', 'Concluído'],
            activeFgColor: AppColors.white,
            inactiveFgColor: AppColors.primary,
            activeBgColor: const [AppColors.primary],
            inactiveBgColor: AppColors.white,
            borderColor: const [AppColors.primary],
            borderWidth: 1.5,
            onToggle: (index) {
              print(index);
              // call controller to update search when this changes
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: AppColors.primary,
                child: _buildExperimentsList,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
