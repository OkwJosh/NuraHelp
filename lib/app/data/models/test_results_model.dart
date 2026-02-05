class TestResultModel {
  final String testName;
  final String description;
  final String observation;
  final String viewLink;
  final String downloadLink;
  final DateTime date;

  TestResultModel({
    required this.testName,
    required this.description,
    required this.observation,
    required this.viewLink,
    required this.downloadLink,
    required this.date,
  });

  static empty() => TestResultModel(
    testName: '',
    description: '',
    observation: '',
    viewLink: '',
    downloadLink: '',
    date: DateTime.now(),
  );

  factory TestResultModel.fromJson(Map<String, dynamic> json) {
    DateTime _parseDate(dynamic dateValue) {
      try {
        if (dateValue == null) return DateTime.now();
        if (dateValue is DateTime) return dateValue;
        if (dateValue is String) return DateTime.parse(dateValue);
        return DateTime.now();
      } catch (e) {
        return DateTime.now();
      }
    }

    final testName = json['name'] ?? '';
    final description = json['description'] ?? '';
    final observation = json['observation'] ?? '';
    final viewLink = json['viewLink'] ?? '';
    final downloadLink = json['downloadLink'] ?? '';

    return TestResultModel(
      testName: testName,
      description: description,
      observation: observation,
      viewLink: viewLink,
      downloadLink: downloadLink,
      date: _parseDate(json['date']),
    );
  }
}
