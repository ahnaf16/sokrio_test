import 'package:get_it/get_it.dart';
import 'package:linkify/_core/network/dio_client.dart';
import 'package:linkify/features/user/repository/user_repo.dart';

final locate = GetIt.instance;

Future<void> initDependencies() async {
  locate.registerSingletonIfAbsent<DioClient>(() => DioClient());
  locate.registerSingletonIfAbsent<UserRepo>(() => UserRepo());
}
