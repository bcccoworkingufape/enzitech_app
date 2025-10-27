// ignore_for_file: avoid_print

// 🎯 Dart imports:
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final locales = ['en', 'pt'];
  bool hasErrors = false;

  try {
    for (final locale in locales) {
      final directory = Directory('lib/shared/l10n/$locale');
      final outputFile = File('lib/shared/l10n/app_$locale.arb');

      final Map<String, dynamic> merged = {"@@locale": locale};

      if (!await directory.exists()){
        print('⚠️ Diretório não encontrado para o idioma: $locale (${directory.path})');
        continue;
      }

      final files = directory.listSync().whereType<File>().where((f) => f.path.endsWith('.arb')).toList();


      for (final file in files) {
        print('  Lendo: ${file.path}');
        try {
          final content = await file.readAsString();
          final jsonMap = json.decode(content) as Map<String, dynamic>;

          jsonMap.remove('@@locale');

          merged.addAll(jsonMap);
        } on FormatException catch (e) {
          print('❌ ERRO DE FORMATAÇÃO JSON no arquivo: ${file.path}');
          print('   Detalhes: $e');
          hasErrors = true;
        } catch (e) {
          print('❌ Erro ao processar o arquivo ${file.path}: $e');
          hasErrors = true;
        }
      }

      // Só grava o arquivo final se não houve erros de formatação
      if (!hasErrors) {
        try {
          final encoder = JsonEncoder.withIndent('  ');
          await outputFile.writeAsString(encoder.convert(merged));
          print('✅ Gerado: ${outputFile.path}');
        } catch (e) {
          print('❌ Erro ao gravar o arquivo ${outputFile.path}: $e');
          hasErrors = true;
        }
      } else {
        print('⚠️ Arquivo final ${outputFile.path} NÃO foi gerado devido a erros anteriores.');
      }
    }

    if (hasErrors) {
      print('\n💔 Processo finalizado com erros. Verifique os arquivos ARB indicados.');
    } else {
      print('\n🎉 Todos os arquivos ARB foram mesclados com sucesso!');
    }

  } catch (e) {
    print('Erro geral ao gerar os arquivos: $e');
  }
}
