import 'package:flutter/material.dart';
import 'package:flutter_restorablez/flutter_restorablez.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const String id = 'test-list';
  const double offset = 100.0;
  const String key = 'flutter_restorablez.scroll.$id';

  Widget buildTestList(ScrollController controller) {
    return ListView.builder(
      controller: controller,
      itemCount: 50,
      itemBuilder: (_, int i) => const SizedBox(height: 50),
    );
  }

  testWidgets('restores scroll offset', (WidgetTester tester) async {
    // Setup WITH saved offset
    SharedPreferences.setMockInitialValues(<String, Object>{
      key: offset,
    });

    ScrollController? controller;

    await tester.pumpWidget(
      MaterialApp(
        home: RestorableScroll(
          id: id,
          builder: (BuildContext context, ScrollController c) {
            controller = c;
            return buildTestList(c);
          },
        ),
      ),
    );

    await tester.pump();
    await tester.pump();
    await tester.pump();
    await tester.pumpAndSettle();

    expect(controller, isNotNull);
    expect(controller!.offset, closeTo(offset, 0.1));
  });

  testWidgets('saves scroll offset when scrolling stops',
      (WidgetTester tester) async {
    // Setup with EMPTY prefs (critical)
    SharedPreferences.setMockInitialValues(<String, Object>{});

    ScrollController? controller;

    await tester.pumpWidget(
      MaterialApp(
        home: RestorableScroll(
          id: id,
          builder: (BuildContext context, ScrollController c) {
            controller = c;
            return buildTestList(c);
          },
        ),
      ),
    );

    await tester.pump();
    await tester.pump();
    await tester.pumpAndSettle();

    expect(controller, isNotNull);
    expect(controller!.offset, 0.0);

    // Scroll
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final double? savedOffset = prefs.getDouble(key);

    expect(savedOffset, isNotNull);
    expect(savedOffset, greaterThan(0));
    expect(savedOffset, closeTo(controller!.offset, 5.0));
  });
}
