library;

import 'dart:async';

import 'package:gql/ast.dart';
import 'package:gql/language.dart';
import 'package:gql/document.dart';
import 'package:meta/meta.dart';

/// DSL
part 'src/dsl/args.dart';

part 'src/dsl/constants.dart';

part 'src/dsl/fragment.dart';

part 'src/dsl/input.dart';

part 'src/dsl/node.dart';

part 'src/dsl/symbol.dart';

part 'src/dsl.dart';

/// AST
part 'src/ast/build.dart';

part 'src/ast/op.dart';

part 'src/ast/query.dart';

part 'src/ast/mutation.dart';

part 'src/ast/subscription.dart';

part 'src/ast/schema.dart';

/// CLIENT
part 'src/client/client.dart';
