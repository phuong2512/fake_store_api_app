import 'package:fake_store_api_app/core/models/user.dart';
import 'package:fake_store_api_app/core/services/auth/user_dao.dart';

abstract class AuthDatabaseService {
  Future<UserModel?> getUserByUsername(String username);

  Future<UserModel?> getUserById(int id);

  Future<void> insertUser(UserModel user);

  Future<void> updateUser(UserModel user);

  Future<void> deleteUser(UserModel user);

  Future<void> deleteAllUsers();
}

class AuthDatabaseServiceImpl implements AuthDatabaseService {
  final UserDao _userDao;

  AuthDatabaseServiceImpl({required UserDao userDao}) : _userDao = userDao;

  @override
  Future<UserModel?> getUserByUsername(String username) async {
    return await _userDao.getUserByUsername(username);
  }

  @override
  Future<UserModel?> getUserById(int id) async {
    return await _userDao.getUserById(id);
  }

  @override
  Future<void> insertUser(UserModel user) async {
    await _userDao.insertUser(user);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _userDao.updateUser(user);
  }

  @override
  Future<void> deleteUser(UserModel user) async {
    await _userDao.deleteUser(user);
  }

  @override
  Future<void> deleteAllUsers() async {
    await _userDao.deleteAllUsers();
  }
}
