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


  static empty() =>
      MedicationModel(medName: '',
          description: '',
          observation: '',
          noOfCapsules: '',
          startDate:DateTime.now(),
          endDate: DateTime.now(),
          date: DateTime.now(),
      );


  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(medName: json['name'],
      description: json['description'],
      observation: json['observation'],
      noOfCapsules: json['capsules'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      date: DateTime.parse(json['date']),
    );
  }
}
