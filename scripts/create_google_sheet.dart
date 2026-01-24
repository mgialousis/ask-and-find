import 'dart:convert';
import 'dart:io';

import 'package:gsheets/gsheets.dart';

Map<String, String> loadEnv(File file) {
  final env = <String, String>{};
  if (!file.existsSync()) {
    return env;
  }
  for (final rawLine in file.readAsLinesSync()) {
    final line = rawLine.trim();
    if (line.isEmpty || line.startsWith('#') || !line.contains('=')) {
      continue;
    }
    final parts = line.split('=');
    if (parts.length < 2) continue;
    final key = parts.first.trim();
    final value = line.substring(line.indexOf('=') + 1).trim();
    env[key] = value.replaceAll(RegExp('^"|"\$'), '');
  }
  return env;
}

Future<void> main() async {
  final repoRoot = Directory.current;
  final envFile = File('${repoRoot.path}/.env');
  final env = loadEnv(envFile);

  final rawCredentials = env['SHEETS_CREDENTIALS_JSON']?.trim();
  if (rawCredentials == null || rawCredentials.isEmpty) {
    stderr.writeln('SHEETS_CREDENTIALS_JSON missing in .env');
    exit(1);
  }

  final credentials = jsonDecode(rawCredentials) as Map<String, dynamic>;
  final gsheets = GSheets(credentials);

  final title = 'Say & Find Submissions ${DateTime.now().toIso8601String().substring(0, 10)}';
  final spreadsheet = await gsheets.createSpreadsheet(
    title,
    worksheetTitles: const [
      'New Card Submissions',
      'Card Corrections',
    ],
  );

  final newSheet = spreadsheet.worksheetByTitle('New Card Submissions');
  final correctionsSheet = spreadsheet.worksheetByTitle('Card Corrections');

  if (newSheet == null || correctionsSheet == null) {
    stderr.writeln('Failed to create expected worksheets.');
    exit(1);
  }

  await newSheet.values.insertRow(1, const [
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
  ]);

  await correctionsSheet.values.insertRow(1, const [
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
  ]);

  final spreadsheetId = spreadsheet.id;
  stdout.writeln('Spreadsheet created:');
  stdout.writeln('https://docs.google.com/spreadsheets/d/$spreadsheetId/edit');
  stdout.writeln('');
  stdout.writeln('Set in .env:');
  stdout.writeln('SHEETS_SPREADSHEET_ID=$spreadsheetId');
}
