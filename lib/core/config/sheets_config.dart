/// Configuration for Google Sheets integration
///
/// To set up Google Sheets integration:
/// 1. Create a Google Cloud project at https://console.cloud.google.com
/// 2. Enable the Google Sheets API
/// 3. Create a service account and download the JSON credentials
/// 4. Create a Google Spreadsheet with two sheets:
///    - "New Card Submissions" with headers: submission_id, submitted_at, status,
///      prompt_en, answers_en, difficulty, source, submitter_name, submitter_email,
///      app_version, locale
///    - "Card Corrections" with headers: submission_id, submitted_at, status,
///      existing_card_id, existing_card_prompt, issue_type, issue_description,
///      submitter_email, app_version, locale
/// 5. Share the spreadsheet with the service account email (with Editor access)
/// 6. Update the values below with your credentials and spreadsheet ID
class SheetsConfig {
  SheetsConfig._();

  /// Google Sheets spreadsheet ID
  /// Found in the URL: https://docs.google.com/spreadsheets/d/{SPREADSHEET_ID}/edit
  static const String spreadsheetId = 'YOUR_SPREADSHEET_ID_HERE';

  /// Sheet names within the spreadsheet
  static const String newCardsSheetName = 'New Card Submissions';
  static const String correctionsSheetName = 'Card Corrections';

  /// Headers for the New Card Submissions sheet
  static const List<String> newCardHeaders = [
    'submission_id',
    'submitted_at',
    'status',
    'prompt_en',
    'answers_en',
    'difficulty',
    'source',
    'submitter_name',
    'submitter_email',
    'app_version',
    'locale',
  ];

  /// Headers for the Card Corrections sheet
  static const List<String> correctionHeaders = [
    'submission_id',
    'submitted_at',
    'status',
    'existing_card_id',
    'existing_card_prompt',
    'issue_type',
    'issue_description',
    'submitter_email',
    'app_version',
    'locale',
  ];

  /// Service account credentials for Google Sheets API
  /// IMPORTANT: In production, consider using a more secure method
  /// to store credentials (e.g., environment variables, secure storage)
  static const Map<String, String> credentials = {
    'type': 'service_account',
    'project_id': 'YOUR_PROJECT_ID',
    'private_key_id': 'YOUR_PRIVATE_KEY_ID',
    'private_key': 'YOUR_PRIVATE_KEY',
    'client_email': 'YOUR_SERVICE_ACCOUNT_EMAIL',
    'client_id': 'YOUR_CLIENT_ID',
    'auth_uri': 'https://accounts.google.com/o/oauth2/auth',
    'token_uri': 'https://oauth2.googleapis.com/token',
    'auth_provider_x509_cert_url':
        'https://www.googleapis.com/oauth2/v1/certs',
    'client_x509_cert_url': 'YOUR_CERT_URL',
  };

  /// Check if credentials are configured
  static bool get isConfigured =>
      spreadsheetId != 'YOUR_SPREADSHEET_ID_HERE' &&
      credentials['project_id'] != 'YOUR_PROJECT_ID';
}
