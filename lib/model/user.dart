class User {
  String email;
  String password;
  String cliniccode;

  User(
      {required this.email,
      required this.password,
      required this.cliniccode});

  factory User.fromDatabaseJson(Map<String, dynamic> data) => User(
      email: data['email'],
      password: data['password'],
      cliniccode: data['cliniccode'],
  );

  Map<String, dynamic> toDatabaseJson() => {
        "email": this.email,
        "password": this.password,
        "cliniccode": this.cliniccode
      };
}
