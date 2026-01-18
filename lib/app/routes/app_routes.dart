/// All app route names as constants
/// Use these instead of hardcoded strings to prevent typos
class AppRoutes {
  // Auth Routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String confirmEmail = '/confirm-email';
  static const String forgetPassword = '/forget-password';
  static const String emailSent = '/email-sent';
  static const String onboarding = '/onboarding';

  // Main Routes
  static const String navigationMenu = '/navigation-menu';
  static const String dashboard = '/dashboard';

  // Messages & Calls
  static const String messages = '/messages';
  static const String directMessage = '/direct-message';
  static const String call = '/call';

  // Health & Medical
  static const String patientHealth = '/patient-health';
  static const String symptomInsights = '/symptom-insights';
  static const String appointments = '/appointments';

  // Doctors
  static const String doctors = '/doctors';
  static const String aboutDoctor = '/about-doctor';

  // Settings & Profile
  static const String settings = '/settings';
  static const String notification = '/notification';
}
