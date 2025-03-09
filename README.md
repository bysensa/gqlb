# GQLB - GraphQL Builder 

This package allows you build query and mutations using dynamic declarative syntax similar to 
GraphQL syntax. 

## Current state
The package is under development.

## Usage

To use this package, add `gqlb` as a dependency in your pubspec.yaml file.

```yaml
dependencies:
  gqlb: ^0.1.0
```

Then import the package:

```dart
import 'package:gqlb/gqlb.dart';
```

### Query example

```dart
final doc = query(
  name: "HeroQuery", () => obj(
    hero: obj(
      name: unit,
      friends: obj(
        name: unit,
      ),
    ),
  ),
);
```

### Complex query
```dart
final doc = query(() {
    final humanFragment = fragment.humanPart(
      ref("Human"),
      name: unit,
      height: unit,
    );

    return obj(
      __typename: unit,
      human: obj(
        args(
          id: 1000,
          name: "John Doe",
          items: [1, 2, 3],
          review: input(
            stars: 5,
            commentary: "This is a great movie!",
          ),
        ),
        humanFragment,
        fragment(
          ref("Human", exact: true),
          name: unit,
        ),
        name: unit,
        height: unit,
        bestFriends: obj.friends(
          name: unit,
          special_name: unit,
        ),
      ),
    );
  }
);
```

## To Do
- [x] Query builder
  - [x] field declaration
  - [x] alias declaration
  - [x] arguments declaration
  - [x] fragments declaration
  - [x] inline fragments declaration
  - [ ] variables declaration
  - [ ] directives declaration
- [x] Mutation builder
  - [x] field declaration
  - [x] alias declaration
  - [x] arguments declaration
  - [x] fragments declaration
  - [x] inline fragments declaration
  - [ ] variables declaration
  - [ ] directives declaration
- [ ] Subscription builder