import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import '../../auth/data/model/user_model.dart';
import '../../auth/presentation/providers/auth_providers.dart';

final sessionProvider = Provider<SessionManager>((ref) {
  return SessionManager(ref);
});

class SessionManager {
  static const sessionTimeout = Duration(hours: 24);
  static const activityTimeout = Duration(minutes: 30);
  static const String lastActiveKey = 'last_active_timestamp';
  static const String sessionKey = 'session_data';

  final Ref _ref;
  Timer? _sessionTimer;
  Timer? _activityTimer;
  Timer? _debounceTimer;

  SessionManager(this._ref) {
    _initializeSessionManagement();
    if (kIsWeb) {
      _setupWebListeners();
    }
  }

  void _setupWebListeners() {
    if (kIsWeb) {
      final window = html.window;
      window.onFocus.listen((_) => updateLastActive());
      window.onBlur.listen((_) => _checkUserActivity());
      window.document.onMouseMove.listen((_) => _debouncedUpdateActivity());
      window.document.onKeyPress.listen((_) => _debouncedUpdateActivity());
      window.onStorage.listen((event) {
        if (event.key == lastActiveKey) {
          _checkUserActivity();
        }
      });
    }
  }

  void _debouncedUpdateActivity() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 5), () {
      updateLastActive();
    });
  }

  void _initializeSessionManagement() {
    _ref.listen(authNotifierProvider, (previous, next) {
      if (next != null) {
        _startSessionTimer();
        _startActivityTimer();
        persistSession(next);
      } else {
        _cancelTimers();
        clearSession();
      }
    });
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(sessionTimeout, () {
      _handleSessionTimeout();
    });
  }

  void _startActivityTimer() {
    _activityTimer?.cancel();
    _activityTimer = Timer(activityTimeout, () {
      _checkUserActivity();
    });
  }

  void _cancelTimers() {
    _sessionTimer?.cancel();
    _activityTimer?.cancel();
    _debounceTimer?.cancel();
  }

  Future<void> updateLastActive() async {
    final timestamp = DateTime.now().toIso8601String();
    if (kIsWeb) {
      html.window.localStorage[lastActiveKey] = timestamp;
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(lastActiveKey, timestamp);
    }
    _startActivityTimer();
  }

  Future<void> _checkUserActivity() async {
    final lastActiveStr = await _getLastActive();

    if (lastActiveStr != null) {
      final lastActive = DateTime.parse(lastActiveStr);
      final now = DateTime.now();

      if (now.difference(lastActive) > activityTimeout) {
        _handleSessionTimeout();
      } else {
        _startActivityTimer();
      }
    }
  }

  Future<String?> _getLastActive() async {
    if (kIsWeb) {
      return html.window.localStorage[lastActiveKey];
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(lastActiveKey);
    }
  }

  Future<void> persistSession(UserModel user) async {
    final sessionData = json.encode(user.toJson());
    if (kIsWeb) {
      html.window.localStorage[sessionKey] = sessionData;
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(sessionKey, sessionData);
    }
  }

  Future<void> clearSession() async {
    if (kIsWeb) {
      html.window.localStorage.remove(sessionKey);
      html.window.localStorage.remove(lastActiveKey);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(sessionKey);
      await prefs.remove(lastActiveKey);
    }
  }

  Future<void> _handleSessionTimeout() async {
    await clearSession();
    final authNotifier = _ref.read(authNotifierProvider.notifier);
    await authNotifier.signOut();
  }
}
