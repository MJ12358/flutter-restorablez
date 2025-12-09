import 'package:flutter/widgets.dart';
import 'package:flutter_restorablez/flutter_restorablez.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Scrollable widgets require a Directionality
/// widget ancestor to determine the cross-axis
/// direction of the scroll view
void main() {
  const String id = 'test-list';
  const double offset = 100.0;
  final List<Widget> items = List<Widget>.generate(
    20,
    (int i) => SizedBox(height: 50, child: Text('Item $i')),
  );

  /// 1) Mock a saved offset of [offset] pixels
  SharedPreferences.setMockInitialValues(
    <String, Object>{id: offset},
  );

  /// 2) Variable to capture the controller from inside the builder
  ScrollController? capturedController;

  testWidgets('restores offset with ListView', (
    WidgetTester tester,
  ) async {
    /// 3) Build the ScrollRestoration widget
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RestorableScroll(
          id: id,
          builder: (BuildContext context, ScrollController controller) {
            // capture it for later inspection
            capturedController = controller;
            return ListView.builder(
              controller: controller,
              itemCount: items.length,
              itemBuilder: (_, int index) {
                return items[index];
              },
            );
          },
        ),
      ),
    );

    /// 4) Allow initState and our postFrameCallback to run
    await tester.pump(); // kicks off initState()
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle(); // waits for any remaining frames

    /// 5) Now assert the controller offset
    expect(capturedController, isNotNull);

    /// It should be roughly [offset] (clamped to maxScroll if list shorter)
    expect(capturedController!.offset, closeTo(offset, 0.1));
  });

  testWidgets('restores offset with CustomScrollView', (
    WidgetTester tester,
  ) async {
    /// 3) Build the ScrollRestoration widget
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RestorableScroll(
          id: id,
          builder: (_, ScrollController controller) {
            // capture it for later inspection
            capturedController = controller;
            return CustomScrollView(
              controller: controller,
              slivers: <Widget>[
                const SliverToBoxAdapter(
                  child: SizedBox(height: 50),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    items,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    /// 4) Allow initState and our postFrameCallback to run
    await tester.pump(); // kicks off initState()
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle(); // waits for any remaining frames

    /// 5) Now assert the controller offset
    expect(capturedController, isNotNull);

    /// It should be roughly [offset] (clamped to maxScroll if list shorter)
    expect(capturedController!.offset, closeTo(offset, 0.1));
  });
}
