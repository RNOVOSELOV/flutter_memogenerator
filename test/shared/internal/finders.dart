import 'package:flutter_test/flutter_test.dart';

Finder findTypeByTextOnlyInParentType(
  final Type type,
  final String text,
  final Type parentType,
) {
  return find.descendant(
    of: find.byType(parentType),
    matching: find.ancestor(of: find.text(text), matching: find.byType(type)),
  );
}

Finder findTypeByChildTypeOnlyInParentType(
    final Type type,
    final Type childType,
    final Type parentType,
    ) {
  return find.descendant(
    of: find.byType(parentType),
    matching: find.ancestor(of: find.byType(childType), matching: find.byType(type)),
  );
}
