// ignore_for_file: avoid_print

import 'dart:io';

void main() async {
  final isWindows = Platform.isWindows;
  final flutterCmd = isWindows ? 'flutter.bat' : 'flutter';

  // Executa o script de geração das traduções
  await _run('dart', ['run', 'lib/shared/l10n/build_arb.dart']);

  // Executa o import_sorter
  await _run('dart', ['run', 'import_sorter:main']);

  // Executa o import_path_converter
  await _run('dart', ['run', 'import_path_converter:main']);

  // Executa o flutter clean
  await _run(flutterCmd, ['clean']);

  // Executa o flutter pub get
  await _run(flutterCmd, ['pub', 'get']);
}

Future<void> _run(String command, List<String> args) async {
  print('-' * 50);
  print('🚀 Executando: $command ${args.join(" ")}\n');

  final process = await Process.start(command, args, runInShell: true);

  // Encaminha a saída padrão e erros diretamente ao terminal
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);

  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    stderr.writeln('\n❌ Erro ao executar "$command ${args.join(" ")}" (código $exitCode)');
    exit(exitCode);
  }
}
