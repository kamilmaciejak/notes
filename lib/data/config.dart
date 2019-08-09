import 'package:notes/resources/string_resource.dart';

enum Flavor {
  DEVELOPMENT,
  PRODUCTION,
}

class Config {
  static StringResource _stringResource;

  static void init(Flavor flavor) {
    switch (flavor) {
      case Flavor.DEVELOPMENT:
        _stringResource = DevStringResource();
        break;
      case Flavor.PRODUCTION:
        _stringResource = ProdStringResource();
        break;
    }
  }

  static StringResource get stringResource => _stringResource;
}
