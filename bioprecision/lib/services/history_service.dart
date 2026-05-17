import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/diagnosis_result.dart';

class HistoryService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'bioprecision_history.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE scans (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            plantName TEXT NOT NULL,
            diseaseName TEXT NOT NULL,
            confidence REAL NOT NULL,
            organicSolution TEXT NOT NULL,
            chemicalSolution TEXT NOT NULL,
            imagePath TEXT NOT NULL,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertScan(DiagnosisResult result) async {
    final db = await database;
    return await db.insert('scans', result.toMap());
  }

  Future<List<DiagnosisResult>> getAllScans() async {
    final db = await database;
    final maps = await db.query('scans', orderBy: 'timestamp DESC');
    return maps.map((m) => DiagnosisResult.fromMap(m)).toList();
  }

  Future<void> deleteScan(int id) async {
    final db = await database;
    await db.delete('scans', where: 'id = ?', whereArgs: [id]);
  }

  /// Deletes all scans whose timestamp is from a previous calendar day.
  /// Call this once on app startup to auto-clear old history.
  Future<int> clearOldHistory() async {
    final db = await database;

    // Build the start of today in ISO-8601 (YYYY-MM-DDT00:00:00.000)
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final cutoff = startOfToday.toIso8601String();

    final deleted = await db.delete(
      'scans',
      // timestamp < today's midnight → older than today
      where: 'timestamp < ?',
      whereArgs: [cutoff],
    );
    return deleted;
  }

  Future<Map<String, dynamic>> getStats() async {
    final scans = await getAllScans();
    final total = scans.length;
    final healthy = scans.where((s) => s.isHealthy).length;
    final atRisk = total - healthy;
    final successRate = total > 0 ? ((healthy / total) * 100).round() : 0;

    return {
      'totalScans': total,
      'healthyCount': healthy,
      'atRiskCount': atRisk,
      'successRate': successRate,
    };
  }
}
