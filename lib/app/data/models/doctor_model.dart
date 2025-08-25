class DoctorModel {
  final String name;
  final String profilePicture;

  DoctorModel({required this.name, required this.profilePicture});

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      name: json['name'],
      profilePicture: json['profilePicture'],
    );
  }
}
