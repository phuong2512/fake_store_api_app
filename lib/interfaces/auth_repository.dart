import 'package:fake_store_api_app/models/user.dart';

abstract class AuthRepository {
  Future<String?> login(String username, String password);
  Future<User?> getUser(String username);
}