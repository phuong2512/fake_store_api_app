import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class UserEntity {
  @PrimaryKey(autoGenerate: false)
  final int id;
  final String username;
  final String password;

  UserEntity({
    required this.id,
    required this.username,
    required this.password,
  });
}
