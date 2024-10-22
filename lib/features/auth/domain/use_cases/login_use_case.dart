import '../../data/model/user_model.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<UserModel?> call(String email, String password) async {
    return await repository.signIn(email, password);
  }
}
