import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pes_vres/core/analytics/analytics_service.dart';
import 'package:pes_vres/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env', isOptional: true);
  await AnalyticsService.instance.initialize();
  await AnalyticsService.instance.capture(
    'app_opened',
    properties: {
      'cold_start': true,
    },
  );
  runApp(const App());
}
