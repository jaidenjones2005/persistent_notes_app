
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class NoteStorage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/notes.txt');
  }

  Future<File> writeNote(String text) async {
    final file = await _localFile;
    return file.writeAsString(text);
  }

  Future<String> readRawContent() async {
    final file = await _localFile;
    return file.readAsString();
  }

  // Phase 3: Safely read saved notes
  Future<String> readNote() async {
    try {
      final file = await _localFile;
      return await file.readAsString();
    } catch (e) {
      return '';
    }
  }
}
