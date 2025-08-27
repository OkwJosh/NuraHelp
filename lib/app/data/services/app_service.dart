import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurahelp/app/data/models/clinical_response.dart';
import 'package:nurahelp/app/data/models/message_models/message_model.dart';
import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:http/http.dart' as http;
import 'package:nurahelp/app/data/models/settings_model/settings_model.dart';
import '../../utilities/exceptions/firebase_exceptions.dart';
import '../../utilities/exceptions/platform_exceptions.dart';
import '../models/login_response.dart';
import '../models/symptom_model.dart';

class AppService {
  static AppService get instance => Get.find();
  final String baseUrl = dotenv.env['NEXT_PUBLIC_API_URL']!;

  Future<Map<String, String>> _getHeaders(User? user,bool acceptValue) async {
    final token = await user?.getIdToken(true);
    return {
      if (token != null) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': acceptValue == true?'*/*':'application/json',

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
      headers: await _getHeaders(user,true),
      body: json.encode({
        'name': patient.name,
        'email': patient.email,
        'phone': patient.phone,
        'DOB': patient.DOB?.millisecondsSinceEpoch,
        'profilePicture': patient.profilePicture,
        'inviteCode': patient.inviteCode,
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

  Future<PatientModel> fetchPatientRecord(User? user) async {
    final url = Uri.parse('$baseUrl/patient/auth/v1/profile');
    final response = await http.get(url, headers: await _getHeaders(user,true));
    final token = await user?.getIdToken();
    print('Hey this is the $token');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LoginResponse.fromJson(data).patient;
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
      headers: await _getHeaders(user,true),
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
      headers: await _getHeaders(user,true),
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

  Future<SettingsModel> fetchPatientSettings(User? user) async {
    final url = Uri.parse('$baseUrl/patient/auth/v1/profile');
    final response = await http.get(url, headers: await _getHeaders(user,true));
    final token = await user?.getIdToken();
    print('Hey this is the $token');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LoginResponse.fromJson(data).settings;
    } else {
      throw Exception('Failed to fetch patient record ${response.statusCode}');
    }
  }

  Future<List<ChatModel>> fetchConversations(User? user) async{
    final url = Uri.parse('$baseUrl/chat/v1/conversations');
    final response = await http.get(url,headers: await _getHeaders(user,true));
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      final List<dynamic> conversations = data['conversations'];
      return conversations.map((json) => ChatModel.fromJson(json)).toList();
    }else{
      throw Exception('Failed to fetch conversations ${response.statusCode}');
    }
  }

  Future<ClinicalResponse> getClinicalData({User? user}) async{
    final url = Uri.parse('$baseUrl/api/v1/my-info');
    final response = await http.get(url,headers: await _getHeaders(user,false));
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return ClinicalResponse.fromJson(data);
    }else{
      throw Exception('Failed to fetch clinical record ${response.statusCode}');
    }
  }


  Future<void> savePatientSymptoms(List<SymptomModel> symptoms, User? user) async {
    final url = Uri.parse('$baseUrl/api/v1/my-symptoms');
    final response = await http.post(
      url,
      headers: await _getHeaders(user,true),
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

  Future<List<SymptomModel>> getPatientSymptoms(User? user, PatientModel patient) async {
    final url = Uri.parse('$baseUrl/api/v1/patient-symptoms');
    final response = await http.post(
      url,
      headers: await _getHeaders(user,true),
      body: jsonEncode({'patientId': patient.id}),
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);

      if (jsonBody is List) {
        List<SymptomModel> allSymptoms = [];

        for (var entry in jsonBody) {
          final symptomsJson = entry['symptoms'] ?? [];

          for (var symptomData in symptomsJson) {
            if (symptomData is Map<String, dynamic>) {
              allSymptoms.add(SymptomModel.fromJson(symptomData));
            }
          }
        }

        return allSymptoms;
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to fetch symptoms. Status code = ${response.statusCode}');
    }
  }
  
  









}
