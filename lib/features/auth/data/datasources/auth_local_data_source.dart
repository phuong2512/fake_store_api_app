import 'package:fake_store_api_app/features/auth/data/datasources/user_dao.dart';
import 'package:fake_store_api_app/features/auth/data/models/user_local_model.dart';

class AuthLocalDataSource {
  final UserDao _userDao;

  AuthLocalDataSource(this._userDao);

  Future<UserLocalModel?> getUserByUsername(String username) async {
    return await _userDao.getUserByUsername(username);
  }

  Future<UserLocalModel?> getUserById(int id) async {
    return await _userDao.getUserById(id);
  }

  Future<void> insertUser(UserLocalModel user) async {
    await _userDao.insertUser(user);
  }

  Future<void> updateUser(UserLocalModel user) async {
    await _userDao.updateUser(user);
  }

  Future<void> deleteUser(UserLocalModel user) async {
    await _userDao.deleteUser(user);
  }

  Future<void> deleteAllUsers() async {
    await _userDao.deleteAllUsers();
  }
}
