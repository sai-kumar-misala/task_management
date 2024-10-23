import '../../data/model/user_model.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase({required this.repository});

  Future<UserModel?> call(String email, String password) async {
    return await repository.signUp(email, password);
  }
}
