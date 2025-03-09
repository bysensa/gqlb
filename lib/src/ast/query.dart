part of '../../gqlb.dart';

Query query(Node Function() builder, {String? name}) {
  final node = builder();
  final fragments = <_FragmentNode>[];
  final selectionSet = _processNodes(node, fragments);
  final fragmentDefs = _processFragments(fragments);

  final op = OperationDefinitionNode(
    type: OperationType.query,
    name: name != null ? NameNode(value: name) : null,
    selectionSet: selectionSet,
  );
  final doc = DocumentNode(
    definitions: [op, ...fragmentDefs],
  );
  final errors = validateOperation(doc);
  assert(
    errors.isEmpty,
    'Query\n ${printNode(doc)}\nhas errors:\n${errors.join('\n')}',
  );
  if (errors.isNotEmpty) {
    throw QueryException(errors);
  }
  return Query._(doc);
}

class Query extends Operation {
  @override
  final DocumentNode _doc;

  Query._(this._doc)
      : assert(
          _doc.definitions
                  .whereType<OperationDefinitionNode>()
                  .firstOrNull
                  ?.type ==
              OperationType.query,
          'Query operation is not provided',
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Mutation &&
          runtimeType == other.runtimeType &&
          _doc == other._doc;

  @override
  int get hashCode => _doc.hashCode;
}

class QueryException implements Exception {
  QueryException(this.errors);

  final List<ValidationError> errors;

  @override
  String toString() {
    return 'Query has errors:\n${errors.join('\n')}';
  }
}
