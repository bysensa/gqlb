part of '../../gqlb.dart';

sealed class Operation {
  DocumentNode get _doc;

  @visibleForTesting
  String toStringDebug() => printNode(_doc);
}
