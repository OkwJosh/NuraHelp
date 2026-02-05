import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mockito/mockito.dart';
import 'package:nurahelp/app/data/models/medication_model.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_health_controller.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/widgets/tab_content/medication_tab_content.dart';
import 'package:nurahelp/app/data/services/app_service.dart';

class MockAppService extends Mock implements AppService {}

void main() {
  late PatientController patientController;
  late PatientHealthController healthController;

  setUpAll(() async {
    // Mock dotenv for testing
    dotenv.testLoad(mergeWith: {'NEXT_PUBLIC_API_URL': 'https://api.test.com'});
    // Mock AppService
    Get.put<AppService>(MockAppService());
  });

  setUp(() {
    patientController = PatientController();
    healthController = PatientHealthController();

    tearDown(() {
      // Only remove controllers, keep AppService
      if (Get.isRegistered<PatientController>()) {
        Get.delete<PatientController>();
      }
      if (Get.isRegistered<PatientHealthController>()) {
        Get.delete<PatientHealthController>();
      }
    });

    group('MedicationTabContent Widget', () {
      testWidgets('should display toggle between Ongoing and History', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: MedicationTabContent(patientController: patientController),
            ),
          ),
        );

        expect(find.text('Ongoing'), findsOneWidget);
        expect(find.text('History'), findsOneWidget);
      });

      testWidgets('should display no medications message when list is empty', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: MedicationTabContent(patientController: patientController),
            ),
          ),
        );

        expect(find.text('No medications prescribed yet'), findsOneWidget);
      });
    });

    group('Medication Status Filtering', () {
      test('should correctly filter ongoing medications', () {
        final today = DateTime.now();
        final medications = [
          MedicationModel(
            medName: 'Aspirin',
            description: 'Pain relief',
            observation: 'Take with water',
            startDate: today.subtract(Duration(days: 5)),
            endDate: today.add(Duration(days: 5)),
            noOfCapsules: '2',
            date: today,
          ),
          MedicationModel(
            medName: 'Ibuprofen',
            description: 'Inflammation',
            observation: 'After meals',
            startDate: today.subtract(Duration(days: 10)),
            endDate: today.subtract(Duration(days: 3)),
            noOfCapsules: '1',
            date: today,
          ),
          MedicationModel(
            medName: 'Metformin',
            description: 'Diabetes control',
            observation: 'Daily dose',
            startDate: today.subtract(Duration(days: 30)),
            endDate: today.add(Duration(days: 60)),
            noOfCapsules: '3',
            date: today,
          ),
        ];

        final healthController = PatientHealthController();
        final ongoing = healthController.getMedicationsByStatus(
          medications,
          true,
        );

        expect(ongoing.length, 2); // Aspirin and Metformin should be ongoing
        expect(
          ongoing.map((m) => m.medName).toList(),
          containsAll(['Aspirin', 'Metformin']),
        );
        expect(
          ongoing.map((m) => m.medName).toList(),
          isNot(contains('Ibuprofen')),
        );
      });

      test('should correctly filter history medications', () {
        final today = DateTime.now();
        final medications = [
          MedicationModel(
            medName: 'Aspirin',
            description: 'Pain relief',
            observation: 'Take with water',
            startDate: today.subtract(Duration(days: 5)),
            endDate: today.add(Duration(days: 5)),
            noOfCapsules: '2',
            date: today,
          ),
          MedicationModel(
            medName: 'Ibuprofen',
            description: 'Inflammation',
            observation: 'After meals',
            startDate: today.subtract(Duration(days: 10)),
            endDate: today.subtract(Duration(days: 3)),
            noOfCapsules: '1',
            date: today,
          ),
          MedicationModel(
            medName: 'Penicillin',
            description: 'Antibiotic',
            observation: 'Three times daily',
            startDate: today.subtract(Duration(days: 20)),
            endDate: today.subtract(Duration(days: 15)),
            noOfCapsules: '1',
            date: today,
          ),
        ];

        final healthController = PatientHealthController();
        final history = healthController.getMedicationsByStatus(
          medications,
          false,
        );

        expect(history.length, 2); // Ibuprofen and Penicillin should be history
        expect(
          history.map((m) => m.medName).toList(),
          containsAll(['Ibuprofen', 'Penicillin']),
        );
      });

      test('should handle edge case: medication ending today', () {
        final today = DateTime.now();
        final endDateToday = DateTime(
          today.year,
          today.month,
          today.day,
          23,
          59,
          59,
        );

        final medications = [
          MedicationModel(
            medName: 'EndingToday',
            description: 'Ends today',
            observation: 'Last day',
            startDate: today.subtract(Duration(days: 5)),
            endDate: endDateToday,
            noOfCapsules: '2',
            date: today,
          ),
        ];

        final healthController = PatientHealthController();
        final ongoing = healthController.getMedicationsByStatus(
          medications,
          true,
        );

        // Should be in ongoing since it hasn't fully ended yet
        expect(ongoing.length, 1);
      });

      test('should handle edge case: medication starting today', () {
        final today = DateTime.now();
        final startDateToday = DateTime(
          today.year,
          today.month,
          today.day,
          0,
          0,
          0,
        );

        final medications = [
          MedicationModel(
            medName: 'StartingToday',
            description: 'Starts today',
            observation: 'First day',
            startDate: startDateToday,
            endDate: today.add(Duration(days: 10)),
            noOfCapsules: '2',
            date: today,
          ),
        ];

        final healthController = PatientHealthController();
        final ongoing = healthController.getMedicationsByStatus(
          medications,
          true,
        );

        // Should be in ongoing since it started today
        expect(ongoing.length, 1);
      });

      test('should handle empty medication list', () {
        final healthController = PatientHealthController();
        final ongoing = healthController.getMedicationsByStatus([], true);
        final history = healthController.getMedicationsByStatus([], false);

        expect(ongoing.isEmpty, isTrue);
        expect(history.isEmpty, isTrue);
      });

      test('should not confuse history with future medications', () {
        final today = DateTime.now();
        final medications = [
          MedicationModel(
            medName: 'FutureMed',
            description: 'Future medication',
            observation: 'Not yet prescribed',
            startDate: today.add(Duration(days: 10)),
            endDate: today.add(Duration(days: 20)),
            noOfCapsules: '1',
            date: today,
          ),
        ];

        final healthController = PatientHealthController();
        final history = healthController.getMedicationsByStatus(
          medications,
          false,
        );
        final ongoing = healthController.getMedicationsByStatus(
          medications,
          true,
        );

        expect(history.isEmpty, isTrue); // Should not be in history
        expect(ongoing.isEmpty, isTrue); // Should not be ongoing either
      });
    });
  });
}
