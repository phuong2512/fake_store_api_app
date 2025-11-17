import 'package:fake_store_api_app/features/auth/data/models/user_entity.dart';
import 'package:fake_store_api_app/features/auth/domain/entities/user.dart';

class UserModel {
  final int id;
  final String username;
  final String password;

  UserModel({required this.id, required this.username, required this.password});

  User toEntity() {
    return User(id: id, username: username, password: password);
  }

  UserEntity toDbEntity() {
    return UserEntity(id: id, username: username, password: password);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    username: json["username"],
    password: json["password"],
  );

  factory UserModel.fromDbEntity(UserEntity entity) => UserModel(
    id: entity.id,
    username: entity.username,
    password: entity.password,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "password": password,
  };
}
