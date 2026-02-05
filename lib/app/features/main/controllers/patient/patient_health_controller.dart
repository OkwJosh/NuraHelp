import 'package:get/get.dart';

class PatientHealthController extends GetxController {
  /// Date selection for filtering clinical data
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  /// Format date to display format: "02 Feb 2026"
  String formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Check if two dates are the same day (ignoring time)
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Filter vitals by selected date
  List getVitalsForDate(List vitals) {
    return vitals.where((vital) {
      return isSameDay(vital.date, selectedDate.value);
    }).toList();
  }

  /// Filter test results by selected date
  List getTestResultsForDate(List testResults) {
    return testResults.where((result) {
      return isSameDay(result.date, selectedDate.value);
    }).toList();
  }

  /// Filter medications by selected date
  /// Checks if selectedDate falls within medication start and end date range
  List getMedicationsForDate(List medications) {
    return medications.where((med) {
      final isAfterStart = selectedDate.value.isAfter(
        med.startDate.subtract(const Duration(days: 1)),
      );
      final isBeforeEnd = selectedDate.value.isBefore(
        med.endDate.add(const Duration(days: 1)),
      );
      return isAfterStart && isBeforeEnd;
    }).toList();
  }

  /// Filter medications by status (Ongoing or History)
  /// Ongoing: medications where today falls within startDate and endDate
  /// History: medications where today is after endDate (medication period ended)
  List getMedicationsByStatus(List medications, bool isOngoing) {
    final now = DateTime.now();

    if (isOngoing) {
      // Ongoing: today is between startDate and endDate (inclusive)
      return medications.where((med) {
        final isAfterStart = now.isAfter(
          med.startDate.subtract(const Duration(days: 1)),
        );
        final isBeforeEnd = now.isBefore(
          med.endDate.add(const Duration(days: 1)),
        );
        return isAfterStart && isBeforeEnd;
      }).toList();
    } else {
      // History: today is after endDate (medication period has ended)
      return medications.where((med) {
        return now.isAfter(med.endDate);
      }).toList();
    }
  }

  /// Set selected date to today
  void setToday() {
    selectedDate.value = DateTime.now();
  }

  /// Navigate to previous day
  void previousDay() {
    selectedDate.value = selectedDate.value.subtract(const Duration(days: 1));
    print('📅 Previous day - New date: ${formatDate(selectedDate.value)}');
  }

  /// Navigate to next day
  void nextDay() {
    selectedDate.value = selectedDate.value.add(const Duration(days: 1));
    print('📅 Next day - New date: ${formatDate(selectedDate.value)}');
  }
}
