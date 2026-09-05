class AnalyticsConfig {
  const AnalyticsConfig._();

  static const String apiKey = String.fromEnvironment(
    'POSTHOG_API_KEY',
    defaultValue: '',
  );

  static const String host = String.fromEnvironment(
    'POSTHOG_HOST',
    defaultValue: 'https://eu.i.posthog.com',
  );

  static const bool allowDebug = bool.fromEnvironment(
    'POSTHOG_ALLOW_DEBUG',
    defaultValue: false,
  );
}
