import 'package:flutter_dotenv/flutter_dotenv.dart';

class AnalyticsConfig {
  const AnalyticsConfig._();

  static String get apiKey {
    final fromEnv = dotenv.maybeGet('POSTHOG_API_KEY', fallback: '')?.trim();
    if (fromEnv != null && fromEnv.isNotEmpty) {
      return fromEnv;
    }
    return const String.fromEnvironment('POSTHOG_API_KEY', defaultValue: '');
  }

  static String get host {
    final fromEnv = dotenv.maybeGet('POSTHOG_HOST', fallback: '')?.trim();
    if (fromEnv != null && fromEnv.isNotEmpty) {
      return fromEnv;
    }
    return const String.fromEnvironment(
      'POSTHOG_HOST',
      defaultValue: 'https://app.posthog.com',
    );
  }

  static bool get allowDebug {
    final fromEnv = dotenv.maybeGet('POSTHOG_ALLOW_DEBUG', fallback: '')?.trim();
    if (fromEnv == null || fromEnv.isEmpty) {
      return const bool.fromEnvironment(
        'POSTHOG_ALLOW_DEBUG',
        defaultValue: false,
      );
    }
    return fromEnv == 'true' || fromEnv == '1';
  }
}
