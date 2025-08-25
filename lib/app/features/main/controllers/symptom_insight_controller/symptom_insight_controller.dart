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
  final RxMap<String, Color> symptomColors = <String,Color>{}.obs;
  final appService = Get.find<AppService>();
  var isLoading = false.obs;
  final patientController = Get.find<PatientController>();
  RxMap<String, List<FlSpot>> symptomSpots = <String, List<FlSpot>>{}.obs;
  var chartTrigger = 0.obs;




  @override
  Future<void> onInit() async {
    super.onInit();
    fetchSymptoms();

  }


  List<SymptomModel> get uniqueSymptoms {
    Map<String, SymptomModel> latestSymptoms = {};

    for (var symptom in symptoms) {
      if (!latestSymptoms.containsKey(symptom.symptomName) ||
          symptom.createdAt.isAfter(latestSymptoms[symptom.symptomName]!.createdAt)) {
        latestSymptoms[symptom.symptomName] = symptom;
      }
    }

    return latestSymptoms.values.toList();
  }

  Future<void> fetchSymptoms() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final token  = await user?.getIdToken();
      print('This is my token $token');
      isLoading.value = true;
      final fetchedSymptoms = await appService.getPatientSymptoms(user,patientController.patient.value);
      symptoms.value = fetchedSymptoms;
      symptoms.refresh();
      generateSpots(symptoms);
    } catch (e) {
      AppToasts.errorSnackBar(title: 'Failed to fetch symptoms: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // List<FlSpot> get symptomSpots {
  //   return symptoms.asMap().entries.map((entry) {
  //     SymptomModel symptom = entry.value;
  //     return FlSpot(xAxisValue(), yAxisValue(symptom.value));
  //   }).toList();
  // }

  void addSymptom() {
    if (!symptomKey.currentState!.validate()) {
      return;
    }
    final newSymptom = SymptomModel(
      symptomName: symptomText.text.trim(),
      value: 0,
      createdAt: DateTime.now(),
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

      // Update timestamps for all symptoms being logged
      for(int i = 0; i < symptoms.length; i++){
        // If this is a new symptom without server timestamp, update it
        if (symptoms[i].createdAt.difference(DateTime.now()).inMinutes.abs() < 1) {
          symptoms[i] = SymptomModel(
            symptomName: symptoms[i].symptomName,
            value: symptoms[i].value,
            createdAt: DateTime.now(),
          );
        }
        print('This are the symptoms ${symptoms[i].value}');
      }

      await appService.savePatientSymptoms(symptoms, user);
      generateSpots(symptoms);
      AppScreenLoader.stopLoading();
      AppToasts.successSnackBar(title: 'Symptoms logged successfully!');
    } catch (e) {
      AppScreenLoader.stopLoading();
      AppToasts.errorSnackBar(title: 'Failed to save symptoms: ${e.toString()}');
    }
  }





  void generateSpots(List<SymptomModel> histories) {
    symptomSpots.clear();

    final now = DateTime.now();
    final oneWeekAgo = now.subtract(Duration(days: 7));

    final recentHistories = histories.where((history) {
      return history.createdAt.isAfter(oneWeekAgo);
    }).toList();

    Map<String, Map<int, List<int>>> groupedData = {};

    for (var history in recentHistories) {
      final day = history.createdAt.weekday;

      groupedData.putIfAbsent(history.symptomName, () => {});
      groupedData[history.symptomName]!.putIfAbsent(day, () => []);
      groupedData[history.symptomName]![day]!.add(history.value);
    }

    // PRE-ASSIGN COLORS BEFORE BUILDING CHART DATA
    for (String symptomName in groupedData.keys) {
      assignColorForSymptom(symptomName); // Do this here, not during build
    }

    // Create chart spots
    groupedData.forEach((symptomName, dayData) {
      symptomSpots.putIfAbsent(symptomName, () => []);

      dayData.forEach((day, values) {
        final averageValue = values.reduce((a, b) => a + b) / values.length;
        final xPos = xAxisValue(day);
        final yPos = yAxisValue(averageValue.round());

        symptomSpots[symptomName]!.add(FlSpot(xPos, yPos));
      });
    });

    // Force update
    symptomSpots.refresh();
  }

// Also modify the color assignment method to be safer:
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

// Add a getter for safe color access during build:
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






  final Set<Color> usedColors = {};

  // Color assignColorForSymptom(String symptom) {
  //   if (!symptomColors.containsKey(symptom)) {
  //
  //     Color color = colorPalette.firstWhere(
  //           (c) => !usedColors.contains(c),
  //       orElse: () => Colors.grey,
  //     );
  //
  //     symptomColors[symptom] = color;
  //     usedColors.add(color);
  //   }
  //   return symptomColors[symptom]!;
  // }

    final colorPalette = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.teal,
      Colors.lightGreen,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
      Colors.black,
      Colors.pinkAccent,
      Colors.purpleAccent,
      Colors.deepPurpleAccent,
      Colors.indigoAccent,
      Colors.blueAccent,
      Colors.cyanAccent,
    ];

}
