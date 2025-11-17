import 'package:dio/dio.dart';
import 'package:fake_store_api_app/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

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
