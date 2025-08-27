class DoctorModel {
  final String name;
  final String profilePicture;
  final String specialty;

  DoctorModel({
    required this.name,
    required this.profilePicture,
    required this.specialty,
  });

  static empty() => DoctorModel(name: '', profilePicture: '', specialty: '');

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      name: json['name'],
      specialty: json['specialty'],
      profilePicture: json['profilePicture'],
    );
  }
}
