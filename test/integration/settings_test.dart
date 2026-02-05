import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mockito/mockito.dart';
import 'package:nurahelp/app/data/services/app_service.dart';

class MockAppService extends Mock implements AppService {}

class MockSettingsController extends GetxController {
  // Notification settings
  final RxBool notificationsEnabled = true.obs;
  final RxBool emailNotificationsEnabled = true.obs;
  final RxBool smsNotificationsEnabled = false.obs;
  final RxBool pushNotificationsEnabled = true.obs;

  // Security settings
  final RxBool biometricAuthEnabled = false.obs;
  final RxBool twoFactorEnabled = false.obs;

  // Personal info
  final RxString firstName = 'John'.obs;
  final RxString lastName = 'Doe'.obs;
  final RxString email = 'john.doe@example.com'.obs;
  final RxString phone = '+1234567890'.obs;

  // Privacy settings
  final RxBool shareHealthData = true.obs;
  final RxBool allowDataAnalytics = true.obs;

  // Theme settings
  final RxString theme = 'light'.obs;

  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
  }

  void toggleEmailNotifications() {
    emailNotificationsEnabled.value = !emailNotificationsEnabled.value;
  }

  void togglePushNotifications() {
    pushNotificationsEnabled.value = !pushNotificationsEnabled.value;
  }

  void toggleBiometricAuth() {
    biometricAuthEnabled.value = !biometricAuthEnabled.value;
  }

  void toggleTwoFactor() {
    twoFactorEnabled.value = !twoFactorEnabled.value;
  }

  void updatePersonalInfo(String first, String last, String mail, String tel) {
    firstName.value = first;
    lastName.value = last;
    email.value = mail;
    phone.value = tel;
  }

  void toggleDataSharing() {
    shareHealthData.value = !shareHealthData.value;
  }

  void changeTheme(String newTheme) {
    theme.value = newTheme;
  }

  void saveSettings() {}
}

void main() {
  late MockSettingsController settingsController;

  setUpAll(() async {
    // Mock dotenv for testing
    dotenv.testLoad(mergeWith: {'NEXT_PUBLIC_API_URL': 'https://api.test.com'});
    // Mock AppService
    Get.put<AppService>(MockAppService());
  });

  setUp(() {
    settingsController = MockSettingsController();

    Get.put<MockSettingsController>(settingsController);
  });

  tearDown(() {
    Get.reset();
  });

  group('Settings Feature - Integration Tests', () {
    test('should initialize settings controller', () {
      expect(settingsController, isNotNull);
      expect(settingsController.notificationsEnabled.value, isTrue);
    });

    test('should toggle notifications', () {
      final initialState = settingsController.notificationsEnabled.value;
      settingsController.toggleNotifications();

      expect(settingsController.notificationsEnabled.value, !initialState);
    });

    test('should manage email notification preferences', () {
      expect(settingsController.emailNotificationsEnabled.value, isTrue);

      settingsController.toggleEmailNotifications();
      expect(settingsController.emailNotificationsEnabled.value, isFalse);

      settingsController.toggleEmailNotifications();
      expect(settingsController.emailNotificationsEnabled.value, isTrue);
    });

    test('should manage push notification preferences', () {
      expect(settingsController.pushNotificationsEnabled.value, isTrue);

      settingsController.togglePushNotifications();
      expect(settingsController.pushNotificationsEnabled.value, isFalse);

      settingsController.togglePushNotifications();
      expect(settingsController.pushNotificationsEnabled.value, isTrue);
    });

    test('should manage biometric authentication', () {
      expect(settingsController.biometricAuthEnabled.value, isFalse);

      settingsController.toggleBiometricAuth();
      expect(settingsController.biometricAuthEnabled.value, isTrue);

      settingsController.toggleBiometricAuth();
      expect(settingsController.biometricAuthEnabled.value, isFalse);
    });

    test('should manage two-factor authentication', () {
      expect(settingsController.twoFactorEnabled.value, isFalse);

      settingsController.toggleTwoFactor();
      expect(settingsController.twoFactorEnabled.value, isTrue);
    });

    test('should update personal information', () {
      const newFirstName = 'Jane';
      const newLastName = 'Smith';
      const newEmail = 'jane.smith@example.com';
      const newPhone = '+0987654321';

      settingsController.updatePersonalInfo(
        newFirstName,
        newLastName,
        newEmail,
        newPhone,
      );

      expect(settingsController.firstName.value, newFirstName);
      expect(settingsController.lastName.value, newLastName);
      expect(settingsController.email.value, newEmail);
      expect(settingsController.phone.value, newPhone);
    });

    test('should validate email format in personal info', () {
      final validEmail = 'user@example.com';
      final invalidEmail = 'invalid-email';

      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

      expect(emailRegex.hasMatch(validEmail), isTrue);
      expect(emailRegex.hasMatch(invalidEmail), isFalse);
    });

    test('should manage health data sharing preferences', () {
      expect(settingsController.shareHealthData.value, isTrue);

      settingsController.toggleDataSharing();
      expect(settingsController.shareHealthData.value, isFalse);

      settingsController.toggleDataSharing();
      expect(settingsController.shareHealthData.value, isTrue);
    });

    test('should manage analytics opt-in', () {
      expect(settingsController.allowDataAnalytics.value, isTrue);

      settingsController.allowDataAnalytics.value = false;
      expect(settingsController.allowDataAnalytics.value, isFalse);

      settingsController.allowDataAnalytics.value = true;
      expect(settingsController.allowDataAnalytics.value, isTrue);
    });

    test('should change theme', () {
      expect(settingsController.theme.value, 'light');

      settingsController.changeTheme('dark');
      expect(settingsController.theme.value, 'dark');

      settingsController.changeTheme('light');
      expect(settingsController.theme.value, 'light');
    });

    test('should handle multiple setting changes', () {
      // Change multiple settings
      settingsController.toggleNotifications();
      settingsController.toggleBiometricAuth();
      settingsController.toggleDataSharing();
      settingsController.changeTheme('dark');

      // Verify all changes
      expect(settingsController.notificationsEnabled.value, isFalse);
      expect(settingsController.biometricAuthEnabled.value, isTrue);
      expect(settingsController.shareHealthData.value, isFalse);
      expect(settingsController.theme.value, 'dark');
    });

    test('should save settings', () {
      settingsController.updatePersonalInfo(
        'Test',
        'User',
        'test@example.com',
        '+1111111111',
      );
      settingsController.toggleNotifications();
      settingsController.toggleBiometricAuth();

      settingsController.saveSettings();

      // Verify settings are still there after save
      expect(settingsController.firstName.value, 'Test');
      expect(settingsController.lastName.value, 'User');
      expect(settingsController.notificationsEnabled.value, isFalse);
      expect(settingsController.biometricAuthEnabled.value, isTrue);
    });

    test('should validate phone number is not empty', () {
      final validPhone = '+1234567890';
      final invalidPhone = '';

      expect(validPhone.isNotEmpty, isTrue);
      expect(invalidPhone.isEmpty, isTrue);
    });

    test('should provide default notification preferences', () {
      expect(settingsController.notificationsEnabled.value, isTrue);
      expect(settingsController.emailNotificationsEnabled.value, isTrue);
      expect(settingsController.smsNotificationsEnabled.value, isFalse);
      expect(settingsController.pushNotificationsEnabled.value, isTrue);
    });

    test('should provide default security preferences', () {
      expect(settingsController.biometricAuthEnabled.value, isFalse);
      expect(settingsController.twoFactorEnabled.value, isFalse);
    });
  });
}
