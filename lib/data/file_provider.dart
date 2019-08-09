import 'dart:io';
import 'package:notes/data/note.dart';
import 'package:simple_permissions/simple_permissions.dart';

class FileProvider {
  static final _path = '/storage/emulated/0/Download';
  static final _filename = 'note.txt';
  static FileProvider _this;

  FileProvider._();

  factory FileProvider() {
    _this ??= FileProvider._();
    return _this;
  }

  Future<File> get _file async => File('$_path/$_filename');

  Future<bool> get hasPermission async =>
      await SimplePermissions.checkPermission(Permission.WriteExternalStorage);

  Future<bool> requestPermission() async {
    PermissionStatus permissionStatus =
        await SimplePermissions.requestPermission(
            Permission.WriteExternalStorage);
    return permissionStatus == PermissionStatus.authorized;
  }

  Future<String> readNoteText() async {
    final file = await _file;
    return await file.readAsString();
  }

  Future<File> writeNote(Note note) async {
    final file = await _file;
    return await file.writeAsString('${note.title}\n${note.text}');
  }
}
