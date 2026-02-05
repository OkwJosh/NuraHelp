import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/models/vital_model.dart';
import 'package:nurahelp/app/data/models/medication_model.dart';
import 'package:nurahelp/app/data/models/test_results_model.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_health_controller.dart';

void main() {
  late PatientHealthController healthController;

  setUp(() {
    healthController = PatientHealthController();
  });

  tearDown(() {
    Get.reset();
  });

  group('PatientHealthController - Date Management', () {
    test('selectedDate should initialize to today', () {
      expect(healthController.selectedDate.value.day, DateTime.now().day);
      expect(healthController.selectedDate.value.month, DateTime.now().month);
      expect(healthController.selectedDate.value.year, DateTime.now().year);
    });

    test('formatDate should return correct format', () {
      final testDate = DateTime(2026, 2, 3);
      final formatted = healthController.formatDate(testDate);
      expect(formatted, equals('3 Feb 2026'));
    });

    test('isSameDay should identify same dates', () {
      final date1 = DateTime(2026, 2, 3, 10, 30);
      final date2 = DateTime(2026, 2, 3, 15, 45);
      expect(healthController.isSameDay(date1, date2), isTrue);
    });

    test('isSameDay should identify different dates', () {
      final date1 = DateTime(2026, 2, 3);
      final date2 = DateTime(2026, 2, 4);
      expect(healthController.isSameDay(date1, date2), isFalse);
    });

    test('setToday should set date to today', () {
      final today = DateTime.now();
      healthController.setToday();
      expect(healthController.selectedDate.value.day, today.day);
    });

    test('previousDay should decrement date by 1 day', () {
      final initialDate = healthController.selectedDate.value;
      healthController.previousDay();
      final expectedDate = initialDate.subtract(Duration(days: 1));
      expect(healthController.selectedDate.value.day, expectedDate.day);
    });

    test('nextDay should increment date by 1 day', () {
      final initialDate = healthController.selectedDate.value;
      healthController.nextDay();
      final expectedDate = initialDate.add(Duration(days: 1));
      expect(healthController.selectedDate.value.day, expectedDate.day);
    });
  });

  group('PatientHealthController - Vitals Filtering', () {
    test('getVitalsForDate should return vitals for matching date', () {
      final today = DateTime.now();
      final vitals = [
        VitalModel(
          bpValue: '120/80',
          bglValue: '100',
          heartRate: '72',
          oxygenSatValue: '98',
          bodyTempValue: '37',
          weightValue: '70',
          date: today,
        ),
        VitalModel(
          bpValue: '118/76',
          bglValue: '102',
          heartRate: '70',
          oxygenSatValue: '97',
          bodyTempValue: '36.8',
          weightValue: '70',
          date: today.subtract(Duration(days: 1)),
        ),
      ];

      final filtered = healthController.getVitalsForDate(vitals);
      expect(filtered.length, 1);
      expect(filtered.first.bpValue, '120/80');
    });

    test('getVitalsForDate should return empty list when no matches', () {
      final tomorrow = DateTime.now().add(Duration(days: 1));
      final vitals = [
        VitalModel(
          bpValue: '120/80',
          bglValue: '100',
          heartRate: '72',
          oxygenSatValue: '98',
          bodyTempValue: '37',
          weightValue: '70',
          date: tomorrow,
        ),
      ];

      final filtered = healthController.getVitalsForDate(vitals);
      expect(filtered.length, 0);
    });
  });

  group('PatientHealthController - Medication Filtering', () {
    test('getMedicationsByStatus should return ongoing medications', () {
      final today = DateTime.now();
      final medications = [
        MedicationModel(
          medName: 'Aspirin',
          description: 'Pain relief',
          observation: 'Take with food',
          startDate: today.subtract(Duration(days: 5)),
          endDate: today.add(Duration(days: 5)),
          noOfCapsules: '2',
          date: today,
        ),
        MedicationModel(
          medName: 'Ibuprofen',
          description: 'Fever reduction',
          observation: 'With meals',
          startDate: today.subtract(Duration(days: 10)),
          endDate: today.subtract(Duration(days: 2)),
          noOfCapsules: '1',
          date: today,
        ),
      ];

      final ongoing = healthController.getMedicationsByStatus(
        medications,
        true,
      );
      expect(ongoing.length, 1);
      expect(ongoing.first.medName, 'Aspirin');
    });

    test('getMedicationsByStatus should return history medications', () {
      final today = DateTime.now();
      final medications = [
        MedicationModel(
          medName: 'Aspirin',
          description: 'Pain relief',
          observation: 'Take with food',
          startDate: today.subtract(Duration(days: 5)),
          endDate: today.add(Duration(days: 5)),
          noOfCapsules: '2',
          date: today,
        ),
        MedicationModel(
          medName: 'Ibuprofen',
          description: 'Fever reduction',
          observation: 'With meals',
          startDate: today.subtract(Duration(days: 10)),
          endDate: today.subtract(Duration(days: 2)),
          noOfCapsules: '1',
          date: today,
        ),
      ];

      final history = healthController.getMedicationsByStatus(
        medications,
        false,
      );
      expect(history.length, 1);
      expect(history.first.medName, 'Ibuprofen');
    });

    test('getMedicationsByStatus should handle empty list', () {
      final ongoing = healthController.getMedicationsByStatus([], true);
      final history = healthController.getMedicationsByStatus([], false);
      expect(ongoing.length, 0);
      expect(history.length, 0);
    });
  });

  group('PatientHealthController - Test Results Filtering', () {
    test('getTestResultsForDate should filter by date', () {
      final today = DateTime.now();
      final testResults = [
        TestResultModel(
          testName: 'Blood Test',
          description: 'Complete blood count',
          observation: 'All values normal',
          viewLink: 'https://example.com/view1',
          downloadLink: 'https://example.com/download1',
          date: today,
        ),
        TestResultModel(
          testName: 'Urine Test',
          description: 'Urinalysis',
          observation: 'No abnormalities',
          viewLink: 'https://example.com/view2',
          downloadLink: 'https://example.com/download2',
          date: today.subtract(Duration(days: 1)),
        ),
      ];

      final filtered = healthController.getTestResultsForDate(testResults);
      expect(filtered.length, 1);
      expect(filtered.first.testName, 'Blood Test');
    });

    test('getTestResultsForDate should return empty when no matches', () {
      final testResults = [
        TestResultModel(
          testName: 'Blood Test',
          description: 'Complete blood count',
          observation: 'All values normal',
          viewLink: 'https://example.com/view1',
          downloadLink: 'https://example.com/download1',
          date: DateTime.now().subtract(Duration(days: 5)),
        ),
      ];

      healthController.selectedDate.value = DateTime.now().add(
        Duration(days: 1),
      );
      final filtered = healthController.getTestResultsForDate(testResults);
      expect(filtered.length, 0);
    });
  });

  group('PatientHealthController - Medication Date Range', () {
    test('getMedicationsForDate should check date within range', () {
      final today = DateTime.now();
      final medications = [
        MedicationModel(
          medName: 'Active Med',
          description: 'Active',
          observation: 'Take daily',
          startDate: today.subtract(Duration(days: 10)),
          endDate: today.add(Duration(days: 10)),
          noOfCapsules: '2',
          date: today,
        ),
      ];

      final result = healthController.getMedicationsForDate(medications);
      expect(result.length, 1);
    });

    test('getMedicationsForDate should exclude past medications', () {
      final today = DateTime.now();
      final medications = [
        MedicationModel(
          medName: 'Past Med',
          description: 'Past',
          observation: 'Discontinued',
          startDate: today.subtract(Duration(days: 20)),
          endDate: today.subtract(Duration(days: 10)),
          noOfCapsules: '1',
          date: today,
        ),
      ];

      final result = healthController.getMedicationsForDate(medications);
      expect(result.length, 0);
    });

    test('getMedicationsForDate should exclude future medications', () {
      final today = DateTime.now();
      final medications = [
        MedicationModel(
          medName: 'Future Med',
          description: 'Future',
          observation: 'Scheduled',
          startDate: today.add(Duration(days: 10)),
          endDate: today.add(Duration(days: 20)),
          noOfCapsules: '1',
          date: today,
        ),
      ];

      final result = healthController.getMedicationsForDate(medications);
      expect(result.length, 0);
    });
  });
}
