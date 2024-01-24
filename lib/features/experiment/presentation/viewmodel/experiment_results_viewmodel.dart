// 🎯 Dart imports:
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:excel/excel.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/entities/experiment_result_entity.dart';
import '../../domain/usecases/get_result/get_result_usecase.dart';
import 'experiment_details_viewmodel.dart';

class ExperimentResultsViewmodel extends ChangeNotifier {
  final GetResultUseCase _getExperimentResultsUseCase;
  final ExperimentDetailsViewmodel _experimentDetailsViewmodel;

  ExperimentResultsViewmodel(
    this._getExperimentResultsUseCase,
    this._experimentDetailsViewmodel,
  );

  StateEnum _state = StateEnum.idle;
  StateEnum get state => _state;
  void setStateEnum(StateEnum state) {
    _state = state;
    notifyListeners();
  }

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure? failure) {
    _failure = failure;
  }

  ExperimentResultEntity? _experimentResult;
  ExperimentResultEntity? get experimentResult => _experimentResult;
  void _setExperimentResult(ExperimentResultEntity? experimentResult) {
    _experimentResult = experimentResult;
    notifyListeners();
  }

  Future<Excel> exportToExcel() async {
    final excel = Excel.createExcel();

    final CellStyle colorTreatment = CellStyle(
      fontColorHex: "#Ffffff",
      backgroundColorHex: "#67252b",
      fontFamily: getFontFamily(FontFamily.Calibri),
    );
    final CellStyle colorHeader = CellStyle(
      fontColorHex: "#Ffffff",
      backgroundColorHex: "#9b7276",
      fontFamily: getFontFamily(FontFamily.Calibri),
    );
    final CellStyle colorBottom = CellStyle(
      fontColorHex: "#1b1b1b",
      backgroundColorHex: "#c2f7cf",
      fontFamily: getFontFamily(FontFamily.Calibri),
    );

    int rowIndex = 0;
    for (var experimentEnzyme in experimentResult!.enzymes) {
      Sheet sheet = excel[experimentEnzyme.enzyme.name];

      for (var treatment in experimentEnzyme.treatments) {
        sheet.insertRowIterables([
          const TextCellValue('Tratamento:'),
          TextCellValue(treatment.treatment.name),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
        ], rowIndex);
        for (var i = 0; i < 12; i++) {
          sheet
              .cell(CellIndex.indexByColumnRow(
                columnIndex: i,
                rowIndex: rowIndex,
              ))
              .cellStyle = colorTreatment;
        }

        rowIndex++;

        sheet.insertRowIterables([
          const TextCellValue('Id'),
          const TextCellValue('Abso. Amostra'),
          const TextCellValue('Abso. Branco'),
          const TextCellValue('Diferença A - B'),
          const TextCellValue('a - Coeficiente Angular da Curva'),
          const TextCellValue('b - Constante da Equação da Curva'),
          const TextCellValue('Curva Cálculo'),
          const TextCellValue('FC - Fator de Correção'),
          const TextCellValue('Tempo (h)'),
          const TextCellValue('Volume (Solução do substrato)'),
          const TextCellValue('Peso da amostra (g)'),
          const TextCellValue('Resultado'),
        ], rowIndex);

        for (var i = 0; i < 12; i++) {
          sheet
              .cell(CellIndex.indexByColumnRow(
                columnIndex: i,
                rowIndex: rowIndex,
              ))
              .cellStyle = colorHeader;
        }

        rowIndex++;

        for (var repetition in treatment.repetitionResults) {
          sheet.insertRowIterables([
            TextCellValue(repetition.repetitionId),
            TextCellValue(repetition.sample.toString()),
            TextCellValue(repetition.whiteSample.toString()),
            TextCellValue(repetition.differenceBetweenSamples.toString()),
            TextCellValue(repetition.variableA.toString()),
            TextCellValue(repetition.variableB.toString()),
            TextCellValue(repetition.curve.toString()),
            TextCellValue(repetition.correctionFactor.toString()),
            TextCellValue(repetition.time.toString()),
            TextCellValue(repetition.volume.toString()),
            TextCellValue(repetition.weightSample.toString()),
            TextCellValue(repetition.result.toString()),
          ], rowIndex);
          rowIndex++;
        }

        rowIndex++;
        rowIndex++;
        rowIndex++;
        sheet.insertRowIterables([
          const TextCellValue('Desenvovido por:'),
          const TextCellValue('ENZITECH'),
          const TextCellValue(''),
          const TextCellValue('👨🏻‍💻 SAIBA MAIS:'),
          const TextCellValue(
              'http://bcccoworking.ufape.edu.br/show.project?idProject=6'),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
        ], rowIndex);
        for (var i = 0; i < 12; i++) {
          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: i, rowIndex: rowIndex))
              .cellStyle = colorBottom;
        }
      }
      rowIndex = 0;
    }

    excel.delete('Sheet1');

    return excel;
  }

  Future<File> saveFileToTemporaryDirectory(Excel excel) async {
    final dir = await getTemporaryDirectory();
    var filename =
        '${dir.path}/${_experimentDetailsViewmodel.experiment!.name.replaceAll(' ', '-')}.xlsx';
    final file = File(filename);
    await file.writeAsBytes(excel.encode()!);

    return file;
  }

  Future<bool> openDialogToUserSaveFile() async {
    final file = await saveFileToTemporaryDirectory(await exportToExcel());

    final params = SaveFileDialogParams(sourceFilePath: file.path);
    final finalPath = await FlutterFileDialog.saveFile(params: params);

    if (finalPath != null) {
      return true;
    }
    return false;
  }

  Future<bool> shareFile() async {
    final file = await saveFileToTemporaryDirectory(await exportToExcel());

    await Share.shareXFiles([
      XFile(file.path,
          name:
              'Resultados do experimento "${_experimentDetailsViewmodel.experiment!.name}"')
    ]);

    return true;
  }

  fetch() async {
    setStateEnum(StateEnum.loading);

    var result = await _getExperimentResultsUseCase(
      experimentId: GetIt.I.get<ExperimentDetailsViewmodel>().experiment!.id,
    );

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {
        _setExperimentResult(success);

        setStateEnum(StateEnum.success);
      },
    );
  }
}
