import 'package:fake_store_api_app/presentations/auth/auth_interface.dart';
import 'package:fake_store_api_app/data/models/user.dart';

class AuthRepository {
  final AuthInterface _authService;

  AuthRepository(this._authService);

  Future<String?> login(String username, String password) async {
    return await _authService.login(username, password);
  }

  Future<User?> getUser(String username) async {
    return await _authService.getUser(username);
  }
}