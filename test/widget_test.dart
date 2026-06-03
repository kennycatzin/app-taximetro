import 'package:flutter_test/flutter_test.dart';

import 'package:mapa_app/main.dart';

void main() {
  testWidgets('renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pump();

    expect(find.text('Ingreso'), findsOneWidget);
    expect(find.text('Kenny Catzin'), findsOneWidget);
  });
}
