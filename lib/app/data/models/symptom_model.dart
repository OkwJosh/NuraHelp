class SymptomModel {
  final String symptomName;
  int value;
  final DateTime createdAt;

  SymptomModel({
    required this.symptomName,
    required this.value,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {'name': symptomName, 'value': value};
  }

  factory SymptomModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    print('Raw updatedAt from server: ${json['updatedAt']}');

    try {
      var updatedAtField = json['createdAt'];

      // Check if the field exists and has the expected structure
      if (updatedAtField != null &&
          updatedAtField is Map<String, dynamic> &&
          updatedAtField.containsKey('\$date') &&
          updatedAtField['\$date'] != null &&
          updatedAtField['\$date'] is Map<String, dynamic> &&
          updatedAtField['\$date'].containsKey('\$numberLong') &&
          updatedAtField['\$date']['\$numberLong'] != null) {

        String timestampStr = updatedAtField['\$date']['\$numberLong'].toString();
        int timestamp = int.parse(timestampStr);
        parsedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);

        print('Successfully parsed date: $parsedDate');
      } else {
        throw Exception('Invalid date structure: $updatedAtField');
      }

    } catch (e) {
      parsedDate = DateTime.now();
      print('Error parsing date: $e');
      print('Using current time as fallback: $parsedDate');
    }

    return SymptomModel(
      symptomName: json['name'] ?? '',
      value: json['value'] ?? 0,
      createdAt: parsedDate,
    );
  }
}