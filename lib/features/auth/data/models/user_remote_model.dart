import 'package:fake_store_api_app/features/auth/data/models/user_local_model.dart';
import 'package:fake_store_api_app/features/auth/domain/entities/user.dart';

class UserRemoteModel {
  final int id;
  final String username;
  final String password;

  UserRemoteModel({
    required this.id,
    required this.username,
    required this.password,
  });

  factory UserRemoteModel.fromJson(Map<String, dynamic> json) {
    return UserRemoteModel(
      id: json["id"],
      username: json["username"],
      password: json["password"],
    );
  }

  User toEntity() {
    return User(id: id, username: username, password: password);
  }

  UserLocalModel toLocalModel() {
    return UserLocalModel(id: id, username: username, password: password);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "username": username, "password": password};
  }
}
