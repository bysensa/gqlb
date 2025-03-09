part of '../../gqlb.dart';

extension on Symbol {
  String get innerText {
    final text = toString();
    return text.substring(8, text.length - 2);
  }
}
