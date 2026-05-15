import 'package:flutter/material.dart';
import 'package:vtu_app/core/models/user.dart';
import 'package:vtu_app/core/services/auth_service.dart';
import 'package:vtu_app/core/services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null || StorageService.isLoggedIn();

  Future<bool> login(String identifier, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(
        LoginRequest(identifier: identifier, password: password),
      );
      if (response.success) {
        _user = response.user;
        if (response.user != null) await StorageService.saveUser(response.user!);
        if (response.token != null) {
          await StorageService.saveToken(response.token!);
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(RegisterRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.register(request);
      if (response.success) {
        _user = response.user;
        if (response.user != null) await StorageService.saveUser(response.user!);
        if (response.token != null) {
          await StorageService.saveToken(response.token!);
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    await StorageService.clear();
    notifyListeners();
  }

  Future<void> refreshUser() async {
    try {
      final userData = await _authService.getProfile();
      _user = userData;
      await StorageService.saveUser(userData);
      notifyListeners();
    } catch (e) {
      // Silent fail
    }
  }

  void updateWalletBalance(double balance) {
    if (_user != null) {
      _user = _user!.copyWith(walletBalance: balance);
      StorageService.updateUser(_user!);
      notifyListeners();
    }
  }
}
