import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pes_vres/app.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The dark mode toggle persisted for months while `app.dart` hardcoded
/// `ThemeMode.light` and `AppTheme.darkTheme` returned the light theme, so the
/// setting did nothing. These tests pin both halves of that wiring.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('darkTheme is actually dark and not a copy of lightTheme', () {
    final dark = AppTheme.darkTheme;
    expect(dark.brightness, Brightness.dark);
    expect(dark.colorScheme.brightness, Brightness.dark);
    expect(dark.scaffoldBackgroundColor, isNot(AppTheme.lightTheme.scaffoldBackgroundColor));
    expect(dark.scaffoldBackgroundColor, AppPalette.dark.background);
    expect(dark.colorScheme.onSurface, AppPalette.dark.textPrimary);
  });

  test('dark palette text meets WCAG AA contrast against its surface', () {
    double luminance(Color c) => c.computeLuminance();
    double ratio(Color fg, Color bg) {
      final l1 = luminance(fg), l2 = luminance(bg);
      final hi = l1 > l2 ? l1 : l2, lo = l1 > l2 ? l2 : l1;
      return (hi + 0.05) / (lo + 0.05);
    }

    const p = AppPalette.dark;
    expect(ratio(p.textPrimary, p.surface), greaterThan(4.5));
    expect(ratio(p.textSecondary, p.surface), greaterThan(4.5));
    expect(ratio(p.textPrimary, p.background), greaterThan(4.5));
    expect(ratio(p.textSecondary, p.background), greaterThan(4.5));
  });

  testWidgets('the dark mode setting drives the applied theme', (tester) async {
    SharedPreferences.setMockInitialValues({'settings_dark_mode': true});
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp).first);
    expect(app.themeMode, ThemeMode.dark,
        reason: 'themeMode must follow settingsProvider, not be hardcoded');

    final context = tester.element(find.byType(Scaffold).first);
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(context.palette.textPrimary, AppPalette.dark.textPrimary);
  });

  testWidgets('light remains the default when the setting is off', (tester) async {
    SharedPreferences.setMockInitialValues({'settings_dark_mode': false});
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp).first);
    expect(app.themeMode, ThemeMode.light);

    final context = tester.element(find.byType(Scaffold).first);
    expect(context.palette.textPrimary, AppColors.textPrimary,
        reason: 'light mode must render exactly as it did before dark existed');
  });
}
