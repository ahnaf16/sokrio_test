import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linkify/app_root.dart';
import 'package:linkify/features/Settings/view/settings_view.dart';
import 'package:linkify/features/user/view/user_details_view.dart';
import 'package:linkify/features/user/view/user_view.dart';
import 'package:linkify/main.export.dart';
import 'package:linkify/models/user.dart';

typedef RouteRedirect = FutureOr<String?> Function(BuildContext, GoRouterState);
String rootPath = RPaths.users.path;
final routerProvider = NotifierProvider<AppRouter, GoRouter>(AppRouter.new);

class AppRouter extends Notifier<GoRouter> {
  final _rootNavigator = GlobalKey<NavigatorState>(debugLabel: 'root');

  GoRouter _appRouter(RouteRedirect? redirect) {
    return GoRouter(
      navigatorKey: _rootNavigator,
      redirect: redirect,
      initialLocation: rootPath,
      routes: [
        ShellRoute(
          routes: _routes,
          builder: (_, s, c) => AppRoot(key: s.pageKey, child: c),
        ),
      ],
      errorBuilder: (_, state) => ErrorRoutePage(error: state.error?.message),
    );
  }

  /// The app router list
  List<RouteBase> get _routes => [
    //! Home
    AppRoute(RPaths.users, (_) => const UserView()),
    AppRoute(RPaths.userDetails(':id'), (s) => UserDetailsView(user: s.extra as User)),

    AppRoute(RPaths.settings, (_) => const SettingsView()),
  ];

  @override
  GoRouter build() {
    Ctx._key = _rootNavigator;
    Toaster.navigator = _rootNavigator;

    FutureOr<String?> redirectLogic(ctx, GoRouterState state) async {
      final current = state.uri.toString();
      cat(current, 'route redirect');

      return null;
    }

    return _appRouter(redirectLogic);
  }
}

class Ctx {
  const Ctx._();
  static GlobalKey<NavigatorState>? _key;
  static BuildContext? get tryContext => _key?.currentContext;

  static BuildContext get context {
    if (_key?.currentContext == null) throw Exception('No context found');
    return _key!.currentContext!;
  }
}
