// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../widgets/ezt_create_experiment_step_indicator.dart';

class CreateExperimentFragmentTemplate extends StatefulWidget {
  const CreateExperimentFragmentTemplate({
    super.key,
    required this.titleOfStepIndicator,
    required this.messageOfStepIndicator,
    required this.body,
  });

  final String titleOfStepIndicator;
  final String messageOfStepIndicator;
  final Widget body;

  @override
  State<CreateExperimentFragmentTemplate> createState() =>
      _CreateExperimentFragmentTemplateState();
}

class _CreateExperimentFragmentTemplateState
    extends State<CreateExperimentFragmentTemplate> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 32),
                EZTCreateExperimentStepIndicator(
                  title: widget.titleOfStepIndicator,
                  message: widget.messageOfStepIndicator,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: widget.body,
          ),
        ],
      ),
    );
  }
}
