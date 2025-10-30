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
import '../../../../shared/extensions/extensions.dart';
import '../../../../shared/ui/ui.dart';
import '../../domain/entities/experiment_result_entity.dart';
import '../../domain/usecases/experiments_usecases.dart';
import 'experiment_details_viewmodel.dart';

class ExperimentResultsViewmodel extends ChangeNotifier {
  final ExperimentsUseCases _experimentsUseCases;
  final ExperimentDetailsViewmodel _experimentDetailsViewmodel;

  ExperimentResultsViewmodel(this._experimentsUseCases, this._experimentDetailsViewmodel);

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

  Future<Excel> exportToExcel(Map<String, String> translations) async {
    final excel = Excel.createExcel();

    final CellStyle colorTreatment = CellStyle(
      fontColorHex: ExcelColor.fromHexString("#Ffffff"),
      backgroundColorHex: ExcelColor.fromHexString("#67252b"),
      fontFamily: getFontFamily(FontFamily.Calibri),
    );
    final CellStyle colorHeader = CellStyle(
      fontColorHex: ExcelColor.fromHexString("#Ffffff"),
      backgroundColorHex: ExcelColor.fromHexString("#9b7276"),
      fontFamily: getFontFamily(FontFamily.Calibri),
    );
    final CellStyle colorBottom = CellStyle(
      fontColorHex: ExcelColor.fromHexString("#1b1b1b"),
      backgroundColorHex: ExcelColor.fromHexString("#c2f7cf"),
      fontFamily: getFontFamily(FontFamily.Calibri),
    );

    int rowIndex = 0;
    for (var experimentEnzyme in experimentResult!.enzymes) {
      Sheet sheet = excel[experimentEnzyme.enzyme.name];

      for (var treatment in experimentEnzyme.treatments) {
        sheet.insertRowIterables([
          TextCellValue(translations['excel_treatment_label'] ?? ""),
          TextCellValue(treatment.treatment.name),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
        ], rowIndex);
        for (var i = 0; i < 12; i++) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: rowIndex)).cellStyle = colorTreatment;
        }

        rowIndex++;

        sheet.insertRowIterables([
          TextCellValue(translations['excel_col_id']!),
          TextCellValue(translations['excel_col_sampleAbsorbance']!),
          TextCellValue(translations['excel_col_whiteSampleAbsorbance']!),
          TextCellValue(translations['excel_col_difference']!),
          TextCellValue(translations['excel_col_variableA']!),
          TextCellValue(translations['excel_col_variableB']!),
          TextCellValue(translations['excel_col_curveCalculation']!),
          TextCellValue(translations['excel_col_correctionFactor']!),
          TextCellValue(translations['excel_col_time']!),
          TextCellValue(translations['excel_col_volume']!),
          TextCellValue(translations['excel_col_sampleWeight']!),
          TextCellValue(translations['excel_col_result']!),
        ], rowIndex);

        for (var i = 0; i < 12; i++) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: rowIndex)).cellStyle = colorHeader;
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
          TextCellValue(translations['excel_footer_developedBy']!),
          TextCellValue('ENZITECH'),
          TextCellValue(''),
          TextCellValue(translations['excel_footer_learnMore']!),
          TextCellValue('http://bcccoworking.ufape.edu.br/show.project?idProject=6'),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
        ], rowIndex);
        for (var i = 0; i < 12; i++) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: rowIndex)).cellStyle = colorBottom;
        }
      }
      rowIndex = 0;
    }

    excel.delete('Sheet1');

    return excel;
  }

  Future<File> saveFileToTemporaryDirectory(Map<String, String> translations) async {
    final excel = await exportToExcel(translations);
    final dir = await getTemporaryDirectory();
    var filename = '${dir.path}/${_experimentDetailsViewmodel.experiment!.name.replaceAll(' ', '-')}.xlsx';
    final file = File(filename);
    await file.writeAsBytes(excel.encode()!);

    return file;
  }

  Future<void> openDialogToUserSaveFile(Map<String, String> translations, BuildContext context) async {
    try {
      final file = await saveFileToTemporaryDirectory(translations);
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);
      if (finalPath != null && context.mounted) {
        EZTSnackBar.show(context, context.l10n.spreadsheetSavedSuccess, eztSnackBarType: EZTSnackBarType.success);
      }
    } on Exception catch (e) {
      _setFailure(e is Failure ? e : UnableToSaveFailure(message: e.toString()));
      setStateEnum(StateEnum.error);
    }
  }

  Future<void> shareFile(Map<String, String> translations, String translatedFilename) async {
    try {
      final file = await saveFileToTemporaryDirectory(translations);
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path, name: translatedFilename)]));
    } on Exception catch (e) {
      _setFailure(e is Failure ? e : UnableToSaveFailure(message: e.toString()));
      setStateEnum(StateEnum.error);
    }
  }

  Future<void> fetch() async {
    setStateEnum(StateEnum.loading);

    var result = await _experimentsUseCases.getResult(
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
