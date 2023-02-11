import '../../entities/http_driver_options.dart';
import '../../entities/http_driver_response.dart';

abstract class HttpService {
  /* Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }); */

  setConfig({String? token});

  Future<HttpDriverResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
    Map<String, dynamic>? extraHeaders,
  });

  Future<HttpDriverResponse> getFile<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
  });

  // Map<String, String>? get getHeaders => throw UnimplementedError();

  Future<HttpDriverResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
  });

  Future<HttpDriverResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
  });

  Future<HttpDriverResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
  });

  Future<HttpDriverResponse> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
  });

  void resetContentType();

  Future<HttpDriverResponse> sendFile<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
    HttpDriverProgressCallback? onSendProgress,
  });
}
