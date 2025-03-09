import 'package:gql/ast.dart';
import "package:gql/language.dart" as lang;
import 'package:gqlb/gqlb.dart';
import 'package:test/test.dart';

void main() {
  test('test query', () {
    final doc = query(
      name: "Hello",
      () => obj(
        hero: obj(
          name: obj,
          friends: obj(
            name: unit,
          ),
        ),
      ),
    );
    print(lang.printNode(doc));
  });

  test('test complex query', () {
    final doc = query(
      () => obj(
        __typename: unit,
        human: obj.someThing(
          args(
            id: 1000,
            name: "John Doe",
            items: [1, 2, 3],
            review: input(
              stars: 5,
              commentary: "This is a great movie!",
            ),
          ),
          fragment(
            ref("Human"),
            name: unit,
            height: unit,
          ),
          name: unit,
          height: unit,
          bestFriends: obj.friends(
            name: unit,
            special_name: unit,
          ),
        ),
      ),
    );
    print(lang.printNode(doc));
  });
}
