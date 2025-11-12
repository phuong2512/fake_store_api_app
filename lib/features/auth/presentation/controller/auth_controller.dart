import 'dart:async';
import 'dart:developer';
import 'package:fake_store_api_app/features/auth/domain/entities/user.dart';
import 'package:fake_store_api_app/features/auth/domain/usecases/get_user.dart';
import 'package:fake_store_api_app/features/auth/domain/usecases/login_user.dart';

class AuthController {
  final LoginUser _loginUser;
  final GetUser _getUser;

  final StreamController<String?> _tokenController;
  final StreamController<User?> _userController;
  final StreamController<bool> _loadingController;

  String? _currentToken;
  User? _currentUser;
  bool _isLoading = false;

  AuthController({required LoginUser loginUser, required GetUser getUser})
    : _loginUser = loginUser,
      _getUser = getUser,
      _tokenController = StreamController<String?>.broadcast(),
      _userController = StreamController<User?>.broadcast(),
      _loadingController = StreamController<bool>.broadcast() {
    log('✅ AuthController INIT');
  }

  String? get token => _currentToken;
  Stream<String?> get tokenStream => _tokenController.stream;

  User? get currentUser => _currentUser;
  Stream<User?> get userStream => _userController.stream;

  bool get isLoading => _isLoading;
  Stream<bool> get loadingStream => _loadingController.stream;

  void _emitToken(String? token) {
    _currentToken = token;
    if (!_tokenController.isClosed) {
      _tokenController.add(token);
    }
  }

  void _emitUser(User? user) {
    _currentUser = user;
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
      final token = await _loginUser(
        LoginParams(username: username, password: password),
      );
      if (token != null) {
        final user = await _getUser(username); // Gọi Usecase
        _emitToken(token);
        _emitUser(user);
      } else {
        _emitToken(null);
        _emitUser(null);
      }
    } catch (e) {
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

  void dispose() {
    log('❌ AuthController DISPOSE');
    _tokenController.close();
    _userController.close();
    _loadingController.close();
  }
}
