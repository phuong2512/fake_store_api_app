import 'package:fake_store_api_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService;
  String? _token;

  AuthController(this._authService);

  String? get token => _token;

  Future<void> login(String username, String password) async {
    final token = await _authService.login(username, password);
    _token = token;
    notifyListeners();
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
