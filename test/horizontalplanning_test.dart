import 'package:flutter_test/flutter_test.dart';

import 'package:horizontalplanning/horizontalplanning.dart';

void main() {
  test('todo', () {
    final HorizontalPlanning hp = HorizontalPlanning(
      title: "Title",
    );
    expect(hp.title, "Title");
  });
}
