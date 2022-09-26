class UserLogin {
  String email;
  String password;
  String cliniccode;

  UserLogin({required this.email,
      required this.password,
      required this.cliniccode});

  Map <String, dynamic> toDatabaseJson() => {
   "email": this.email,
        "password": this.password,
        "cliniccode": this.cliniccode
  };
}

class Token{
  String token;

  Token({required this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token']
    );
  }
}
