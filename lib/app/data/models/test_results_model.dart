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
    required this.date
  });


  static empty() =>
      TestResultModel(testName: '',
          description: '',
          observation: '',
          viewLink: '',
          downloadLink: '',
          date: DateTime.now(),
      );


  factory TestResultModel.fromJson(Map<String, dynamic> json){
    return TestResultModel(
      testName: json['name'],
      description: json['description'],
      observation: json['observation'],
      viewLink: json['viewLink'],
      downloadLink: json['downloadLink'],
      date: DateTime.parse(json['date']),
    );
  }


}