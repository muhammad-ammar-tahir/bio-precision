import 'package:translator/translator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_logger.dart';

/// Provides English → Urdu translation for dynamic API content
/// (crop names, disease names, treatment phrases).
class TranslationService {
  const TranslationService._();

  // ── Crop / Plant Names ────────────────────────────────────────────────────
  static const Map<String, String> _cropMap = {
    'tomato': 'ٹماٹر',
    'maize': 'مکئی',
    'corn': 'مکئی',
    'wheat': 'گندم',
    'rice': 'چاول',
    'potato': 'آلو',
    'pepper': 'مرچ',
    'bell pepper': 'شملہ مرچ',
    'chili': 'لال مرچ',
    'cotton': 'کپاس',
    'sugarcane': 'گنا',
    'mango': 'آم',
    'banana': 'کیلا',
    'orange': 'سنترہ',
    'apple': 'سیب',
    'grape': 'انگور',
    'grapes': 'انگور',
    'strawberry': 'اسٹرابیری',
    'soybean': 'سویا بین',
    'soy': 'سویا',
    'onion': 'پیاز',
    'garlic': 'لہسن',
    'cucumber': 'کھیرا',
    'eggplant': 'بینگن',
    'brinjal': 'بینگن',
    'spinach': 'پالک',
    'sunflower': 'سورج مکھی',
    'chickpea': 'چنا',
    'lentil': 'مسور دال',
    'peanut': 'مونگ پھلی',
    'groundnut': 'مونگ پھلی',
    'watermelon': 'تربوز',
    'melon': 'خربوزہ',
    'cabbage': 'بند گوبھی',
    'cauliflower': 'پھول گوبھی',
    'bitter gourd': 'کریلہ',
    'bottle gourd': 'لوکی',
    'okra': 'بھنڈی',
    'lady finger': 'بھنڈی',
    'mung bean': 'مونگ',
    'black-eyed pea': 'لوبیا',
    'pea': 'مٹر',
    'peas': 'مٹر',
    'bean': 'پھلی',
    'beans': 'پھلیاں',
    'carrot': 'گاجر',
    'radish': 'مولی',
    'turnip': 'شلجم',
    'unknown': 'نامعلوم',
    'plant': 'پودا',
    'leaf': 'پتّہ',
    'crop': 'فصل',
  };

  // ── Disease Names ─────────────────────────────────────────────────────────
  static const Map<String, String> _diseaseMap = {
    'early blight': 'ابتدائی جھلساؤ',
    'late blight': 'دیر سے جھلساؤ',
    'leaf rust': 'پتوں کا زنگ',
    'stem rust': 'تنے کا زنگ',
    'yellow rust': 'پیلا زنگ',
    'stripe rust': 'دھاری دار زنگ',
    'powdery mildew': 'سفید پاؤڈری پھپھوندی',
    'downy mildew': 'سفیدی پھپھوندی',
    'leaf spot': 'پتوں کے دھبے',
    'bacterial leaf spot': 'بیکٹیریائی پتوں کے دھبے',
    'anthracnose': 'انتھراکنوز',
    'gray mold': 'سرمئی پھپھوندی',
    'grey mold': 'سرمئی پھپھوندی',
    'botrytis': 'بوٹریٹس',
    'fusarium wilt': 'فیوزیریم مرجھاؤ',
    'verticillium wilt': 'ورٹیسیلیم مرجھاؤ',
    'bacterial wilt': 'بیکٹیریائی مرجھاؤ',
    'crown rot': 'جڑ کی سڑن',
    'root rot': 'جڑ کا سڑنا',
    'damping off': 'نمی سے نقصان',
    'mosaic virus': 'موزیک وائرس',
    'tobacco mosaic virus': 'تمباکو موزیک وائرس',
    'tomato mosaic virus': 'ٹماٹر موزیک وائرس',
    'cucumber mosaic virus': 'کھیرے کا موزیک وائرس',
    'septoria leaf spot': 'سیپٹوریا پتوں کے دھبے',
    'cercospora leaf spot': 'سرکوسپورا پتوں کے دھبے',
    'alternaria leaf spot': 'الٹرناریا پتوں کے دھبے',
    'leaf blight': 'پتوں کا جھلساؤ',
    'fire blight': 'آگ سے جھلساؤ',
    'citrus canker': 'کھٹے پھلوں کا ناسور',
    'black rot': 'کالی سڑن',
    'smut': 'کنڈوا',
    'loose smut': 'ڈھیلا کنڈوا',
    'covered smut': 'ڈھکا کنڈوا',
    'common scab': 'عام خارش',
    'aphid': 'تیلا',
    'whitefly': 'سفید مکھی',
    'spider mite': 'مکڑی کا کیڑا',
    'thrips': 'تھرپس',
    'nematode': 'نیماٹوڈ',
    'healthy': 'صحت مند',
    'no disease': 'بیماری نہیں',
    'no disease detected': 'کوئی بیماری نہیں پائی گئی',
    'disease free': 'بیماری سے پاک',
    'unknown disease': 'نامعلوم بیماری',
    'unidentified': 'ناشناختہ',
    'nutrient deficiency': 'غذائی کمی',
    'nitrogen deficiency': 'نائٹروجن کی کمی',
    'phosphorus deficiency': 'فاسفورس کی کمی',
    'potassium deficiency': 'پوٹاشیم کی کمی',
    'iron deficiency': 'آئرن کی کمی',
    'magnesium deficiency': 'میگنیشیم کی کمی',
    'calcium deficiency': 'کیلشیم کی کمی',
    'leaf curl': 'پتوں کا مڑنا',
    'leaf roll': 'پتوں کا لپٹنا',
    'chlorosis': 'کلوروسس',
    'necrosis': 'بافتوں کا مرنا',
    'wilting': 'مرجھانا',
  };

