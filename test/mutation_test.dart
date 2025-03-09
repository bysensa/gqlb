import 'package:gql/ast.dart';
import "package:gql/language.dart" as lang;
import 'package:gqlb/gqlb.dart';
import 'package:test/test.dart';

void main() {
  // Test the query functionality here
  test('test mutation', () {
    final doc = mutation(
      name: "CreateReviewForEpisode",
      () => obj(
        createReview: obj(
          args(
            episode: "JEDI",
            review: input(stars: 5, commentary: "This is a great movie!"),
          ),
          stars: unit,
          commentary: unit,
        ),
      ),
    );
    print(lang.printNode(doc));
  });

  test('multiple mutations', () {
    final doc = mutation(
      name: "DeleteStarships",
      () => obj(
        firstShip: obj.deleteStarship(args(id: 3001)),
        secondShip: obj.deleteStarship(args(id: 3002)),
      ),
    );
    print(lang.printNode(doc));
  });
}
