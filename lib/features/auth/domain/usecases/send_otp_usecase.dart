import '../../data/model/auth_response_model.dart';
import '../repository/auth_repository.dart';

class SendOtpUsecase {
  final AuthRepository repository;

  SendOtpUsecase(this.repository);

  Future<AuthResponseModel> call(
      String phone,
      ) {
    return repository.sendOtp(phone);
  }
}