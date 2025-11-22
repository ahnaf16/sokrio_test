import 'package:linkify/routes/logic/app_route.dart';

export 'package:go_router/go_router.dart';

class RPaths {
  const RPaths._();

  // home
  static const users = RPath('/users');
  static RPath userDetails(String id) => users + RPath('/details/$id');

  // settings
  static const settings = RPath('/settings');
}
