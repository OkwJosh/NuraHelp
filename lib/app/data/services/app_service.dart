import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:http/http.dart' as http;

class AppService {
  static AppService get instance => Get.find();
  final String baseUrl = dotenv.env['NEXT_PUBLIC_API_URL']!;

  Future<Map<String, String>> _getHeaders() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();

    return {if (token != null) 'Authorization': 'Bearer $token'};
  }

  // Future<Map<String,dynamic>> savePatientRecord(PatientModel patient) async{
  //
  //   final url = Uri.parse('$baseUrl/');
  //
  // }

  Future<void> requestOtp(String email) async {
    final url = Uri.parse('$baseUrl/api/v1/get_otp');

    final response = await http.post(
      url,
      headers: {"Content-Type":'application/json',
      'Accept':'*/*'
      },
      body: jsonEncode({"email": email}));

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
      headers: {"Content-Type":'application/json',
        'Accept':'*/*'
      },
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
}
