import 'dart:convert';

class DiagnosisResult {
  final String plantName;
  final String diseaseName;
  final double confidence;
  final String organicSolution;
  final String chemicalSolution;
  final String imagePath;
  final DateTime timestamp;
  final int? id;

  DiagnosisResult({
    required this.plantName,
    required this.diseaseName,
    required this.confidence,
    required this.organicSolution,
    required this.chemicalSolution,
    required this.imagePath,
    required this.timestamp,
    this.id,
  });

  bool get isHealthy => diseaseName.toLowerCase().contains('healthy') || 
                         diseaseName.toLowerCase().contains('no disease');

  String get statusLabel {
    if (isHealthy) return 'RESOLVED';
    if (confidence >= 90) return 'ACTION REQUIRED';
    return 'UNDER TREATMENT';
  }

  factory DiagnosisResult.fromGeminiJson(
    Map<String, dynamic> json, {
    required String imagePath,
  }) {
    return DiagnosisResult(
      plantName: json['plantName'] ?? 'Unknown Plant',
      diseaseName: json['diseaseName'] ?? 'Unknown',
      confidence: (json['confidence'] ?? 0).toDouble(),
      organicSolution: json['organicSolution'] ?? 'No organic solution provided.',
      chemicalSolution: json['chemicalSolution'] ?? 'No chemical solution provided.',
      imagePath: imagePath,
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plantName': plantName,
      'diseaseName': diseaseName,
      'confidence': confidence,
      'organicSolution': organicSolution,
      'chemicalSolution': chemicalSolution,
      'imagePath': imagePath,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory DiagnosisResult.fromMap(Map<String, dynamic> map) {
    return DiagnosisResult(
      id: map['id'] as int?,
      plantName: map['plantName'] as String,
      diseaseName: map['diseaseName'] as String,
      confidence: (map['confidence'] as num).toDouble(),
      organicSolution: map['organicSolution'] as String,
      chemicalSolution: map['chemicalSolution'] as String,
      imagePath: map['imagePath'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  String toJsonString() => jsonEncode(toMap());
}
