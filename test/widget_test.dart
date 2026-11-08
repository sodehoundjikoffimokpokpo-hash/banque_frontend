import 'package:flutter_test/flutter_test.dart';
import 'package:banque_frontend/main.dart';

void main() {
  testWidgets('Vérification du chargement du tableau de bord', (
    WidgetTester tester,
  ) async {
    // Charge notre widget de banque
    await tester.pumpWidget(const TableauDeBordBancaire());
  });
}
