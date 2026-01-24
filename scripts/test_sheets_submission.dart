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
    final key = line.split('=').first.trim();
    final value = line.substring(line.indexOf('=') + 1).trim();
    env[key] = value.replaceAll(RegExp('^"|"\$'), '');
  }
  return env;
}

Future<void> main() async {
  final repoRoot = Directory.current;
  final envFile = File('${repoRoot.path}/.env');
  final env = loadEnv(envFile);

  final spreadsheetId = env['SHEETS_SPREADSHEET_ID']?.trim();
  final rawCredentials = env['SHEETS_CREDENTIALS_JSON']?.trim();

  if (spreadsheetId == null || spreadsheetId.isEmpty) {
    stderr.writeln('SHEETS_SPREADSHEET_ID missing in .env');
    exit(1);
  }
  if (rawCredentials == null || rawCredentials.isEmpty) {
    stderr.writeln('SHEETS_CREDENTIALS_JSON missing in .env');
    exit(1);
  }

  final credentials = jsonDecode(rawCredentials) as Map<String, dynamic>;
  final gsheets = GSheets(credentials);
  final spreadsheet = await gsheets.spreadsheet(spreadsheetId);

  final newCardsSheet = spreadsheet.worksheetByTitle('New Card Submissions');
  if (newCardsSheet == null) {
    stderr.writeln('Worksheet "New Card Submissions" not found.');
    exit(1);
  }

  final now = DateTime.now().toIso8601String();
  final row = [
    'test-${DateTime.now().millisecondsSinceEpoch}',
    now,
    'test',
    'Test prompt (auto)',
    jsonEncode(['Answer 1', 'Answer 2', 'Answer 3', 'Answer 4', 'Answer 5', 'Answer 6', 'Answer 7', 'Answer 8', 'Answer 9', 'Answer 10']),
    'easy',
    'automated_test',
    'system',
    'system@example.com',
    'local',
    'en',
  ];

  final result = await newCardsSheet.values.appendRow(row);
  if (!result) {
    stderr.writeln('Failed to append test row.');
    exit(1);
  }

  stdout.writeln('Test row appended successfully.');
}
