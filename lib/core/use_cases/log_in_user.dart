import 'package:fake_store_api_app/core/repositories/auth/auth_repository.dart';

class LogInUser {
  final AuthRepository _repository;

  LogInUser(this._repository);

  Future<String?> call(String username, String password) async {
    return await _repository.login(username, password);
  }
}
