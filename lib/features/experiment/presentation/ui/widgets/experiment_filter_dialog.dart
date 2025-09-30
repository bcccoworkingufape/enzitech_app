// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

import '../../../../../../l10n/app_localizations.dart';


// 🌎 Project imports:
import '../../../../../shared/extensions/context_theme_mode_extensions.dart';
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
    final l10n = AppLocalizations.of(context)!;

    final Map<String, String> orderByMap = {
      "name": l10n.filter_name,
      "description": l10n.filter_description,
      "repetitions": l10n.repetitions,
      "progress": l10n.filter_progress,
      "createdAt": l10n.filter_creationDate,
      "updatedAt": l10n.filter_modificationDate,
    };

    final Map<String, String> orderingMap = {
      "ASC": l10n.order_ascending,
      "DESC": l10n.order_descending,
    };

    return AlertDialog(
      title: Text(l10n.filters, style: TextStyles(context).titleBoldHeading),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(l10n.orderBy, style: TextStyles(context).buttonBoldHeading),
            DropdownButton<String>(
              isExpanded: true,
              value: dropdownOrderByValue,
              hint: Text(l10n.select),
              style: TextStyles.termRegular.copyWith(
                fontSize: 16,
                color: context.getApplyedColorScheme.onPrimaryContainer,
              ),
              icon: null,
              elevation: 16,
              underline: Container(
                height: 1.1,
              ),
              onChanged: (String? value) {
                setState(() {
                  dropdownOrderByValue = value!;
                });
              },
              items: orderByMap.keys.toList().map<DropdownMenuItem<String>>((key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(orderByMap[key]!),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(l10n.organizeInOrder, style: TextStyles(context).buttonBoldHeading),
            DropdownButton<String>(
              isExpanded: true,
              value: dropdownOrderingValue,
              hint: Text(l10n.select),
              style: TextStyles.termRegular.copyWith(
                fontSize: 16,
                color: context.getApplyedColorScheme.onPrimaryContainer,
              ),
              icon: null,
              elevation: 16,
              underline: Container(
                height: 1.1,
              ),
              onChanged: (String? value) {
                setState(() {
                  dropdownOrderingValue = value!;
                });
              },
              items: orderingMap.keys.toList().map<DropdownMenuItem<String>>((key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(orderingMap[key]!),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: <Widget>[
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all<Color>(
              context.getApplyedColorScheme.error,
            ),
          ),
          onPressed: () {
            _experimentsViewmodel.clearFilters();
            Navigator.of(context).pop();
          },
          child: Text(
            l10n.clearFilters(numberOfFiltersEnabled()), // Botão usa plural
            style: TextStyles(context).buttonPrimary.copyWith(
              color: context.getApplyedColorScheme.error,
            ),
          ),
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              context.getApplyedColorScheme.primary,
            ),
            overlayColor: MaterialStateProperty.all<Color>(
              context.getApplyedColorScheme.error,
            ),
          ),
          child: Text(
            l10n.applyFilters(numberOfFiltersEnabled()), // Botão usa plural
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