part of '../../gqlb.dart';

class _Args {
  Map<String, _Arg> _args = {};

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName != _supportedInvocation) {
      return UnsupportedError('Only call invocation is supported');
    }

    for (final entry in invocation.namedArguments.entries) {
      if (entry.value is _Input) {
        _args[entry.key.innerText] = _InputArg(entry.value);
      } else if (entry.value is List) {
        _args[entry.key.innerText] =
            _PrimitiveArg(entry.value.map(_Arg.from).toList());
      } else {
        _args[entry.key.innerText] = _PrimitiveArg(entry.value);
      }
    }

    return this;
  }
}

sealed class _Arg {
  const _Arg();

  factory _Arg.from(dynamic value) =>
      value is _Input ? _InputArg(value) : _PrimitiveArg(value);
}

class _PrimitiveArg extends _Arg {
  dynamic _value;

  _PrimitiveArg(this._value);
}

class _InputArg extends _Arg {
  _Input _value;

  _InputArg(this._value);
}
