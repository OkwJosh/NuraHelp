class SymptomModel {
  final String symptomName;
  int value;
  final DateTime createdAt;
  final String? color;

  SymptomModel({
    required this.symptomName,
    required this.value,
    DateTime? createdAt,
    this.color,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    final json = {'name': symptomName, 'value': value};
    if (color != null) {
      json['color'] = color as Object;
    }
    return json;
  }

  factory SymptomModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;

    try {
      // First try parsing 'date' field (ISO string from app_service)
      if (json['date'] != null && json['date'] is String) {
        parsedDate = DateTime.parse(json['date']);
      }
      // Then try parsing MongoDB date structure
      else if (json['createdAt'] != null) {
        var createdAtField = json['createdAt'];

        if (createdAtField is Map<String, dynamic> &&
            createdAtField.containsKey('\$date') &&
            createdAtField['\$date'] != null) {
          var dateValue = createdAtField['\$date'];

          // Handle $numberLong structure
          if (dateValue is Map<String, dynamic> &&
              dateValue.containsKey('\$numberLong')) {
            String timestampStr = dateValue['\$numberLong'].toString();
            int timestamp = int.parse(timestampStr);
            parsedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
          }
          // Handle direct timestamp value
          else if (dateValue is num) {
            parsedDate = DateTime.fromMillisecondsSinceEpoch(dateValue.toInt());
          } else {
            throw Exception('Invalid date value: $dateValue');
          }
        } else {
          throw Exception('Invalid createdAt structure: $createdAtField');
        }
      } else {
        throw Exception('No date field found');
      }
    } catch (e) {
      parsedDate = DateTime.now();
    }

    return SymptomModel(
      symptomName: json['name'] ?? '',
      value: json['value'] ?? 0,
      createdAt: parsedDate,
      color: json['color'] as String?,
    );
  }
}
