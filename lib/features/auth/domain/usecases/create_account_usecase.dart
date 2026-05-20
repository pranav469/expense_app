import '../repository/auth_repository.dart';

class CreateAccountUsecase {
  final AuthRepository repository;

  CreateAccountUsecase(this.repository);

  Future<String> call({
    required String phone,
    required String nickname,
  }) {
    return repository.createAccount(
      phone: phone,
      nickname: nickname,
    );
  }
}