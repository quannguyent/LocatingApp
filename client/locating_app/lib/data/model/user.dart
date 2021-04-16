import 'package:meta/meta.dart';

class User {
  final String username;
  final String password;

  User(this.username, this.password);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map["username"] = this.username;
    map["password"] = this.password;
    return map;
  }

  @override
  String toString() => 'User { name: $username, email: $password}';
}