import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api_client.dart';
import '../../../core/base_result_state.dart';
import '../../../core/config.dart';
import '../../../shared/model/user.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  static const _sessionKey = 'user_session';

  final ApiClient _apiClient;

  UserSession? _session;
  BaseResultState<UserSession> _loginState =
      const BaseResultStateInitial<UserSession>();
  BaseResultState<void> _registerState = const BaseResultStateInitial<void>();

  UserSession? get session => _session;
  bool get isLoggedIn => _session?.token.isNotEmpty == true;
  String get token => _session?.token ?? '';
  BaseResultState<UserSession> get loginState => _loginState;
  BaseResultState<void> get registerState => _registerState;

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final rawSession = prefs.getString(_sessionKey);

    if (rawSession == null || rawSession.isEmpty) return;

    final decoded = jsonDecode(rawSession) as Map<String, dynamic>;
    _session = UserSession.fromJson(decoded);
    _apiClient.setToken(_session!.token);
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _registerState = const BaseResultStateLoading<void>();
    notifyListeners();

    try {
      final response = await _apiClient.post(
        '/register',
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(AppConfig.requestTimeout);

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400 || decoded['error'] == true) {
        throw Exception(decoded['message'] ?? 'Registration failed');
      }

      _registerState = const BaseResultStateSuccess<void>(null);
    } on SocketException {
      _registerState = const BaseResultStateError<void>(
        'No internet connection',
      );
    } catch (e) {
      _registerState = BaseResultStateError<void>(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }

    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    _loginState = const BaseResultStateLoading<UserSession>();
    notifyListeners();

    try {
      final response = await _apiClient.post(
        '/login',
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(AppConfig.requestTimeout);

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400 || decoded['error'] == true) {
        throw Exception(decoded['message'] ?? 'Login failed');
      }

      final loginResult = decoded['loginResult'] as Map<String, dynamic>? ?? {};
      final session = UserSession.fromJson(loginResult);

      _session = session;
      _loginState = BaseResultStateSuccess<UserSession>(session);
      _apiClient.setToken(session.token);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionKey, jsonEncode(session.toJson()));
    } on SocketException {
      _loginState = const BaseResultStateError<UserSession>(
        'No internet connection',
      );
    } catch (e) {
      _loginState = BaseResultStateError<UserSession>(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }

    notifyListeners();
  }

  Future<void> logout() async {
    _session = null;
    _loginState = const BaseResultStateInitial<UserSession>();
    _registerState = const BaseResultStateInitial<void>();
    _apiClient.setToken(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    notifyListeners();
  }
}
