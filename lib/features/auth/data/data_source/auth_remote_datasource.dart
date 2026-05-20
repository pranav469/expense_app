import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../model/auth_response_model.dart';

class AuthRemoteDatasource {

  final Dio dio = DioClient.dio;

  Future<AuthResponseModel> sendOtp(
      String phone,
      ) async {
    try {
      final response = await dio.post(
        ApiConstants.sendOtp,
        data: {
          'phone': phone,
        },
      );

      print('RESULT IS $response');

      return AuthResponseModel.fromJson(
        response.data,
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            'Failed to send OTP',
      );
    }
  }

  Future<String> createAccount({
    required String phone,
    required String nickname,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.createAccount,
        data: {
          'phone': phone,
          'nickname': nickname,
        },
      );

      return response.data['token'];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            'Failed to create account',
      );
    }
  }
}