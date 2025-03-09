part of '../../gqlb.dart';

SelectionSetNode _processNodes(Node node, List<_FragmentNode> fragments) {
  return runZoned(
    () => SelectionSetNode(
      selections: node.selectionNodes().toList(),
    ),
    zoneValues: {
      #fragments: fragments,
    },
  );
}

Iterable _processFragments(List<_FragmentNode> fragments) sync* {
  for (final fragment in fragments) {
    yield FragmentDefinitionNode(
      name: NameNode(value: fragment._name),
      typeCondition: _typeConditionNode(fragment)!,
      selectionSet: SelectionSetNode(
        selections: _selectionNodes(fragment._nodes).toList(growable: false),
      ),
    );
  }
}

extension on Node {
  void registerFragment(_FragmentNode fragment) {
    final fragments = Zone.current[#fragments];
    if (fragments is! List<_FragmentNode>) {
      throw StateError('Global list of fragments is not defined');
    }
    fragments.add(fragment);
  }

  Iterable<SelectionNode> selectionNodes() sync* {
    for (final fragment in _fragments) {
      if (fragment.isInline) {
        yield InlineFragmentNode(
          typeCondition: _typeConditionNode(fragment),
          selectionSet: SelectionSetNode(
            selections: _selectionNodes(
              fragment._nodes,
            ).toList(growable: false),
          ),
        );
      } else {
        registerFragment(fragment);
        yield FragmentSpreadNode(
          name: NameNode(value: fragment._name),
        );
      }
    }
    yield* _selectionNodes(_nodes);
  }
}

TypeConditionNode? _typeConditionNode(_FragmentNode node) {
  if (node._on == null) {
    return null;
  }
  final type = node._on!;
  return TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: type.name),
      isNonNull: type.exact,
    ),
  );
}

Iterable<SelectionNode> _selectionNodes(List<Node> nodes) sync* {
  for (final node in nodes) {
    yield FieldNode(
      name: NameNode(value: node._name),
      alias: node._alias.isNotEmpty ? NameNode(value: node._alias) : null,
      arguments: [
        for (final arg in node._args.entries)
          ArgumentNode(
            name: NameNode(value: arg.key),
            value: _argValueNode(arg.value),
          )
      ],
      selectionSet: node.isTerminal
          ? null
          : SelectionSetNode(
              selections: node.selectionNodes().toList(growable: false),
            ),
    );
  }
}

ValueNode _argValueNode(_Arg arg) {
  return switch (arg) {
    _PrimitiveArg(_value: final val) when val == null => NullValueNode(),
    _PrimitiveArg(_value: final val) when val is bool =>
      BooleanValueNode(value: val),
    _PrimitiveArg(_value: final val) when val is String =>
      StringValueNode(value: val, isBlock: val.contains('\n')),
    _PrimitiveArg(_value: final val) when val is int =>
      IntValueNode(value: val.toString()),
    _PrimitiveArg(_value: final val) when val is double =>
      FloatValueNode(value: val.toString()),
    _PrimitiveArg(_value: final val) when val is Enum =>
      EnumValueNode(name: NameNode(value: val.name)),
    _PrimitiveArg(_value: final val) when val is List =>
      ListValueNode(values: val.whereType<_Arg>().map(_argValueNode).toList()),
    _InputArg(_value: final val) => ObjectValueNode(
        fields: [
          for (final entry in val._args.entries)
            ObjectFieldNode(
              name: NameNode(value: entry.key),
              value: _argValueNode(entry.value),
            ),
        ],
      ),
    _ => NullValueNode(),
  };
}
