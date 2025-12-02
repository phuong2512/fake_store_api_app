import 'package:fake_store_api_app/core/repositories/auth/auth_repository.dart';

class LogOutUser {
  final AuthRepository repository;

  LogOutUser(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}
