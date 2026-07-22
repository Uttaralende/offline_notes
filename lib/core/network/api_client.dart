import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  late final Dio dio = Dio(
    BaseOptions(
      // baseUrl: 'https://YOUR_MOCK_API_URL.com',
      baseUrl: 'https://6a60c230da10c59c180910df.mockapi.io/offline_notes/api/',

      connectTimeout: const Duration(seconds: 30),

      receiveTimeout: const Duration(seconds: 30),

      sendTimeout: const Duration(seconds: 30),

      headers: {
        "Content-Type": "application/json",
      },
    ),
  );
}