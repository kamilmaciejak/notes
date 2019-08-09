import 'dart:async';

import 'package:notes/data/database_provider.dart';
import 'package:notes/data/file_provider.dart';
import 'package:notes/data/note.dart';
import 'package:notes/ui/utils/time.dart';

abstract class NoteBloc {
  void init({int id});
  Stream<Note> get noteStream;
  Stream<String> get messageStream;
  Stream<bool> get returnStream;
  Future<bool> validate(String title, String text);
  void save(String title, String text);
  void duplicate();
  void exportToFile();
  void deleteNote();
  void dispose();
}

class NoteBlocImpl implements NoteBloc {
  final _databaseProvider = DatabaseProvider();
  final _noteController = StreamController<Note>.broadcast();
  final _messageController = StreamController<String>();
  final _returnController = StreamController<bool>();

  Note _note;

  @override
  void init({int id}) async {
    if (id == null) {
      _noteController.sink.add(null);
    } else {
      _databaseProvider.getNote(id).then((note) {
        _note = note;
        _noteController.sink.add(note);
      });
    }
  }

  @override
  Stream<Note> get noteStream => _noteController.stream;

  @override
  Stream<String> get messageStream => _messageController.stream;

  @override
  Stream<bool> get returnStream => _returnController.stream;

  @override
  Future<bool> validate(String title, String text) async => true;

  @override
  void save(String title, String text) {
    final note = Note(
      id: _note?.id,
      title: title,
      text: text,
      creationDate: _note?.creationDate ?? getCurrentDateTime(),
    );
    _databaseProvider.insertNote(note).then((id) {
      _returnController.sink.add(true);
    });
  }

  @override
  void duplicate() {
    final duplicatedNote = Note(
      title: _note.title,
      text: _note.text,
      creationDate: getCurrentDateTime(),
    );
    _databaseProvider.insertNote(duplicatedNote).then((id) {
      _returnController.sink.add(true);
    });
  }

  @override
  void exportToFile() {
    final fileProvider = FileProvider();
    fileProvider.hasPermission.then((isGranted) {
      if (isGranted) {
        fileProvider.writeNote(_note).then((file) {
          _messageController.sink.add('Exported to: ${file.path}');
        }).catchError((error) {
          _messageController.sink.add(error);
        });
      } else {
        _requestPermission();
      }
    });
  }

  void _requestPermission() {
    FileProvider().requestPermission().then((isGranted) {
      if (isGranted) {
        _messageController.sink.add('Authorized, ready to export');
      } else {
        _messageController.sink.add('Denied');
      }
    });
  }

  @override
  void deleteNote() {
    _databaseProvider.deleteNote(_note.id).then((number) {
      _returnController.sink.add(true);
      _returnController.sink.add(true);
    });
  }

  @override
  void dispose() {
    _noteController.close();
    _messageController.close();
    _returnController.close();
  }
}
