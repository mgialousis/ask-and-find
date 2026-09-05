/// Public configuration for the card-submission API.
///
/// The mobile app intentionally contains no Google service-account credentials.
/// A separately deployed HTTPS backend owns those credentials, validates and
/// rate-limits requests, and writes accepted submissions to the data store.
class SubmissionEndpointConfig {
  const SubmissionEndpointConfig._();

  static const String _rawUrl = String.fromEnvironment(
    'SUBMISSIONS_ENDPOINT_URL',
    defaultValue: '',
  );

  static Uri? get endpoint {
    final uri = Uri.tryParse(_rawUrl.trim());
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      return null;
    }
    return uri;
  }
}
