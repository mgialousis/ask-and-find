import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pes_vres/l10n/app_localizations.dart';
import 'package:pes_vres/presentation/screens/home/home_screen.dart';

void main() {
  testWidgets('Home screen shows Spanish strings when locale is es',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: HomeScreen(),
      ),
    );

    expect(find.text('Nuevo Juego'), findsOneWidget);
    expect(find.text('Cómo Jugar'), findsOneWidget);
    expect(find.text('Ajustes'), findsOneWidget);
  });
}
