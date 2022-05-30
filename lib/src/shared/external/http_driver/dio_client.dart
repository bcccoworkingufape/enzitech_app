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
  final String tenantId;
  final String channelId;
  final String apiKey;

  HttpDriverOptions({
    required this.accessToken,
    required this.baseUrl,
    required this.tenantId,
    required this.channelId,
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

  // static header() => {"Content-Type": "application/json"};

  // var logger = Logger();

  /* Future<DioClient> init() async {
    dio = Dio(BaseOptions(baseUrl: BASE_URL, headers: header()));
    initInterceptors();
    return this;
  } */

  void initInterceptors() {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
    // dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (requestOptions, handler) {
    //       // logger.i(
    //       //     "REQUEST[${requestOptions.method}] => PATH: ${requestOptions.path}"
    //       //     "=> REQUEST VALUES: ${requestOptions.queryParameters} => HEADERS: ${requestOptions.headers}");
    //       return handler.next(requestOptions);
    //     },
    //     onResponse: (response, handler) {
    //       // logger
    //       //     .i("RESPONSE[${response.statusCode}] => DATA: ${response.data}");
    //       return handler.next(response);
    //     },
    //     onError: (err, handler) {
    //       // logger.i("Error[${err.response?.statusCode}]");
    //       return handler.next(err);
    //     },
    //   ),
    // );
  }

  /*Future<dynamic> request(
      {required String url,
      required Method method,
      Map<String, dynamic>? params}) async {
    dio = Dio(BaseOptions(baseUrl: BASE_URL, headers: header()));
    init();
    Response response;

    try {
      if (method == Method.POST) {
        response = await dio.post(url, data: params);
      } else if (method == Method.DELETE) {
        response = await dio.delete(url);
      } else if (method == Method.PATCH) {
        response = await dio.patch(url);
      } else {
        response = await dio.get(url, queryParameters: params);
      }

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized");
      } else if (response.statusCode == 403) {
        throw Exception("Forbidden");
      } else if (response.statusCode == 500) {
        throw Exception("Server Error");
      } else {
        throw Exception("Something does wen't wrong");
      }
    } on SocketException catch (e) {
      // logger.e(e);
      throw Exception("Not Internet Connection");
    } on FormatException catch (e) {
      // logger.e(e);
      throw Exception("Bad response format");
    } on DioError catch (e) {
      // logger.e(e);
      throw Exception(e);
    } catch (e) {
      // logger.e(e);
      throw Exception("Something wen't wrong");
    }
  } */

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
          }
          if (message.isEmpty) {
            if (dioError.response == null) {
              // ErrorReporter().report(
              //   endpoint: dioError.requestOptions.path,
              //   message: message,
              //   stackTrace: dioError.stackTrace!,
              //   requestParams: dioError.requestOptions.data,
              // );

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

            // ErrorReporter().report(
            //   endpoint: dioError.requestOptions.path,
            //   message: message,
            //   stackTrace: dioError.stackTrace!,
            //   requestParams: dioError.requestOptions.data,
            // );
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
    initInterceptors(); //Logger

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
    initInterceptors(); //Logger

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
    initInterceptors(); //Logger

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
    initInterceptors(); //Logger

    resetContentType();
    return await interceptRequests(
      dio.post(path,
          data: data,
          queryParameters: queryParameters,
          onReceiveProgress: onReceiveProgress),
    );
  }

  Future<HttpDriverResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
  }) async {
    initInterceptors(); //Logger

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
    initInterceptors(); //Logger

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
    initInterceptors(); //Logger

    dio.options.headers['content-type'] = 'multipart/form-data';
    return await interceptRequests(
      dio.post<T>(path,
          data: data,
          queryParameters: queryParameters,
          onReceiveProgress: onReceiveProgress),
    );
  }
}
