// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../../shared/extensions/build_context_extensions.dart';
import '../../../../../shared/ui/ui.dart';
import '../../../../experiment/presentation/viewmodel/experiments_viewmodel.dart';

class ExperimentFilterDialog extends StatefulWidget {
  const ExperimentFilterDialog({super.key});

  @override
  State<ExperimentFilterDialog> createState() => _ExperimentFilterDialogState();
}

class _ExperimentFilterDialogState extends State<ExperimentFilterDialog> {
  late final ExperimentsViewmodel _experimentsViewmodel;

  String? dropdownOrderByValue;
  String? dropdownOrderingValue;

  @override
  void initState() {
    super.initState();
    _experimentsViewmodel = GetIt.I.get<ExperimentsViewmodel>();
    dropdownOrderByValue = _experimentsViewmodel.orderBy;
    dropdownOrderingValue = _experimentsViewmodel.ordering;
  }

  int numberOfFiltersEnabled() {
    int number = 0;

    if (dropdownOrderByValue != null) {
      number++;
    }

    if (dropdownOrderingValue != null) {
      number++;
    }

    return number;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> orderByMap = {
      "name": context.l10n.filter_name,
      "description": context.l10n.filter_description,
      "repetitions": context.l10n.repetitions,
      "progress": context.l10n.filter_progress,
      "createdAt": context.l10n.filter_creationDate,
      "updatedAt": context.l10n.filter_modificationDate,
    };

    final Map<String, String> orderingMap = {
      "ASC": context.l10n.order_ascending,
      "DESC": context.l10n.order_descending,
    };

    return AlertDialog(
      title: Text(context.l10n.filters, style: TextStyles(context).titleBoldHeading),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(context.l10n.orderBy, style: TextStyles(context).buttonBoldHeading),
            DropdownButton<String>(
              isExpanded: true,
              value: dropdownOrderByValue,
              hint: Text(context.l10n.select),
              style: TextStyles.termRegular.copyWith(
                fontSize: 16,
                color: context.getApplyedColorScheme.onPrimaryContainer,
              ),
              icon: null,
              elevation: 16,
              underline: Container(height: 1.1),
              onChanged: (String? value) {
                setState(() {
                  dropdownOrderByValue = value!;
                });
              },
              items: orderByMap.keys.toList().map<DropdownMenuItem<String>>((key) {
                return DropdownMenuItem<String>(value: key, child: Text(orderByMap[key]!));
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(context.l10n.organizeInOrder, style: TextStyles(context).buttonBoldHeading),
            DropdownButton<String>(
              isExpanded: true,
              value: dropdownOrderingValue,
              hint: Text(context.l10n.select),
              style: TextStyles.termRegular.copyWith(
                fontSize: 16,
                color: context.getApplyedColorScheme.onPrimaryContainer,
              ),
              icon: null,
              elevation: 16,
              underline: Container(height: 1.1),
              onChanged: (String? value) {
                setState(() {
                  dropdownOrderingValue = value!;
                });
              },
              items: orderingMap.keys.toList().map<DropdownMenuItem<String>>((key) {
                return DropdownMenuItem<String>(value: key, child: Text(orderingMap[key]!));
              }).toList(),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: <Widget>[
        TextButton(
          style: ButtonStyle(overlayColor: WidgetStateProperty.all<Color>(context.getApplyedColorScheme.error)),
          onPressed: () {
            _experimentsViewmodel.clearFilters();
            Navigator.of(context).pop();
          },
          child: Text(
            context.l10n.clearFilters(numberOfFiltersEnabled()), // Botão usa plural
            style: TextStyles(context).buttonPrimary.copyWith(color: context.getApplyedColorScheme.error),
          ),
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(context.getApplyedColorScheme.primary),
            overlayColor: WidgetStateProperty.all<Color>(context.getApplyedColorScheme.error),
          ),
          child: Text(
            context.l10n.applyFilters(numberOfFiltersEnabled()), // Botão usa plural
            style: TextStyles(context).buttonBoldBackground,
          ),
          onPressed: () {
            _experimentsViewmodel.setOrderBy(dropdownOrderByValue);
            _experimentsViewmodel.setOrdering(dropdownOrderingValue);
            _experimentsViewmodel.fetch();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
