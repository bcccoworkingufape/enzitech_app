// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// 🌎 Project imports:
import 'package:enzitech_app/core/domain/service/http/http_service.dart';

class MockDioClient extends Mock implements HttpService {}

void main() {
  setUp(() {});
}
