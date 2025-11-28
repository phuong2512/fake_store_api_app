import 'package:fake_store_api_app/features/auth/domain/entities/user.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class UserLocalModel {
  @PrimaryKey(autoGenerate: false)
  final int id;
  final String username;
  final String password;

  UserLocalModel({
    required this.id,
    required this.username,
    required this.password,
  });

  User toEntity() {
    return User(id: id, username: username, password: password);
  }

  factory UserLocalModel.fromEntity(User user) {
    return UserLocalModel(
      id: user.id,
      username: user.username,
      password: user.password,
    );
  }
}
