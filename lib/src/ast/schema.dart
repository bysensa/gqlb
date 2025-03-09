part of '../../gqlb.dart';

class Schema {
  final DocumentNode _doc;

  Schema._(this._doc);
}

class SchemaException implements Exception {
  SchemaException(this.errors);

  final List<ValidationError> errors;

  @override
  String toString() {
    return 'Schema has errors:\n${errors.join('\n')}';
  }
}
