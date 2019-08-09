import 'package:intl/intl.dart';

int getCurrentDateTime() => DateTime.now().millisecondsSinceEpoch;

String formatDateTime(int milliseconds) => DateFormat('dd.MM.yyyy HH:mm:ss')
    .format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
