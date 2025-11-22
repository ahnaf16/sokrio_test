import 'package:linkify/main.export.dart';

export 'package:dio/dio.dart';

class DioClient {
  DioClient({this.useEvent = true}) {
    _dio = Dio(_options);
    _dio.interceptors.add(_interceptorsWrapper());
    _dio.interceptors.add(DioLogger());
  }

  final bool useEvent;
  late Dio _dio;

  final _options = BaseOptions(
    baseUrl: EndPoints.clientApi,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    headers: {'Accept': 'application/json'},
  );

  Future<Map<String, String?>> header() async {
    return {'x-api-key': 'reqres-free-v1'};
  }

  // Get:-----------------------------------------------------------------------
  Future<Response> get(
    String url, {
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final response = await _dio.get(
      url,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }

  // Post:----------------------------------------------------------------------
  Future<Response> post(
    String url, {
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final formData = data == null ? null : FormData.fromMap(data, ListFormat.multiCompatible);

      final Response response = await _dio.post(
        url,
        data: formData,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> request(
    String url,
    String method, {
    String? baseUrl,
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.request(url, data: data, options: options, cancelToken: cancelToken);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Interceptors :----------------------------------------------------------------------
  InterceptorsWrapper _interceptorsWrapper() => InterceptorsWrapper(
    onRequest: (options, handler) async {
      final headers = await header();
      options.headers.addAll(headers);
      return handler.next(options);
    },
    onResponse: (res, handler) async {
      return handler.next(res);
    },
    onError: (err, handler) async {
      return handler.next(err);
    },
  );
}
