import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_logger.dart';

/// Model for a connected/offline IoT device.
class FarmDevice {
  final String id;
  final String name;
  final String type;
  final bool isConnected;

  const FarmDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.isConnected,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'type': type,
        'isConnected': isConnected ? 1 : 0,
      };

  factory FarmDevice.fromMap(Map<String, dynamic> m) => FarmDevice(
        id: m['id'] as String,
        name: m['name'] as String,
        type: m['type'] as String,
        isConnected: (m['isConnected'] as int) == 1,
      );
}

class UserProfileProvider extends ChangeNotifier {
  static const _keyFarmName = 'profile_farm_name';
  static const _keyFarmSize = 'profile_farm_size';
  static const _keyCropTypes = 'profile_crop_types';
  static const _keyPlanType = 'profile_plan_type';
  static const _keyAlertDisease = 'notif_disease';
  static const _keyAlertWeather = 'notif_weather';
  static const _keyAlertTips = 'notif_tips';
  static const _keyDevices = 'profile_devices';

  // Farm Profile
  String _farmName = 'My Farm';
  String _farmSize = '';
  List<String> _cropTypes = [];

  // Notifications
  bool _diseaseAlerts = true;
  bool _weatherAlerts = true;
  bool _usageTips = false;

  // Devices
  List<FarmDevice> _devices = [
    const FarmDevice(
        id: 'dev_1',
        name: 'Soil Sensor 01',
        type: 'Soil Sensor',
        isConnected: true),
    const FarmDevice(
        id: 'dev_2',
        name: 'Weather Station',
        type: 'Weather Station',
        isConnected: false),
  ];

  // Plan
  String _plan = 'Pro Plan';

  // Getters
  String get farmName => _farmName;
  String get farmSize => _farmSize;
  List<String> get cropTypes => List.unmodifiable(_cropTypes);
  bool get diseaseAlerts => _diseaseAlerts;
  bool get weatherAlerts => _weatherAlerts;
  bool get usageTips => _usageTips;
  List<FarmDevice> get devices => List.unmodifiable(_devices);
  String get plan => _plan;

  // ── Load from SharedPreferences ──────────────────────────────────────────
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _farmName = prefs.getString(_keyFarmName) ?? 'My Farm';
      _farmSize = prefs.getString(_keyFarmSize) ?? '';
      _cropTypes = prefs.getStringList(_keyCropTypes) ?? [];
      _plan = prefs.getString(_keyPlanType) ?? 'Pro Plan';
      _diseaseAlerts = prefs.getBool(_keyAlertDisease) ?? true;
      _weatherAlerts = prefs.getBool(_keyAlertWeather) ?? true;
      _usageTips = prefs.getBool(_keyAlertTips) ?? false;

      final rawDevices = prefs.getStringList(_keyDevices);
      if (rawDevices != null && rawDevices.isNotEmpty) {
        _devices = rawDevices.map((raw) {
          // Simple key=value encoding: id|name|type|connected
          final parts = raw.split('|');
          if (parts.length == 4) {
            return FarmDevice(
              id: parts[0],
              name: parts[1],
              type: parts[2],
              isConnected: parts[3] == '1',
            );
          }
          return null;
        }).whereType<FarmDevice>().toList();
      }
      notifyListeners();
    } catch (e) {
      AppLogger.e('UserProfileProvider.load failed', error: e);
    }
  }

  // ── Farm Profile ─────────────────────────────────────────────────────────
  Future<void> saveFarmProfile({
    required String name,
    required String size,
    required List<String> cropTypes,
  }) async {
    _farmName = name.trim().isEmpty ? 'My Farm' : name.trim();
    _farmSize = size.trim();
    _cropTypes = cropTypes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFarmName, _farmName);
    await prefs.setString(_keyFarmSize, _farmSize);
    await prefs.setStringList(_keyCropTypes, _cropTypes);
    notifyListeners();
  }

  // ── Notifications ────────────────────────────────────────────────────────
  Future<void> setDiseaseAlerts(bool v) async {
    _diseaseAlerts = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAlertDisease, v);
    notifyListeners();
  }

  Future<void> setWeatherAlerts(bool v) async {
    _weatherAlerts = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAlertWeather, v);
    notifyListeners();
  }

  Future<void> setUsageTips(bool v) async {
    _usageTips = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAlertTips, v);
    notifyListeners();
  }

  // ── Devices ──────────────────────────────────────────────────────────────
  Future<void> addDevice(FarmDevice device) async {
    _devices = [..._devices, device];
    await _persistDevices();
    notifyListeners();
  }

  Future<void> removeDevice(String id) async {
    _devices = _devices.where((d) => d.id != id).toList();
    await _persistDevices();
    notifyListeners();
  }

  Future<void> _persistDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = _devices.map((d) {
      final c = d.isConnected ? '1' : '0';
      return '${d.id}|${d.name}|${d.type}|$c';
    }).toList();
    await prefs.setStringList(_keyDevices, raw);
  }

  // ── Plan ─────────────────────────────────────────────────────────────────
  Future<void> setPlan(String plan) async {
    _plan = plan;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPlanType, plan);
    notifyListeners();
  }

  // ── Clear all data ───────────────────────────────────────────────────────
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _farmName = 'My Farm';
    _farmSize = '';
    _cropTypes = [];
    _plan = 'Pro Plan';
    _diseaseAlerts = true;
    _weatherAlerts = true;
    _usageTips = false;
    notifyListeners();
  }
}
