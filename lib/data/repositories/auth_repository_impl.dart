import 'package:fake_store_api_app/data/models/user.dart';
import 'package:fake_store_api_app/data/services/auth_service.dart';
import 'package:fake_store_api_app/data/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<String?> login(String username, String password) async {
    try {
      final token = await _authService.login(username, password);
      return token;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> getUser(String username) async {
    try {
      final user = await _authService.getUser(username);
      return user;
    } catch (e) {
      return null;
    }
  }
}
