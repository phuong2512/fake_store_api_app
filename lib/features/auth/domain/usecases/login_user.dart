import 'package:fake_store_api_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository _repository;

  LoginUser(this._repository);

  Future<String?> call(String username, String password) async {
    return await _repository.login(username, password);
  }
}