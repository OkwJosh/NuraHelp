import 'dart:core';

class MedicationModel {
  final String medName;
  final String description;
  final String observation;
  final String noOfCapsules;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime date;

  MedicationModel({
    required this.medName,
    required this.description,
    required this.observation,
    required this.noOfCapsules,
    required this.startDate,
    required this.endDate,
    required this.date,
  });

  static empty() => MedicationModel(
    medName: '',
    description: '',
    observation: '',
    noOfCapsules: '',
    startDate: DateTime.now(),
    endDate: DateTime.now(),
    date: DateTime.now(),
  );

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    final duration = json['duration'] as String? ?? '';
    final parsedDates = _parseDuration(duration);

    final parsedMed = MedicationModel(
      medName: json['name'] ?? '',
      description: json['description'] ?? '',
      observation: json['observation'] ?? '',
      noOfCapsules: json['capsules'] ?? '',
      startDate:
          parsedDates['start'] ?? _parseDate('startDate', json['startDate']),
      endDate: parsedDates['end'] ?? _parseDate('endDate', json['endDate']),
      date: _parseDate('date', json['date']),
    );
    return parsedMed;
  }

  static Map<String, DateTime?> _parseDuration(String duration) {
    if (duration.isEmpty) {
      return {'start': null, 'end': null};
    }

    try {
      // Format: "01 Feb - 16 Feb 2026"
      final parts = duration.split(' - ');
      if (parts.length != 2) {

        return {'start': null, 'end': null};
      }

      final startPart = parts[0].trim(); // "01 Feb"
      final endPart = parts[1].trim(); // "16 Feb 2026"

      // Extract year from endPart (last 4 chars)
      final yearMatch = RegExp(r'\d{4}').firstMatch(endPart);
      if (yearMatch == null) {
        return {'start': null, 'end': null};
      }
      final year = yearMatch.group(0)!;

      // Append year to startPart if not present
      final startWithYear = startPart.contains(year)
          ? startPart
          : '$startPart $year';

      final startDate = DateTime.parse(_convertToIso(startWithYear));

      final endDate = DateTime.parse(_convertToIso(endPart));
      return {'start': startDate, 'end': endDate};
    } catch (e) {
      return {'start': null, 'end': null};
    }
  }

  static String _convertToIso(String dateStr) {
    // Convert "01 Feb 2026" to "2026-02-01"
    const months = {
      'Jan': '01',
      'Feb': '02',
      'Mar': '03',
      'Apr': '04',
      'May': '05',
      'Jun': '06',
      'Jul': '07',
      'Aug': '08',
      'Sep': '09',
      'Oct': '10',
      'Nov': '11',
      'Dec': '12',
    };

    final parts = dateStr.trim().split(RegExp(r'\s+'));
    if (parts.length < 3)
      throw FormatException('Invalid date format: $dateStr');

    final day = parts[0];
    final month = months[parts[1]] ?? parts[1];
    final year = parts[2];

    return '$year-$month-$day';
  }

  static DateTime _parseDate(String fieldName, dynamic dateValue) {
    
    try {
      if (dateValue == null) {
        return DateTime.now();
      }
      if (dateValue is DateTime) {
        return dateValue;
      }
      if (dateValue is String) {
        final parsed = DateTime.parse(dateValue);
        return parsed;
      }
      return DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }
}
