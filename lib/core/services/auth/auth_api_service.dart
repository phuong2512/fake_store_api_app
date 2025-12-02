import 'package:dio/dio.dart';
import 'package:fake_store_api_app/core/models/user.dart';

abstract class AuthApiService {
  Future<String?> login(String username, String password);

  Future<UserModel?> getUser(String username);
}

class AuthApiServiceImpl implements AuthApiService {
  final Dio _dio;

  AuthApiServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<String?> login(String username, String password) async {
    final response = await _dio.post(
      '/auth/login',
      data: {"username": username, "password": password},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['token'];
    }
    return null;
  }

  @override
  Future<UserModel?> getUser(String username) async {
    final response = await _dio.get('/users');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final users = response.data as List;
      final userData = users.firstWhere(
        (user) => user['username'] == username,
        orElse: () => null,
      );
      if (userData != null) {
        return UserModel.fromJson(userData);
      }
    }
    return null;
  }
}
