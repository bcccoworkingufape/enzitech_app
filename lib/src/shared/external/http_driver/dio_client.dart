// 📦 Package imports:
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/failures/failures.dart';

class HttpDriverResponse {
  final dynamic data;
  final int? statusCode;
  String? statusMessage;

  HttpDriverResponse({
    required this.data,
    required this.statusCode,
    this.statusMessage,
  });
}

class HttpDriverOptions {
  final AccessToken accessToken;
  final BaseUrl baseUrl;
  final String accessTokenType;
  final String apiKey;

  HttpDriverOptions({
    required this.accessToken,
    required this.baseUrl,
    required this.apiKey,
    this.accessTokenType = "Bearer",
  });
}

typedef HttpDriverProgressCallback = void Function(int count, int total);
typedef AccessToken = String Function();
typedef CustomerId = String Function();
typedef BaseUrl = String Function();
typedef CallbackType<T> = T Function();

// enum Method { POST, GET, PUT, DELETE, PATCH }

// const BASE_URL = "https://fakestoreapi.com/";

class DioClient {
  Dio dio = Dio();

  final HttpDriverOptions httpDriverOptions;

  DioClient(
    this.httpDriverOptions,
  ) {
    _setConfig();
  }

  void _setConfig() {
    dio.options.baseUrl = httpDriverOptions.baseUrl();
    dio.options.headers.addAll(
      {
        'content-type': "application/json; charset=utf-8",
        'x-api-key':
            '${httpDriverOptions.accessTokenType} ${httpDriverOptions.apiKey}',
      },
    );
    dio.interceptors.addAll([
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
        case DioError:
          var dioError = (e as DioError);
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
            //* API do EZT configurada assim
            // var message = "";
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
              throw dioError.message.contains('Connection timed out')
                  ? serverFailure
                  : ServerFailure(message: dioError.message);
            }
            if (dioError.message.isNotEmpty) {
              message = dioError.message;
            } else if (dioError.response!.statusMessage != '') {
              message = dioError.response!.statusMessage ?? message;
            } else if (dioError.response!.data != '') {
              message = dioError.response!.data['message'] ?? message;
            } else {
              message = dioError.message;
            }
            message = message.isEmpty ? serverFailure.message : message;
          }

          switch (dioError.response!.statusCode) {
            case 400:
              throw InvalidOrMissingFieldFailure(
                  key: errorCode, message: message);
            case 401:
              throw ExpiredTokenOrWrongUserFailure(
                  key: errorCode, message: message);
            case 403:
              throw ForbiddenFailure(key: errorCode, message: message);
            case 404:
              throw NotFoundFailure(key: errorCode, message: message);
            case 422:
              throw UnprocessableEntity(key: errorCode, message: message);
            case 500:
              throw ServerFailure(key: errorCode, message: message);
            case 503:
              throw ServerFailure(key: errorCode, message: message);
            case 426:
              throw InvalidDeviceIdFailure(key: errorCode, message: message);
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

  Map<String, String>? get getHeaders => throw UnimplementedError();

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

  void resetContentType() {
    dio.options.headers['content-type'] = 'application/json; charset=utf-8';
  }

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
