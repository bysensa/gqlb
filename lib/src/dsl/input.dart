part of '../../gqlb.dart';

class _Input {
  Map<String, _Arg> _args = {};

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName != _supportedInvocation) {
      return UnsupportedError('Only call invocation is supported');
    }

    _args.addAll(
      invocation.namedArguments.map((key, value) {
        return MapEntry(key.innerText, _Arg.from(value));
      }),
    );

    return this;
  }
}
