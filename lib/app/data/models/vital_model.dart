class VitalModel {
  final String bglValue;
  final String weightValue;
  final String heartRate;
  final String oxygenSatValue;
  final String bodyTempValue;
  final String bpValue;
  final DateTime date;

  VitalModel({
    required this.bglValue,
    required this.weightValue,
    required this.heartRate,
    required this.oxygenSatValue,
    required this.bodyTempValue,
    required this.bpValue,
    required this.date,
  });


  static empty() => VitalModel(
    bglValue: '',
    weightValue: '',
    heartRate: '',
    oxygenSatValue: '',
    bodyTempValue: '',
    bpValue: '',
    date: DateTime.now(),
  );

  factory VitalModel.fromJson(Map<String, dynamic> json) {
    return VitalModel(
      bglValue: json['bgl'],
      weightValue: json['weight'],
      heartRate: json['heartRate'],
      oxygenSatValue: json['oxygen'],
      bodyTempValue: json['bodyTemp'],
      bpValue: json['bp'],
      date: DateTime.parse(json['date']),
    );
  }
}