  // ── Key Treatment Phrases ─────────────────────────────────────────────────
  static const Map<String, String> _treatmentPhraseMap = {
    // General organic
    'remove and destroy infected leaves':
        'متاثرہ پتے ہٹا کر تلف کریں',
    'prune infected leaves': 'متاثرہ پتے کاٹ دیں',
    'remove infected plant parts': 'متاثرہ حصے ہٹا دیں',
    'improve air circulation': 'ہوا کی آمد و رفت بہتر کریں',
    'avoid overhead watering': 'اوپر سے پانی دینے سے بچیں',
    'water at the base': 'پودے کی جڑ میں پانی دیں',
    'apply mulch': 'ملچ لگائیں',
    'neem oil spray': 'نیم کے تیل کا اسپرے',
    'neem oil': 'نیم کا تیل',
    'baking soda solution': 'بیکنگ سوڈا کا محلول',
    'garlic extract': 'لہسن کا عرق',
    'copper-based solution': 'تانبے پر مبنی محلول',
    'copper-based fungicide': 'تانبے پر مبنی فنگی سائیڈ',
    'bordeaux mixture': 'بورڈو مکسچر',
    'crop rotation': 'فصل کا چکر',
    'use disease-resistant varieties': 'بیماری مزاحم اقسام استعمال کریں',
    'avoid overcrowding': 'پودوں کو زیادہ قریب نہ لگائیں',
    'sanitize tools': 'آلات صاف کریں',
    'compost tea': 'کمپوسٹ چائے',
    'apply potassium bicarbonate': 'پوٹاشیم بائی کاربونیٹ لگائیں',
    'trichoderma': 'ٹرائیکوڈرما',
    'apply organic fertilizer': 'نامیاتی کھاد ڈالیں',
    'sulfur dust': 'گندھک کا پاؤڈر',
    // Frequency phrases
    'every 7-10 days': 'ہر ۷ سے ۱۰ دن بعد',
    'every 7 days': 'ہر ۷ دن بعد',
    'every 14 days': 'ہر ۱۴ دن بعد',
    'weekly': 'ہفتہ وار',
    'twice a week': 'ہفتے میں دو بار',
    'once a week': 'ہفتے میں ایک بار',
    'after rain': 'بارش کے بعد',
    // Chemical
    'apply copper-based solution every 7-10 days':
        'تانبے پر مبنی محلول ہر ۷ سے ۱۰ دن بعد لگائیں',
    'mancozeb': 'مینکوزیب',
    'chlorothalonil': 'کلوروتھالونل',
    'azoxystrobin': 'ازوکسی اسٹروبن',
    'propiconazole': 'پروپیکونازول',
    'tebuconazole': 'ٹیبوکونازول',
    'carbendazim': 'کاربینڈازم',
    'metalaxyl': 'میٹالاکسل',
    'captan': 'کیپٹن',
    'thiram': 'تھیرم',
    'iprodione': 'آئپروڈیون',
    'follow label instructions': 'لیبل پر دی گئی ہدایات پر عمل کریں',
    'wear protective gear': 'حفاظتی لباس پہنیں',
    'fungicide': 'فنگی سائیڈ',
    'bactericide': 'بیکٹیریا کش دوا',
    'pesticide': 'کیڑے مار دوا',
    'insecticide': 'حشرات کش دوا',
    'herbicide': 'جڑی بوٹی مار دوا',
    'systemic fungicide': 'نظامی فنگی سائیڈ',
  };

