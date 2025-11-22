import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:linkify/main.export.dart';

mixin ApiHandler {
  DioClient get dio => locate<DioClient>();

  FutureReport<T> handler<T>({
    required Future<Response> Function() call,
    required T Function(Map<String, dynamic> map) mapper,
  }) async {
    try {
      final Response(:statusCode, :data) = await call();

      if (statusCode == null || statusCode < 200 || statusCode >= 300) {
        return failure('Call ended with code $statusCode', e: data);
      }

      final decoded = _decodeResponse(data);

      if (decoded case final Map<String, dynamic> decode) {
        return right(mapper(decode));
      }

      return failure('Expected Map<String,dynamic>, got ${decoded.runtimeType}', e: data);
    } on SocketException catch (e, st) {
      return failure(e.message, e: e, s: st);
    } on DioException catch (e, st) {
      final failure = Failure.fromDio(e, st);
      return left(failure);
    } on Failure catch (e, st) {
      return left(e.copyWith(stackTrace: st));
    } catch (e, st) {
      return failure('$e', e: e, s: st);
    }
  }

  FutureReport<T> handleRaw<T>({
    required Future<Response> Function() call,
    required T Function(dynamic map) mapper,
  }) async {
    try {
      final Response(:statusCode, :data) = await call();

      if (statusCode == null || statusCode < 200 || statusCode >= 300) {
        return failure('Call ended with code $statusCode', e: data);
      }

      final decoded = _decodeResponse(data);

      return right(mapper(decoded));
    } on SocketException catch (e, st) {
      return failure(e.message, e: e, s: st);
    } on DioException catch (e, st) {
      final failure = Failure.fromDio(e, st);
      return left(failure);
    } on Failure catch (e, st) {
      return left(e.copyWith(stackTrace: st));
    } catch (e, st) {
      return failure('$e', e: e, s: st);
    }
  }

  dynamic _decodeResponse(data) {
    if (data case final Map<String, dynamic> decode) return decode;
    if (data case final String decode) return jsonDecode(decode);

    return data;
  }
}
