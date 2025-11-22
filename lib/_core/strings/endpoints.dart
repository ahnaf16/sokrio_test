import 'package:flutter/foundation.dart';
import 'package:linkify/main.export.dart';

extension type const EndPoint(String value) implements String {
  String queryParams(SMap query) {
    return '$this?${query.entries.map((e) => '${e.key}=${e.value}').join('&')}';
  }

  String get name => replaceAll('/', '');
}

class EndPoints {
  EndPoints._();

  static String? testURL;
  static bool get isTestUrl => testURL != null && !kReleaseMode;

  // base url
  static const String _baseUrl = 'https://reqres.in';
  static const String _apiSuffix = 'api';

  static String get _host => '${isTestUrl ? testURL : _baseUrl}';

  static String get clientApi => '$_host/$_apiSuffix';

  static EndPoint get users => const EndPoint('/users');
}
