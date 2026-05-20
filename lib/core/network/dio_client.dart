import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'app_logger.dart';

class DioClient {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              AppLogger.logger.i('''
🚀 API REQUEST

METHOD: ${options.method}
URL: ${options.baseUrl}${options.path}

HEADERS:
${options.headers}

BODY:
${options.data}
''');

              handler.next(options);
            },

            onResponse: (response, handler) {
              AppLogger.logger.f('''
✅ API RESPONSE

STATUS CODE: ${response.statusCode}

URL:
${response.requestOptions.baseUrl}${response.requestOptions.path}

RESPONSE:
${response.data}
''');

              handler.next(response);
            },

            onError: (DioException e, handler) {
              AppLogger.logger.e('''
❌ API ERROR

STATUS CODE:
${e.response?.statusCode}

URL:
${e.requestOptions.baseUrl}${e.requestOptions.path}

ERROR:
${e.response?.data ?? e.message}
''');

              handler.next(e);
            },
          ),
        );
}
