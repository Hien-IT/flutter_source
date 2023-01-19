import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileLocal {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final file = File('$path/counter.txt');

    if (!file.existsSync()) {
      file.createSync();
    }

    return file;
  }

  Future<void> deleteFile() async {
    final file = await _localFile;
    await file.delete();
  }

  Future<File> writeFile(String data) async {
    final file = await _localFile;

    return file.writeAsString(data);
  }

  Future<String> readFile() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '';
    }
  }
}
