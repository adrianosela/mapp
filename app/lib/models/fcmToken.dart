class FCM {
  String token;
  static String userToken;

  FCM({this.token});

  Map<String, dynamic> toJson() => {
    'fcmToken' : token
  };

  static setToken(str) {
    userToken = str;
  }

  static String getToken() {
    return userToken;
  }
}