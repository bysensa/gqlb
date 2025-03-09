import 'package:gql/ast.dart';
import "package:gql/language.dart" as lang;
import 'package:gqlb/gqlb.dart';
import 'package:test/test.dart';

void main() {
  test('test query', () {
    final doc = query(
      name: "HeroQuery",
      () => obj(
        hero: obj(
          name: unit,
          friends: obj(
            name: unit,
          ),
        ),
      ),
    );
    print(doc.toStringDebug());
  });

  test('test complex query', () {
    final doc = query(
      () {
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
      },
    );
    print(doc.toStringDebug());
  });
}
