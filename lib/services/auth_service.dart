import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthService {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://fakestoreapi.com/auth/login',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '',
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
}
