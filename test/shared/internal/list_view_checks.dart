import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// itemCount without separators
void checkListViewSeparatedType({
  required final ListView listView,
  final int? itemCount,
}) {
  final String widgetName = "ListView";
  expect(
    listView.childrenDelegate,
    isInstanceOf<SliverChildBuilderDelegate>(),
    reason: "$widgetName should use constructor ListView.separated",
  );
  if (itemCount != null) {
    final realItemsCount = max(0, itemCount * 2 - 1);
    expect(
      realItemsCount,
      (listView.childrenDelegate as SliverChildBuilderDelegate).childCount,
      reason: "$widgetName should have $realItemsCount itemCount (including separators)",
    );
  }
}
