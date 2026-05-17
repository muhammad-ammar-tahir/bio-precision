// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'بائیو پریسیژن';

  @override
  String get dashboard => 'ڈیش بورڈ';

  @override
  String get capture => 'کیپچر';

  @override
  String get history => 'تاریخ';

  @override
  String get profile => 'پروفائل';

  @override
  String get currentVitality => 'موجودہ صحت';

  @override
  String healthyPercent(int percent) {
    return '$percent% صحت مند';
  }

  @override
  String upPercent(int percent) {
    return '+$percent% اوپر';
  }

  @override
  String get localClimate => 'مقامی موسم';

  @override
  String get temperature => 'درجہ حرارت';

  @override
  String get humidity => 'نمی';

  @override
  String get uvIndex => 'یو وی انڈیکس';

  @override
  String get optimalRange => 'بہترین حد';

  @override
  String get stableClimate => 'مستحکم موسم';

  @override
  String get soilMoisture => 'مٹی کی نمی';

  @override
  String get npkLevels => 'این پی کے سطح';

  @override
  String get optimal => 'بہترین';

  @override
  String get recentInsights => 'حالیہ بصیرتیں';

  @override
  String get seeHistory => 'تاریخ دیکھیں';

  @override
  String get confidence => 'اعتماد';

  @override
  String get actionRequired => 'کارروائی ضروری';

  @override
  String get stable => 'مستحکم';

  @override
  String get underTreatment => 'زیرِ علاج';

  @override
  String get resolved => 'حل شدہ';

  @override
  String get scanNow => 'ابھی اسکین کریں';

  @override
  String get selectImage => 'تصویر منتخب کریں';

  @override
  String get takePhoto => 'تصویر لیں';

  @override
  String get chooseGallery => 'گیلری سے منتخب کریں';

  @override
  String get analyzing => 'تجزیہ ہو رہا ہے...';

  @override
  String get analyzeLeaf => 'پتّے کا تجزیہ';

  @override
  String get diagnosisResults => 'تشخیص کے نتائج';

  @override
  String get highAlert => 'ہائی الرٹ';

  @override
  String get treatmentPlan => 'علاج کا منصوبہ';

  @override
  String get organicSolution => 'نامیاتی حل';

  @override
  String get chemicalSolution => 'کیمیائی حل';

  @override
  String get addToTreatmentLog => 'علاج لاگ میں شامل کریں';

  @override
  String get savedToHistory => 'علاج کی تاریخ میں محفوظ!';

  @override
  String get zoneRecovery => 'زون بحالی';

  @override
  String plantsImproving(String count) {
    return '$count پودے بہتری دکھا رہے ہیں';
  }

  @override
  String get repository => 'ذخیرہ';

  @override
  String get diseaseHistory => 'بیماری کی تاریخ';

  @override
  String get diseaseHistorySubtitle =>
      'اپنی فصلوں کے تاریخی تشخیصی اسکینز کا جائزہ لیں اور ان کا نظم کریں۔';

  @override
  String get searchDiseases => 'بیماریاں تلاش کریں...';

  @override
  String get viewReport => 'رپورٹ دیکھیں';

  @override
  String get monthlyAnalytics => 'ماہانہ تجزیات';

  @override
  String get scans => 'اسکینز';

  @override
  String get atRisk => 'خطرے میں';

  @override
  String get health => 'صحت';

  @override
  String get noDisease => 'کوئی بیماری نہیں';

  @override
  String get cropHealthy => 'فصل صحت مند';

  @override
  String get accountSettings => 'اکاؤنٹ کی ترتیبات';

  @override
  String get farmProfile => 'فارم پروفائل';

  @override
  String get notificationSettings => 'اطلاع کی ترتیبات';

  @override
  String get deviceSensorManagement => 'آلہ اور سینسر مینجمنٹ';

  @override
  String get dataPrivacy => 'ڈیٹا اور رازداری';

  @override
  String get subscriptionPlan => 'سبسکرپشن پلان';

  @override
  String get proPlan => 'پرو پلان';

  @override
  String get freePlan => 'مفت پلان';

  @override
  String get premium => 'پریمیم';

  @override
  String get logout => 'لاگ آؤٹ';

  @override
  String get seasonalInsight => 'موسمی بصیرت';

  @override
  String get seasonalInsightBody =>
      'اس ہفتے صبح سویرے نمی کی سطح نائٹروجن جذب کرنے کے لیے بہترین ہے۔';

  @override
  String get viewAnalytics => 'تجزیات دیکھیں';

  @override
  String get totalScans => 'کل اسکینز';

  @override
  String get cropsTracked => 'ٹریک شدہ فصلیں';

  @override
  String get successRate => 'کامیابی کی شرح';

  @override
  String get language => 'زبان';

  @override
  String get english => 'English';

  @override
  String get urdu => 'اردو';

  @override
  String get errorLoadingWeather => 'موسمی ڈیٹا لوڈ نہیں ہو سکا';

  @override
  String get errorAnalyzing => 'تجزیہ ناکام۔ دوبارہ کوشش کریں۔';

  @override
  String get noInternetError =>
      'انٹرنیٹ کنکشن نہیں۔ براہ کرم اپنا نیٹ ورک چیک کریں۔';

  @override
  String get quotaError =>
      'سروس وقتی طور پر دستیاب نہیں۔ مفت حد ختم ہو سکتی ہے۔';

  @override
  String get notAPlantError => 'پتّہ نظر نہیں آیا۔ براہ کرم پتّے کو واضح کریں۔';

  @override
  String get noHistoryYet =>
      'ابھی تک کوئی اسکین نہیں۔ پتّا اسکین کرنے کے لیے کیمرہ استعمال کریں!';

  @override
  String diagnosedAgo(String time) {
    return '$time پہلے تشخیص';
  }

  @override
  String get retry => 'دوبارہ کوشش';

  @override
  String get save => 'محفوظ کریں';

  @override
  String get cancel => 'منسوخ';

  @override
  String get delete => 'حذف کریں';

  @override
  String get confirm => 'تصدیق';

  @override
  String get deviceConnected => 'جڑا ہوا';

  @override
  String get deviceOffline => 'آف لائن';

  @override
  String get addDevice => 'آلہ شامل کریں';

  @override
  String get removeDevice => 'آلہ ہٹائیں';

  @override
  String get exportData => 'تمام اسکین ڈیٹا برآمد کریں';

  @override
  String get deleteAllData => 'تمام ڈیٹا حذف کریں';

  @override
  String get changePlan => 'پلان تبدیل کریں';

  @override
  String get farmName => 'فارم کا نام';

  @override
  String get farmSize => 'فارم کا سائز (ایکڑ)';

  @override
  String get cropTypes => 'فصل کی اقسام';

  @override
  String get diseaseAlerts => 'بیماری کی اطلاعات';

  @override
  String get weatherAlerts => 'موسمی اطلاعات';

  @override
  String get usageTips => 'استعمال کے مشورے';
}
