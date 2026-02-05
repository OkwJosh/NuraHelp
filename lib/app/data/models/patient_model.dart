import 'package:nurahelp/app/data/models/appointment_model.dart';
import 'package:nurahelp/app/data/models/clinical_response.dart';
import 'package:nurahelp/app/data/models/doctor_model.dart';

class PatientModel {
  String? id;
  String name;
  String email;
  String phone;
  bool isComplete = false;
  DateTime? DOB;
  String? profilePicture;
  String? inviteCode;
  DoctorModel? doctor;
  List<AppointmentModel> appointments = [];
  ClinicalResponse? clinicalResponse;

  PatientModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.DOB,
    this.profilePicture,
    this.inviteCode,
    this.doctor,
    this.appointments = const [],
    this.clinicalResponse,
    this.isComplete = false,
  });

  List<String>? get nameParts => name.split(' ');

  String? get firstName => nameParts?[0];

  String? get lastName => nameParts?[1];

  static PatientModel empty() => PatientModel(
    id: '',
    name: '',
    email: '',
    phone: '',
    DOB: DateTime.now(),
    profilePicture: '',
    appointments: [],
    isComplete: false,
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'DOB': DOB?.millisecondsSinceEpoch,
      'profilePicture': profilePicture,
      'isComplete': isComplete,
    };
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      DOB: json['DOB'] != null ? DateTime.parse(json['DOB']) : null,
      doctor: json['doctor'] != null
          ? DoctorModel.fromJson(json['doctor'])
          : null,
      profilePicture: json['profilePicture'],
      appointments:[], // Appointments are fetched separately from /api/v1/appointments
      clinicalResponse: null,
      isComplete: json['isComplete'] ?? false,
    );
  }
}
