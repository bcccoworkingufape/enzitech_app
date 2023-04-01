// 🐦 Flutter imports:
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/entities/experiment_result_entity.dart';
import '../../domain/usecases/get_result/get_result_usecase.dart';
import 'experiment_details_viewmodel.dart';

class ExperimentResultsViewmodel extends ChangeNotifier {
  final GetResultUseCase _getExperimentResultsUseCase;

  ExperimentResultsViewmodel(
    this._getExperimentResultsUseCase,
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

  Future<bool> exportToExcel() async {
    try {
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
            'Tratamento:',
            treatment.treatment.name,
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            ''
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
            'Id',
            'Abso. Amostra',
            'Abso. Branco',
            'Diferença A - B',
            'a - Coeficiente Angular da Curva',
            'b - Constante da Equação da Curva',
            'Curva Cálculo',
            'FC - Fator de Correção',
            'Tempo (h)',
            'Volume (Solução do substrato)',
            'Peso da amostra (g)',
            'Resultado'
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
              repetition.repetitionId,
              repetition.sample,
              repetition.whiteSample,
              repetition.differenceBetweenSamples,
              repetition.variableA,
              repetition.variableB,
              repetition.curve,
              repetition.correctionFactor,
              repetition.time,
              repetition.volume,
              repetition.weightSample,
              repetition.result
            ], rowIndex);
            rowIndex++;
          }

          rowIndex++;
          rowIndex++;
          rowIndex++;
          sheet.insertRowIterables([
            'Desenvovido por:',
            'ENZITECH',
            '',
            '👨🏻‍💻 SAIBA MAIS:',
            'http://bcccoworking.ufape.edu.br/show.project?idProject=6',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
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

      // ask for permission
      await Permission.manageExternalStorage.request();
      var status = await Permission.manageExternalStorage.status;
      if (status.isDenied) {
        // We didn't ask for permission yet or the permission has been denied   before but not permanently.
        return false;
      }

      // You can can also directly ask the permission about its status.
      if (await Permission.storage.isRestricted) {
        // The OS restricts access, for example because of parental controls.
        return false;
      }

      if (await Permission.manageExternalStorage.isPermanentlyDenied) {
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
        openAppSettings();
      }

      if (status.isGranted) {
        // here you add the code to store the file
        final directory = await getExternalStorageDirectory();
        final filePath =
            '${directory?.path}/${GetIt.I.get<ExperimentDetailsViewmodel>().experiment!.name.replaceAll(' ', '')}.xlsx';
        final file = File(filePath);
        file.writeAsBytesSync(excel.encode()!);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> shareResult() async {
    try {
      // ask for permission
      await Permission.manageExternalStorage.request();
      var status = await Permission.manageExternalStorage.status;
      if (status.isDenied) {
        // We didn't ask for permission yet or the permission has been denied   before but not permanently.
        return false;
      }

      // You can can also directly ask the permission about its status.
      if (await Permission.storage.isRestricted) {
        // The OS restricts access, for example because of parental controls.
        return false;
      }

      if (await Permission.manageExternalStorage.isPermanentlyDenied) {
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
        openAppSettings();
      }

      if (status.isGranted) {
        var exportedWithSuccess = await exportToExcel();
        if (exportedWithSuccess) {
          // here you add the code to store the file
          final directory = await getExternalStorageDirectory();
          final filePath =
              '${directory?.path}/${GetIt.I.get<ExperimentDetailsViewmodel>().experiment!.name.replaceAll(' ', '')}.xlsx';
          Share.shareXFiles([
            XFile(filePath,
                name:
                    'Resultados do experimento "${GetIt.I.get<ExperimentDetailsViewmodel>().experiment!.name}"')
          ]);

          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
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
