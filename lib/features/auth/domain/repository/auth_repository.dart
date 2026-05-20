import '../../data/model/auth_response_model.dart';

abstract class AuthRepository {
  Future<AuthResponseModel> sendOtp(
      String phone,
      );

  Future<String> createAccount({
    required String phone,
    required String nickname,
  });
}