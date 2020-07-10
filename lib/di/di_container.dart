import 'package:dartservice_web/service/heartbeat/heartbeat_repository.dart';
import 'package:dartservice_web/service/heartbeat/heartbeat_service.dart';
import 'package:dartservice_web/service/settings/settings_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void getItInit() {
  getIt.registerFactory<HeartbeatRepository>(() => HeartbeatRepository());
  getIt.registerFactory<SettingsRepository>(() => SettingsRepository());
  getIt.registerSingleton<HeartbeatService>(
    HeartbeatService(
      getIt.get<HeartbeatRepository>(),
      getIt.get<SettingsRepository>(),
    ),
  );
}
