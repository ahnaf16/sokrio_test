import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:internet_connectivity_checker/internet_connectivity_checker.dart';
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
          return Stack(
            children: [
              child ?? Container(),
              Positioned(
                bottom: 0,
                child: ConnectivityBuilder(
                  builder: (status) {
                    final connected = status == ConnectivityStatus.online;
                    if (connected) return const SizedBox();
                    return Material(
                      type: MaterialType.transparency,
                      child: DecoContainer(
                        width: context.width,
                        padding: Pads.lg().copyWith(bottom: Insets.xl),
                        color: context.colors.error,
                        alignment: Alignment.center,
                        child: Row(
                          spacing: Insets.med,
                          children: [
                            Icon(Icons.wifi_off, color: context.colors.onError),
                            Text(
                              'You are offline',
                              style: context.text.bodyMedium?.copyWith(color: context.colors.onError),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
