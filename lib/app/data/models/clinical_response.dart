import 'package:nurahelp/app/data/models/medication_model.dart';
import 'package:nurahelp/app/data/models/test_results_model.dart';
import 'package:nurahelp/app/data/models/vital_model.dart';

import 'appointment_model.dart';

class ClinicalResponse {
  final List<VitalModel> vitals;
  final List<MedicationModel> medications;
  final List<TestResultModel> testResults;

  ClinicalResponse({
    required this.vitals,
    required this.medications,
    required this.testResults,
  });

  static empty() => ClinicalResponse(
    vitals: [],
    medications: [],
    testResults: [],
  );


  Map<String, dynamic> toJson() {
    return {
      'vitals': vitals.map((v) => v.toJson()).toList(),
      'medications': medications.map((m) => m.toJson()).toList(),
      'testResults': testResults.map((t) => t.toJson()).toList(),
    };
  }

  factory ClinicalResponse.fromJson(Map<String, dynamic> json) {
    final appointmentsList =
        (json['appointments'] as List<dynamic>?)?.map((item) {
          final appointment = AppointmentModel.fromJson(item);
          return appointment;
        }).toList() ??
        [];

    final testResultsList =
        (json['testResults'] as List<dynamic>?)?.map((item) {
          final result = TestResultModel.fromJson(item as Map<String, dynamic>);
          return result;
        }).toList() ??
        [];

    return ClinicalResponse(
      vitals:
          (json['vitals'] as List<dynamic>?)
              ?.map((item) => VitalModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      medications:
          (json['medications'] as List<dynamic>?)
              ?.map(
                (item) =>
                    MedicationModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      testResults: testResultsList,
    );
  }
}
