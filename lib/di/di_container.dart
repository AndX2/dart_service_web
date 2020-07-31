import 'package:dartservice_web/res/images.dart';
import 'package:dartservice_web/res/strings.dart';
import 'package:dartservice_web/service/heartbeat/heartbeat_repository.dart';
import 'package:dartservice_web/service/heartbeat/heartbeat_service.dart';
import 'package:dartservice_web/service/settings/settings_repository.dart';
import 'package:get_it/get_it.dart';

/// Экземпляр контейнера DI
final getIt = GetIt.instance;

/// Метод инициализации DI контейнера. Здесь происходит сделующее:
/// 1. Создаются и регистрируются Singleton'ы
/// 2. Регистрируются фабрики для создания объектов "по запросу"
/// 3. Определяется порядок создания объектов
/// Вызов данного метода выполняется в методе main() - точке запуска приложения
void getItInit() {
  /// Регистрация репозитория для получения с сервера настроек для приложения
  getIt.registerFactory<SettingsRepository>(() => SettingsRepository());
  getIt.registerFactory<HeartbeatRepository>(() => HeartbeatRepository());
  /// Создание и регистрация сервиса с зависимостями
  getIt.registerSingleton<HeartbeatService>(
    HeartbeatService(
      getIt.get<HeartbeatRepository>(),
      getIt.get<SettingsRepository>(),
    ),
  );
  getIt.registerSingleton<Images>(Images());
  getIt.registerSingleton<Strings>(Strings());
}
