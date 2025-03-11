part of '../../gqlb.dart';

class GraphQLClient<R> {
  final SchemaProvider schemaProvider;
  final Transport<R> transport;

  GraphQLClient({
    required this.schemaProvider,
    required this.transport,
  });

  Schema? _schema;

  Future<void> _ensureSchemaReady() async {
    _schema ??= await schemaProvider.schema();
  }

  Future<R> execute(Operation op) async {
    await _ensureSchemaReady();
    final schema = _schema!;
    final errors = validateRequest(schema._doc, op._doc);
    assert(
      errors.isEmpty,
      'Request\n ${printNode(op._doc)}\nhas errors:\n${errors.join('\n')}',
    );
    if (errors.isNotEmpty) {
      throw ExecutionException(errors);
    }
    return await transport.execute(op);
  }

  Stream<R> subscribe(Subscription op) async* {
    await _ensureSchemaReady();
    final schema = _schema!;
    final errors = validateRequest(schema._doc, op._doc);
    assert(
      errors.isEmpty,
      'Request\n ${printNode(op._doc)}\nhas errors:\n${errors.join('\n')}',
    );
    if (errors.isNotEmpty) {
      throw ExecutionException(errors);
    }
    yield* transport.subscribe(op);
  }
}

class ExecutionException implements Exception {
  ExecutionException(this.errors);

  final List<ValidationError> errors;

  @override
  String toString() {
    return 'Request has errors:\n${errors.join('\n')}';
  }
}

mixin SchemaProvider {
  FutureOr<String> rawSchema();

  @mustCallSuper
  Future<Schema> schema() async {
    final schemaString = await rawSchema();
    final schemaDoc = parseString(schemaString);
    final errors = validateSchema(schemaDoc);
    assert(
      errors.isEmpty,
      'Schema\n ${printNode(schemaDoc)}\nhas errors:\n${errors.join('\n')}',
    );
    if (errors.isNotEmpty) {
      throw SchemaException(errors);
    }
    return Schema._(schemaDoc);
  }
}

mixin Transport<R> {
  Future<R> execute(Operation op);

  Stream<R> subscribe(Operation op);
}
