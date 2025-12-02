import 'package:fake_store_api_app/core/models/user.dart';
import 'package:fake_store_api_app/core/services/auth/auth_api_service.dart';
import 'package:fake_store_api_app/core/services/auth/auth_database_service.dart';

abstract class AuthRepository {
  Future<String?> login(String username, String password);

  Future<void> logout();

  Future<UserModel?> getUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _remoteDataSource;
  final AuthDatabaseService _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  UserModel? _currentUser;
  String? _token;

  @override
  Future<String?> login(String username, String password) async {
    try {
      _token = await _remoteDataSource.login(username, password);

      if (_token != null) {
        final userModel = await _remoteDataSource.getUser(username);

        if (userModel != null) {
          await _localDataSource.insertUser(userModel);
          _currentUser = userModel;
        }
      }

      return _token;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel?> getUser() async {
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    _token = null;
    await _localDataSource.deleteAllUsers();
  }
}
