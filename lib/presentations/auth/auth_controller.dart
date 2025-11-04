import 'dart:async';
import 'package:fake_store_api_app/data/models/user.dart';
import 'package:fake_store_api_app/data/repositories/auth_repository.dart';

class AuthState {
  final String? token;
  final User? currentUser;
  final bool isLoading;
  final String? error;

  AuthState({
    this.token,
    this.currentUser,
    required this.isLoading,
    this.error,
  });

  AuthState copyWith({
    String? token,
    User? currentUser,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      token: token ?? this.token,
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthController {
  final AuthRepository _authRepository;
  final StreamController<AuthState> _stateController;

  AuthController(this._authRepository)
    : _stateController = StreamController<AuthState>.broadcast() {
    _emitState(AuthState(isLoading: false));
  }

  Stream<AuthState> get state => _stateController.stream;
  AuthState? _currentState;

  AuthState get currentState => _currentState ?? AuthState(isLoading: false);

  String? get token => currentState.token;

  User? get currentUser => currentState.currentUser;

  void _emitState(AuthState state) {
    if (_stateController.isClosed) return;
    _currentState = state;
    _stateController.add(state);
  }

  Future<void> login(String username, String password) async {
    _emitState(currentState.copyWith(isLoading: true, error: null));

    try {
      final token = await _authRepository.login(username, password);

      if (token != null) {
        final user = await _authRepository.getUser(username);
        _emitState(
          AuthState(token: token, currentUser: user, isLoading: false),
        );
      } else {
        _emitState(
          AuthState(isLoading: false, error: 'Invalid username or password'),
        );
      }
    } catch (e) {
      _emitState(AuthState(isLoading: false, error: e.toString()));
    }
  }

  void logout() {
    _emitState(AuthState(isLoading: false));
  }

  void dispose() {
    _stateController.close();
  }
}
