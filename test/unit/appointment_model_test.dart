import 'package:flutter_test/flutter_test.dart';
import 'package:nurahelp/app/data/models/appointment_model.dart';

void main() {
  group('AppointmentModel', () {
    test('should create appointment with default status', () {
      final appointment = AppointmentModel(
        id: 'apt-001',
        purpose: 'Checkup',
        appointmentDate: DateTime(2026, 2, 10),
        appointmentStartTime: '10:00 AM',
        appointmentFinishTime: '11:00 AM',
        image: 'image.jpg',
        status: 'Not Canceled',
      );

      expect(appointment.id, 'apt-001');
      expect(appointment.purpose, 'Checkup');
      expect(appointment.status, 'Not Canceled');
    });

    test('should create appointment with custom status', () {
      final appointment = AppointmentModel(
        id: 'apt-002',
        purpose: 'Surgery',
        appointmentDate: DateTime(2026, 2, 15),
        appointmentStartTime: '2:00 PM',
        appointmentFinishTime: '3:30 PM',
        image: 'image.jpg',
        status: 'Canceled',
      );

      expect(appointment.status, 'Canceled');
    });

    test('empty() should create appointment with empty fields', () {
      final emptyApt = AppointmentModel.empty();

      expect(emptyApt.id, '');
      expect(emptyApt.purpose, '');
      expect(emptyApt.appointmentStartTime, '');
      expect(emptyApt.appointmentFinishTime, '');
      expect(emptyApt.image, '');
      expect(emptyApt.status, 'Not Canceled');
    });

    test('fromJson should parse JSON correctly', () {
      final json = {
        'id': 'apt-003',
        'purpose': 'Consultation',
        'date': '2026-02-05T10:00:00.000Z',
        'starttime': '10:00 AM',
        'endtime': '10:30 AM',
        'image': 'doctor.jpg',
        'status': 'Not Canceled',
      };

      final appointment = AppointmentModel.fromJson(json);

      expect(appointment.id, 'apt-003');
      expect(appointment.purpose, 'Consultation');
      expect(appointment.appointmentStartTime, '10:00 AM');
      expect(appointment.appointmentFinishTime, '10:30 AM');
      expect(appointment.image, 'doctor.jpg');
      expect(appointment.status, 'Not Canceled');
    });

    test('fromJson should default status to Not Canceled if missing', () {
      final json = {
        'id': 'apt-004',
        'purpose': 'Checkup',
        'date': '2026-02-05T10:00:00.000Z',
        'starttime': '10:00 AM',
        'endtime': '10:30 AM',
        'image': 'doctor.jpg',
      };

      final appointment = AppointmentModel.fromJson(json);
      expect(appointment.status, 'Not Canceled');
    });

    test('fromJson should parse canceled status correctly', () {
      final json = {
        'id': 'apt-005',
        'purpose': 'Checkup',
        'date': '2026-02-05T10:00:00.000Z',
        'starttime': '10:00 AM',
        'endtime': '10:30 AM',
        'image': 'doctor.jpg',
        'status': 'Canceled',
      };

      final appointment = AppointmentModel.fromJson(json);
      expect(appointment.status, 'Canceled');
    });
  });

  group('AppointmentModel - Date Parsing', () {
    test('should parse appointment date correctly from ISO string', () {
      final json = {
        'id': 'apt-006',
        'purpose': 'Follow-up',
        'date': '2026-02-10T14:30:00.000Z',
        'starttime': '2:30 PM',
        'endtime': '3:00 PM',
        'image': 'doctor.jpg',
      };

      final appointment = AppointmentModel.fromJson(json);
      expect(appointment.appointmentDate.year, 2026);
      expect(appointment.appointmentDate.month, 2);
      expect(appointment.appointmentDate.day, 10);
    });
  });
}
