import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/services/app_service.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/utilities/loaders/loaders.dart';
import '../../../../data/models/symptom_model.dart';
import '../../../../utilities/popups/screen_loader.dart';

class SymptomInsightController extends GetxController {
  static SymptomInsightController get instance => Get.find();

  final TextEditingController symptomText = TextEditingController();
  final GlobalKey<FormState> symptomKey = GlobalKey<FormState>();

  final symptoms = <SymptomModel>[].obs;
  final symptomColors = <String, Color>{}.obs;
  final symptomSpots = <String, List<FlSpot>>{}.obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final isMonthlyView = false.obs;
  final chartTrigger = 0.obs;
  final _cachedUniqueSymptoms = <SymptomModel>[].obs;
  final _appService = Get.find<AppService>();
  final _patientController = Get.find<PatientController>();
  final Set<Color> _usedColors = {};

  // FIXED: Rolling 7-day window for daily view
  DateTime get chartStartDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (isMonthlyView.value) {
      return today.subtract(Duration(days: 29));
    } else {
      // Last 7 days including today (today - 6 days)
      return today.subtract(Duration(days: 6));
    }
  }

  DateTime get chartEndDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  // FIXED: Get weekday label based on chronological position
  // dayIndex 0 = oldest day, dayIndex 6 = today
  String getWeekdayLabel(int dayIndex) {
    if (dayIndex < 0 || dayIndex > 6) return '';

    final date = chartStartDate.add(Duration(days: dayIndex));
    const weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    // Convert DateTime.weekday (1=Mon, 7=Sun) to array index (0=Sun, 6=Sat)
    final adjustedWeekday = date.weekday % 7;
    return weekdays[adjustedWeekday];
  }

  String getWeekLabel(int weekIndex) {
    return 'W${weekIndex + 1}';
  }

  int get numberOfWeeks => 5;

  List<SymptomModel> get uniqueSymptoms => _cachedUniqueSymptoms;

  @override
  void onInit() {
    super.onInit();
  }

  void _updateCachedUniqueSymptoms() {
    final Map<String, SymptomModel> latestSymptoms = {};

    for (var symptom in symptoms) {
      if (!latestSymptoms.containsKey(symptom.symptomName) ||
          symptom.createdAt.isAfter(
            latestSymptoms[symptom.symptomName]!.createdAt,
          )) {
        latestSymptoms[symptom.symptomName] = symptom;
      }
    }

    _cachedUniqueSymptoms.assignAll(latestSymptoms.values.toList());
  }

  Future<void> fetchSymptoms() async {
    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;

      final fetchedSymptoms = await _appService.getPatientSymptoms(
        user,
        _patientController.patient.value,
      );

      // FIXED: Preserve existing color assignments to prevent color changes
      final Map<String, Color> existingColors = Map.from(symptomColors);

      symptomColors.clear();

      Map<String, String?> uniqueSymptomColors = {};

      for (var symptom in fetchedSymptoms) {
        if (!uniqueSymptomColors.containsKey(symptom.symptomName)) {
          uniqueSymptomColors[symptom.symptomName] = symptom.color;
        }
      }

      for (var entry in uniqueSymptomColors.entries) {
        final symptomName = entry.key;
        final colorString = entry.value;

        // Check if we already have a color assignment
        if (existingColors.containsKey(symptomName)) {
          symptomColors[symptomName] = existingColors[symptomName]!;
          _usedColors.add(existingColors[symptomName]!);
        } else if (colorString != null && colorString.isNotEmpty) {
          try {
            final colorValue = int.parse(colorString, radix: 16);
            final color = Color(colorValue);
            symptomColors[symptomName] = color;
            _usedColors.add(color);
          } catch (e) {
            assignColorForSymptom(symptomName);
          }
        } else {
          assignColorForSymptom(symptomName);
        }
      }

      symptoms.assignAll(fetchedSymptoms);
      _updateCachedUniqueSymptoms();
      generateSpots(symptoms);
      chartTrigger.value++;
    } catch (e) {
      AppToasts.errorSnackBar(
        title: 'Failed to fetch symptoms: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void addSymptom() {
    final formState = symptomKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final symptomName = symptomText.text.trim();
    if (symptomName.isEmpty) return;

    assignColorForSymptom(symptomName);

    final newSymptom = SymptomModel(
      symptomName: symptomName,
      value: 0,
      createdAt: DateTime.now(),
      color: getSymptomColor(symptomName).value.toRadixString(16),
    );

    symptoms.add(newSymptom);
    _updateCachedUniqueSymptoms();
    symptomText.clear();

    final context = Get.context;
    if (context != null) {
      Navigator.pop(context);
    }

    generateSpots(symptoms);
    chartTrigger.value++;
  }

  Future<void> logSymptoms() async {
    try {
      AppScreenLoader.openLoadingDialog('Logging Symptoms');
      final user = FirebaseAuth.instance.currentUser;

      final List<Map<String, dynamic>> symptomsToSend = [];

      for (final symptom in symptoms) {
        assignColorForSymptom(symptom.symptomName);

        symptomsToSend.add({
          'name': symptom.symptomName,
          'value': symptom.value,
          'color': getSymptomColor(symptom.symptomName).value.toRadixString(16),
        });
      }

      await _appService.savePatientSymptomsWithColors(symptomsToSend, user);
      await fetchSymptoms();

      AppScreenLoader.stopLoading();
      AppToasts.successSnackBar(title: 'Symptoms logged successfully!');
    } catch (e) {
      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(
        title: 'Failed to save symptoms: ${e.toString()}',
      );
    }
  }

  void generateSpots(List<SymptomModel> histories) {
    final newSpots = <String, List<FlSpot>>{};

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime startDate;
    DateTime endDate;

    if (isMonthlyView.value) {
      startDate = today.subtract(const Duration(days: 29));
      endDate = today;
    } else {
      // FIXED: Rolling 7-day window
      startDate = today.subtract(const Duration(days: 6));
      endDate = today;
    }

    final recentHistories = histories.where((history) {
      final historyDate = DateTime(
        history.createdAt.year,
        history.createdAt.month,
        history.createdAt.day,
      );
      return !historyDate.isBefore(startDate) && !historyDate.isAfter(endDate);
    }).toList();

    final Map<String, Map<String, List<int>>> groupedData = {};

    for (var history in recentHistories) {
      final dateKey = DateTime(
        history.createdAt.year,
        history.createdAt.month,
        history.createdAt.day,
      ).toIso8601String();

      groupedData.putIfAbsent(history.symptomName, () => {});
      groupedData[history.symptomName]!.putIfAbsent(dateKey, () => []);
      groupedData[history.symptomName]![dateKey]!.add(history.value);
    }

    for (String symptomName in groupedData.keys) {
      assignColorForSymptom(symptomName);
    }

    groupedData.forEach((symptomName, dateData) {
      newSpots.putIfAbsent(symptomName, () => []);

      final sortedDates = dateData.keys.toList()..sort();

      for (var dateKey in sortedDates) {
        final date = DateTime.parse(dateKey);
        final values = dateData[dateKey]!;
        final averageValue = values.reduce((a, b) => a + b) / values.length;

        final xPos = isMonthlyView.value
            ? xAxisValueMonthly(date, startDate)
            : xAxisValueDaily(date, startDate);
        final yPos = yAxisValue(averageValue.round());

        newSpots[symptomName]!.add(FlSpot(xPos, yPos));
      }
    });

    symptomSpots.assignAll(newSpots);
  }

  Color assignColorForSymptom(String symptom) {
    if (!symptomColors.containsKey(symptom)) {
      final color = _colorPalette.firstWhere(
        (c) => !_usedColors.contains(c),
        orElse: () => Colors.grey,
      );

      symptomColors[symptom] = color;
      _usedColors.add(color);
    }
    return symptomColors[symptom]!;
  }

  Color getSymptomColor(String symptom) {
    return symptomColors[symptom] ?? Colors.grey;
  }

  // FIXED: Calculate x position based on chronological days from start date
  // This ensures the graph displays left-to-right chronologically
  double xAxisValueDaily(DateTime date, DateTime startDate) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final normalizedStart = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final daysSinceStart = normalizedDate.difference(normalizedStart).inDays;

    // Ensure we're within the 7-day range (0-6)
    if (daysSinceStart < 0 || daysSinceStart > 6) {
      return 0.5; // Default to first position if out of range
    }

    // Map days 0-6 to x positions 0.5, 2.5, 4.5, 6.5, 8.5, 10.5, 12.5
    // Day 0 (7 days ago) -> 0.5, Day 6 (today) -> 12.5
    return (daysSinceStart * 2) + 0.5;
  }

  double xAxisValueMonthly(DateTime date, DateTime startDate) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final normalizedStart = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final daysSinceStart = normalizedDate.difference(normalizedStart).inDays;
    final weekIndex = daysSinceStart ~/ 7;
    final dayInWeek = daysSinceStart % 7;
    return (weekIndex * 3) + (dayInWeek * 0.4);
  }

  void toggleViewMode() {
    isMonthlyView.value = !isMonthlyView.value;
    generateSpots(symptoms);
    chartTrigger.value++;
  }

  double yAxisValue(int value) {
    if (value < 0 || value > 10) return 0.0;
    return value * 1.6;
  }

  void updateSymptomValue(String symptomName, int value) {
    for (var symptom in symptoms) {
      if (symptom.symptomName == symptomName) {
        symptom.value = value;
      }
    }
    symptoms.refresh();
    _updateCachedUniqueSymptoms();
    generateSpots(symptoms);
  }


  Future<void> refreshSymptomData() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

     

    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    symptomText.dispose();
    super.onClose();
  }

  static const _colorPalette = [
    Color(0xFF1F77B4), // Blue
    Color(0xFFFF7F0E), // Orange
    Color(0xFF2CA02C), // Green
    Color(0xFFD62728), // Red
    Color(0xFF9467BD), // Purple
    Color(0xFF8C564B), // Brown
    Color(0xFFE377C2), // Pink
    Color(0xFF7F7F7F), // Gray
    Color(0xFFBCBD22), // Olive
    Color(0xFF17BECF), // Cyan
    Color(0xFF003F5C), // Dark Blue
    Color(0xFF58508D), // Indigo
    Color(0xFFBC5090), // Magenta
    Color(0xFFFF6361), // Coral Red
    Color(0xFFFFA600), // Gold
    Color(0xFF264653), // Deep Teal
    Color(0xFF2A9D8F), // Teal Green
    Color(0xFFE9C46A), // Mustard
    Color(0xFFF4A261), // Soft Orange
    Color(0xFFE76F51), // Burnt Orange
    Color(0xFF0B3954), // Navy
    Color(0xFF087E8B), // Cool Cyan
    Color(0xFFBFD7EA), // Light Blue
    Color(0xFFFF5A5F), // Soft Red
    Color(0xFF8FC93A), // Lime Green
    Color(0xFF6A4C93), // Deep Violet
    Color(0xFF1982C4), // Bright Blue
    Color(0xFF8AC926), // Fresh Green
    Color(0xFFFFCA3A), // Yellow
    Color(0xFFFF595E), // Salmon
    Color(0xFF343A40), // Charcoal
    Color(0xFF495057), // Dark Gray
    Color(0xFFADB5BD), // Light Gray
    Color(0xFFF8F9FA), // Almost White
    Color(0xFF4D908E), // Muted Teal
    Color(0xFF577590), // Slate Blue
    Color(0xFF43AA8B), // Soft Green
    Color(0xFFF8961E), // Orange Yellow
    Color(0xFFF3722C), // Warm Orange
  ];
}
