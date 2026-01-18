/// NAVIGATION MIGRATION GUIDE
/// ===========================
/// 
/// This guide shows how to replace old Get.to/Get.off calls with named routes
/// 
/// BENEFITS:
/// - Centralized route management
/// - Type-safe navigation
/// - Easier to refactor
/// - Better for web/deep linking
/// 
/// ===========================
/// BASIC NAVIGATION EXAMPLES
/// ===========================

// ❌ OLD WAY - Direct navigation
// Get.to(() => LoginScreen());

// ✅ NEW WAY - Named route
// Get.toNamed(AppRoutes.login);


// ❌ OLD WAY - Navigate and replace
// Get.off(() => DashboardScreen());

// ✅ NEW WAY - Named route replace
// Get.offNamed(AppRoutes.dashboard);


// ❌ OLD WAY - Clear all and navigate
// Get.offAll(() => NavigationMenu());

// ✅ NEW WAY - Clear all with named route
// Get.offAllNamed(AppRoutes.navigationMenu);


/// ===========================
/// PASSING ARGUMENTS
/// ===========================

// ❌ OLD WAY - Pass constructor parameters
// Get.to(() => DirectMessagePage(doctor: doctorModel));

// ✅ NEW WAY - Pass as arguments
// Get.toNamed(AppRoutes.directMessage, arguments: doctorModel);
//
// In the screen, retrieve with:
// final doctor = Get.arguments as DoctorModel;


// ❌ OLD WAY - Multiple parameters in constructor
// Get.to(() => ConfirmEmailScreen(email: emailText));

// ✅ NEW WAY - Pass arguments
// Get.toNamed(AppRoutes.confirmEmail, arguments: emailText);


/// ===========================
/// COMMON PATTERNS TO REPLACE
/// ===========================

/// PATTERN 1: Navigate to messages
// ❌ Old:
// Get.to(() => MessagesScreen(), transition: Transition.rightToLeft);
//
// ✅ New:
// Get.toNamed(AppRoutes.messages);
// (transition already defined in routes)


/// PATTERN 2: Navigate to direct message with doctor
// ❌ Old:
// Get.to(() => DirectMessagePage(doctor: controller.patient.value.doctor!));
//
// ✅ New:
// Get.toNamed(
//   AppRoutes.directMessage, 
//   arguments: controller.patient.value.doctor,
// );


/// PATTERN 3: Login flow - replace all screens
// ❌ Old:
// Get.offAll(() => NavigationMenu());
//
// ✅ New:
// Get.offAllNamed(AppRoutes.navigationMenu);


/// PATTERN 4: Email verification flow
// ❌ Old:
// Get.to(
//   () => ConfirmEmailScreen(email: email.text.trim()),
//   transition: Transition.rightToLeft,
// );
//
// ✅ New:
// Get.toNamed(AppRoutes.confirmEmail, arguments: email.text.trim());


/// PATTERN 5: Back to previous screen
// ✅ Still use:
// Get.back();
// No change needed!


/// ===========================
/// ADVANCED: PASSING MULTIPLE ARGUMENTS
/// ===========================

// If you need to pass multiple values, use a Map:
// Get.toNamed(
//   AppRoutes.someScreen,
//   arguments: {
//     'doctor': doctorModel,
//     'appointment': appointmentModel,
//     'mode': 'edit',
//   },
// );
//
// Retrieve in screen:
// final args = Get.arguments as Map<String, dynamic>;
// final doctor = args['doctor'] as DoctorModel;
// final appointment = args['appointment'] as AppointmentModel;
// final mode = args['mode'] as String;


/// ===========================
/// FIND & REPLACE GUIDE
/// ===========================
/// Use VS Code Find & Replace (Ctrl+Shift+H) with these patterns:
///
/// 1. Simple navigation to LoginScreen
///    Find:    Get\.to\(\(\) => LoginScreen\(\)\)
///    Replace: Get.toNamed(AppRoutes.login)
///
/// 2. Replace all to NavigationMenu
///    Find:    Get\.offAll\(\(\) => NavigationMenu\(\)\)
///    Replace: Get.offAllNamed(AppRoutes.navigationMenu)
///
/// Note: For screens with arguments, you'll need to manually refactor
