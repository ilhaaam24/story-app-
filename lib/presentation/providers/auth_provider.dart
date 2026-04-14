import 'package:flutter/foundation.dart';
import 'package:submission_pertama/data/datasources/local_datasource.dart';
import 'package:submission_pertama/data/repositories/auth_repository.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final LocalDatasource _localDatasource;

  AuthState _state = AuthState.initial;
  String? _errorMessage;
  String? _token;

  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  String? get token => _token;

  AuthProvider(this._authRepository, this._localDatasource) {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _localDatasource.isLoggedIn();
    if (isLoggedIn) {
      _token = await _localDatasource.getToken();
      if (_token != null) {
        _state = AuthState.authenticated;
      } else {
        _state = AuthState.unauthenticated;
      }
    } else {
      _state = AuthState.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      final user = await _authRepository.login(email, password);
      _token = user.token;
      await _localDatasource.saveToken(user.token);
      _state = AuthState.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      await _authRepository.register(name, email, password);
      _state = AuthState.unauthenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _localDatasource.clearSession();
    _token = null;
    _state = AuthState.unauthenticated;
    notifyListeners();
  }
}
