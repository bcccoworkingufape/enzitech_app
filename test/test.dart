// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// 🌎 Project imports:
import 'package:enzitech_app/core/domain/entities/http_driver_response.dart';
import 'package:enzitech_app/core/domain/service/http/http_service.dart';

class MockDioClient extends Mock implements HttpService {}

void main() {
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
  });

  void setUpMockHttpClientSuccess200() {
    when(mockDioClient.get('http://example.com')).thenAnswer(
      (_) async => HttpDriverResponse(data: 'data', statusCode: 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockDioClient.get('http://example.com')).thenAnswer(
      (_) async =>
          HttpDriverResponse(data: 'Something went wrong', statusCode: 404),
    );
  }
}
