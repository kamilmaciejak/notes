import 'package:flutter/material.dart';
import 'package:notes/bloc/home_bloc.dart';
import 'package:notes/bloc/note_bloc.dart';
import 'package:notes/data/note.dart';
import 'package:notes/ui/note.dart';
import 'package:notes/ui/widgets/builders/builders.dart';
import 'package:notes/ui/widgets/custom_raised_button.dart';
import 'package:notes/ui/widgets/utils/constants.dart';
import 'package:notes/ui/widgets/utils/methods.dart';
import 'package:notes/ui/widgets/utils/result.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  static const screenTitle = 'Home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc _homeBloc;
  NoteBloc _noteBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBlocImpl();
    _noteBloc = NoteBlocImpl();
    _homeBloc.init();
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    _noteBloc.dispose();
    super.dispose();
  }

  void _showNote(BuildContext context, {int id}) {
    Navigator.pushNamed(
      context,
      NoteScreen.routeName,
      arguments: NoteScreenArguments(id: id),
    ).then((refresh) {
      if (refresh == true) {
        _homeBloc.refresh();
      }
    });
  }

  void _searchForNote(BuildContext context) {
    buildInputDialog(
      context,
      'Search',
      'Title or text',
    ).then((result) {
      if (result is TextResult) {
        _homeBloc.search(result.text);
      } else if (result is CancellationResult) {
        _homeBloc.refresh();
      }
    });
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.format_paint),
        onPressed: _homeBloc.customizeTopButtonsVisibility,
      ),
    ];
  }

  Row _buildButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomRaisedButton(
            onPressed: _showNote,
            text: 'Add',
            icon: Icons.add,
            padding: const EdgeInsets.all(largeMargin),
          ),
        ),
        SizedBox(width: margin12),
        Expanded(
          child: CustomRaisedButton(
            onPressed: _searchForNote,
            text: 'Search',
            icon: Icons.search,
            padding: const EdgeInsets.all(largeMargin),
          ),
        ),
      ],
    );
  }

  Expanded _buildNotes() {
    return Expanded(
      child: StreamBuilder(
        stream: _homeBloc.notesStream,
        builder: (BuildContext context, AsyncSnapshot<List<Note>> notes) {
          if (notes.hasData) {
            if (notes.data.length > 0) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: notes.data.length,
                itemBuilder: (context, index) => StreamBuilder(
                  stream: _homeBloc.currentNoteIndexStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<int> currentNoteIndex) {
                    if (currentNoteIndex.hasData) {
                      return buildListItem(
                        context,
                        index,
                        currentNoteIndex.data,
                        notes.data,
                        (context, id) => _showNote(context, id: id),
                        (context, index) => _homeBloc.changeCurrentNote(index),
                      );
                    } else {
                      return buildListItem(
                        context,
                        index,
                        null,
                        notes.data,
                        (context, id) => _showNote(context, id: id),
                        (context, index) => _homeBloc.changeCurrentNote(index),
                      );
                    }
                  },
                ),
              );
            } else {
              return buildMessageText("Empty");
            }
          } else if (notes.hasError) {
            return buildMessageText(notes.error);
          }
          return buildProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(HomeScreen.screenTitle),
        actions: _buildActions(),
      ),
      backgroundColor: getBackgroundColor(context),
      body: Padding(
        padding: const EdgeInsets.all(margin),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder(
                stream: _homeBloc.topButtonsVisibilityStream,
                builder: (BuildContext context, AsyncSnapshot<bool> visible) =>
                    buildVisibleWidget(
                  Column(
                    children: <Widget>[
                      _buildButton(),
                      SizedBox(
                        height: margin,
                      ),
                    ],
                  ),
                  visible.hasData && visible.data,
                ),
              ),
              _buildNotes(),
              StreamBuilder(
                stream: _homeBloc.topButtonsVisibilityStream,
                builder: (BuildContext context, AsyncSnapshot<bool> visible) =>
                    buildVisibleWidget(
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: margin,
                      ),
                      _buildButton(),
                    ],
                  ),
                  visible.hasData && !visible.data,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
