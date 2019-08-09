import 'dart:async';

import 'package:notes/data/database_provider.dart';
import 'package:notes/data/note.dart';
import 'package:notes/data/shared_preferences.dart';

abstract class HomeBloc {
  void init();
  void refresh();
  void search(String text);
  Stream<bool> get topButtonsVisibilityStream;
  Stream<List<Note>> get notesStream;
  Stream<int> get currentNoteIndexStream;
  void customizeTopButtonsVisibility();
  void changeCurrentNote(int index);
  void dispose();
}

class HomeBlocImpl implements HomeBloc {
  final _databaseProvider = DatabaseProvider();
  final _topButtonsVisibilityController = StreamController<bool>.broadcast();
  final _notesController = StreamController<List<Note>>();
  final _currentNoteIndexController = StreamController<int>.broadcast();

  int _currentNoteIndex;

  @override
  void init() {
    getBool(prefHomeTopButtonsVisible).then((topButtonsVisible) {
      print('::: init(): topButtonsVisible');
      _topButtonsVisibilityController.sink.add(topButtonsVisible);
    });
    _databaseProvider.getNotes().then((notes) {
      print('::: init(): notes');
      _notesController.sink.add(notes);
    });
  }

  @override
  void refresh() {
    _databaseProvider.getNotes().then((notes) {
      print('::: refresh(): notes');
      _notesController.sink.add(notes);
    });
    _currentNoteIndex = null;
    print('::: refresh(): currentNoteIndex');
    _currentNoteIndexController.sink.add(_currentNoteIndex);
  }

  @override
  void search(String text) {
    _databaseProvider.getNotesWithText(text).then((notes) {
      print('::: search(): notes');
      _notesController.sink.add(notes);
    });
    _currentNoteIndex = null;
    print('::: search(): currentNoteIndex');
    _currentNoteIndexController.sink.add(_currentNoteIndex);
  }

  @override
  Stream<bool> get topButtonsVisibilityStream => _topButtonsVisibilityController.stream;

  @override
  Stream<List<Note>> get notesStream => _notesController.stream;

  @override
  Stream<int> get currentNoteIndexStream => _currentNoteIndexController.stream;

  @override
  void customizeTopButtonsVisibility() {
    getBool(prefHomeTopButtonsVisible).then((topButtonsVisible) {
      final newTopButtonsVisible = !topButtonsVisible;

      setBool(prefHomeTopButtonsVisible, newTopButtonsVisible);
      print('::: customizeTopButtonsVisibility(): topButtonsVisible');
      _topButtonsVisibilityController.sink.add(newTopButtonsVisible);
    });
  }

  @override
  void changeCurrentNote(int index) {
    if (index == _currentNoteIndex) {
      _currentNoteIndex = null;
    } else {
      _currentNoteIndex = index;
    }
    print('::: changeCurrentNote(): currentNoteIndex');
    _currentNoteIndexController.sink.add(_currentNoteIndex);
  }

  @override
  void dispose() {
    _topButtonsVisibilityController.close();
    _notesController.close();
    _currentNoteIndexController.close();
  }
}
