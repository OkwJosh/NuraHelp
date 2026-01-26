import 'package:get/get.dart';
import 'package:nurahelp/app/bindings/network_bindings.dart';
import 'package:nurahelp/app/features/auth/screens/forget_password/email_sent.dart';
import 'package:nurahelp/app/features/auth/screens/forget_password/forget_password.dart';
import 'package:nurahelp/app/features/auth/screens/login/login.dart';
import 'package:nurahelp/app/features/auth/screens/sign_up/confirm_email.dart';
import 'package:nurahelp/app/features/auth/screens/sign_up/onboarding.dart';
import 'package:nurahelp/app/features/auth/screens/sign_up/sign_up.dart';
import 'package:nurahelp/app/features/main/screens/appointments/appointments.dart';
import 'package:nurahelp/app/features/main/screens/dashboard/dashboard.dart';
import 'package:nurahelp/app/features/main/screens/doctors/about_doctor.dart';
import 'package:nurahelp/app/features/main/screens/doctors/doctors.dart';
import 'package:nurahelp/app/features/main/screens/messages_and_calls/call.dart';
import 'package:nurahelp/app/features/main/screens/messages_and_calls/direct_message.dart';
import 'package:nurahelp/app/features/main/screens/messages_and_calls/messages.dart';
import 'package:nurahelp/app/features/main/screens/notification/notification.dart';
import 'package:nurahelp/app/features/main/screens/nura_bot/nura_bot.dart';
import 'package:nurahelp/app/features/main/screens/patient_health/patient_health.dart';
import 'package:nurahelp/app/features/main/screens/settings/edit_personal_information.dart';
import 'package:nurahelp/app/features/main/screens/settings/settings.dart';
import 'package:nurahelp/app/features/main/screens/symptom_insights/symptom_insights.dart';
import 'package:nurahelp/app/nav_menu.dart';
import 'package:nurahelp/app/splash_screen.dart';
import 'package:nurahelp/app/routes/app_routes.dart';

/// Centralized route configuration for the entire app
class AppPages {
  static final List<GetPage> pages = [
    // ==================== AUTH ROUTES ====================
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: NetworkBindings(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignUpScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.confirmEmail,
      page: () {
        final email = Get.arguments as String? ?? '';
        return ConfirmEmailScreen(email: email);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.forgetPassword,
      page: () => const ForgetPasswordScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.emailSent,
      page: () {
        final email = Get.arguments as String? ?? '';
        return EmailSentScreen(email: email);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => FirstTimeOnBoardingScreen(),
      transition: Transition.rightToLeft,
    ),

    // ==================== MAIN ROUTES ====================
    GetPage(
      name: AppRoutes.navigationMenu,
      page: () => NavigationMenu(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.nuraBot,
      page: () => NuraBot(),
      transition: Transition.rightToLeft,
    ),

    // ==================== MESSAGES & CALLS ====================
    GetPage(
      name: AppRoutes.messages,
      page: () => const MessagesScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.directMessage,
      page: () {
        final doctor = Get.arguments;
        return DirectMessagePage(doctor: doctor);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.call,
      page: () => const CallScreen(),
      transition: Transition.rightToLeft,
    ),

    // ==================== HEALTH & MEDICAL ====================
    GetPage(
      name: AppRoutes.patientHealth,
      page: () => PatientHealthScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.symptomInsights,
      page: () => const SymptomInsightsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.appointments,
      page: () => AppointmentsScreen(),
      transition: Transition.rightToLeft,
    ),

    // ==================== DOCTORS ====================
    GetPage(
      name: AppRoutes.doctors,
      page: () => const DoctorsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.aboutDoctor,
      page: () {
        return AboutDoctorScreen();
      },
      transition: Transition.rightToLeft,
    ),

    // ==================== SETTINGS & PROFILE ====================
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.editPersonalInformation,
      page: () => const EditPersonalInformation(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => const NotificationScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
