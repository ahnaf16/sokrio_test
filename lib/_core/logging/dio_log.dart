import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:linkify/main.export.dart';

class DioLogger extends Interceptor {
  DioLogger._privateConstructor();
  static final DioLogger _instance = DioLogger._privateConstructor();
  factory DioLogger() => _instance;

  List<String> hiddenList = [];
  List<String> ignoreList = [];

  bool captureRequestCount = !kReleaseMode;
  bool logResponse = true;
  bool requestBody = true;
  bool requestHeader = false;
  bool responseBody = true;

  final Map<Uri, int> _requestCount = {};
  Map<Uri, int> get requestCount => _requestCount;

  void _addCount(Uri uri) {
    if (_requestCount.containsKey(uri)) {
      _requestCount[uri] = _requestCount.parseInt(uri) + 1;
    } else {
      _requestCount[uri] = 1;
    }
  }

  @override
  void onError(err, handler) {
    if (ignoreList.any((e) => err.requestOptions.uri.toString().contains(e))) {
      return handler.next(err);
    }

    const h = LogHelper(true);

    final bf = StringBuffer();
    bf.writeln(h.start('DioException'));
    bf.writeln(h.kvLine('uri', err.requestOptions.uri));
    bf.writeln(h.kvLine('type', err.type));
    if (err.error != null) bf.writeln(h.kvLine('error', err.error));

    if (err.response != null) {
      bf.writeln(h.kvLine('statusCode', err.response?.statusCode));
      bf.writeln(h.start('Error response'));
      bf.writeln(h.jsonMap(1, err.response?.data));
    }
    bf.writeln(h.end('DioException'));
    logPrint(bf.toString());
    handler.next(err);
  }

  @override
  void onRequest(options, handler) {
    if (ignoreList.any((e) => options.uri.toString().contains(e))) {
      return handler.next(options);
    }
    if (captureRequestCount) _addCount(options.uri);

    const h = LogHelper(false);

    final bf = StringBuffer();
    bf.writeln(h.start('Request'));
    bf.writeln(h.kvLine('uri', options.uri));
    bf.writeln(h.kvLine('method', options.method));
    bf.writeln(h.kvLine('Authorization', options.headers[HttpHeaders.authorizationHeader]));

    if (requestHeader && options.headers.isNotEmpty) {
      bf.writeln(h.start('headers'));
      bf.writeln(h.jsonMap(1, options.headers));
    }
    if (requestBody && options.data != null) {
      bf.writeln(h.start('data'));
      bf.writeln(h.jsonMap(1, options.data));
    }

    bf.writeln(h.end('Request'));

    logPrint(bf.toString());

    handler.next(options);
  }

  @override
  void onResponse(response, handler) {
    if (ignoreList.any((e) => response.requestOptions.uri.toString().contains(e))) {
      return handler.next(response);
    }

    final path = response.requestOptions.path;

    if (!logResponse) return;
    const h = LogHelper(false);
    final bf = StringBuffer();
    bf.writeln(h.start('Response'));
    bf.writeln(h.kvLine('uri', response.requestOptions.uri));
    bf.writeln(h.kvLine('statusCode', response.statusCode));

    if (hiddenList.any((e) => path.startsWith(e))) return handler.next(response);

    if (responseBody && response.data != null) {
      bf.writeln(h.start('body'));
      bf.writeln(h.jsonMap(1, response.data));
    }

    bf.writeln(h.end('Response'));
    logPrint(bf.toString());

    handler.next(response);
  }

  /// Log printer; defaults print log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file, for example:
  /// ```dart
  ///  final file=File("./log.txt");
  ///  final sink=file.openWrite();
  ///  dio.interceptors.add(LogInterceptor(logPrint: sink.writeln));
  ///  ...
  ///  await sink.close();
  /// ```
  void logPrint(dynamic o) => log(o.toString());
}
