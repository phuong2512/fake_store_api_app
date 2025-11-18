import 'package:fake_store_api_app/features/auth/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}
