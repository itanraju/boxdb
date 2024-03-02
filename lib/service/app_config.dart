import 'package:get_it/get_it.dart';
import 'package:learning/provider/database_provider.dart';

GetIt appConfig = GetIt.I;

void setupAppConfig() {
  appConfig.registerLazySingleton(() => DbProvider());
}
