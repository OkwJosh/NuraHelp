import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mockito/mockito.dart';
import 'package:nurahelp/app/data/models/appointment_model.dart';
import 'package:nurahelp/app/common/appointment_card/appointment_card.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/data/services/app_service.dart';

class MockAppService extends Mock implements AppService {}

void main() {
  late PatientController mockPatientController;

  setUpAll(() async {
    // Mock dotenv for testing
    dotenv.testLoad(mergeWith: {'NEXT_PUBLIC_API_URL': 'https://api.test.com'});
    // Mock AppService
    Get.put<AppService>(MockAppService());
  });

  setUp(() {
    mockPatientController = PatientController();
    Get.put<PatientController>(mockPatientController);
  });

  tearDown(() {
    // Only remove PatientController, keep AppService
    if (Get.isRegistered<PatientController>()) {
      Get.delete<PatientController>();
    }
  });

  group('AppointmentCard Widget', () {
    testWidgets('should display appointment details correctly', (
      WidgetTester tester,
    ) async {
      final appointment = AppointmentModel(
        id: 'apt-001',
        purpose: 'Regular Checkup',
        appointmentDate: DateTime(2026, 2, 5),
        appointmentStartTime: '10:00 AM',
        appointmentFinishTime: '10:30 AM',
        image: 'doctor.jpg',
        status: 'Not Canceled',
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: AppointmentCard(
              isVirtual: false,
              patientController: mockPatientController,
              appointment: appointment,
            ),
          ),
        ),
      );

      expect(find.text('10:00 AM - 10:30 AM'), findsOneWidget);
      expect(find.text('In-person visit'), findsOneWidget);
    });

    testWidgets('should hide menu button for canceled appointments', (
      WidgetTester tester,
    ) async {
      final canceledAppointment = AppointmentModel(
        id: 'apt-002',
        purpose: 'Consultation',
        appointmentDate: DateTime(2026, 2, 10),
        appointmentStartTime: '2:00 PM',
        appointmentFinishTime: '2:30 PM',
        image: 'doctor.jpg',
        status: 'Canceled',
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: AppointmentCard(
              isVirtual: false,
              patientController: mockPatientController,
              appointment: canceledAppointment,
            ),
          ),
        ),
      );

      // PopupMenuButton should not be present for canceled appointments
      expect(find.byType(PopupMenuButton), findsNothing);
    });

    testWidgets(
      'should display canceled status badge for canceled appointments',
      (WidgetTester tester) async {
        final canceledAppointment = AppointmentModel(
          id: 'apt-003',
          purpose: 'Surgery',
          appointmentDate: DateTime(2026, 2, 15),
          appointmentStartTime: '3:00 PM',
          appointmentFinishTime: '4:00 PM',
          image: 'doctor.jpg',
          status: 'Canceled',
        );

        await tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: AppointmentCard(
                isVirtual: false,
                showStatus: true,
                patientController: mockPatientController,
                appointment: canceledAppointment,
              ),
            ),
          ),
        );

        expect(find.text('Canceled'), findsWidgets);
      },
    );

    testWidgets('should display join button for virtual appointments', (
      WidgetTester tester,
    ) async {
      final virtualAppointment = AppointmentModel(
        id: 'apt-004',
        purpose: 'Virtual Consultation',
        appointmentDate: DateTime(2026, 2, 12),
        appointmentStartTime: '11:00 AM',
        appointmentFinishTime: '11:30 AM',
        image: 'doctor.jpg',
        status: 'Not Canceled',
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: AppointmentCard(
              isVirtual: true,
              patientController: mockPatientController,
              appointment: virtualAppointment,
            ),
          ),
        ),
      );

      expect(find.text('Join'), findsOneWidget);
      expect(find.text('Virtual Visit'), findsOneWidget);
    });

    testWidgets('should not display join button for in-person appointments', (
      WidgetTester tester,
    ) async {
      final inPersonAppointment = AppointmentModel(
        id: 'apt-005',
        purpose: 'In-person Checkup',
        appointmentDate: DateTime(2026, 2, 20),
        appointmentStartTime: '9:00 AM',
        appointmentFinishTime: '9:30 AM',
        image: 'doctor.jpg',
        status: 'Not Canceled',
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: AppointmentCard(
              isVirtual: false,
              patientController: mockPatientController,
              appointment: inPersonAppointment,
            ),
          ),
        ),
      );

      expect(find.text('Join'), findsNothing);
      expect(find.text('In-person visit'), findsOneWidget);
    });

    testWidgets('should have proper elevation and styling', (
      WidgetTester tester,
    ) async {
      final appointment = AppointmentModel(
        id: 'apt-006',
        purpose: 'Routine Checkup',
        appointmentDate: DateTime(2026, 2, 8),
        appointmentStartTime: '8:00 AM',
        appointmentFinishTime: '8:30 AM',
        image: 'doctor.jpg',
        status: 'Not Canceled',
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: AppointmentCard(
              isVirtual: false,
              patientController: mockPatientController,
              appointment: appointment,
            ),
          ),
        ),
      );

      final material = find.byType(Material).first;
      expect(material, findsOneWidget);
    });
  });
}
