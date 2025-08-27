import 'package:nurahelp/app/data/models/medication_model.dart';
import 'package:nurahelp/app/data/models/test_results_model.dart';
import 'package:nurahelp/app/data/models/vital_model.dart';

import 'appointment_model.dart';

class ClinicalResponse {
  final List<VitalModel> vitals;
  final List<MedicationModel> medications;
  final List<TestResultModel> testResults;
  final List<AppointmentModel> appointments;

  ClinicalResponse({
    required this.vitals,
    required this.medications,
    required this.testResults,
    required this.appointments,
  });

  static empty() =>
      ClinicalResponse(
        vitals: VitalModel.empty(),
        medications: MedicationModel.empty(),
        testResults: TestResultModel.empty(),
        appointments: AppointmentModel.empty(),
      );



  factory ClinicalResponse.fromJson(Map<String, dynamic> json) {
  return ClinicalResponse(
  vitals: (json['vitals'] as List<dynamic>?)
      ?.map((item) => VitalModel.fromJson(item as Map<String, dynamic>))
      .toList() ?? [],
  medications: (json['medications'] as List<dynamic>?)
      ?.map((item) => MedicationModel.fromJson(item as Map<String, dynamic>))
      .toList() ?? [],
  testResults: (json['testResults'] as List<dynamic>?)
      ?.map((item) => TestResultModel.fromJson(item as Map<String, dynamic>))
      .toList() ?? [],
  appointments: (json['appointments'] as List<dynamic>?)
      ?.map((item) => AppointmentModel.fromJson(item as Map<String, dynamic>))
      .toList() ?? [],
  );
  }
  }
