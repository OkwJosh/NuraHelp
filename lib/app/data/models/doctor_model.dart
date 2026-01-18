class DoctorModel {
  final String? id;
  final String name;
  final String profilePicture;
  final String specialty;

  DoctorModel({
    this.id,
    required this.name,
    required this.profilePicture,
    required this.specialty,
  });

  static empty() => DoctorModel(name: '', profilePicture: '', specialty: '');

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      specialty: json['specialty'],
      profilePicture: json['profilePicture'],
    );
  }
}
