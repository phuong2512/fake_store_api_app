import 'package:fake_store_api_app/features/auth/data/models/user_local_model.dart';
import 'package:floor/floor.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM users WHERE username = :username')
  Future<UserLocalModel?> getUserByUsername(String username);

  @Query('SELECT * FROM users WHERE id = :id')
  Future<UserLocalModel?> getUserById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUser(UserLocalModel user);

  @update
  Future<void> updateUser(UserLocalModel user);

  @delete
  Future<void> deleteUser(UserLocalModel user);

  @Query('DELETE FROM users')
  Future<void> deleteAllUsers();
}
