

class AppointmentModel {
  final String id;
  final String purpose;
  final String appointmentStartTime;
  final String appointmentFinishTime;
  final DateTime appointmentDate;
  final String image;


  AppointmentModel({
    required this.id,
    required this.purpose,
    required this.appointmentDate,
    required this.appointmentStartTime,
    required this.appointmentFinishTime,
    required this.image
  });


  static empty() {
    return AppointmentModel(
      id: '',
      purpose: '',
      appointmentDate: DateTime.now(),
      appointmentFinishTime: '',
      appointmentStartTime: '',
      image: '',
    );
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json){
    return AppointmentModel(
        id: json['id'],
        purpose: json['purpose'],
        appointmentDate: DateTime.parse(json['date']),
        appointmentStartTime:json['starttime'],
        appointmentFinishTime: json['endtime'],
        image: json['image']
    );
  }


}