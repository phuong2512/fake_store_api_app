import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class UserModel {
  @PrimaryKey(autoGenerate: false)
  final int id;
  final String username;
  final String password;

  const UserModel({
    required this.id,
    required this.username,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      username: json["username"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "username": username, "password": password};
  }

  UserModel copyWith({int? id, String? username, String? password}) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
