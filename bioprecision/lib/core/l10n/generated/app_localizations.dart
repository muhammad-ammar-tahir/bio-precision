import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BioPrecision'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @capture.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get capture;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @currentVitality.
  ///
  /// In en, this message translates to:
  /// **'CURRENT VITALITY'**
  String get currentVitality;

  /// No description provided for @healthyPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Healthy'**
  String healthyPercent(int percent);

  /// No description provided for @upPercent.
  ///
  /// In en, this message translates to:
  /// **'+{percent}% UP'**
  String upPercent(int percent);

  /// No description provided for @localClimate.
  ///
  /// In en, this message translates to:
  /// **'Local Climate'**
  String get localClimate;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'TEMPERATURE'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'HUMIDITY'**
  String get humidity;

  /// No description provided for @uvIndex.
  ///
  /// In en, this message translates to:
  /// **'UV INDEX'**
  String get uvIndex;

  /// No description provided for @optimalRange.
  ///
  /// In en, this message translates to:
  /// **'Optimal Range'**
  String get optimalRange;

  /// No description provided for @stableClimate.
  ///
  /// In en, this message translates to:
  /// **'Stable Climate'**
  String get stableClimate;

  /// No description provided for @soilMoisture.
  ///
  /// In en, this message translates to:
  /// **'Soil Moisture'**
  String get soilMoisture;

  /// No description provided for @npkLevels.
  ///
  /// In en, this message translates to:
  /// **'NPK Levels'**
  String get npkLevels;

  /// No description provided for @optimal.
  ///
  /// In en, this message translates to:
  /// **'Optimal'**
  String get optimal;

  /// No description provided for @recentInsights.
  ///
  /// In en, this message translates to:
  /// **'Recent Insights'**
  String get recentInsights;

  /// No description provided for @seeHistory.
  ///
  /// In en, this message translates to:
  /// **'SEE HISTORY'**
  String get seeHistory;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @actionRequired.
  ///
  /// In en, this message translates to:
  /// **'ACTION REQUIRED'**
  String get actionRequired;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'STABLE'**
  String get stable;

  /// No description provided for @underTreatment.
  ///
  /// In en, this message translates to:
  /// **'UNDER TREATMENT'**
  String get underTreatment;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'RESOLVED'**
  String get resolved;

  /// No description provided for @scanNow.
  ///
  /// In en, this message translates to:
  /// **'Scan Now'**
  String get scanNow;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectImage;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takePhoto;

  /// No description provided for @chooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseGallery;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// No description provided for @analyzeLeaf.
  ///
  /// In en, this message translates to:
  /// **'Analyze Leaf'**
  String get analyzeLeaf;

  /// No description provided for @diagnosisResults.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis Results'**
  String get diagnosisResults;

  /// No description provided for @highAlert.
  ///
  /// In en, this message translates to:
  /// **'High Alert'**
  String get highAlert;

  /// No description provided for @treatmentPlan.
  ///
  /// In en, this message translates to:
  /// **'Treatment Plan'**
  String get treatmentPlan;

  /// No description provided for @organicSolution.
  ///
  /// In en, this message translates to:
  /// **'Organic Solution'**
  String get organicSolution;

  /// No description provided for @chemicalSolution.
  ///
  /// In en, this message translates to:
  /// **'Chemical Solution'**
  String get chemicalSolution;

  /// No description provided for @addToTreatmentLog.
  ///
  /// In en, this message translates to:
  /// **'Add to Treatment Log'**
  String get addToTreatmentLog;

  /// No description provided for @savedToHistory.
  ///
  /// In en, this message translates to:
  /// **'Saved to treatment history!'**
  String get savedToHistory;

  /// No description provided for @zoneRecovery.
  ///
  /// In en, this message translates to:
  /// **'Zone Recovery'**
  String get zoneRecovery;

  /// No description provided for @plantsImproving.
  ///
  /// In en, this message translates to:
  /// **'{count} Plants showing improvement'**
  String plantsImproving(String count);

  /// No description provided for @repository.
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get repository;

  /// No description provided for @diseaseHistory.
  ///
  /// In en, this message translates to:
  /// **'Disease History'**
  String get diseaseHistory;

  /// No description provided for @diseaseHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review and manage historical diagnostic scans from your crops.'**
  String get diseaseHistorySubtitle;

  /// No description provided for @searchDiseases.
  ///
  /// In en, this message translates to:
  /// **'Search diseases...'**
  String get searchDiseases;

  /// No description provided for @viewReport.
  ///
  /// In en, this message translates to:
  /// **'View Report'**
  String get viewReport;

  /// No description provided for @monthlyAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Monthly Analytics'**
  String get monthlyAnalytics;

  /// No description provided for @scans.
  ///
  /// In en, this message translates to:
  /// **'SCANS'**
  String get scans;

  /// No description provided for @atRisk.
  ///
  /// In en, this message translates to:
  /// **'AT RISK'**
  String get atRisk;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'HEALTH'**
  String get health;

  /// No description provided for @noDisease.
  ///
  /// In en, this message translates to:
  /// **'No Disease'**
  String get noDisease;

  /// No description provided for @cropHealthy.
  ///
  /// In en, this message translates to:
  /// **'Crop Healthy'**
  String get cropHealthy;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT SETTINGS'**
  String get accountSettings;

  /// No description provided for @farmProfile.
  ///
  /// In en, this message translates to:
  /// **'Farm Profile'**
  String get farmProfile;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @deviceSensorManagement.
  ///
  /// In en, this message translates to:
  /// **'Device & Sensor Management'**
  String get deviceSensorManagement;

  /// No description provided for @dataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & Privacy'**
  String get dataPrivacy;

  /// No description provided for @subscriptionPlan.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plan'**
  String get subscriptionPlan;

  /// No description provided for @proPlan.
  ///
  /// In en, this message translates to:
  /// **'Pro Plan'**
  String get proPlan;

  /// No description provided for @freePlan.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get freePlan;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @seasonalInsight.
  ///
  /// In en, this message translates to:
  /// **'Seasonal Insight'**
  String get seasonalInsight;

  /// No description provided for @seasonalInsightBody.
  ///
  /// In en, this message translates to:
  /// **'Early morning moisture levels are optimal for nitrogen absorption this week.'**
  String get seasonalInsightBody;

  /// No description provided for @viewAnalytics.
  ///
  /// In en, this message translates to:
  /// **'VIEW ANALYTICS'**
  String get viewAnalytics;

  /// No description provided for @totalScans.
  ///
  /// In en, this message translates to:
  /// **'TOTAL SCANS'**
  String get totalScans;

  /// No description provided for @cropsTracked.
  ///
  /// In en, this message translates to:
  /// **'CROPS TRACKED'**
  String get cropsTracked;

  /// No description provided for @successRate.
  ///
  /// In en, this message translates to:
  /// **'SUCCESS RATE'**
  String get successRate;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @urdu.
  ///
  /// In en, this message translates to:
  /// **'اردو'**
  String get urdu;

  /// No description provided for @errorLoadingWeather.
  ///
  /// In en, this message translates to:
  /// **'Could not load weather data'**
  String get errorLoadingWeather;

  /// No description provided for @errorAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analysis failed. Please try again.'**
  String get errorAnalyzing;

  /// No description provided for @noInternetError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check and try again.'**
  String get noInternetError;

  /// No description provided for @quotaError.
  ///
  /// In en, this message translates to:
  /// **'Service temporarily unavailable. Free tier limit may be reached.'**
  String get quotaError;

  /// No description provided for @notAPlantError.
  ///
  /// In en, this message translates to:
  /// **'No leaf detected. Please ensure the leaf is clearly visible.'**
  String get notAPlantError;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No scans yet. Use the camera to scan a leaf!'**
  String get noHistoryYet;

  /// No description provided for @diagnosedAgo.
  ///
  /// In en, this message translates to:
  /// **'DIAGNOSED {time} AGO'**
  String diagnosedAgo(String time);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @deviceConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get deviceConnected;

  /// No description provided for @deviceOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get deviceOffline;

  /// No description provided for @addDevice.
  ///
  /// In en, this message translates to:
  /// **'Add Device'**
  String get addDevice;

  /// No description provided for @removeDevice.
  ///
  /// In en, this message translates to:
  /// **'Remove Device'**
  String get removeDevice;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export All Scan Data'**
  String get exportData;

  /// No description provided for @deleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete All Data'**
  String get deleteAllData;

  /// No description provided for @changePlan.
  ///
  /// In en, this message translates to:
  /// **'Change Plan'**
  String get changePlan;

  /// No description provided for @farmName.
  ///
  /// In en, this message translates to:
  /// **'Farm Name'**
  String get farmName;

  /// No description provided for @farmSize.
  ///
  /// In en, this message translates to:
  /// **'Farm Size (acres)'**
  String get farmSize;

  /// No description provided for @cropTypes.
  ///
  /// In en, this message translates to:
  /// **'Crop Types'**
  String get cropTypes;

  /// No description provided for @diseaseAlerts.
  ///
  /// In en, this message translates to:
  /// **'Disease Alerts'**
  String get diseaseAlerts;

  /// No description provided for @weatherAlerts.
  ///
  /// In en, this message translates to:
  /// **'Weather Alerts'**
  String get weatherAlerts;

  /// No description provided for @usageTips.
  ///
  /// In en, this message translates to:
  /// **'Usage Tips'**
  String get usageTips;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
