import 'package:fake_store_api_app/features/auth/data/datasources/user_dao.dart';
import 'package:fake_store_api_app/features/auth/data/models/user_entity.dart';

class AuthLocalDataSource {
  final UserDao _userDao;

  AuthLocalDataSource(this._userDao);

  Future<UserEntity?> getUserByUsername(String username) async {
    return await _userDao.getUserByUsername(username);
  }

  Future<UserEntity?> getUserById(int id) async {
    return await _userDao.getUserById(id);
  }

  Future<void> insertUser(UserEntity user) async {
    await _userDao.insertUser(user);
  }

  Future<void> updateUser(UserEntity user) async {
    await _userDao.updateUser(user);
  }

  Future<void> deleteUser(UserEntity user) async {
    await _userDao.deleteUser(user);
  }

  Future<void> deleteAllUsers() async {
    await _userDao.deleteAllUsers();
  }
}
