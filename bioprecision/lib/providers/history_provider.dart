import 'package:flutter/material.dart';
import '../models/diagnosis_result.dart';
import '../services/history_service.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryService _historyService = HistoryService();

  List<DiagnosisResult> _scans = [];
  int _totalScans = 0;
  int _atRiskCount = 0;
  int _successRate = 0;
  bool _isLoading = false;

  List<DiagnosisResult> get scans => _scans;
  int get totalScans => _totalScans;
  int get atRiskCount => _atRiskCount;
  int get successRate => _successRate;
  int get healthyPercent => _totalScans > 0 ? (100 - ((_atRiskCount / _totalScans) * 100).round()) : 92;
  bool get isLoading => _isLoading;

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _scans = await _historyService.getAllScans();
      final stats = await _historyService.getStats();
      _totalScans = stats['totalScans'] as int;
      _atRiskCount = stats['atRiskCount'] as int;
      _successRate = stats['successRate'] as int;
    } catch (e) {
      debugPrint('Error loading history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteScan(int id) async {
    await _historyService.deleteScan(id);
    await loadHistory();
  }

  List<DiagnosisResult> search(String query) {
    if (query.isEmpty) return _scans;
    final lower = query.toLowerCase();
    return _scans.where((s) {
      return s.diseaseName.toLowerCase().contains(lower) ||
          s.plantName.toLowerCase().contains(lower);
    }).toList();
  }
}
