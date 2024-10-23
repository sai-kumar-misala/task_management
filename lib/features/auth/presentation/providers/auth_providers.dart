import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../session/providers/session_provider.dart';
import '../../data/data_sources/auth_remote_data_source.dart';
import '../../data/model/user_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';
import '../../domain/use_cases/signup_use_case.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final userModelProvider = StateProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user != null) {
        return UserModel(
          uid: user.uid,
          email: user.email!,
          lastActive: DateTime.now(),
        );
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

class AuthNotifier extends StateNotifier<UserModel?> {
  final Ref _ref;
  final FirebaseAuth _auth;

  AuthNotifier(this._ref)
      : _auth = FirebaseAuth.instance,
        super(null) {
    _ref.listen(userModelProvider, (previous, next) {
      state = next;
      if (next != null) {
        Future.microtask(() {
          _ref.read(sessionProvider).updateLastActive();
          _ref.read(sessionProvider).persistSession(next);
        });
      } else {
        Future.microtask(() {
          _ref.read(sessionProvider).clearSession();
        });
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _ref.read(loginUseCaseProvider).call(email, password);
    } catch (error) {
      throw Exception('Login failed: ${error.toString()}');
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _ref.read(signUpUseCaseProvider).call(email, password);
    } catch (error) {
      throw Exception('Sign up failed: ${error.toString()}');
    }
  }

  Future<void> signOut() async {
    await _ref.read(logOutUseCaseProvider).call();
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier(ref);
});

final loginUseCaseProvider = Provider((ref) {
  return LoginUseCase(repository: ref.read(authRepositoryProvider));
});

final signUpUseCaseProvider = Provider((ref) {
  return SignUpUseCase(repository: ref.read(authRepositoryProvider));
});

final logOutUseCaseProvider = Provider((ref) {
  return LogoutUseCase(repository: ref.read(authRepositoryProvider));
});

final authRepositoryProvider = Provider((ref) {
  return AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSource());
});
