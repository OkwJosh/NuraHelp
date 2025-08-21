import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:nurahelp/app/data/models/settings_model/settings_model.dart';

class LoginResponse {
  String message;
  final PatientModel patient;
  final SettingsModel settings;

  LoginResponse(
      {required this.message, required this.patient, required this.settings});


  factory LoginResponse.fromJson(json){
    return LoginResponse(message: json['message'],
        patient: PatientModel.fromJson(json['patient']),
        settings: SettingsModel.fromJson(json['settings']),
    );
  }
}







