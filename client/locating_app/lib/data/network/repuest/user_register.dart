class UserRegister {
  String userName;
  String email;
  String password;
  String firstName;
  String lastName;
  String phone;

  UserRegister(
      this.userName,
      this.email,
      this.password,
      this.firstName,
      this.lastName,
      this.phone
      );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map["username"] = this.userName;
    map["email"] = this.email;
    map["password"] = this.password;
    map["first_name"] = this.firstName;
    map["last_name"] = this.lastName;
    map["phone"] = this.phone;
    return map;
  }
}
