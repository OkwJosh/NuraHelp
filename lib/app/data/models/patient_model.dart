class PatientModel {
  final String id;
  String fullName;
  String email;
  String phoneNumber;
  int age;
  String? profilePicture;

  PatientModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.age,
    required this.profilePicture,
  });

  List<String> get nameParts => fullName.split("");

  String get firstName => nameParts[0];

  String get lastName => nameParts[1];

  static PatientModel empty() => PatientModel(
    id: '',
    fullName: '',
    email: '',
    phoneNumber: '',
    age: 0,
    profilePicture: '',
  );

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'fullName':fullName,
      'email':email,
      'phoneNumber':phoneNumber,
      'age':age,
      'profilePicture':profilePicture,
    };
  }


}
