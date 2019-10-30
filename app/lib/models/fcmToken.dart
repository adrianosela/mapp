class FCM {
  final String token;

  FCM({this.token});

  Map<String, dynamic> toJson() => {
    'fcmToken' : token
  };
}