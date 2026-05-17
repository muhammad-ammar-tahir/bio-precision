import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/app_logger.dart';
import '../models/diagnosis_result.dart';
import '../services/gemini_service.dart';
import '../services/history_service.dart';

/// State of the scanner flow.
enum ScannerStatus { idle, picking, analyzing, done, error }

class ScannerProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final HistoryService _historyService = HistoryService();
  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedImage;
  DiagnosisResult? _result;
  ScannerStatus _status = ScannerStatus.idle;

  /// Friendly, user-facing error message.
  String? _errorMessage;

  /// Raw category for the UI to decide which action to show (retry, dismiss).
  GeminiErrorType? _errorType;

  File? get selectedImage => _selectedImage;
  DiagnosisResult? get result => _result;
  bool get isAnalyzing => _status == ScannerStatus.analyzing;
  ScannerStatus get status => _status;
  String? get error => _errorMessage;
  GeminiErrorType? get errorType => _errorType;

  Future<bool> pickImage(ImageSource source) async {
    try {
      final xFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (xFile != null) {
        _selectedImage = File(xFile.path);
        _result = null;
        _errorMessage = null;
        _errorType = null;
        _status = ScannerStatus.idle;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      AppLogger.e('Image pick failed', error: e);
      _errorMessage = 'Could not access camera/gallery. Please try again.';
      _status = ScannerStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> analyzeImage({bool isUrdu = false}) async {
    if (_selectedImage == null) return false;

    _status = ScannerStatus.analyzing;
    _errorMessage = null;
    _errorType = null;
    notifyListeners();

    try {
      _result = await _geminiService.analyzeImage(
        _selectedImage!,
        isUrdu: isUrdu,
      );
      // Auto-save to history
      await _historyService.insertScan(_result!);
      _status = ScannerStatus.done;
      notifyListeners();
      return true;
    } on GeminiException catch (e) {
      AppLogger.e('GeminiException [${e.type}]: ${e.rawMessage}');
      _errorMessage = e.rawMessage;
      _errorType = e.type;
      _status = ScannerStatus.error;
      notifyListeners();
      return false;
    } catch (e, stack) {
      AppLogger.e('Unexpected analyzeImage error', error: e, stack: stack);
      _errorMessage =
          'An unexpected error occurred. Please try again.';
      _errorType = GeminiErrorType.unknown;
      _status = ScannerStatus.error;
      notifyListeners();
      return false;
    }
  }

  /// Retry the last analysis with the same image.
  Future<bool> retry({bool isUrdu = false}) => analyzeImage(isUrdu: isUrdu);

  void reset() {
    _selectedImage = null;
    _result = null;
    _errorMessage = null;
    _errorType = null;
    _status = ScannerStatus.idle;
    notifyListeners();
  }
}
