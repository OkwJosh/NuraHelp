class SecurityModel{
  final bool twoFactorAuth;

  SecurityModel({required this.twoFactorAuth});


  Map<dynamic,dynamic> toJson(){
    return
        {
          'twoFactorAuth':twoFactorAuth
        };
  }

  factory SecurityModel.fromJson(json){
    return SecurityModel(
      twoFactorAuth: json['twoFactorAuth']
    );
  }



}