import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/app.dart';

void main() {
  testWidgets('MindTouch app launches onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MindTouchApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('MindTouch'), findsOneWidget);
    expect(find.text('Neural control, reimagined.'), findsOneWidget);
  });
}
