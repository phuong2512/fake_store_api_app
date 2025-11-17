import 'package:fake_store_api_app/features/auth/data/models/user_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM users WHERE username = :username')
  Future<UserEntity?> getUserByUsername(String username);

  @Query('SELECT * FROM users WHERE id = :id')
  Future<UserEntity?> getUserById(int id);

  @insert
  Future<void> insertUser(UserEntity user);

  @update
  Future<void> updateUser(UserEntity user);

  @delete
  Future<void> deleteUser(UserEntity user);

  @Query('DELETE FROM users')
  Future<void> deleteAllUsers();
}