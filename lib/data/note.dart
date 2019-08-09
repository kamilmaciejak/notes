import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable(nullable: false)
class Note {
  final int id;
  final String title;
  final String text;
  final int creationDate;

  Note({
    this.id,
    this.title,
    this.text,
    this.creationDate,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}

/* build_runner commands:
flutter packages pub run build_runner build
flutter packages pub run build_runner watch
*/
