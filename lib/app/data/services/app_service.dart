import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurahelp/app/data/models/appointment_model.dart';
import 'package:nurahelp/app/data/models/clinical_response.dart';
import 'package:nurahelp/app/data/models/message_models/conversation_model.dart';
import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:http/http.dart' as http;
import 'package:nurahelp/app/data/models/settings_model/settings_model.dart';
import 'package:nurahelp/app/data/services/cache_service.dart';

import '../models/login_response.dart';
import '../models/symptom_model.dart';

class AppService extends GetxService {
  static AppService get instance => Get.find();
  final String baseUrl = dotenv.env['NEXT_PUBLIC_API_URL']!;

  /// Helper method to handle API errors gracefully
  Future<T> _withErrorHandling<T>(
    Future<T> Function() operation,
    String operationName,
  ) async {
    try {
      return await operation();
    } on SocketException {
      throw Exception('Network error: Unable to reach the server.');
    } on TimeoutException {
      throw Exception('$operationName timed out. Please try again.');
    } on FormatException {
      throw Exception('Invalid response format from server.');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String>> _getHeaders(User? user, bool acceptValue) async {
    String? token;
    try {
      token = await user?.getIdToken().timeout(const Duration(seconds: 5));
    } catch (e) {
      token = await user?.getIdToken();
    }

    return {
      if (token != null) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': acceptValue ? '*/*' : 'application/json',
    };
  }

  // ---------------------------------------------------------------------------
  // AUTH & OTP
  // ---------------------------------------------------------------------------

  Future<void> requestOtp(String email) async {
    return _withErrorHandling<void>(() async {
      final url = Uri.parse('$baseUrl/api/v1/get_otp');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to get otp. Status: ${response.statusCode}');
      }
    }, 'requestOtp');
  }

  Future<void> verifyOtp(String email, String otp) async {
    return _withErrorHandling<void>(() async {
      final url = Uri.parse('$baseUrl/api/v1/verify_otp');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
            body: jsonEncode({'email': email, 'otp': otp.trim()}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to verify otp. Status: ${response.statusCode}');
      }
    }, 'verifyOtp');
  }

  // ---------------------------------------------------------------------------
  // PATIENT RECORD & SYNCING
  // ---------------------------------------------------------------------------

  Future<List<AppointmentModel>> fetchAppointments(User? user) async {
    return _withErrorHandling<List<AppointmentModel>>(() async {
      final appointmentsUrl = Uri.parse('$baseUrl/api/v1/appointments');
      final response = await http
          .get(appointmentsUrl, headers: await _getHeaders(user, false))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data['appointments'] is List) {
          final List<dynamic> rawList = data['appointments'] as List<dynamic>;

          final appointments = rawList
              .map(
                (item) =>
                    AppointmentModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();

          // 🔥 SYNC CLINICAL CACHE: Update the local cache with these detailed appointments
          final clinicalCache =
              CacheService.instance.getCachedClinicalData() ?? {};
          clinicalCache['appointments'] = rawList;
          await CacheService.instance.cacheClinicalData(clinicalCache);

          return appointments;
        }
      } else {
        throw Exception('Failed to fetch appointments: ${response.statusCode}');
      }
      return [];
    }, 'fetchAppointments');
  }

  Future<PatientModel> fetchPatientRecord(
    User? user, {
    bool forceRefresh = false,
  }) async {
    PatientModel patient;

    if (!forceRefresh) {
      final cachedData = CacheService.instance.getCachedPatient();
      if (cachedData != null) {
        try {
          patient = LoginResponse.fromJson({
            'message': 'cached',
            'patient': cachedData,
            'settings': CacheService.instance.getCachedSettings() ?? {},
          }).patient;

          // Even with cached patient, always fetch fresh appointments
          final appointments = await fetchAppointments(user);
          patient.appointments = appointments;
          return patient;
        } catch (e) {
          // Error parsing cached patient, fall through to API fetch
        }
      }
    }

    return _withErrorHandling<PatientModel>(() async {
      // 1. Fetch Profile
      final url = Uri.parse('$baseUrl/patient/auth/v1/profile');
      final response = await http
          .get(url, headers: await _getHeaders(user, true))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final patient = LoginResponse.fromJson(data).patient;

        // 2. Fetch Detailed Appointments (Source of Truth for "Canceled" status)
        final appointments = await fetchAppointments(user);
        patient.appointments = appointments;

        await CacheService.instance.cachePatient(data['patient']);
        return patient;
      } else {
        throw Exception(
          'Failed to fetch patient record: ${response.statusCode}',
        );
      }
    }, 'fetchPatientRecord');
  }

  Future<void> savePatientRecord(PatientModel patient, User? user) async {
    return _withErrorHandling<void>(() async {
      final url = Uri.parse('$baseUrl/patient/auth/v1/register');
      final response = await http
          .post(
            url,
            headers: await _getHeaders(user, true),
            body: json.encode({
              'name': patient.name,
              'email': patient.email,
              'phone': patient.phone,
              'DOB': patient.DOB?.millisecondsSinceEpoch,
              'profilePicture': patient.profilePicture,
              'isComplete': patient.isComplete,
            }),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        user?.delete();
        throw Exception(
          'Failed to save details to db. Status code = ${response.statusCode}',
        );
      }
    }, 'savePatientRecord');
  }

  Future<Map<String, dynamic>> updatePatientField({
    User? user,
    PatientModel? patient,
  }) async {
    return _withErrorHandling<Map<String, dynamic>>(() async {
      final url = Uri.parse('$baseUrl/patient/auth/v1/update');
      final response = await http
          .put(
            url,
            headers: await _getHeaders(user, true),
            body: jsonEncode({'personalInfo': patient?.toJson()}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Failed to save details to db. '
          'Status code = ${response.statusCode}, '
          'Response body = ${response.body}',
        );
      }
    }, 'updatePatientField');
  }

  // ---------------------------------------------------------------------------
  // SETTINGS & PROFILE UPDATES
  // ---------------------------------------------------------------------------

  Future<SettingsModel> fetchPatientSettings(
    User? user, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cachedData = CacheService.instance.getCachedSettings();
      if (cachedData != null) {
        try {
          return SettingsModel.fromJson(cachedData);
        } catch (e) {
          // Error parsing cached settings, fall through to API fetch
        }
      }
    }

    return _withErrorHandling<SettingsModel>(() async {
      final url = Uri.parse('$baseUrl/patient/auth/v1/profile');
      final response = await http
          .get(url, headers: await _getHeaders(user, true))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Ensure settings exists in JSON to avoid "Null is not subtype of String"
        final settingsJson = data['settings'] ?? {};
        final settings = SettingsModel.fromJson(settingsJson);
        await CacheService.instance.cacheSettings(settingsJson);
        return settings;
      } else {
        throw Exception('Failed to fetch settings: ${response.statusCode}');
      }
    }, 'fetchPatientSettings');
  }

  Future<void> savePatientSettings(SettingsModel settings, User? user) async {
    return _withErrorHandling<void>(() async {
      final url = Uri.parse('$baseUrl/patient/auth/v1/update');
      final response = await http
          .put(
            url,
            headers: await _getHeaders(user, true),
            body: json.encode({'setting': settings.toJson()}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        await CacheService.instance.cacheSettings(settings.toJson());
      } else {
        throw Exception('Failed to save settings: ${response.statusCode}');
      }
    }, 'savePatientSettings');
  }

  Future<ClinicalResponse> getClinicalData({
    User? user,
    bool forceRefresh = false,
  }) async {
    // Check cache first unless force refresh
    if (!forceRefresh) {
      final cachedData = CacheService.instance.getCachedClinicalData();
      if (cachedData != null) {
        try {
          return ClinicalResponse.fromJson(cachedData);
        } catch (e) {
          // Error parsing cached clinical data, fall through to API fetch
        }
      }
    }

    return _withErrorHandling<ClinicalResponse>(() async {
      // Fetch from API
      final url = Uri.parse('$baseUrl/api/v1/my-info');
      final response = await http
          .get(url, headers: await _getHeaders(user, false))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Validate response is a Map
        if (data is! Map<String, dynamic>) {
          throw Exception(
            'Invalid clinical data format: Expected Map but got ${data.runtimeType}',
          );
        }

        final clinical = ClinicalResponse.fromJson(data);

        // Cache the result
        await CacheService.instance.cacheClinicalData(data);

        return clinical;
      } else {
        throw Exception(
          'Failed to fetch clinical record ${response.statusCode}',
        );
      }
    }, 'getClinicalData');
  }

  Future<void> savePatientSymptoms(
    List<SymptomModel> symptoms,
    User? user,
  ) async {
    return _withErrorHandling<void>(() async {
      final url = Uri.parse('$baseUrl/api/v1/my-symptoms');
      final response = await http
          .post(
            url,
            headers: await _getHeaders(user, true),
            body: jsonEncode({
              'symptoms': symptoms.map((s) => s.toJson()).toList(),
            }),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Failed to save symptoms. status code = ${response.statusCode}',
        );
      }
    }, 'savePatientSymptoms');
  }

  Future<void> savePatientSymptomsWithColors(
    List<Map<String, dynamic>> symptoms,
    User? user,
  ) async {
    return _withErrorHandling<void>(() async {
      final url = Uri.parse('$baseUrl/api/v1/my-symptoms');
      final response = await http
          .post(
            url,
            headers: await _getHeaders(user, true),
            body: jsonEncode({'symptoms': symptoms}),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Failed to save symptoms. status code = ${response.statusCode}',
        );
      }
    }, 'savePatientSymptomsWithColors');
  }

  Future<List<SymptomModel>> getPatientSymptoms(
    User? user,
    PatientModel patient,
  ) async {
    return _withErrorHandling<List<SymptomModel>>(() async {
      final url = Uri.parse('$baseUrl/api/v1/patient-symptoms');
      final response = await http
          .post(
            url,
            headers: await _getHeaders(user, true),
            body: jsonEncode({'patientId': patient.id}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        if (jsonBody is List) {
          List<SymptomModel> allSymptoms = [];

          for (var entry in jsonBody) {
            final dateString = entry['date'] as String?;
            final symptomsJson = entry['symptoms'] ?? [];

            for (var symptomData in symptomsJson) {
              if (symptomData is Map<String, dynamic>) {
                // Add date to symptom data if available
                if (dateString != null) {
                  symptomData['date'] = dateString;
                }
                allSymptoms.add(SymptomModel.fromJson(symptomData));
              }
            }
          }

          return allSymptoms;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception(
          'Failed to fetch symptoms. Status code = ${response.statusCode}',
        );
      }
    }, 'getPatientSymptoms');
  }

  Future<Map<String, dynamic>> linkDoctorToPatient(
    String inviteCode,
    User? user,
  ) async {
    return _withErrorHandling<Map<String, dynamic>>(() async {
      final url = Uri.parse('$baseUrl/patient/auth/v1/link-doctor');
      final response = await http
          .post(
            url,
            headers: await _getHeaders(user, true),
            body: jsonEncode({'inviteCode': inviteCode}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to link doctor');
      }
    }, 'linkDoctorToPatient');
  }

  // Add these methods to your AppService class

  // Get chat history with a specific user
  Future<Map<String, dynamic>> getChatHistory(
    String receiverId,
    User? user,
  ) async {
    return _withErrorHandling<Map<String, dynamic>>(() async {
      final url = Uri.parse('$baseUrl/chat/v1/history/$receiverId');
      final response = await http
          .get(url, headers: await _getHeaders(user, true))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch chat history: ${response.statusCode}');
      }
    }, 'getChatHistory');
  }

  // Get all conversations
  Future<List<ConversationModel>> getConversations(
    User? user, {
    bool forceRefresh = false,
  }) async {
    // Check cache first unless force refresh
    if (!forceRefresh) {
      final cachedData = CacheService.instance.getCachedConversations();
      if (cachedData != null) {
        try {
          return cachedData
              .map((json) => ConversationModel.fromJson(json))
              .toList();
        } catch (e) {
          // Error parsing cached conversations, fall through to API fetch
        }
      }
    }

    return _withErrorHandling<List<ConversationModel>>(() async {
      // Fetch from API
      final url = Uri.parse('$baseUrl/chat/v1/conversations');
      final response = await http
          .get(url, headers: await _getHeaders(user, true))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Cache the result
        await CacheService.instance.cacheConversations(data);

        return data.map((json) => ConversationModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to fetch conversations: ${response.statusCode}',
        );
      }
    }, 'getConversations');
  }

  // Mark messages as read from a specific sender
  Future<void> markMessagesAsRead(String senderId, User? user) async {
    return _withErrorHandling<void>(() async {
      final url = Uri.parse('$baseUrl/chat/v1/read/$senderId');
      final response = await http
          .put(url, headers: await _getHeaders(user, true))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to mark messages as read: ${response.statusCode}',
        );
      }
    }, 'markMessagesAsRead');
  }

  Future<void> markAllMessagesAsRead(User? user) async {
    return _withErrorHandling<void>(() async {
      final url = Uri.parse('$baseUrl/chat/v1/read/all');
      final response = await http
          .put(url, headers: await _getHeaders(user, true))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to mark all messages as read: ${response.statusCode}',
        );
      }
    }, 'markAllMessagesAsRead');
  }

  // Upload file for chat (image, document, etc.)
  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<Map<String, dynamic>> uploadChatFile(
    XFile file,
    String receiver,
    User? user,
  ) async {
    return _withErrorHandling<Map<String, dynamic>>(() async {
      final url = Uri.parse('$baseUrl/api/v1/upload');

      final request = http.MultipartRequest('POST', url);
      request.headers.addAll(await _getHeaders(user, true));
      request.fields['receiver'] = receiver;

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: file.name,
        ),
      );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to upload file: ${response.statusCode}');
      }
    }, 'uploadChatFile');
  }

  /// Update the patient's isComplete field after OTP verification
  Future<Map<String, dynamic>> updateIsCompleteField(
    User? user,
    PatientModel patient,
  ) async {
    return _withErrorHandling<Map<String, dynamic>>(() async {
      final url = Uri.parse('$baseUrl/patient/auth/v1/update');

      final response = await http
          .put(
            url,
            headers: await _getHeaders(user, true),
            body: jsonEncode({
              'personalInfo': {'isComplete': true},
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Cache the updated patient
        final data = jsonDecode(response.body);
        if (data['patient'] != null) {
          await CacheService.instance.cachePatient(data['patient']);
        }
        return data;
      } else {
        throw Exception(
          'Failed to update patient. '
          'Status code = ${response.statusCode}',
        );
      }
    }, 'updateIsCompleteField');
  }
}
