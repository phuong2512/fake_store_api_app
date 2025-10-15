import 'package:fake_store_api_app/models/user.dart';
import 'package:fake_store_api_app/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;
  String? _token;
  User? _currentUser;

  AuthController(this._authRepository);

  String? get token => _token;
  User? get currentUser => _currentUser;

  Future<void> login(String username, String password) async {
    final token = await _authRepository.login(username, password);
    _token = token;
    _currentUser = await _authRepository.getUser(username);
    notifyListeners();
  }

  void logout() {
    _token = null;
    _currentUser = null;
    notifyListeners();
  }
}