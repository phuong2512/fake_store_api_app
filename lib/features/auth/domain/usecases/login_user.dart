import 'package:fake_store_api_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;
  LoginUser(this.repository);

  Future<String?> call(LoginParams params) async {
    return await repository.login(params.username, params.password);
  }
}

class LoginParams {
  final String username;
  final String password;
  LoginParams({required this.username, required this.password});
}