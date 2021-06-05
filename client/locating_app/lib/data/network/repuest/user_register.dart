class UserRegister {
  String username;
  String email;
  String password;
  String displayName;
  String phone;

  UserRegister(
      this.username,
      this.email,
      this.password,
      this.displayName,
      this.phone
      );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map["username"] = this.username;
    map["email"] = this.email;
    map["password"] = this.password;
    map["displayName"] = this.displayName;
    map["phone"] = this.phone;
    map["sexId"] = 1;
    map["birthday"] = "2021-05-31T14:36:31.842Z";
    return map;
  }
}
