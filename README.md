# GQLB - GraphQL Builder

This package allows you build query and mutations using dynamic declarative syntax similar to
GraphQL syntax.

## Current state

Work in progress

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

## Query

### Simple query

```dart

final doc = query(
  name: "HeroQuery", () =>
    obj(
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

## Mutation

### Simple mutation

```dart

final doc = mutation(
  name: "CreateReviewForEpisode",
      () =>
      obj(
        new_review: obj.createReview(
          args(
            episode: "JEDI",
            review: input(stars: 5, commentary: "This is a great movie!"),
          ),
          stars: unit,
          commentary: unit,
        ),
      ),
);
```

### Multiple mutations

```dart

final doc = mutation(
  name: "DeleteStarships",
      () =>
      obj(
        firstShip: obj.deleteStarship(args(id: 3001)),
        secondShip: obj.deleteStarship(args(id: 3002)),
      ),
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
- [x] Subscription builder
    - [x] field declaration
    - [x] alias declaration
    - [x] arguments declaration
    - [x] fragments declaration
    - [x] inline fragments declaration
    - [ ] variables declaration
    - [ ] directives declaration
- [x] abstraction for Client
    - [x] operation execution
    - [ ] operation and request validation
