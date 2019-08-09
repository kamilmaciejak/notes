import 'package:flutter/material.dart';
import 'package:notes/bloc/note_bloc.dart';
import 'package:notes/data/note.dart';
import 'package:notes/ui/utils/time.dart';
import 'package:notes/ui/utils/validators.dart';
import 'package:notes/ui/widgets/builders/builders.dart';
import 'package:notes/ui/widgets/custom_raised_button.dart';
import 'package:notes/ui/widgets/custom_text_field.dart';
import 'package:notes/ui/widgets/utils/constants.dart';
import 'package:notes/ui/widgets/utils/methods.dart';

class NoteScreenArguments {
  final int id;

  NoteScreenArguments({this.id});
}

class NoteScreen extends StatefulWidget {
  static const routeName = '/note';
  static const screenTitle = 'Note';
  static const titleLength = 24;

  final NoteScreenArguments args;

  NoteScreen({
    Key key,
    this.args,
  }) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _textController = TextEditingController();

  NoteBloc _noteBloc;
  FocusNode _titleFocusNode;
  FocusNode _textFocusNode;

  @override
  void initState() {
    super.initState();
    _noteBloc = NoteBlocImpl();
    _noteBloc.noteStream.listen(_initView);
    _noteBloc.messageStream.listen(_showMessage);
    _noteBloc.returnStream.listen(_return);
    _noteBloc.init(id: widget.args.id);
    _titleFocusNode = FocusNode();
    _textFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    _titleFocusNode.dispose();
    _textFocusNode.dispose();
    _noteBloc.dispose();
    super.dispose();
  }

  void _initView(Note note) {
    if (note == null) {
      _titleController.text = '';
      _textController.text = '';
    } else {
      _titleController.text = note.title;
      _textController.text = note.text;
    }
  }

  void _save(BuildContext context) {
    final form = _formKey.currentState;
    if (form.validate()) {
      String title = _titleController.text;
      String text = _textController.text;
      _noteBloc.validate(title, text).then((valid) {
        if (valid) {
          form.save();
          _noteBloc.save(title, text);
        } else {
          _showMessage('Invalid title or text');
        }
      });
    }
  }

  void _showDeletionDialog(BuildContext context) {
    buildDialog(
      context,
      'Are you sure you want to delete this note?',
      (context) => _noteBloc.deleteNote(),
    );
  }

  void _showMessage(String text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  void _return(bool update) {
    Navigator.pop(context, update);
  }

  bool _isSaved() {
    return widget.args.id != null;
  }

  Row _buildButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomRaisedButton(
            onPressed: (context) => _noteBloc.duplicate(),
            text: 'Duplicate',
            icon: Icons.content_copy,
            padding: const EdgeInsets.all(largeMargin),
          ),
        ),
        SizedBox(width: margin12),
        CustomRaisedButton(
          onPressed: (context) => _noteBloc.exportToFile(),
          text: 'Export to file',
          icon: Icons.file_upload,
          padding: const EdgeInsets.all(largeMargin),
        ),
      ],
    );
  }

  Text _buildCreationDate(int creationDate) =>
      Text('Creation date: ${formatDateTime(creationDate)}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(NoteScreen.screenTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(margin),
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Text(
                  'Note',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.display1.fontSize,
                  ),
                ),
                SizedBox(height: margin24),
                CustomTextField(
                  validator: validateTitle,
                  onSaved: (context, title) => {},
                  onFieldSubmitted: (user) => changeFocus(
                    context,
                    _titleFocusNode,
                    _textFocusNode,
                  ),
                  hintText: 'Title',
                  icon: Icons.title,
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  focusNode: _titleFocusNode,
                  autofocus: !_isSaved(),
                  maxLength: NoteScreen.titleLength,
                ),
                SizedBox(height: margin12),
                CustomTextField(
                  validator: validateText,
                  onSaved: (context, text) => {},
                  hintText: 'Text',
                  icon: Icons.text_fields,
                  controller: _textController,
                  focusNode: _textFocusNode,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                ),
                StreamBuilder(
                  stream: _noteBloc.noteStream,
                  builder: (BuildContext context, AsyncSnapshot<Note> note) =>
                      buildVisibleWidget(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(height: margin12),
                        _buildCreationDate(note.data?.creationDate ?? 0),
                      ],
                    ),
                    _isSaved(),
                  ),
                ),
                SizedBox(height: margin24),
                CustomRaisedButton(
                  onPressed: _save,
                  text: 'Save',
                  icon: Icons.save,
                  padding: const EdgeInsets.all(largeMargin),
                ),
                SizedBox(height: margin12),
                buildVisibleWidget(
                  _buildButtons(),
                  _isSaved(),
                ),
                SizedBox(height: margin12),
                buildVisibleWidget(
                  CustomRaisedButton(
                    onPressed: _showDeletionDialog,
                    text: 'Delete',
                    icon: Icons.delete,
                    padding: const EdgeInsets.all(largeMargin),
                  ),
                  _isSaved(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
