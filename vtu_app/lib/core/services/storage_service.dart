import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vtu_app/core/models/user.dart';
import 'package:vtu_app/core/network/api_client.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static String? _cachedToken;
  static bool _cachedIsLoggedIn = false;

  static Future<void> init() async {
    _cachedToken = await _storage.read(key: _tokenKey);
    _cachedIsLoggedIn = await _storage.read(key: _isLoggedInKey) != null;
    if (_cachedToken != null) {
      ApiClient().updateToken(_cachedToken!);
    }
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    _cachedToken = token;
    ApiClient().updateToken(token);
  }

  static String? getTokenSync() {
    return _cachedToken;
  }

  static Future<void> saveUser(User user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
    await _storage.write(key: _isLoggedInKey, value: 'true');
    _cachedIsLoggedIn = true;
  }

  static Future<User?> getUserAsync() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<void> updateUser(User user) async {
    await saveUser(user);
  }

  static Future<void> updateWalletBalance(double balance) async {
    final user = await getUserAsync();
    if (user != null) {
      final updatedUser = user.copyWith(walletBalance: balance);
      await saveUser(updatedUser);
    }
  }

  static bool isLoggedIn() {
    return _cachedIsLoggedIn;
  }

  static Future<bool> isLoggedInAsync() async {
    final value = await _storage.read(key: _isLoggedInKey);
    return value != null;
  }

  static Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
    await _storage.delete(key: _isLoggedInKey);
    _cachedToken = null;
    _cachedIsLoggedIn = false;
    ApiClient().clearToken();
  }
}
