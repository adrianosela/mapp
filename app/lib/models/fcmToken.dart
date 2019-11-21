class FCM {
  static String token;
  static String userToken;

  Map<String, dynamic> toJson() => {
    'fcmToken' : token
  };

  static setFcmToken(str) {
    token = str;
  }

  static getFcmToken() {
    return token;
  }

  static setToken(str) {
    userToken = str;
  }

  static String getToken() {
    return userToken;
  }
}