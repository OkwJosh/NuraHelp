import 'package:nurahelp/app/data/models/clinical_response.dart';
import 'package:nurahelp/app/data/models/doctor_model.dart';

class PatientModel {
  String? id;
  String name;
  String email;
  String phone;
  DateTime? DOB;
  String? profilePicture;
  final String? inviteCode;
  DoctorModel? doctor;
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
    this.clinicalResponse
  });

  List<String>? get nameParts => name.split(' ');

  String? get firstName => nameParts?[0];

  String? get lastName => nameParts?[1];



  static PatientModel empty() =>
      PatientModel(
        id: '',
        name: '',
        email: '',
        phone: '',
        DOB: DateTime.now(),
        profilePicture: '',
        inviteCode: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'DOB': DOB?.millisecondsSinceEpoch,
      'profilePicture': profilePicture,
      'inviteCode': inviteCode,
    };
  }

  factory PatientModel.fromJson(Map<String, dynamic> json){
    return PatientModel(
        id: json['_id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        DOB: DateTime.parse(json['DOB']),
        doctor: DoctorModel.fromJson(json['doctor']),
        profilePicture: json['profilePicture'],
    );
  }


}
