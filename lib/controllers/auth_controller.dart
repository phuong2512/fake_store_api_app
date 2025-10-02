import 'package:fake_store_api_app/interfaces/auth_interface.dart';
import 'package:fake_store_api_app/models/user.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final AuthInterface _authService;
  String? _token;
  User? _currentUser;

  AuthController(this._authService);

  String? get token => _token;
  User? get currentUser => _currentUser;

  Future<void> login(String username, String password) async {
    final token = await _authService.login(username, password);
    _token = token;
    _currentUser = await _authService.getUser(username);
    notifyListeners();
  }

  void logout() {
    _token = null;
    _currentUser = null;
    notifyListeners();
  }
}
