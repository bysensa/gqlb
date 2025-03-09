part of '../../gqlb.dart';

class _FragmentNode {
  _TypeRef? _on;
  String _name = '';
  List<Node> _nodes = [];

  bool get isInline => _name.isEmpty;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (!invocation.isMethod) {
      return UnsupportedError('Only method invocation supported');
    }
    if (invocation.memberName != _supportedInvocation) {
      _name = invocation.memberName.innerText;
    }

    final targetType = invocation.positionalArguments.firstOrNull;
    if (targetType is! _TypeRef) {
      return StateError(
        'first positional argument of fragment must contain Type name '
        'for on clause declared using ref function',
      );
    }
    _on = targetType;

    for (final entry in invocation.namedArguments.entries) {
      final field = entry.key.innerText;
      final value = entry.value;
      if (value is Node) {
        value._name = field;
        _nodes.add(value);
      }
    }

    return this;
  }
}

class _TypeRef {
  _TypeRef(this.name, {this.exact = false});

  final String name;
  final bool exact;
}
