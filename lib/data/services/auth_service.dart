import 'package:dio/dio.dart';
import 'package:fake_store_api_app/data/models/user.dart';

class AuthService {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://fakestoreapi.com',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {"username": username, "password": password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data['token'];
        return token;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<User?> getUser(String username) async {
    try {
      final response = await _dio.get('/users');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = (response.data as List).firstWhere(
          (user) => user['username'] == username,
        );
        if (user != null) {
          return User.fromJson(user);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
