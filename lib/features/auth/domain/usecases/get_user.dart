import 'package:fake_store_api_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fake_store_api_app/features/auth/domain/entities/user.dart';
class GetUser {
  final AuthRepository repository;
  GetUser(this.repository);

  Future<User?> call(String username) async {
    return await repository.getUser(username);
  }
}