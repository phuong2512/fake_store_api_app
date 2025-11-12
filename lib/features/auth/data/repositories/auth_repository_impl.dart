import 'package:fake_store_api_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:fake_store_api_app/features/auth/domain/entities/user.dart';
import 'package:fake_store_api_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<String?> login(String username, String password) async {
    try {
      final token = await _dataSource.login(username, password);
      return token;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> getUser(String username) async {
    try {
      // (Ghi chú: DataSource trả về Model, Model "is-a" Entity, nên hợp lệ)
      final userModel = await _dataSource.getUser(username);
      return userModel?.toEntity();
    } catch (e) {
      return null;
    }
  }
}
