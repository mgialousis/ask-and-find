import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

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
/// 6. Store the JSON credentials in `.env` as `SHEETS_CREDENTIALS_JSON`
/// 7. Set the spreadsheet ID in `.env` as `SHEETS_SPREADSHEET_ID`
class SheetsConfig {
  SheetsConfig._();

  /// Google Sheets spreadsheet ID
  /// Found in the URL: https://docs.google.com/spreadsheets/d/{SPREADSHEET_ID}/edit
  static String get spreadsheetId =>
      dotenv.maybeGet('SHEETS_SPREADSHEET_ID', fallback: '')!.trim().isNotEmpty
          ? dotenv.get('SHEETS_SPREADSHEET_ID')
          : 'YOUR_SPREADSHEET_ID_HERE';

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

  /// Check if credentials are configured
  static bool get isConfigured =>
      spreadsheetId != 'YOUR_SPREADSHEET_ID_HERE' &&
      (dotenv.maybeGet('SHEETS_CREDENTIALS_JSON', fallback: '')!
          .trim()
          .isNotEmpty);

  static Future<Map<String, dynamic>> loadCredentials() async {
    final rawJson =
        dotenv.maybeGet('SHEETS_CREDENTIALS_JSON', fallback: '')?.trim();
    if (rawJson == null || rawJson.isEmpty) {
      throw StateError(
        'Missing SHEETS_CREDENTIALS_JSON in .env configuration.',
      );
    }
    return jsonDecode(rawJson) as Map<String, dynamic>;
  }
}
