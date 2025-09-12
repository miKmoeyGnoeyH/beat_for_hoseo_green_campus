import 'dart:developer';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class PermissiveFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => true;
}

class FileOutput extends LogOutput {
  final String filename;
  File? _logFile;

  FileOutput(this.filename);

  @override
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _logFile = File('${directory.path}/$filename');
    log("log file path: ${_logFile!.path}");

    if (!(await _logFile!.exists())) {
      await _logFile!.create(recursive: true);
    }
  }

  @override
  Future<void> output(OutputEvent event) async {
    if (_logFile == null) return;
    for (var line in event.lines) {
      await _logFile!.writeAsString('$line\n', mode: FileMode.append);
    }
  }

  @override
  Future<void> destroy() async {}
}

class BEATLogger {
  static late final Logger _instance;

  static Future<void> init() async {
    final fileOutput = FileOutput("log.txt");
    await fileOutput.init(); // 로그 파일 초기화

    _instance = Logger(
      printer: PrettyPrinter(
        methodCount: 5,
        // lineLength: 100000,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      filter: PermissiveFilter(),
      output: MultiOutput([
        ConsoleOutput(), // 콘솔 출력 추가!
        fileOutput, // 파일 출력
      ]),
    );
  }

  static void d(String message) => _instance.d(message);

  static void i(String message) => _instance.i(message);

  static void e(String message) => _instance.e(message);

  static void w(String message) => _instance.w(message);
}
