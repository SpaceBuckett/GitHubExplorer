import 'package:dio/dio.dart';

class DioService {
  static final DioService _instance = DioService._internal();
  late final Dio _dio;

  factory DioService() => _instance;

  DioService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.github.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  Dio get dio => _dio;
}
