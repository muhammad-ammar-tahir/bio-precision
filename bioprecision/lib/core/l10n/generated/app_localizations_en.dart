// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BioPrecision';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get capture => 'Capture';

  @override
  String get history => 'History';

  @override
  String get profile => 'Profile';

  @override
  String get currentVitality => 'CURRENT VITALITY';

  @override
  String healthyPercent(int percent) {
    return '$percent% Healthy';
  }

  @override
  String upPercent(int percent) {
    return '+$percent% UP';
  }

  @override
  String get localClimate => 'Local Climate';

  @override
  String get temperature => 'TEMPERATURE';

  @override
  String get humidity => 'HUMIDITY';

  @override
  String get uvIndex => 'UV INDEX';

  @override
  String get optimalRange => 'Optimal Range';

  @override
  String get stableClimate => 'Stable Climate';

  @override
  String get soilMoisture => 'Soil Moisture';

  @override
  String get npkLevels => 'NPK Levels';

  @override
  String get optimal => 'Optimal';

  @override
  String get recentInsights => 'Recent Insights';

  @override
  String get seeHistory => 'SEE HISTORY';

  @override
  String get confidence => 'Confidence';

  @override
  String get actionRequired => 'ACTION REQUIRED';

  @override
  String get stable => 'STABLE';

  @override
  String get underTreatment => 'UNDER TREATMENT';

  @override
  String get resolved => 'RESOLVED';

  @override
  String get scanNow => 'Scan Now';

  @override
  String get selectImage => 'Select Image';

  @override
  String get takePhoto => 'Take a Photo';

  @override
  String get chooseGallery => 'Choose from Gallery';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get analyzeLeaf => 'Analyze Leaf';

  @override
  String get diagnosisResults => 'Diagnosis Results';

  @override
  String get highAlert => 'High Alert';

  @override
  String get treatmentPlan => 'Treatment Plan';

  @override
  String get organicSolution => 'Organic Solution';

  @override
  String get chemicalSolution => 'Chemical Solution';

  @override
  String get addToTreatmentLog => 'Add to Treatment Log';

  @override
  String get savedToHistory => 'Saved to treatment history!';

  @override
  String get zoneRecovery => 'Zone Recovery';

  @override
  String plantsImproving(String count) {
    return '$count Plants showing improvement';
  }

  @override
  String get repository => 'Repository';

  @override
  String get diseaseHistory => 'Disease History';

  @override
  String get diseaseHistorySubtitle =>
      'Review and manage historical diagnostic scans from your crops.';

  @override
  String get searchDiseases => 'Search diseases...';

  @override
  String get viewReport => 'View Report';

  @override
  String get monthlyAnalytics => 'Monthly Analytics';

  @override
  String get scans => 'SCANS';

  @override
  String get atRisk => 'AT RISK';

  @override
  String get health => 'HEALTH';

  @override
  String get noDisease => 'No Disease';

  @override
  String get cropHealthy => 'Crop Healthy';

  @override
  String get accountSettings => 'ACCOUNT SETTINGS';

  @override
  String get farmProfile => 'Farm Profile';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get deviceSensorManagement => 'Device & Sensor Management';

  @override
  String get dataPrivacy => 'Data & Privacy';

  @override
  String get subscriptionPlan => 'Subscription Plan';

  @override
  String get proPlan => 'Pro Plan';

  @override
  String get freePlan => 'Free Plan';

  @override
  String get premium => 'Premium';

  @override
  String get logout => 'Logout';

  @override
  String get seasonalInsight => 'Seasonal Insight';

  @override
  String get seasonalInsightBody =>
      'Early morning moisture levels are optimal for nitrogen absorption this week.';

  @override
  String get viewAnalytics => 'VIEW ANALYTICS';

  @override
  String get totalScans => 'TOTAL SCANS';

  @override
  String get cropsTracked => 'CROPS TRACKED';

  @override
  String get successRate => 'SUCCESS RATE';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get urdu => 'اردو';

  @override
  String get errorLoadingWeather => 'Could not load weather data';

  @override
  String get errorAnalyzing => 'Analysis failed. Please try again.';

  @override
  String get noInternetError =>
      'No internet connection. Please check and try again.';

  @override
  String get quotaError =>
      'Service temporarily unavailable. Free tier limit may be reached.';

  @override
  String get notAPlantError =>
      'No leaf detected. Please ensure the leaf is clearly visible.';

  @override
  String get noHistoryYet => 'No scans yet. Use the camera to scan a leaf!';

  @override
  String diagnosedAgo(String time) {
    return 'DIAGNOSED $time AGO';
  }

  @override
  String get retry => 'Retry';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get deviceConnected => 'Connected';

  @override
  String get deviceOffline => 'Offline';

  @override
  String get addDevice => 'Add Device';

  @override
  String get removeDevice => 'Remove Device';

  @override
  String get exportData => 'Export All Scan Data';

  @override
  String get deleteAllData => 'Delete All Data';

  @override
  String get changePlan => 'Change Plan';

  @override
  String get farmName => 'Farm Name';

  @override
  String get farmSize => 'Farm Size (acres)';

  @override
  String get cropTypes => 'Crop Types';

  @override
  String get diseaseAlerts => 'Disease Alerts';

  @override
  String get weatherAlerts => 'Weather Alerts';

  @override
  String get usageTips => 'Usage Tips';
}
