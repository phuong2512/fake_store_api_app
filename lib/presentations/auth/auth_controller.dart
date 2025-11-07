import 'dart:async';
import 'package:fake_store_api_app/data/models/user.dart';
import 'package:fake_store_api_app/data/repositories/auth_repository.dart';

class AuthController {
  final AuthRepository _authRepository;

  final StreamController<String?> _tokenController;
  final StreamController<User?> _userController;
  final StreamController<bool> _loadingController;

  String? _currentToken;
  User? _currentUser;
  bool _isLoading = false;

  AuthController(this._authRepository)
      : _tokenController = StreamController<String?>.broadcast(),
        _userController = StreamController<User?>.broadcast(),
        _loadingController = StreamController<bool>.broadcast();

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
      final token = await _authRepository.login(username, password);

      if (token != null) {
        final user = await _authRepository.getUser(username);
        _emitToken(token);
        _emitUser(user);
        _emitLoading(false);
      } else {
        _emitToken(null);
        _emitUser(null);
        _emitLoading(false);
      }
    } catch (e) {
      _emitToken(null);
      _emitUser(null);
      _emitLoading(false);
    }
  }

  void logout() {
    _emitToken(null);
    _emitUser(null);
    _emitLoading(false);
  }

  void dispose() {
    _tokenController.close();
    _userController.close();
    _loadingController.close();
  }
}