import 'dart:developer' show log;

import 'package:gsheets/gsheets.dart';
import 'package:pes_vres/core/config/sheets_config.dart';
import 'package:pes_vres/domain/entities/card_submission.dart';

/// Service for interacting with Google Sheets API
///
/// Handles submission of new cards and corrections to a Google Spreadsheet.
class GoogleSheetsService {
  GSheets? _gsheets;
  Spreadsheet? _spreadsheet;
  Worksheet? _newCardsSheet;
  Worksheet? _correctionsSheet;
  bool _initialized = false;

  /// Check if the service is properly configured
  bool get isConfigured => SheetsConfig.isConfigured;

  /// Check if the service is initialized
  bool get isInitialized => _initialized;

  /// Initialize the Google Sheets connection
  ///
  /// Returns true if initialization was successful, false otherwise.
  Future<bool> initialize() async {
    if (!isConfigured) {
      log(
        'Google Sheets not configured. Please update SheetsConfig.',
        name: 'GoogleSheetsService',
      );
      return false;
    }

    if (_initialized) {
      return true;
    }

    try {
      final credentials = await SheetsConfig.loadCredentials();
      _gsheets = GSheets(credentials);
      _spreadsheet = await _gsheets!.spreadsheet(SheetsConfig.spreadsheetId);

      // Get or create the sheets
      _newCardsSheet = _spreadsheet!.worksheetByTitle(
        SheetsConfig.newCardsSheetName,
      );
      _correctionsSheet = _spreadsheet!.worksheetByTitle(
        SheetsConfig.correctionsSheetName,
      );

      // Create sheets if they don't exist
      if (_newCardsSheet == null) {
        _newCardsSheet = await _spreadsheet!.addWorksheet(
          SheetsConfig.newCardsSheetName,
        );
        await _newCardsSheet!.values.insertRow(1, SheetsConfig.newCardHeaders);
      }

      if (_correctionsSheet == null) {
        _correctionsSheet = await _spreadsheet!.addWorksheet(
          SheetsConfig.correctionsSheetName,
        );
        await _correctionsSheet!.values.insertRow(
          1,
          SheetsConfig.correctionHeaders,
        );
      }

      _initialized = true;
      log('Google Sheets service initialized', name: 'GoogleSheetsService');
      return true;
    } catch (e, stackTrace) {
      log(
        'Failed to initialize Google Sheets: $e',
        name: 'GoogleSheetsService',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Submit a new card to Google Sheets
  ///
  /// Returns true if submission was successful, false otherwise.
  Future<bool> submitNewCard(CardSubmission submission) async {
    if (!_initialized) {
      final success = await initialize();
      if (!success) return false;
    }

    if (submission.type != SubmissionType.newCard) {
      log(
        'Invalid submission type for new card: ${submission.type}',
        name: 'GoogleSheetsService',
      );
      return false;
    }

    try {
      final row = submission.toNewCardSheetRow();
      final result = await _newCardsSheet!.values.appendRow(row);

      if (result) {
        log(
          'New card submitted successfully: ${submission.id}',
          name: 'GoogleSheetsService',
        );
      }
      return result;
    } catch (e, stackTrace) {
      log(
        'Failed to submit new card: $e',
        name: 'GoogleSheetsService',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Submit a card correction to Google Sheets
  ///
  /// Returns true if submission was successful, false otherwise.
  Future<bool> submitCorrection(CardSubmission submission) async {
    if (!_initialized) {
      final success = await initialize();
      if (!success) return false;
    }

    if (submission.type != SubmissionType.correction) {
      log(
        'Invalid submission type for correction: ${submission.type}',
        name: 'GoogleSheetsService',
      );
      return false;
    }

    try {
      final row = submission.toCorrectionSheetRow();
      final result = await _correctionsSheet!.values.appendRow(row);

      if (result) {
        log(
          'Correction submitted successfully: ${submission.id}',
          name: 'GoogleSheetsService',
        );
      }
      return result;
    } catch (e, stackTrace) {
      log(
        'Failed to submit correction: $e',
        name: 'GoogleSheetsService',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Submit a card submission (auto-detects type)
  Future<bool> submit(CardSubmission submission) async {
    switch (submission.type) {
      case SubmissionType.newCard:
        return submitNewCard(submission);
      case SubmissionType.correction:
        return submitCorrection(submission);
    }
  }
}
