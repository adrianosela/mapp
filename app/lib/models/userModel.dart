class User {

  final String name;
  final String email;
  final String password;
  String userId;

  User({this.name, this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    User user = new User(
      name: json['name'],
      email: json['email'],
      password: json['password']
    );
    user.userId = json['_id'];
    return user;
  }

  Map<String, dynamic> toJson() => {
    'name' : name,
    'email' : email,
    'password' : password
  };
}