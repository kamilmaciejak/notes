abstract class StringResource {
  String appName;
}

class DevStringResource implements StringResource {
  String appName = 'Notes (Dev)';
}

class ProdStringResource implements StringResource {
  String appName = 'Notes';
}
