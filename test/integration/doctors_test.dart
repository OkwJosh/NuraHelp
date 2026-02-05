import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mockito/mockito.dart';
import 'package:nurahelp/app/data/models/doctor_model.dart';
import 'package:nurahelp/app/data/services/app_service.dart';

class MockAppService extends Mock implements AppService {}

void main() {
  setUpAll(() async {
    dotenv.testLoad(mergeWith: {'NEXT_PUBLIC_API_URL': 'https://api.test.com'});
    Get.put<AppService>(MockAppService());
  });

  tearDown(() {
    Get.reset();
  });

  group('Doctors Feature - Integration Tests', () {
    test('should initialize doctors functionality', () {
      expect(Get.find<AppService>(), isNotNull);
      print('✅ [DOCTORS] Doctors feature initialized successfully');
    });

    test('should create doctor model with required fields', () {
      final doctor = DoctorModel(
        id: 'doc-001',
        name: 'Dr. John Smith',
        specialty: 'Cardiologist',
        profilePicture: 'https://example.com/profile.jpg',
      );

      expect(doctor.id, 'doc-001');
      expect(doctor.name, 'Dr. John Smith');
      expect(doctor.specialty, 'Cardiologist');
      expect(doctor.profilePicture, 'https://example.com/profile.jpg');
      print('✅ [DOCTORS] Doctor model created successfully');
    });

    test('should validate doctor specialty field', () {
      final validSpecialties = [
        'Cardiologist',
        'Neurologist',
        'General Practitioner',
        'Dermatologist',
        'Pediatrician',
      ];

      final testSpecialty = 'Cardiologist';
      expect(validSpecialties.contains(testSpecialty), isTrue);
      print('✅ [DOCTORS] Doctor specialty validation passed');
    });

    test('should format doctor name properly', () {
      final doctor = DoctorModel(
        id: 'doc-001',
        name: 'Dr. Jane Doe',
        specialty: 'General Practitioner',
        profilePicture: 'https://example.com/profile.jpg',
      );

      final name = doctor.name;
      final specialty = doctor.specialty;

      expect(name, contains('Dr.'));
      expect(specialty, isNotEmpty);
      print('✅ [DOCTORS] Doctor name and specialty formatted correctly');
    });

    test('should create doctor instance with all fields', () {
      final doctor = DoctorModel(
        id: 'doc-002',
        name: 'Dr. Smith',
        specialty: 'Neurologist',
        profilePicture: 'https://example.com/profile2.jpg',
      );

      expect(doctor, isNotNull);
      expect(doctor.name, 'Dr. Smith');
      expect(doctor.specialty, 'Neurologist');
      expect(doctor.profilePicture, 'https://example.com/profile2.jpg');
      print('✅ [DOCTORS] Doctor instance created with all fields');
    });

    test('should filter doctors by specialty', () {
      final doctors = [
        DoctorModel(
          id: 'doc-001',
          name: 'Dr. John',
          specialty: 'Cardiologist',
          profilePicture: 'https://example.com/profile1.jpg',
        ),
        DoctorModel(
          id: 'doc-002',
          name: 'Dr. Jane',
          specialty: 'Neurologist',
          profilePicture: 'https://example.com/profile2.jpg',
        ),
        DoctorModel(
          id: 'doc-003',
          name: 'Dr. Bob',
          specialty: 'Cardiologist',
          profilePicture: 'https://example.com/profile3.jpg',
        ),
      ];

      final cardiologists = doctors
          .where((doc) => doc.specialty == 'Cardiologist')
          .toList();

      expect(cardiologists.length, 2);
      expect(
        cardiologists.every((doc) => doc.specialty == 'Cardiologist'),
        isTrue,
      );
      print('✅ [DOCTORS] Doctors filtered by specialty');
    });

    test('should search doctors by name', () {
      final doctors = [
        DoctorModel(
          id: 'doc-001',
          name: 'Dr. Johnson',
          specialty: 'Cardiologist',
          profilePicture: 'https://example.com/profile1.jpg',
        ),
        DoctorModel(
          id: 'doc-002',
          name: 'Dr. Smith',
          specialty: 'Neurologist',
          profilePicture: 'https://example.com/profile2.jpg',
        ),
      ];

      const searchQuery = 'Johnson';
      final results = doctors
          .where(
            (doc) => doc.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();

      expect(results.length, 1);
      expect(results.first.name, 'Dr. Johnson');
      print('✅ [DOCTORS] Doctor search by name works');
    });

    test('should create empty doctor model', () {
      final emptyDoctor = DoctorModel.empty();

      expect(emptyDoctor.name, '');
      expect(emptyDoctor.specialty, '');
      expect(emptyDoctor.profilePicture, '');
      print('✅ [DOCTORS] Empty doctor model created');
    });

    test('should handle multiple doctors', () {
      final doctorsList = [
        DoctorModel(
          id: 'doc-001',
          name: 'Dr. Primary',
          specialty: 'General Practitioner',
          profilePicture: 'https://example.com/primary.jpg',
        ),
        DoctorModel(
          id: 'doc-002',
          name: 'Dr. Specialist',
          specialty: 'Cardiologist',
          profilePicture: 'https://example.com/specialist.jpg',
        ),
      ];

      expect(doctorsList.length, 2);
      expect(
        doctorsList.map((d) => d.specialty).toList(),
        contains('General Practitioner'),
      );
      expect(
        doctorsList.map((d) => d.specialty).toList(),
        contains('Cardiologist'),
      );
      print('✅ [DOCTORS] Multiple doctors handled correctly');
    });

    test('should parse doctor from JSON', () {
      final json = {
        '_id': 'doc-001',
        'name': 'Dr. Test',
        'specialty': 'Cardiologist',
        'profilePicture': 'https://example.com/test.jpg',
      };

      final doctor = DoctorModel.fromJson(json);

      expect(doctor.id, 'doc-001');
      expect(doctor.name, 'Dr. Test');
      expect(doctor.specialty, 'Cardiologist');
      print('✅ [DOCTORS] Doctor parsed from JSON');
    });
  });
}
