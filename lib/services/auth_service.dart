import 'package:dio/dio.dart';
import 'package:fake_store_api_app/models/user.dart';
import 'package:flutter/material.dart';

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
      if (response.statusCode == 201) {
        return response.data['token'];
      }
      return null;
    } catch (e) {
      debugPrint("Login error: $e");
      return null;
    }
  }

  Future<User?> getUser(String username) async {
    try {
      final response = await _dio.get('/users');
      if (response.statusCode == 200) {
        final user = (response.data as List).firstWhere(
          (user) => user['username'] == username,
        );
        if (user != null) {
          debugPrint(user.toString());
          return User.fromJson(user);
        }
      }
      return null;
    } catch (e) {
      debugPrint("Get user error: $e");
      return null;
    }
  }
}
