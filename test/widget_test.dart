import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alhussein_aldali_portfolio/app/portfolio_app.dart';

void main() {
  testWidgets('Nav shows main sections', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PortfolioApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Home'), findsWidgets);
    expect(find.text('About'), findsWidgets);
    expect(find.text('Projects'), findsWidgets);
    expect(find.text('Widgets'), findsWidgets);
    expect(find.text('Memory'), findsWidgets);
    expect(find.text('Contact'), findsWidgets);
  });
}

