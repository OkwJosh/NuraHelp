import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Caching service to store and retrieve data locally
/// Reduces API calls and improves app performance
class CacheService extends GetxService {
  static CacheService get instance => Get.find();

  late SharedPreferences _prefs;

  Future<CacheService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  static const String _patientKey = 'cached_patient';
  static const String _settingsKey = 'cached_settings';
  static const String _clinicalKey = 'cached_clinical';
  static const String _conversationsKey = 'cached_conversations';
  static const String _appointmentsKey = 'cached_appointments';

  // Cache timestamps
  static const String _patientTimestampKey = 'cached_patient_timestamp';
  static const String _settingsTimestampKey = 'cached_settings_timestamp';
  static const String _clinicalTimestampKey = 'cached_clinical_timestamp';
  static const String _conversationsTimestampKey =
      'cached_conversations_timestamp';
  static const String _appointmentsTimestampKey =
      'cached_appointments_timestamp';

  // Cache expiration times (in minutes)
  static const int patientCacheExpiry = 60; // 1 hour
  static const int settingsCacheExpiry = 120; // 2 hours
  static const int clinicalCacheExpiry = 30; // 30 minutes
  static const int conversationsCacheExpiry = 5; // 5 minutes
  static const int appointmentsCacheExpiry = 15; // 15 minutes

  // ==================== GENERIC CACHE METHODS ====================

  /// Save data to cache with timestamp
  Future<bool> _saveToCache(
    String key,
    String timestampKey,
    dynamic data,
  ) async {
    try {
      final jsonString = jsonEncode(data);
      await _prefs.setString(key, jsonString);
      await _prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get data from cache if not expired
  dynamic _getFromCache(String key, String timestampKey, int expiryMinutes) {
    try {
      final timestamp = _prefs.getInt(timestampKey);
      if (timestamp == null) return null;

      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      final cacheAgeMinutes = cacheAge / (1000 * 60);

      if (cacheAgeMinutes > expiryMinutes) {
        return null;
      }

      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;

      return jsonDecode(jsonString);
    } catch (e) {
      return null;
    }
  }

  /// Clear specific cache
  Future<void> _clearCache(String key, String timestampKey) async {
    await _prefs.remove(key);
    await _prefs.remove(timestampKey);
  }

  // ==================== PATIENT DATA ====================

  Future<bool> cachePatient(Map<String, dynamic> patient) async {
    return await _saveToCache(_patientKey, _patientTimestampKey, patient);
  }

  Map<String, dynamic>? getCachedPatient() {
    final data = _getFromCache(
      _patientKey,
      _patientTimestampKey,
      patientCacheExpiry,
    );
    if (data != null) {}
    return data;
  }

  Future<void> clearPatientCache() async {
    await _clearCache(_patientKey, _patientTimestampKey);
  }

  // ==================== SETTINGS ====================

  Future<bool> cacheSettings(Map<String, dynamic> settings) async {
    return await _saveToCache(_settingsKey, _settingsTimestampKey, settings);
  }

  Map<String, dynamic>? getCachedSettings() {
    final data = _getFromCache(
      _settingsKey,
      _settingsTimestampKey,
      settingsCacheExpiry,
    );
    if (data != null) {}
    return data;
  }

  Future<void> clearSettingsCache() async {
    await _clearCache(_settingsKey, _settingsTimestampKey);
  }

  // ==================== CLINICAL DATA ====================

  Future<bool> cacheClinicalData(Map<String, dynamic> clinical) async {
    return await _saveToCache(_clinicalKey, _clinicalTimestampKey, clinical);
  }

  Map<String, dynamic>? getCachedClinicalData() {
    final data = _getFromCache(
      _clinicalKey,
      _clinicalTimestampKey,
      clinicalCacheExpiry,
    );
    if (data != null) {}
    return data;
  }

  Future<void> clearClinicalCache() async {
    await _clearCache(_clinicalKey, _clinicalTimestampKey);
  }

  // ==================== CONVERSATIONS ====================

  Future<bool> cacheConversations(List<dynamic> conversations) async {
    return await _saveToCache(
      _conversationsKey,
      _conversationsTimestampKey,
      conversations,
    );
  }

  List<dynamic>? getCachedConversations() {
    final data = _getFromCache(
      _conversationsKey,
      _conversationsTimestampKey,
      conversationsCacheExpiry,
    );
    if (data != null) {}
    return data as List<dynamic>?;
  }

  Future<void> clearConversationsCache() async {
    await _clearCache(_conversationsKey, _conversationsTimestampKey);
    await _clearCache(_conversationsKey, _conversationsTimestampKey);
  }

  // ==================== APPOINTMENTS ====================

  Future<bool> cacheAppointments(List<dynamic> appointments) async {
    return await _saveToCache(
      _appointmentsKey,
      _appointmentsTimestampKey,
      appointments,
    );
  }

  List<dynamic>? getCachedAppointments() {
    final data = _getFromCache(
      _appointmentsKey,
      _appointmentsTimestampKey,
      appointmentsCacheExpiry,
    );
    if (data != null) {}
    return data as List<dynamic>?;
  }

  Future<void> clearAppointmentsCache() async {
    await _clearCache(_appointmentsKey, _appointmentsTimestampKey);
  }

  // ==================== UTILITY METHODS ====================

  /// Clear all cached data
  Future<void> clearAllCache() async {
    await Future.wait([
      clearPatientCache(),
      clearSettingsCache(),
      clearClinicalCache(),
      clearConversationsCache(),
      clearAppointmentsCache(),
    ]);
  }

  /// Check if cache exists and is valid
  bool isCacheValid(String timestampKey, int expiryMinutes) {
    final timestamp = _prefs.getInt(timestampKey);
    if (timestamp == null) return false;

    final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
    final cacheAgeMinutes = cacheAge / (1000 * 60);

    return cacheAgeMinutes <= expiryMinutes;
  }

  /// Get cache age in minutes
  int? getCacheAge(String timestampKey) {
    final timestamp = _prefs.getInt(timestampKey);
    if (timestamp == null) return null;

    final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
    return (cacheAge / (1000 * 60)).round();
  }
}
