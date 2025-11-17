import 'package:fake_store_api_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:fake_store_api_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fake_store_api_app/features/auth/domain/entities/user.dart';
import 'package:fake_store_api_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<String?> login(String username, String password) async {
    try {
      // API Call
      final token = await _remoteDataSource.login(username, password);

      if (token != null) {
        // API success → Lấy thông tin user
        final userModel = await _remoteDataSource.getUser(username);

        if (userModel != null) {
          // Lưu vào Local DB
          await _localDataSource.insertUser(userModel.toDbEntity());
        }
      }

      return token;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> getUser(String username) async {
    // Đọc từ Local DB trước
    final localUser = await _localDataSource.getUserByUsername(username);

    if (localUser != null) {
      return User(
        id: localUser.id,
        username: localUser.username,
        password: localUser.password,
      );
    }

    // Nếu không có trong local → Fetch từ API
    try {
      final userModel = await _remoteDataSource.getUser(username);

      if (userModel != null) {
        // Save to Local DB
        await _localDataSource.insertUser(userModel.toDbEntity());
        return userModel.toEntity();
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}
