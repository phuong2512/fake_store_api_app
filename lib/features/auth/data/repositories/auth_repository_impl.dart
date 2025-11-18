import 'package:fake_store_api_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:fake_store_api_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fake_store_api_app/features/auth/domain/entities/user.dart';
import 'package:fake_store_api_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  User? _currentUser;
  String? _token;

  @override
  Future<String?> login(String username, String password) async {
    try {
      // API Call
      _token = await _remoteDataSource.login(username, password);

      if (_token != null) {
        // API success → Lấy thông tin user
        final userModel = await _remoteDataSource.getUser(username);

        if (userModel != null) {
          // Lưu vào Local DB
          await _localDataSource.insertUser(userModel.toDbEntity());
          _currentUser = userModel.toEntity();
        }
      }

      return _token;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> getUser() async {
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    _token = null;
  }
}


