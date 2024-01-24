// 📦 Package imports:
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// 🌎 Project imports:
import '../../../domain/entities/http_driver_options.dart';
import '../../../domain/entities/http_driver_response.dart';
import '../../../domain/service/http/http_service.dart';
import '../../../failures/failures.dart';

class DioHttpServiceImp implements HttpService {
  Dio dio = Dio();

  final HttpDriverOptions httpDriverOptions;

  DioHttpServiceImp(
    this.httpDriverOptions,
  ) {
    setConfig();
  }

  @override
  setConfig({String? token}) async {
    String gettedToken = httpDriverOptions.accessToken();
    if (token != null) {
      gettedToken = token;
    }
    dio.options.baseUrl = httpDriverOptions.baseUrl();
    dio.options.connectTimeout = const Duration(seconds: 60);
    dio.options.receiveTimeout = const Duration(seconds: 60);

    dio.options.headers.addAll(
      {
        'content-type': "application/json; charset=utf-8",
        'Authorization': '${httpDriverOptions.accessTokenType} $gettedToken',
      },
    );
    dio.interceptors.addAll([
      CurlLoggerDioInterceptor(printOnSuccess: true),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    ]);
  }

  Future<HttpDriverResponse> interceptRequests(Future request) async {
    try {
      var response = await request.catchError((e) => throw e);
      var data = response.data;
      return HttpDriverResponse(data: data, statusCode: response.statusCode);
    } on Exception catch (e) {
      var message = "";
      var errorCode = 0;

      var serverFailure = ServerFailure();
      switch (e.runtimeType) {
        case NoNetworkFailure:
          rethrow;
        case DioException:
          var dioError = (e as DioException);
          var data = dioError.response?.data;
          if (data is Map<String, dynamic> && data.containsKey('data')) {
            var message = "";
            if (dioError.response!.data['data']["message"] is List) {
              message = (dioError.response!.data['data']["message"] as List)
                  .join(", ");
            } else {
              message = dioError.response!.data['data']["message"];
            }
            message = message;
            errorCode = dioError.response!.data['data']["errorCode"];
          } else if (data is Map<String, dynamic> &&
              !data.containsKey('data')) {
            //-> ENZITECH API configured with the possibility of not containing key 'data'
            if (dioError.response!.data["message"] is List) {
              message = (dioError.response!.data["message"] as List).join(", ");
            } else {
              message = dioError.response!.data["message"];
            }
            message = message;
            errorCode = dioError.response!.data["statusCode"];
          }
          if (message.isEmpty) {
            if (dioError.response == null) {
              if (dioError.message!.contains('Connection failed')) {
                throw NoNetworkFailure(
                    message: dioError.message ?? 'No Network Failure');
              } else {
                throw dioError.message!.contains('Connection timed out')
                    ? serverFailure
                    : ServerFailure(
                        message: dioError.message ?? 'Server Failure');
              }
            }
            if (dioError.message!.isNotEmpty) {
              message = dioError.message ?? '';
            } else if (dioError.response!.statusMessage != '') {
              message = dioError.response!.statusMessage ?? message;
            } else if (dioError.response!.data != '') {
              message = dioError.response!.data['message'] ?? message;
            } else {
              message = dioError.message ?? '';
            }
            message = message.isEmpty ? serverFailure.message : message;
          }

          //TODO: Verify this
          if (dioError.type == DioExceptionType.connectionTimeout) {
            throw NoNetworkFailure(message: "Connection Timeout Exception");
          } else if (dioError.type == DioExceptionType.receiveTimeout) {
            throw NoNetworkFailure(message: "Receive Timeout Exception");
          }

          switch (dioError.response!.statusCode) {
            case 400:
              throw InvalidOrMissingFieldFailure(
                key: errorCode,
                message: message,
              );
            case 401:
              throw ExpiredTokenOrWrongUserFailure(
                key: errorCode,
                message: message,
              );
            case 403:
              throw ForbiddenFailure(
                key: errorCode,
                message: message,
              );
            case 404:
              throw NotFoundFailure(
                key: errorCode,
                message: message,
              );
            case 422:
              throw UnprocessableEntityFailure(
                key: errorCode,
                message: message,
              );
            case 426:
              throw InvalidDeviceIdFailure(
                key: errorCode,
                message: message,
              );
            case 500:
              throw ServiceUnavailableFailure(
                key: errorCode,
                message: message,
              );
            case 503:
              throw ServerFailure(
                key: errorCode,
                message: message,
              );
            default:
              throw message.isEmpty
                  ? serverFailure
                  : ServerFailure(message: message, key: errorCode);
          }
        default:
          throw serverFailure;
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
        options: Options(
          headers: extraHeaders,
        ),
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
    return await interceptRequests(
      dio.get(
        path,
        queryParameters: queryParameters,
      ),
    );
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
      dio.patch(path,
          data: data,
          queryParameters: queryParameters,
          onReceiveProgress: onReceiveProgress),
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
      dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
      ),
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
      dio.put(path,
          data: data,
          queryParameters: queryParameters,
          onReceiveProgress: onReceiveProgress),
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
    return await interceptRequests(
      dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      ),
    );
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
      dio.post<T>(path,
          data: data,
          queryParameters: queryParameters,
          onReceiveProgress: onReceiveProgress),
    );
  }
}
