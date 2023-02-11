typedef HttpDriverProgressCallback = void Function(int count, int total);
typedef AccessToken = String Function();
typedef CustomerId = String Function();
typedef BaseUrl = String Function();
typedef CallbackType<T> = T Function();

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
