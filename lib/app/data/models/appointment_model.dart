class AppointmentModel {
  final String id;
  final String purpose;
  final String appointmentStartTime;
  final String appointmentFinishTime;
  final DateTime appointmentDate;
  final String image;
  String status; // 'Not Canceled' or 'Canceled'

  AppointmentModel({
    required this.id,
    required this.purpose,
    required this.appointmentDate,
    required this.appointmentStartTime,
    required this.appointmentFinishTime,
    required this.image,
    required this.status,
  });

  static empty() {
    return AppointmentModel(
      id: '',
      purpose: '',
      appointmentDate: DateTime.now(),
      appointmentFinishTime: '',
      appointmentStartTime: '',
      image: '',
      status: '',
    );
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? '';
    final purpose = json['purpose'] ?? '';
    final appointmentDate = json['date'] != null
        ? DateTime.parse(json['date'])
        : DateTime.now();
    final appointmentStartTime = json['starttime'] ?? '';
    final appointmentFinishTime = json['endtime'] ?? '';
    final image = json['image'] ?? '';

    // Handle null or missing status field with fallback
    final status = json['status']?.toString() ?? 'Canceled';

    return AppointmentModel(
      id: id,
      purpose: purpose,
      appointmentDate: appointmentDate,
      appointmentStartTime: appointmentStartTime,
      appointmentFinishTime: appointmentFinishTime,
      image: image,
      status: status,
    );
  }
}
