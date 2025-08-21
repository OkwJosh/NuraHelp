class PatientModel {
  String? id;
  String name;
  String email;
  String phone;
  int? age;
  String? profilePicture;
  final String? inviteCode;
  DateTime? birthInfo;

  PatientModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.age,
    this.profilePicture,
    this.inviteCode,
    this.birthInfo
  });

  List<String>? get nameParts => name.split(' ');

  String? get firstName => nameParts?[0];

  String? get lastName => nameParts?[1];



  static PatientModel empty() =>
      PatientModel(
        id: '',
        name: '',
        email: '',
        phone: '',
        age: 0,
        profilePicture: '',
        inviteCode: '',

      );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'profilePicture': profilePicture,
      'inviteCode': inviteCode,
    };
  }

  factory PatientModel.fromJson(Map<String, dynamic> json){
    return PatientModel(
        id: json['_id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        age: json['age'],
        profilePicture: json['profilePicture'],
    );
  }


}
