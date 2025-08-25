class SecurityModel{
  bool twoFactorAuth;

  SecurityModel({required this.twoFactorAuth});


  Map<dynamic,dynamic> toJson(){
    return
        {
          'twoFactorAuth':twoFactorAuth
        };
  }

  static SecurityModel empty()=>
    SecurityModel(twoFactorAuth: false);

  factory SecurityModel.fromJson(json){
    return SecurityModel(
      twoFactorAuth: json['twoFactorAuth']
    );
  }



}