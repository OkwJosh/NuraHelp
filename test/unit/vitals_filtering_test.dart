import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/models/vital_model.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_health_controller.dart';

void main() {
  late PatientHealthController healthController;

  setUp(() {
    healthController = PatientHealthController();
  });

  tearDown(() {
    Get.reset();
  });

  group('Vitals Filtering Tests', () {
    test('should filter vitals for today', () {
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
        VitalModel(
          bpValue: '119/79',
          bglValue: '99',
          heartRate: '71',
          oxygenSatValue: '98.5',
          bodyTempValue: '37.2',
          weightValue: '70',
          date: today,
        ),
      ];

      final filtered = healthController.getVitalsForDate(vitals);

      expect(filtered.length, 2);
      expect(filtered.every((v) => v.date.day == today.day), isTrue);
    });

    test('should return empty list when no vitals match date', () {
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

      healthController.selectedDate.value = DateTime.now().subtract(
        Duration(days: 1),
      );
      final filtered = healthController.getVitalsForDate(vitals);

      expect(filtered.isEmpty, isTrue);
    });

    test('should handle multiple vitals on same day', () {
      final today = DateTime.now();
      final vitals = [
        VitalModel(
          bpValue: '120/80',
          bglValue: '100',
          heartRate: '72',
          oxygenSatValue: '98',
          bodyTempValue: '37',
          weightValue: '70',
          date: DateTime(today.year, today.month, today.day, 8, 0),
        ),
        VitalModel(
          bpValue: '119/79',
          bglValue: '102',
          heartRate: '70',
          oxygenSatValue: '97',
          bodyTempValue: '36.8',
          weightValue: '70',
          date: DateTime(today.year, today.month, today.day, 10, 30),
        ),
        VitalModel(
          bpValue: '118/78',
          bglValue: '99',
          heartRate: '71',
          oxygenSatValue: '98.2',
          bodyTempValue: '37.1',
          weightValue: '70',
          date: DateTime(today.year, today.month, today.day, 14, 15),
        ),
      ];

      final filtered = healthController.getVitalsForDate(vitals);

      expect(filtered.length, 3);
      expect(
        filtered.map((v) => v.bpValue).toList(),
        containsAll(['120/80', '119/79', '118/78']),
      );
    });

    test('should preserve vital properties when filtering', () {
      final today = DateTime.now();
      final vitals = [
        VitalModel(
          bpValue: '130/85',
          bglValue: '105',
          heartRate: '75',
          oxygenSatValue: '96',
          bodyTempValue: '37.5',
          weightValue: '72',
          date: today,
        ),
      ];

      final filtered = healthController.getVitalsForDate(vitals);

      expect(filtered.first.bpValue, '130/85');
      expect(filtered.first.bglValue, '105');
      expect(filtered.first.heartRate, '75');
      expect(filtered.first.oxygenSatValue, '96');
      expect(filtered.first.bodyTempValue, '37.5');
      expect(filtered.first.weightValue, '72');
    });

    test('should not filter by time, only by date', () {
      final today = DateTime.now();
      final vitals = [
        VitalModel(
          bpValue: '120/80',
          bglValue: '100',
          heartRate: '72',
          oxygenSatValue: '98',
          bodyTempValue: '37',
          weightValue: '70',
          date: DateTime(today.year, today.month, today.day, 0, 0, 0),
        ),
        VitalModel(
          bpValue: '121/81',
          bglValue: '101',
          heartRate: '73',
          oxygenSatValue: '98.1',
          bodyTempValue: '37.1',
          weightValue: '70',
          date: DateTime(today.year, today.month, today.day, 23, 59, 59),
        ),
      ];

      final filtered = healthController.getVitalsForDate(vitals);

      expect(filtered.length, 2);
    });

    test('should handle vitals from different months', () {
      final today = DateTime.now();
      final lastMonth = today.subtract(Duration(days: 30));

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
          bpValue: '122/82',
          bglValue: '102',
          heartRate: '74',
          oxygenSatValue: '97',
          bodyTempValue: '36.9',
          weightValue: '70',
          date: lastMonth,
        ),
      ];

      final filtered = healthController.getVitalsForDate(vitals);

      expect(filtered.length, 1);
      expect(filtered.first.bpValue, '120/80');
    });

    test('should handle empty vitals list', () {
      final filtered = healthController.getVitalsForDate([]);

      expect(filtered.isEmpty, isTrue);
    });
  });

  group('Vital Value Formats', () {
    test('should handle various vital value formats', () {
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
          bpValue: '122/82',
          bglValue: '105',
          heartRate: '75',
          oxygenSatValue: '97.5',
          bodyTempValue: '36.8',
          weightValue: '71',
          date: today,
        ),
        VitalModel(
          bpValue: '118/78',
          bglValue: '98',
          heartRate: '70',
          oxygenSatValue: '99',
          bodyTempValue: '37.2',
          weightValue: '69',
          date: today,
        ),
      ];

      final filtered = healthController.getVitalsForDate(vitals);

      expect(filtered.length, 3);
      expect(
        filtered.map((v) => v.bpValue).toList(),
        equals(['120/80', '122/82', '118/78']),
      );
    });
  });
}
