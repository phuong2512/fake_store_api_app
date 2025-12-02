import 'package:fake_store_api_app/core/models/user.dart';
import 'package:fake_store_api_app/core/repositories/auth/auth_repository.dart';

class GetUser {
  final AuthRepository repository;

  GetUser(this.repository);

  Future<UserModel?> call() async {
    return await repository.getUser();
  }
}