  /// Translates a single word or phrase from English to Urdu.
  /// Falls back to the original [text] if not found in any map.
  static String translateTerm(String text, {bool cropMap = false, bool diseaseMap = false}) {
    final lower = text.toLowerCase().trim();
    if (cropMap) {
      return _cropMap[lower] ?? text;
    }
    if (diseaseMap) {
      return _diseaseMap[lower] ?? text;
    }
    return _cropMap[lower] ?? _diseaseMap[lower] ?? text;
  }

  /// Translates a crop / plant name to Urdu.
  static String translateCrop(String name) {
    final lower = name.toLowerCase().trim();
    // Try exact match first
    if (_cropMap.containsKey(lower)) return _cropMap[lower]!;
    // Try partial match
    for (final entry in _cropMap.entries) {
      if (lower.contains(entry.key) || entry.key.contains(lower)) {
        return entry.value;
      }
    }
    return name;
  }

  /// Translates a disease name to Urdu.
  static String translateDisease(String name) {
    final lower = name.toLowerCase().trim();
    if (_diseaseMap.containsKey(lower)) return _diseaseMap[lower]!;
    // Healthy synonyms
    if (lower.contains('healthy') || lower.contains('no disease') || lower == 'صحت مند') {
      return 'صحت مند';
    }
    // Partial match
    for (final entry in _diseaseMap.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return name;
  }

  /// Translates a long treatment string by checking cache, then translating via
  /// GoogleTranslator API. Falls back to static map if API fails.
  static Future<String> translateTreatmentAsync(String text) async {
    if (text.isEmpty) return text;
    
    // 1. Aggressive Caching
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'trans_${text.hashCode}';
    final cached = prefs.getString(cacheKey);
    if (cached != null) return cached;

    // 2. Static Map Fallback (exact match)
    final lowerText = text.toLowerCase().trim();
    if (_treatmentPhraseMap.containsKey(lowerText)) {
      return _treatmentPhraseMap[lowerText]!;
    }
    
    // 3. Translation via GoogleTranslator (handles any length)
    try {
      final translator = GoogleTranslator();
      AppLogger.d('Calling GoogleTranslator API for text length: ${text.length}');
      
      final translation = await translator.translate(text, from: 'en', to: 'ur');
      final result = translation.text;
      
      // Cache the successful translation
      await prefs.setString(cacheKey, result);
      return result;
    } catch (e) {
      AppLogger.e('GoogleTranslator API failed', error: e);
      // Fallback to phrase map for this specific text
      final fallbackText = _applyPhraseMap(text);
      return fallbackText;
    }
  }

  /// Replaces known phrases within a text block
  static String _applyPhraseMap(String text) {
    String result = text;
    for (final entry in _treatmentPhraseMap.entries) {
      if (result.toLowerCase().contains(entry.key)) {
        result = result.replaceAll(
          RegExp(entry.key, caseSensitive: false),
          entry.value,
        );
      }
    }
    return result;
  }
}
