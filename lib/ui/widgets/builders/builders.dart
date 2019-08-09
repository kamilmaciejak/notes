import 'package:flutter/material.dart';
import 'package:notes/data/note.dart';
import 'package:notes/ui/widgets/utils/callbacks.dart';
import 'package:notes/ui/widgets/utils/constants.dart';
import 'package:notes/ui/widgets/utils/methods.dart';
import 'package:notes/ui/widgets/utils/result.dart';

Widget buildVisibleWidget(Widget widget, bool visible) => Visibility(
      visible: visible,
      child: widget,
    );

Widget buildMessageText(String text) => Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

Widget buildProgressIndicator() => Center(
      child: CircularProgressIndicator(),
    );

Future<void> buildDialog(
    BuildContext context, String text, PressedCallback onPressed) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      title: Icon(
        Icons.warning,
      ),
      content: Text(
        text,
      ),
      actions: <Widget>[
        FlatButton(
          textColor: getTextColor(context),
          onPressed: () => Navigator.of(context).pop(),
          child: Text('No'),
        ),
        FlatButton(
          textColor: getTextColor(context),
          onPressed: () => onPressed(context),
          child: Text('Yes'),
        )
      ],
    ),
  );
}

Future<Result> buildInputDialog(
    BuildContext context, String okButtonText, String hintText) {
  String text = '';
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      title: Icon(
        Icons.info,
      ),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: Colors.black12,
          icon: Icon(Icons.search),
        ),
        onChanged: (value) {
          text = value;
        },
        textCapitalization: TextCapitalization.sentences,
      ),
      actions: <Widget>[
        FlatButton(
          textColor: getTextColor(context),
          onPressed: () => Navigator.of(context).pop(Result.text(text)),
          child: Text(okButtonText),
        ),
        FlatButton(
          textColor: getTextColor(context),
          onPressed: () => Navigator.of(context).pop(Result.cancellation()),
          child: Text('Cancel'),
        )
      ],
    ),
  );
}

Text _buildListItemTitleText(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  );
}

Text _buildListItemSubtitleText(BuildContext context, String text) {
  return Text(
    text,
    style: Theme.of(context).textTheme.caption.copyWith(
          fontSize: 14,
        ),
  );
}

Widget buildListItem(
    BuildContext context,
    int index,
    int currentIndex,
    List<Note> notes,
    SelectedCallback onSelected,
    SelectedCallback onCurrentSelected) {
  return Card(
    elevation: 2,
    margin: EdgeInsets.symmetric(vertical: smallMargin),
    child: InkWell(
      onTap: () => onSelected(
        context,
        notes[index].id,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              print("Container was tapped1");
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(
                left: margin20,
                top: margin12,
                bottom: margin12,
              ),
              child: Ink(
                decoration: ShapeDecoration(
                  color: getIconButtonColor(context),
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.pageview,
                    color: Colors.white,
                  ),
                  onPressed: () => onCurrentSelected(
                    context,
                    index,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: margin12,
                horizontal: margin20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildListItemTitleText(
                          notes[index].title,
                        ),
                        SizedBox(height: smallMargin),
                        buildVisibleWidget(
                            _buildListItemSubtitleText(
                              context,
                              notes[index].text,
                            ),
                            index == currentIndex)
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: getTextColor(context),
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
