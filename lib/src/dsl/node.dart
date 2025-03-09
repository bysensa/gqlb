part of '../../gqlb.dart';

class Node {
  String __name = '';
  String __alias = '';
  List<Node> _nodes = [];
  List<_FragmentNode> _fragments = [];
  Map<String, _Arg> _args = {};

  bool get isTerminal => _nodes.isEmpty && _fragments.isEmpty;

  set _name(String name) => __name = name;
  String get _name => __alias.isEmpty ? __name : __alias;

  set _alias(String alias) => __alias = alias;
  String get _alias => __alias.isEmpty ? __alias : __name;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (!invocation.isMethod) {
      return UnsupportedError('Only method invocation supported');
    }
    if (invocation.memberName != _supportedInvocation) {
      _alias = invocation.memberName.innerText;
    }

    final positional = invocation.positionalArguments;
    final named = invocation.namedArguments;

    for (final arg in positional) {
      if (arg is _Args) {
        _args.addAll(arg._args);
      } else if (arg is _FragmentNode) {
        _fragments.add(arg);
      }
    }

    for (final entry in named.entries) {
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
