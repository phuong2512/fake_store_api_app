import 'dart:async';
import 'dart:developer';

import 'package:fake_store_api_app/core/models/user.dart';
import 'package:fake_store_api_app/core/use_cases/get_user.dart';
import 'package:fake_store_api_app/core/use_cases/log_in_user.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  final LogInUser _loginUser;
  final GetUser _getUser;

  final StreamController<String?> _tokenController =
      StreamController.broadcast();
  final StreamController<UserModel?> _userController =
      StreamController.broadcast();
  final StreamController<bool> _loadingController =
      StreamController.broadcast();

  bool _isLoading = false;

  LoginController({required LogInUser loginUser, required GetUser getUser})
    : _loginUser = loginUser,
      _getUser = getUser {
    log('✅ LoginController INIT');
    _emitToken(null);
    _emitUser(null);
    _emitLoading(false);
  }

  Stream<String?> get tokenStream => _tokenController.stream;

  Stream<UserModel?> get userStream => _userController.stream;

  bool get isLoading => _isLoading;

  Stream<bool> get loadingStream => _loadingController.stream;

  void _emitToken(String? token) {
    if (!_tokenController.isClosed) {
      _tokenController.add(token);
    }
  }

  void _emitUser(UserModel? user) {
    if (!_userController.isClosed) {
      _userController.add(user);
    }
  }

  void _emitLoading(bool loading) {
    _isLoading = loading;
    if (!_loadingController.isClosed) {
      _loadingController.add(loading);
    }
  }

  Future<void> login(String username, String password) async {
    _emitLoading(true);

    try {
      final token = await _loginUser(username, password);

      if (token != null) {
        final user = await _getUser();
        _emitToken(token);
        _emitUser(user);
      } else {
        _emitToken(null);
        _emitUser(null);
      }
    } catch (e) {
      log('❌ Login error: $e');
      _emitToken(null);
      _emitUser(null);
    } finally {
      _emitLoading(false);
    }
  }

  void logout() {
    _emitToken(null);
    _emitUser(null);
    _emitLoading(false);
  }

  @override
  void dispose() {
    log('❌ LoginController DISPOSE');
    _tokenController.close();
    _userController.close();
    _loadingController.close();
    super.dispose();
  }
}
