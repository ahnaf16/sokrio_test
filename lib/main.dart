import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:linkify/main.export.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await initDependencies();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: kAppName,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        routerConfig: ref.watch(routerProvider),
        builder: (context, child) {
          return 
ConnectivityBuilder(
      builder: (status) {
        bool connected = status == ConnectivityStatus.online;
        return Text(connected ? "Online" : "Offline");
      },
    );

        },
      ),
    );
  }
}
