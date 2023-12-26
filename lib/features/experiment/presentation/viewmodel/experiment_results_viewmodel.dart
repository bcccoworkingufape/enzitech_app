// 🎯 Dart imports:
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:excel/excel.dart';
import 'package:get_it/get_it.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../../main/presentation/viewmodel/settings_viewmodel.dart';
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

  //TODO: Improve this method
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

      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;

      final storageStatus = android.version.sdkInt < 33
          ? await Permission.storage.request() // ask for permission
          : PermissionStatus.granted;

      if (storageStatus.isDenied) {
        // We didn't ask for permission yet or the permission has been denied   before but not permanently.
        return false;
      }

      // You can can also directly ask the permission about its status.
      if (await Permission.storage.isRestricted) {
        // The OS restricts access, for example because of parental controls.
        return false;
      }

      if (await Permission.storage.isPermanentlyDenied) {
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
        openAppSettings();
      }

      if (storageStatus.isGranted) {
        // here you add the code to store the file
        // final directory = await getExternalStorageDirectory();
        final filePath =
            '${await GetIt.I.get<SettingsViewmodel>().getDownloadEnzitechPath()}/${GetIt.I.get<ExperimentDetailsViewmodel>().experiment!.name.replaceAll(' ', '-')}.xlsx';
        final file = File(filePath);
        if (file.existsSync()) {
          //TODO: check solution, this doesnt work when app is removed and reinstalled (API 30+)
          await File(filePath).delete();
          // await file.delete(recursive: true);
        }
        MediaScanner.loadMedia(path: filePath);

        file.writeAsBytesSync(excel.encode()!, flush: true);
        setStateEnum(StateEnum.idle);
        _setFailure(null);
        return true;
      }
      return false;
    } catch (e) {
      if (e is PathNotFoundException) {
        _setFailure(UnableToSaveFailure(
            message:
                'Não foi possível criar o arquivo, cheque seu diretório "${GetIt.I.get<SettingsViewmodel>().savedPath}" e limpe todas as planilhas existentes!'));
        setStateEnum(StateEnum.error);
      }
      return false;
    }
  }

  /* Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  } */

  //TODO: Improve this method

  //TODO: Improve this method
  Future<bool> shareResult() async {
    try {
      // ask for permission
      await Permission.storage.request();
      var status = await Permission.storage.status;
      if (status.isDenied) {
        // We didn't ask for permission yet or the permission has been denied   before but not permanently.
        return false;
      }

      // You can can also directly ask the permission about its status.
      if (await Permission.storage.isRestricted) {
        // The OS restricts access, for example because of parental controls.
        return false;
      }

      if (await Permission.storage.isPermanentlyDenied) {
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
              '${await GetIt.I.get<SettingsViewmodel>().getDownloadEnzitechPath()}/${GetIt.I.get<ExperimentDetailsViewmodel>().experiment!.name.replaceAll(' ', '-')}.xlsx';
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
