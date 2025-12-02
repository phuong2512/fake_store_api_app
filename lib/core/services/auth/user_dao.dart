import 'package:fake_store_api_app/core/models/user.dart';
import 'package:floor/floor.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM users WHERE username = :username')
  Future<UserModel?> getUserByUsername(String username);

  @Query('SELECT * FROM users WHERE id = :id')
  Future<UserModel?> getUserById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUser(UserModel user);

  @update
  Future<void> updateUser(UserModel user);

  @delete
  Future<void> deleteUser(UserModel user);

  @Query('DELETE FROM users')
  Future<void> deleteAllUsers();
}
