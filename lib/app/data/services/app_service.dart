import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurahelp/app/data/models/clinical_response.dart';
import 'package:nurahelp/app/data/models/message_models/conversation_model.dart';
import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:http/http.dart' as http;
import 'package:nurahelp/app/data/models/settings_model/settings_model.dart';
import 'package:nurahelp/app/data/services/cache_service.dart';
import '../../utilities/exceptions/firebase_exceptions.dart';
import '../../utilities/exceptions/platform_exceptions.dart';
import '../models/login_response.dart';
import '../models/symptom_model.dart';

class AppService {
  static AppService get instance => Get.find();
  final String baseUrl = dotenv.env['NEXT_PUBLIC_API_URL']!;

  Future<Map<String, String>> _getHeaders(User? user, bool acceptValue) async {
    final token = await user?.getIdToken(true);
    return {
      if (token != null) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': acceptValue == true ? '*/*' : 'application/json',
    };
  }

  Future<void> requestOtp(String email) async {
    final url = Uri.parse('$baseUrl/api/v1/get_otp');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to get otp. Status code == ${response.statusCode}',
      );
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    final url = Uri.parse('$baseUrl/api/v1/verify_otp');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
      body: jsonEncode({'email': email, 'otp': otp.trim()}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to verify otp. Status code == ${response.statusCode}',
      );
    }
  }

  Future<void> savePatientRecord(PatientModel patient, User? user) async {
    final url = Uri.parse('$baseUrl/patient/auth/v1/register');
    final response = await http.post(
      url,
      headers: await _getHeaders(user, true),
      body: json.encode({
        'name': patient.name,
        'email': patient.email,
        'phone': patient.phone,
        'DOB': patient.DOB?.millisecondsSinceEpoch,
        'profilePicture': patient.profilePicture,
        // 'inviteCode': patient.inviteCode,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      user?.delete();
      throw Exception(
        'Failed to save details to db. Status code = ${response.statusCode}',
      );
    }
  }

  Future<PatientModel> fetchPatientRecord(
    User? user, {
    bool forceRefresh = false,
  }) async {
    print(
      '🔍 [AppService] fetchPatientRecord called - forceRefresh: $forceRefresh',
    );

    // Check cache first unless force refresh
    if (!forceRefresh) {
      final cachedData = CacheService.instance.getCachedPatient();
      if (cachedData != null) {
        try {
          return LoginResponse.fromJson({
            'patient': cachedData,
            'settings': {},
          }).patient;
        } catch (e) {
          print('❌ [AppService] Error parsing cached patient: $e');
        }
      }
    }

    // Fetch from API
    final url = Uri.parse('$baseUrl/patient/auth/v1/profile');
    final response = await http.get(
      url,
      headers: await _getHeaders(user, true),
    );
    final token = await user?.getIdToken();
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final patient = LoginResponse.fromJson(data).patient;

      // Cache the result
      await CacheService.instance.cachePatient(data['patient']);

      return patient;
    } else {
      throw Exception('Failed to fetch patient record ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> updatePatientField({
    User? user,
    PatientModel? patient,
  }) async {
    final url = Uri.parse('$baseUrl/patient/auth/v1/update');
    final response = await http.put(
      url,
      headers: await _getHeaders(user, true),
      body: jsonEncode({'personalInfo': patient?.toJson()}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to save details to db. '
        'Status code = ${response.statusCode}, '
        'Response body = ${response.body}',
      );
    }
  }

  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const FormatException();
    } on PlatformException catch (e) {
      throw AppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.Please try again';
    }
  }

  Future<void> savePatientSettings(SettingsModel settings, User? user) async {
    final url = Uri.parse('$baseUrl/patient/auth/v1/update');
    final response = await http.put(
      url,
      headers: await _getHeaders(user, true),
      body: json.encode({'setting': settings.toJson()}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to save settings. status code = ${response.statusCode}',
      );
    }
  }

  Future<SettingsModel> fetchPatientSettings(
    User? user, {
    bool forceRefresh = false,
  }) async {
    // Check cache first unless force refresh
    if (!forceRefresh) {
      final cachedData = CacheService.instance.getCachedSettings();
      if (cachedData != null) {
        try {
          return LoginResponse.fromJson({
            'patient': {},
            'settings': cachedData,
          }).settings;
        } catch (e) {
          print('❌ [AppService] Error parsing cached settings: $e');
        }
      }
    }

    // Fetch from API
    final url = Uri.parse('$baseUrl/patient/auth/v1/profile');
    final response = await http.get(
      url,
      headers: await _getHeaders(user, true),
    );
    final token = await user?.getIdToken();
    print('Hey this is the $token');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final settings = LoginResponse.fromJson(data).settings;

      // Cache the result
      await CacheService.instance.cacheSettings(data['settings']);

      return settings;
    } else {
      throw Exception('Failed to fetch patient record ${response.statusCode}');
    }
  }

  Future<ClinicalResponse> getClinicalData({
    User? user,
    bool forceRefresh = false,
  }) async {
    print(
      '🔍 [AppService] getClinicalData called - forceRefresh: $forceRefresh',
    );

    // Check cache first unless force refresh
    if (!forceRefresh) {
      final cachedData = CacheService.instance.getCachedClinicalData();
      if (cachedData != null) {
        try {
          return ClinicalResponse.fromJson(cachedData);
        } catch (e) {
          print('❌ [AppService] Error parsing cached clinical data: $e');
        }
      }
    }

    // Fetch from API
    final url = Uri.parse('$baseUrl/api/v1/my-info');
    final response = await http.get(
      url,
      headers: await _getHeaders(user, false),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final clinical = ClinicalResponse.fromJson(data);

      // Cache the result
      await CacheService.instance.cacheClinicalData(data);

      return clinical;
    } else {
      throw Exception('Failed to fetch clinical record ${response.statusCode}');
    }
  }

  Future<void> savePatientSymptoms(
    List<SymptomModel> symptoms,
    User? user,
  ) async {
    final url = Uri.parse('$baseUrl/api/v1/my-symptoms');
    final response = await http.post(
      url,
      headers: await _getHeaders(user, true),
      body: jsonEncode({'symptoms': symptoms.map((s) => s.toJson()).toList()}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to save symptoms. status code = ${response.statusCode}',
      );
    }
  }

  Future<void> savePatientSymptomsWithColors(
    List<Map<String, dynamic>> symptoms,
    User? user,
  ) async {
    final url = Uri.parse('$baseUrl/api/v1/my-symptoms');
    final response = await http.post(
      url,
      headers: await _getHeaders(user, true),
      body: jsonEncode({'symptoms': symptoms}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to save symptoms. status code = ${response.statusCode}',
      );
    }
  }

  Future<List<SymptomModel>> getPatientSymptoms(
    User? user,
    PatientModel patient,
  ) async {
    final url = Uri.parse('$baseUrl/api/v1/patient-symptoms');
    final response = await http.post(
      url,
      headers: await _getHeaders(user, true),
      body: jsonEncode({'patientId': patient.id}),
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);

      print('===== RAW API RESPONSE =====');
      print(jsonEncode(jsonBody));
      print('============================');

      if (jsonBody is List) {
        List<SymptomModel> allSymptoms = [];

        for (var entry in jsonBody) {
          final dateString = entry['date'] as String?;
          final symptomsJson = entry['symptoms'] ?? [];

          print('Entry date string: $dateString');
          print('Symptoms in this entry: ${symptomsJson.length}');

          for (var symptomData in symptomsJson) {
            if (symptomData is Map<String, dynamic>) {
              // Add date to symptom data if available
              if (dateString != null) {
                symptomData['date'] = dateString;
              }
              print('Symptom data before parsing: $symptomData');
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
  }

  Future<Map<String, dynamic>> linkDoctorToPatient(
    String inviteCode,
    User? user,
  ) async {
    final url = Uri.parse('$baseUrl/patient/auth/v1/link-doctor');
    final response = await http.post(
      url,
      headers: await _getHeaders(user, true),
      body: jsonEncode({'inviteCode': inviteCode}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to link doctor');
    }
  }

  // Add these methods to your AppService class

  // Get chat history with a specific user
  Future<Map<String, dynamic>> getChatHistory(
    String receiverId,
    User? user,
  ) async {
    final url = Uri.parse('$baseUrl/chat/v1/history/$receiverId');
    final response = await http.get(
      url,
      headers: await _getHeaders(user, true),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch chat history: ${response.statusCode}');
    }
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
          print('❌ [AppService] Error parsing cached conversations: $e');
        }
      }
    }

    // Fetch from API
    final url = Uri.parse('$baseUrl/chat/v1/conversations');
    final response = await http.get(
      url,
      headers: await _getHeaders(user, true),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // Cache the result
      await CacheService.instance.cacheConversations(data);

      return data.map((json) => ConversationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch conversations: ${response.statusCode}');
    }
  }

  // Mark messages as read from a specific sender
  Future<void> markMessagesAsRead(String senderId, User? user) async {
    final url = Uri.parse('$baseUrl/chat/v1/read/$senderId');
    final response = await http.put(
      url,
      headers: await _getHeaders(user, true),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to mark messages as read: ${response.statusCode}',
      );
    }
  }

  // Mark all messages as read
  Future<void> markAllMessagesAsRead(User? user) async {
    final url = Uri.parse('$baseUrl/chat/v1/read/all');
    final response = await http.put(
      url,
      headers: await _getHeaders(user, true),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to mark all messages as read: ${response.statusCode}',
      );
    }
  }

  // Upload file for chat (image, document, etc.)
  Future<Map<String, dynamic>> uploadChatFile(
    XFile file,
    String receiver,
    User? user,
  ) async {
    final url = Uri.parse('$baseUrl/api/v1/upload');

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll(await _getHeaders(user, true));
    request.fields['receiver'] = receiver;

    request.files.add(
      await http.MultipartFile.fromPath('file', file.path, filename: file.name),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to upload file: ${response.statusCode}');
    }
  }
}
