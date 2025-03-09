part of '../../gqlb.dart';

Mutation mutation(Node Function() builder, {String? name}) {
  final node = builder();
  final fragments = <_FragmentNode>[];
  final selectionSet = _processNodes(node, fragments);
  final fragmentDefs = _processFragments(fragments);

  final op = OperationDefinitionNode(
    type: OperationType.mutation,
    name: name != null ? NameNode(value: name) : null,
    selectionSet: selectionSet,
  );
  final doc = DocumentNode(
    definitions: [op, ...fragmentDefs],
  );
  final errors = validateOperation(doc);
  assert(
    errors.isEmpty,
    'Mutation\n ${printNode(doc)}\nhas errors:\n${errors.join('\n')}',
  );
  if (errors.isNotEmpty) {
    throw MutationException(errors);
  }
  return Mutation._(doc);
}

class Mutation extends Operation {
  @override
  final DocumentNode _doc;

  Mutation._(this._doc)
      : assert(
          _doc.definitions
                  .whereType<OperationDefinitionNode>()
                  .firstOrNull
                  ?.type ==
              OperationType.mutation,
          'Mutation operation is not provided',
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

class MutationException implements Exception {
  MutationException(this.errors);

  final List<ValidationError> errors;

  @override
  String toString() {
    return 'Mutation has errors:\n${errors.join('\n')}';
  }
}
