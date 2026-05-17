import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/weather_provider.dart';
import 'providers/scanner_provider.dart';
import 'providers/history_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/user_profile_provider.dart';
import 'services/history_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Load saved locale
  final localeProvider = LocaleProvider();
  await localeProvider.loadSavedLocale();

  // Load user profile
  final userProfileProvider = UserProfileProvider();
  await userProfileProvider.load();

  // Auto-clear history from previous days
  await HistoryService().clearOldHistory();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => ScannerProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider.value(value: userProfileProvider),
      ],
      child: const BioPrecisionApp(),
    ),
  );
}
