import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_sources/auth_remote_data_source.dart';
import '../../data/model/user_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/login_use_case.dart';

final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<UserModel?> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(null);

  Future<void> signIn(String email, String password) async {
    try {
      UserModel? user =
          await _ref.read(loginUseCaseProvider).call(email, password);
      state = user;
    } catch (error) {
      throw Exception('Login failed: ${error.toString()}');
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      UserModel? user =
          await _ref.read(authRepositoryProvider).signUp(email, password);
      state = user;
    } catch (error) {
      throw Exception('Sign up failed: ${error.toString()}');
    }
  }

  Future<void> signOut() async {
    await _ref.read(authRepositoryProvider).signOut();
    state = null;
  }
}

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(repository: ref.read(authRepositoryProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSource());
});
