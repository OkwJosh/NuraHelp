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
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'DOB': DOB?.toIso8601String(),
      'profilePicture': profilePicture,
      'isComplete': isComplete,
      if (doctor != null) 'doctor': doctor!.toJson(),
    };
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDOB;
    final rawDOB = json['DOB'];
    if (rawDOB is String) {
      parsedDOB = DateTime.tryParse(rawDOB);
    } else if (rawDOB is int) {
      parsedDOB = DateTime.fromMillisecondsSinceEpoch(rawDOB);
    }

    return PatientModel(
      id: json['_id']?.toString(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      DOB: parsedDOB,
      doctor: json['doctor'] != null && json['doctor'] is Map<String, dynamic>
          ? DoctorModel.fromJson(json['doctor'])
          : null,
      profilePicture: json['profilePicture']?.toString(),
      appointments:
          [], // Appointments are fetched separately from /api/v1/appointments
      clinicalResponse: null,
      isComplete: json['isComplete'] ?? false,
    );
  }
}
