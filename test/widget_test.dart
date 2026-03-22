import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:optizenqor_healthcare/app.dart';

void main() {
  testWidgets('App renders authentication flow', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Checking session...'), findsOneWidget);
  });
}
