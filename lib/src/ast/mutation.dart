part of '../../gqlb.dart';

DocumentNode mutation(Node Function() builder, {String? name}) {
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
  return doc;
}
