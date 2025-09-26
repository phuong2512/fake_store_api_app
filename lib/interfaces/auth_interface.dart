import 'package:fake_store_api_app/models/user.dart';

abstract class AuthInterface {
  Future<String?> login(String username, String password);
  Future<User?> getUser(String username);
}