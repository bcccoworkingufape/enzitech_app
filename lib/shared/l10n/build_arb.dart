// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final locales = ['en', 'pt'];

  try {
    for (final locale in locales) {
      final directory = Directory('lib/shared/l10n/$locale');
      final outputFile = File('lib/shared/l10n/app_$locale.arb');

      final Map<String, dynamic> merged = {"@@locale": locale};

      if (!await directory.exists()) continue;

      final files = directory.listSync().whereType<File>().where((f) => f.path.endsWith('.arb')).toList();

      for (final file in files) {
        final content = await file.readAsString();
        final jsonMap = json.decode(content) as Map<String, dynamic>;

        merged.addAll(jsonMap);
      }

      // Grava o arquivo final formatado
      final encoder = JsonEncoder.withIndent('  ');
      await outputFile.writeAsString(encoder.convert(merged));

      print('✅ Gerado: ${outputFile.path}');
    }
    print('\n🎉 Todos os arquivos ARB foram mesclados com sucesso!');
  } catch (e) {
    print('Erro ao gerar os arquivos: $e');
  }
}
