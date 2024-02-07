class FirebaseModel {
  String email;
  String password;
  String userName;
  String uid;

  FirebaseModel(
      {required this.email,
      required this.password,
      required this.userName,
      required this.uid});

  Map<String, dynamic> convert2Map() {
    return {
      'UserName': userName,
      'Email': email,
      'Password': password,
      'uid': uid,
    };
  }
}
