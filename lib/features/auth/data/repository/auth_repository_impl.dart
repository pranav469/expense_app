import '../../domain/repository/auth_repository.dart';
import '../data_source/auth_remote_datasource.dart';
import '../model/auth_response_model.dart';

class AuthRepositoryImpl
    implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(
      this.remoteDatasource,
      );

  @override
  Future<AuthResponseModel> sendOtp(
      String phone,
      ) {
    return remoteDatasource.sendOtp(phone);
  }

  @override
  Future<String> createAccount({
    required String phone,
    required String nickname,
  }) {
    return remoteDatasource.createAccount(
      phone: phone,
      nickname: nickname,
    );
  }
}