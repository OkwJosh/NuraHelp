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
  Rx<String>? symptomValue;
  var symptoms = <SymptomModel>[].obs;
  final RxMap<String, Color> symptomColors = <String, Color>{}.obs;
  final appService = Get.find<AppService>();
  var isLoading = false.obs;
  final patientController = Get.find<PatientController>();
  RxMap<String, List<FlSpot>> symptomSpots = <String, List<FlSpot>>{}.obs;
  var chartTrigger = 0.obs;
  final Set<Color> usedColors = {};
  var isMonthlyView =
      false.obs; // false = daily (7 days), true = monthly (30 days)

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchSymptoms();
  }

  List<SymptomModel> get uniqueSymptoms {
    Map<String, SymptomModel> latestSymptoms = {};

    for (var symptom in symptoms) {
      if (!latestSymptoms.containsKey(symptom.symptomName) ||
          symptom.createdAt.isAfter(
            latestSymptoms[symptom.symptomName]!.createdAt,
          )) {
        latestSymptoms[symptom.symptomName] = symptom;
      }
    }

    return latestSymptoms.values.toList();
  }

  Future<void> fetchSymptoms() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken();
      print('This is my token $token');
      isLoading.value = true;

      // Fetch symptoms with color data
      final fetchedSymptoms = await appService.getPatientSymptoms(
        user,
        patientController.patient.value,
      );

      // Debug: Print fetched symptoms with dates
      print('===== FETCHED SYMPTOMS FROM DB =====');
      for (var symptom in fetchedSymptoms) {
        print(
          'Symptom: ${symptom.symptomName}, Value: ${symptom.value}, Date: ${symptom.createdAt}',
        );
      }
      print('===================================');

      // Restore colors from database
      symptomColors.clear();
      usedColors.clear();

      // Process unique symptom names to avoid color conflicts
      Map<String, String?> uniqueSymptomColors = {};

      for (var symptom in fetchedSymptoms) {
        // Store the first valid color found for each symptom name
        if (!uniqueSymptomColors.containsKey(symptom.symptomName)) {
          uniqueSymptomColors[symptom.symptomName] = symptom.color;
        }
      }

      // Now assign colors based on unique symptom names
      for (var entry in uniqueSymptomColors.entries) {
        final symptomName = entry.key;
        final colorString = entry.value;

        // If symptom has a color stored, restore it
        if (colorString != null && colorString.isNotEmpty) {
          try {
            // Parse hex color string (e.g., "ffff0000" for red)
            final colorValue = int.parse(colorString, radix: 16);
            final color = Color(colorValue);
            symptomColors[symptomName] = color;
            usedColors.add(color);
          } catch (e) {
            print('Error parsing color for $symptomName: $e');
            // If color parsing fails, assign a new color
            assignColorForSymptom(symptomName);
          }
        } else {
          // No color stored, assign a new one
          assignColorForSymptom(symptomName);
        }
      }

      symptoms.value = fetchedSymptoms;
      symptoms.refresh();
      generateSpots(symptoms);
    } catch (e) {
      AppToasts.errorSnackBar(
        title: 'Failed to fetch symptoms: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void addSymptom() {
    if (!symptomKey.currentState!.validate()) {
      return;
    }

    final symptomName = symptomText.text.trim();

    // Assign color if not already assigned
    assignColorForSymptom(symptomName);

    final newSymptom = SymptomModel(
      symptomName: symptomName,
      value: 0,
      createdAt: DateTime.now(),
      color: getSymptomColor(symptomName).value.toRadixString(16),
    );

    symptoms.add(newSymptom);
    symptomText.clear();
    Navigator.pop(Get.context!);

    generateSpots(symptoms);
  }

  void logSymptoms() async {
    try {
      AppScreenLoader.openLoadingDialog('Logging Symptoms');
      final user = FirebaseAuth.instance.currentUser;

      // Prepare symptoms with colors for API
      List<Map<String, dynamic>> symptomsToSend = [];

      for (int i = 0; i < symptoms.length; i++) {
        // Ensure color is assigned
        final symptomName = symptoms[i].symptomName;
        assignColorForSymptom(symptomName);

        symptomsToSend.add({
          'name': symptomName,
          'value': symptoms[i].value,
          'color': getSymptomColor(
            symptomName,
          ).value.toRadixString(16), // Save as hex
        });

        print('Logging symptom: $symptomName with value ${symptoms[i].value}');
      }

      // Send to API with color data
      await appService.savePatientSymptomsWithColors(symptomsToSend, user);

      // Refresh symptoms from server to get updated data
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
    symptomSpots.clear();

    final now = DateTime.now();
    final daysToShow = isMonthlyView.value ? 30 : 7;
    final startDate = now.subtract(Duration(days: daysToShow));

    print('===== GENERATE SPOTS DEBUG =====');
    print('Current date: $now');
    print('Start date (${daysToShow}d ago): $startDate');
    print('Total histories count: ${histories.length}');

    // Filter histories based on view mode
    final recentHistories = histories.where((history) {
      return history.createdAt.isAfter(startDate);
    }).toList();

    print('Filtered histories count: ${recentHistories.length}');
    for (var h in recentHistories) {
      print('  - ${h.symptomName}: ${h.value} on ${h.createdAt}');
    }

    // Group by symptom name and date (normalized to day)
    Map<String, Map<String, List<int>>> groupedData = {};

    for (var history in recentHistories) {
      // Normalize date to remove time component
      final dateKey = DateTime(
        history.createdAt.year,
        history.createdAt.month,
        history.createdAt.day,
      ).toIso8601String();

      groupedData.putIfAbsent(history.symptomName, () => {});
      groupedData[history.symptomName]!.putIfAbsent(dateKey, () => []);
      groupedData[history.symptomName]![dateKey]!.add(history.value);
    }

    print('Grouped data by symptom:');
    groupedData.forEach((symptom, dates) {
      print('  $symptom: ${dates.length} days');
    });
    print('================================');

    // Ensure colors are assigned
    for (String symptomName in groupedData.keys) {
      assignColorForSymptom(symptomName);
    }

    // Create chart spots with proper sorting
    groupedData.forEach((symptomName, dateData) {
      symptomSpots.putIfAbsent(symptomName, () => []);

      // Sort dates to ensure proper line drawing
      final sortedDates = dateData.keys.toList()..sort();

      for (var dateKey in sortedDates) {
        final date = DateTime.parse(dateKey);
        final values = dateData[dateKey]!;
        final averageValue = values.reduce((a, b) => a + b) / values.length;

        // Calculate x position based on view mode
        final xPos = isMonthlyView.value
            ? xAxisValueMonthly(date, DateTime.now())
            : xAxisValue(date.weekday);
        final yPos = yAxisValue(averageValue.round());

        symptomSpots[symptomName]!.add(FlSpot(xPos, yPos));
      }
    });

    // Force update
    symptomSpots.refresh();
  }

  Color assignColorForSymptom(String symptom) {
    if (!symptomColors.containsKey(symptom)) {
      Color color = colorPalette.firstWhere(
        (c) => !usedColors.contains(c),
        orElse: () => Colors.grey,
      );

      symptomColors[symptom] = color;
      usedColors.add(color);
    }
    return symptomColors[symptom]!;
  }

  Color getSymptomColor(String symptom) {
    return symptomColors[symptom] ?? Colors.grey;
  }

  double xAxisValue(int day) {
    switch (day) {
      case 1:
        return 0.5;
      case 2:
        return 2.5;
      case 3:
        return 4.5;
      case 4:
        return 6.5;
      case 5:
        return 8.5;
      case 6:
        return 10.5;
      case 7:
        return 12.5;
      default:
        return 0.0;
    }
  }

  // For monthly view: distribute dates across 30 days
  double xAxisValueMonthly(DateTime date, DateTime endDate) {
    final daysAgo = endDate.difference(date).inDays;
    // Map 30 days to x range 0-13
    return 13.0 - (daysAgo * 13.0 / 30.0);
  }

  void toggleViewMode() {
    isMonthlyView.value = !isMonthlyView.value;
    generateSpots(symptoms);
    chartTrigger.value++;
  }

  double yAxisValue(int value) {
    switch (value) {
      case 0:
        return 0.0;
      case 1:
        return 1.6;
      case 2:
        return 3.2;
      case 3:
        return 4.8;
      case 4:
        return 6.4;
      case 5:
        return 8.0;
      case 6:
        return 9.6;
      case 7:
        return 11.2;
      case 8:
        return 12.8;
      case 9:
        return 14.4;
      case 10:
        return 16.0;
      default:
        return 0.0;
    }
  }

  final colorPalette = [
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
