class User {

  final String firstName;
  final String lastName;
  final String email;
  final String password;

  User({this.firstName, this.lastName, this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();

    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['password'] = password;

    return map;
  }
}