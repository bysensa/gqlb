part of '../../gqlb.dart';

Subscription subscription(Node Function() builder, {String? name}) {
  final node = builder();
  final fragments = <_FragmentNode>[];
  final selectionSet = _processNodes(node, fragments);
  final fragmentDefs = _processFragments(fragments);

  final op = OperationDefinitionNode(
    type: OperationType.subscription,
    name: name != null ? NameNode(value: name) : null,
    selectionSet: selectionSet,
  );
  final doc = DocumentNode(
    definitions: [op, ...fragmentDefs],
  );
  final errors = validateOperation(doc);
  assert(
    errors.isEmpty,
    'Subscription\n ${printNode(doc)}\nhas errors:\n${errors.join('\n')}',
  );
  if (errors.isNotEmpty) {
    throw SubscriptionException(errors);
  }
  return Subscription._(doc);
}

class Subscription extends Operation {
  @override
  final DocumentNode _doc;

  Subscription._(this._doc)
      : assert(
          _doc.definitions
                  .whereType<OperationDefinitionNode>()
                  .firstOrNull
                  ?.type ==
              OperationType.subscription,
          'Subscription operation is not provided',
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subscription &&
          runtimeType == other.runtimeType &&
          _doc == other._doc;

  @override
  int get hashCode => _doc.hashCode;
}

class SubscriptionException implements Exception {
  SubscriptionException(this.errors);

  final List<ValidationError> errors;

  @override
  String toString() {
    return 'Mutation has errors:\n${errors.join('\n')}';
  }
}
