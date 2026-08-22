// 📦 Package imports:
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// 🌎 Project imports:
import '../../../domain/entities/http_driver_options.dart';
import '../../../domain/entities/http_driver_response.dart';
import '../../../domain/service/http/http_service.dart';
import '../../../failures/failures.dart';

class DioHttpServiceImp implements HttpService {
  Dio dio = Dio();

  final HttpDriverOptions httpDriverOptions;

  DioHttpServiceImp(this.httpDriverOptions) {
    setConfig();
  }

  @override
  Future<void> setConfig({String? token}) async {
    String gettedToken = httpDriverOptions.accessToken();
    if (token != null) {
      gettedToken = token;
    }
    dio.options.baseUrl = httpDriverOptions.baseUrl();
    dio.options.connectTimeout = const Duration(seconds: 60);
    dio.options.receiveTimeout = const Duration(seconds: 60);

    // Reinicia o estado sensível para evitar vazamento do token da sessão anterior
    // após logout ou login como outro usuário.
    dio.options.headers.clear();
    dio.options.headers.addAll({
      'content-type': "application/json; charset=utf-8",
      'Authorization': '${httpDriverOptions.accessTokenType} $gettedToken',
    });

    // Os interceptadores são stateful; remova qualquer instância anterior antes de re-adicionar
    // para que um novo login não empilhe loggers de debug duplicados.
    dio.interceptors.clear();
    if (kDebugMode && httpDriverOptions.useDebugLogger == true) {
      dio.interceptors.addAll([
        CurlLoggerDioInterceptor(printOnSuccess: false),
        PrettyDioLogger(
          requestHeader: false,
          requestBody: false,
          responseBody: false,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      ]);
    }
  }

  /// Remove o cabeçalho de autorização (usado no fluxo de logout) e limpa
  /// quaisquer interceptadores stateful.
  @override
  Future<void> clearSession() async {
    dio.options.headers.remove('Authorization');
    dio.interceptors.clear();
  }

  Future<HttpDriverResponse> interceptRequests(Future request) async {
    try {
      var response = await request.catchError((e) => throw e);
      var data = response.data;
      return HttpDriverResponse(data: data, statusCode: response.statusCode);
    } on Exception catch (e) {
      String message = "";
      int errorCode = 0;
      switch (e) {
        case NoNetworkFailure _:
          rethrow;
        case DioException _:
          var dioError = (e as DioException);
          var response = dioError.response;
          var responseData = response?.data;
          
          errorCode = response?.statusCode ?? 0;

          if (responseData != null && responseData is Map) {
            if (responseData.containsKey('message')) {
              var msg = responseData['message'];
              message = (msg is List) ? msg.join(", ") : msg.toString();
            } else if (responseData.containsKey('error')) {
              var msg = responseData['error'];
              message = (msg is List) ? msg.join(", ") : msg.toString();
            }

            if (responseData.containsKey('errorCode')) {
              errorCode = responseData['errorCode'];
            }
          }

          if (message.trim().isEmpty) {
            message = dioError.message ?? "Erro inesperado";
          }

          switch (response?.statusCode) {
            case 400: throw InvalidOrMissingFieldFailure(key: errorCode, message: message);
            case 401: throw ExpiredTokenOrWrongUserFailure(key: errorCode, message: message);
            case 403: throw ForbiddenFailure(key: errorCode, message: message);
            case 404: throw NotFoundFailure(key: errorCode, message: message);
            case 422: throw UnprocessableEntityFailure(key: errorCode, message: message);
            case 500: throw ServiceUnavailableFailure(key: errorCode, message: message);
            default: throw ServerFailure(message: message, key: errorCode);
          }

        default:
          throw ServerFailure(message: e.toString());
      }
    }
  }

  @override
  Future<HttpDriverResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
    Map<String, dynamic>? extraHeaders,
  }) async {
    resetContentType();
    return await interceptRequests(
      dio.get(
        path,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        options: Options(headers: extraHeaders),
      ),
    );
  }

  @override
  Future<HttpDriverResponse> getFile<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
  }) async {
    dio.options.headers['content-type'] = 'image/png';
    return await interceptRequests(dio.get(path, queryParameters: queryParameters));
  }

  @override
  Future<HttpDriverResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
  }) async {
    resetContentType();
    return await interceptRequests(
      dio.patch(path, data: data, queryParameters: queryParameters, onReceiveProgress: onReceiveProgress),
    );
  }

  @override
  Future<HttpDriverResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
  }) async {
    resetContentType();
    return await interceptRequests(
      dio.post(path, data: data, queryParameters: queryParameters, onReceiveProgress: onReceiveProgress),
    );
  }

  @override
  Future<HttpDriverResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
  }) async {
    resetContentType();
    return await interceptRequests(
      dio.put(path, data: data, queryParameters: queryParameters, onReceiveProgress: onReceiveProgress),
    );
  }

  @override
  Future<HttpDriverResponse> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
  }) async {
    resetContentType();
    return await interceptRequests(dio.delete<T>(path, data: data, queryParameters: queryParameters));
  }

  @override
  void resetContentType() {
    dio.options.headers['content-type'] = 'application/json; charset=utf-8';
  }

  @override
  Future<HttpDriverResponse> sendFile<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
    HttpDriverProgressCallback? onSendProgress,
  }) async {
    dio.options.headers['content-type'] = 'multipart/form-data';
    return await interceptRequests(
      dio.post<T>(path, data: data, queryParameters: queryParameters, onReceiveProgress: onReceiveProgress),
    );
  }
}
