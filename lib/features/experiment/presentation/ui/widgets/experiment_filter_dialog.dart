// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

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

  Widget get _orderByDropdown {
    return DropdownButton<String>(
      isExpanded: true,
      value: dropdownOrderByValue,
      hint: const Text("Selecionar"),
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
      title: Text('Filtros', style: TextStyles(context).titleBoldHeading),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Ordenar por: ', style: TextStyles(context).buttonBoldHeading),
            _orderByDropdown,
            const SizedBox(
              height: 24,
            ),
            Text('Organizar em ordem: ',
                style: TextStyles(context).buttonBoldHeading),
            _orderingDropdown,
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
            numberOfFiltersEnabled() > 1 ? 'Limpar filtros' : 'Limpar filtro',
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
            numberOfFiltersEnabled() > 1 ? 'Aplicar filtros' : 'Aplicar filtro',
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
