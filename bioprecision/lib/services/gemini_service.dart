import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../core/app_logger.dart';
import '../models/diagnosis_result.dart';

/// Categorised error types so the UI can show specific messages.
class GeminiException implements Exception {
  final GeminiErrorType type;
  final String rawMessage;
  const GeminiException(this.type, this.rawMessage);

  @override
  String toString() => rawMessage;
}

enum GeminiErrorType {
  noInternet,
  quotaExceeded,
  notAPlant,
  malformedResponse,
  unknown,
}

class GeminiService {
  static String _buildSystemInstruction(bool isUrdu) {
    final langInstruction = isUrdu
        ? 'IMPORTANT: You MUST respond entirely in Urdu language (اردو). '
          'All field values — plantName, diseaseName, organicSolution, '
          'chemicalSolution — must be written in Urdu script. '
          'Do NOT use English for any of these values.'
        : 'Respond in English.';

    return '$langInstruction\n'
        'You are an expert agricultural AI assistant and plant pathologist. '
        'Your task is to analyze the uploaded image.\n'
        '1. FIRST, verify if the image contains a plant or crop. '
        'If the image is NOT a plant (e.g., human, animal, car, object, blank), '
        'you MUST set diseaseName to "ERROR_NOT_A_PLANT", plantName to '
        '${isUrdu ? '"نامعلوم"' : '"Unknown"'}, and confidence to 0.\n'
        '2. If it is a plant, precisely identify the specific plant species '
        'and the exact disease present.\n'
        '3. Provide a realistic confidence level (0-100).\n'
        '4. If the plant is healthy, set diseaseName to '
        '${isUrdu ? '"صحت مند"' : '"Healthy"'} and confidence to 100.\n'
        '5. Provide detailed, highly accurate, and actionable treatment plans. '
        'organicSolution should contain specific organic/cultural treatments. '
        'chemicalSolution should contain specific chemical/fungicide/pesticide '
        'recommendations.\n'
        'Return the data ONLY as a valid JSON object with exactly these keys: '
        'plantName, diseaseName, confidence, organicSolution, chemicalSolution.\n'
        'Do NOT wrap the JSON in markdown code blocks.';
  }

  Future<DiagnosisResult> analyzeImage(File imageFile,
      {bool isUrdu = false}) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final mimeType = imageFile.path.toLowerCase().endsWith('.png')
        ? 'image/png'
        : 'image/jpeg';

    final requestBody = {
      'system_instruction': {
        'parts': [
          {'text': _buildSystemInstruction(isUrdu)}
        ]
      },
      'contents': [
        {
          'parts': [
            {
              'inline_data': {
                'mime_type': mimeType,
                'data': base64Image,
              }
            },
            {
              'text': isUrdu
                  ? 'اس پودے کی تصویر کا تجزیہ کریں اور بیماری کی شناخت کریں۔'
                  : 'Analyze this plant leaf image and identify any diseases.'
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.1,
        'maxOutputTokens': 1024,
      }
    };

    final uri = Uri.parse('$GEMINI_BASE_URL?key=$API_KEY_GEMINI');

    http.Response response;
    try {
      response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 45));
    } on SocketException {
      throw const GeminiException(
        GeminiErrorType.noInternet,
        'No internet connection. Please check your network and try again.',
      );
    } on Exception catch (e) {
      // Covers TimeoutException and other network errors
      final msg = e.toString().toLowerCase();
      if (msg.contains('timeout') || msg.contains('connection')) {
        throw const GeminiException(
          GeminiErrorType.noInternet,
          'No internet connection. Please check your network and try again.',
        );
      }
      throw GeminiException(
        GeminiErrorType.unknown,
        'An unexpected network error occurred. Please try again.',
      );
    }

    // ── HTTP status handling ──────────────────────────────────────────────
    if (response.statusCode == 403 || response.statusCode == 429) {
      AppLogger.w('Gemini quota/auth error: ${response.statusCode}');
      throw const GeminiException(
        GeminiErrorType.quotaExceeded,
        'Service temporarily unavailable. Your free tier limit may be reached.',
      );
    }

    if (response.statusCode != 200) {
      String detail = '';
      try {
        final errJson = jsonDecode(response.body) as Map<String, dynamic>;
        detail = (errJson['error']?['message'] as String?) ?? '';
      } catch (_) {}
      AppLogger.e('Gemini HTTP ${response.statusCode}: $detail');
      throw GeminiException(
        GeminiErrorType.unknown,
        'Analysis failed (HTTP ${response.statusCode}). Please try again.',
      );
    }

    // ── Parse response ────────────────────────────────────────────────────
    Map<String, dynamic> responseJson;
    try {
      responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.e('Gemini malformed JSON', error: e);
      throw const GeminiException(
        GeminiErrorType.malformedResponse,
        'Analysis failed. Please try again with a clearer leaf image.',
      );
    }

    final candidates = responseJson['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      AppLogger.w('Gemini returned no candidates');
      throw const GeminiException(
        GeminiErrorType.malformedResponse,
        'Analysis failed. Please try again with a clearer leaf image.',
      );
    }

    String rawText;
    try {
      final content =
          candidates[0]['content'] as Map<String, dynamic>;
      final parts = content['parts'] as List;
      rawText = parts[0]['text'] as String;
    } catch (e) {
      AppLogger.e('Gemini content parse error', error: e);
      throw const GeminiException(
        GeminiErrorType.malformedResponse,
        'Analysis failed. Please try again with a clearer leaf image.',
      );
    }

    // Extract JSON robustly
    String cleanJson = rawText.trim();
    final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(cleanJson);
    if (jsonMatch != null) {
      cleanJson = jsonMatch.group(0)!;
    }

    Map<String, dynamic> diagnosisJson;
    try {
      diagnosisJson = jsonDecode(cleanJson) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.e('Gemini inner JSON parse error. Raw: $rawText', error: e);
      throw const GeminiException(
        GeminiErrorType.malformedResponse,
        'Analysis failed. Please try again with a clearer leaf image.',
      );
    }

    // ── Not-a-plant check ─────────────────────────────────────────────────
    final diseaseVal = (diagnosisJson['diseaseName'] as String?) ?? '';
    if (diseaseVal == 'ERROR_NOT_A_PLANT') {
      throw GeminiException(
        GeminiErrorType.notAPlant,
        isUrdu
            ? 'پتّہ نظر نہیں آیا۔ براہ کرم پتّے کو واضح طور پر دکھا کر دوبارہ کوشش کریں۔'
            : 'No leaf detected. Please ensure the leaf is clearly visible and try again.',
      );
    }

    return DiagnosisResult.fromGeminiJson(
      diagnosisJson,
      imagePath: imageFile.path,
    );
  }
}
