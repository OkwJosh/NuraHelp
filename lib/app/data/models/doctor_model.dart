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
      id: json['_id']?.toString() ?? json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      specialty: json['specialty']?.toString() ?? '',
      profilePicture: json['profilePicture']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'specialty': specialty,
      'profilePicture': profilePicture,
    };
  }
}
