// 🐦 Flutter imports:
import 'package:enzitech_app/src/features/home/ui/fragments/experiments/viewmodel/experiments_viewmodel.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';

class ExperimentFilterDialog extends StatefulWidget {
  const ExperimentFilterDialog({super.key});

  @override
  State<ExperimentFilterDialog> createState() => _ExperimentFilterDialogState();
}

class _ExperimentFilterDialogState extends State<ExperimentFilterDialog> {
  late final ExperimentsViewmodel viewmodel;

  String? dropdownOrderByValue;
  String? dropdownOrderingValue;

  Map<String, String> orderByMap = {
    "name": "Nome",
    "description": "Descrição",
    "repetitions": "Repetições",
    "progress": "Progresso",
    "createdAt": "Data de criação",
    "updatedAt": "Data de modificação",
  };

  Map<String, String> orderingMap = {
    "ASC": "Crescente",
    "DESC": "Decrescente",
  };

  @override
  void initState() {
    super.initState();
    viewmodel = context.read<ExperimentsViewmodel>();
    dropdownOrderByValue = viewmodel.orderBy;
    dropdownOrderingValue = viewmodel.ordering;
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

  Widget get _orderByDropdown {
    return DropdownButton<String>(
      isExpanded: true,
      value: dropdownOrderByValue,
      hint: const Text("Selecionar"),
      style: TextStyles.termRegular.copyWith(
        fontSize: 16,
      ),
      icon: null,
      elevation: 16,
      underline: Container(
        height: 1.1,
        color: AppColors.line,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownOrderByValue = value!;
        });
      },
      items: orderByMap.keys.toList().map<DropdownMenuItem<String>>((e) {
        return DropdownMenuItem<String>(
          value: e,
          child: Text(orderByMap[e]!),
        );
      }).toList(),
    );
  }

  Widget get _orderingDropdown {
    return DropdownButton<String>(
      isExpanded: true,
      value: dropdownOrderingValue,
      hint: const Text("Selecionar"),
      style: TextStyles.termRegular.copyWith(
        fontSize: 16,
      ),
      icon: null,
      elevation: 16,
      underline: Container(
        height: 1.1,
        color: AppColors.line,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownOrderingValue = value!;
        });
      },
      items: orderingMap.keys.toList().map<DropdownMenuItem<String>>((e) {
        return DropdownMenuItem<String>(
          value: e,
          child: Text(orderingMap[e]!),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filtros', style: TextStyles.titleBoldHeading),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Ordenar por: ', style: TextStyles.buttonBoldPrimary),
            _orderByDropdown,
            const SizedBox(
              height: 24,
            ),
            Text('Organizar em ordem: ', style: TextStyles.buttonBoldPrimary),
            _orderingDropdown,
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: <Widget>[
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all<Color>(
                AppColors.danger.withOpacity(0.1)),
          ),
          onPressed: () {
            viewmodel.clearFilters();

            Navigator.of(context).pop();
          },
          child: Text(
            numberOfFiltersEnabled() > 1 ? 'Limpar filtros' : 'Limpar filtro',
            style: TextStyles.buttonPrimary.copyWith(
              color: AppColors.delete,
            ),
          ),
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              AppColors.primary,
            ),
            overlayColor: MaterialStateProperty.all<Color>(
              AppColors.materialTheme.shade600,
            ),
          ),
          child: Text(
              numberOfFiltersEnabled() > 1
                  ? 'Aplicar filtros'
                  : 'Aplicar filtro',
              style: TextStyles.buttonBoldBackground),
          onPressed: () {
            viewmodel.setOrderBy(dropdownOrderByValue);
            viewmodel.setOrdering(dropdownOrderingValue);

            viewmodel.loadExperiments(1);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
